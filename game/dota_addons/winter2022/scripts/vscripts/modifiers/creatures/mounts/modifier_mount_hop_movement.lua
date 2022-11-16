modifier_mount_hop_movement = class({})

local CRASH_TYPE_UNIT = 0
local CRASH_TYPE_TREE = 1
local CRASH_TYPE_CLIFF = 2
local CRASH_TYPE_UNKNOWN = -1

----------------------------------------------------------------------------------
function modifier_mount_hop_movement:IsHidden()
	return true
end

----------------------------------------------------------------------------------
function modifier_mount_hop_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:CheckState()
	local state = 
	{
		[ MODIFIER_STATE_STUNNED ] = true,
	}
	return state
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:GetModifierDisableTurning( params )
	return 1
end

----------------------------------------------------------------------------------------
function modifier_mount_hop_movement:OnDeath( params )
	if IsServer() == false then
		return
	end

	local hAttacker = params.attacker
	local hVictim = params.unit
	if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker == self:GetParent() and self:GetHero() ~= nil and
		hVictim ~= nil and hVictim:IsNull() == false and hVictim:IsRealHero() == true then
		GameRules.Winter2022:GetTeamAnnouncer( self:GetHero():GetTeamNumber() ):OnMountKill( self:GetHero() )
	end
end

----------------------------------------------------------------------------------
function modifier_mount_hop_movement:OnCreated( kv )
	if not IsServer() then return end

	self.flCreationTime = GameRules:GetDOTATime( false, true )

	local hAbility = self:GetAbility()

	-- Hopping
	self.hop_distance = hAbility:GetSpecialValueFor("hop_distance")
	self.hop_height = hAbility:GetSpecialValueFor("hop_height")
	self.hop_time = hAbility:GetSpecialValueFor("hop_time")
	self.can_move_up_cliffs = hAbility:GetSpecialValueFor("can_move_up_cliffs") == 1
	self.hop_pause = hAbility:GetSpecialValueFor("hop_pause")
	self.turn_rate = hAbility:GetSpecialValueFor( "turn_rate" )
	self.hops_after_dismount = hAbility:GetSpecialValueFor( "hops_after_dismount" )

	-- Landing
	self.impact_radius = hAbility:GetSpecialValueFor("impact_radius")
	self.impact_stun = hAbility:GetSpecialValueFor("impact_stun") == 1
	self.base_damage = hAbility:GetSpecialValueFor("base_damage")
	self.damage_per_level = hAbility:GetSpecialValueFor("damage_per_level")
	self.knockback_distance = hAbility:GetSpecialValueFor("knockback_distance")
	self.knockback_duration = hAbility:GetSpecialValueFor("knockback_duration")

	-- Constants
	self.flDespawnTime = 1
	self.nTreeDestroyRadius = self.impact_radius
	self.flHopCoefficient = 3

	-- Startup
	self.bIsHopping = false
	self.flHopTime = 0
	self.flArcHeightPct = 0

	if self:GetParent().flDesiredYaw == nil then
		self:GetParent().flDesiredYaw = self:GetParent():GetAnglesAsVector().y
	end

	if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then 
		self:Destroy()
		print("Failed to apply motion controller")
		return
	end
	
	if hAbility.OnMovementStart ~= nil then
		hAbility:OnMovementStart()
	end

	self:StartIntervalThink( 0.02 )
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():SetOrigin(GetGroundPosition(self:GetParent():GetOrigin(), self:GetParent()))

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )
	
	local hAbility = self:GetAbility()
	if hAbility ~= nil then
		if hAbility.GetAnimation_Movement ~= nil then
			self:GetParent():RemoveGesture( hAbility:GetAnimation_Movement() )
		end
		if hAbility.OnMovementEnd ~= nil then
			hAbility:OnMovementEnd()
		end
	end
	-- always despawn mount when it stops moving
	if not self:GetParent():HasModifier("modifier_kill") and self.bDisableDespawn ~= true then
		self:GetParent():AddNewModifier( nil, nil, "modifier_kill", { duration = self.flDespawnTime } )
	end
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:UpdateHorizontalMotion( me, dt )
	if not IsServer() or not self:GetParent() then return end

	if self.bIsHopping then
		local flAlpha = math.min( ( GameRules:GetDOTATime( false, true ) - self.flHopTime ) / self.hop_time, 1 )

		if flAlpha >= 1 then
			local vEndPos = self.vHopTarget
			vEndPos.z = me:GetOrigin().z
			self:EndHop( me, vEndPos )
			
			-- Set Hero Position too. Set here instead of in modifier_mounted so that update order doesn't matter
			if self:IsHeroRiding() then
				local vHeroPosition = self:GetParent():GetAbsOrigin()
				vHeroPosition.z = self:GetHero():GetAbsOrigin().z
			
				self:GetHero():SetAbsOrigin( vHeroPosition )
			end
		else
			local vNewPos = self.vHopStart + ( self.vHopTarget - self.vHopStart ) * flAlpha

			local flHeightDelta = GetGroundHeight( vNewPos, self:GetParent() ) - GetGroundHeight( self:GetParent():GetOrigin(), self:GetParent( ))
			if not self.can_move_up_cliffs and flHeightDelta >= 30 then
				-- dismount when we hit a cliff
				if self:GetAbility().OnCrash ~= nil then
					self:GetAbility():OnCrash( false )
				end
				
				self:GetHero():RemoveModifierByName("modifier_mounted")
				self:Destroy()
				return
			end

			vNewPos.z = me:GetOrigin().z
			me:SetOrigin( vNewPos )
			
			-- Set Hero Position too. Set here instead of in modifier_mounted so that update order doesn't matter
			if self:IsHeroRiding() then
				local vHeroPosition = vNewPos
				vHeroPosition.z = self:GetHero():GetAbsOrigin().z
			
				self:GetHero():SetAbsOrigin( vHeroPosition )
			end
		end
	else
		-- Calculate turning
		local bHeroIsRiding = self:IsHeroRiding()
		local flAngles = self:GetParent():GetAnglesAsVector()
		local flAngleDiff = bHeroIsRiding and AngleDiff( self:GetParent().flDesiredYaw, flAngles.y ) or 0

		local flTurnAmount = math.min( dt * self.turn_rate, math.abs( flAngleDiff ) )
		if flAngleDiff < 0.0 then flTurnAmount = flTurnAmount * -1 end

		if flAngleDiff ~= 0.0 then
			flAngles.y = flAngles.y + flTurnAmount
			me:SetAbsAngles( flAngles.x, flAngles.y, flAngles.z )
		end

		-- Check to despawn
		if not bHeroIsRiding and self.hops_after_dismount <= 0 then
			self:Destroy()
			return
		end

		if GameRules:GetDOTATime( false, true ) >= self.flHopTime then
			self:StartHop()
			if not bHeroIsRiding then
				self.hops_after_dismount = self.hops_after_dismount - 1
			end
		end
	
		-- Set Hero Position too. Set here instead of in modifier_mounted so that update order doesn't matter
		if bHeroIsRiding then
			self:GetHero():SetAbsAngles( flAngles.x, flAngles.y, flAngles.z )
		end
	end
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:UpdateVerticalMotion( me, dt )
	if not IsServer() or not self:GetParent() then return end

	local vNewPos
	if self.bIsHopping then
		local flAlpha = math.min( ( GameRules:GetDOTATime( false, true ) - self.flHopTime ) / self.hop_time, 1 )
		local flHeight = self.flHopParabolaA * flAlpha * flAlpha + self.flHopParabolaB * flAlpha
		vNewPos = me:GetOrigin()
		vNewPos.z = self.vHopStart.z + flHeight
		me:SetOrigin( vNewPos )
		--print("Vertical Motion - Alpha: "..flAlpha..", Position: "..vNewPos.z)

		-- Used in passives to adjust rider vertical offset
		self.flArcHeightPct = 2.0 * ( flAlpha < 0.5 and flAlpha or ( 1 - flAlpha ) ) -- 0 to 1 to 0 value
		self.bGoingUp = flAlpha < 0.5

		GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.nTreeDestroyRadius, false )
	else
		vNewPos = me:GetOrigin()
		vNewPos.z = GetGroundHeight( me:GetOrigin(), self:GetParent() )
		me:SetOrigin(vNewPos)
	end
			
	-- Set Hero Position too. Set here instead of in modifier_mounted so that update order doesn't matter
	if self:IsHeroRiding() then
		local vHeroPosition = self:GetHero():GetAbsOrigin()
		vHeroPosition.z = vNewPos.z
		if self:GetAbility() ~= nil and self:GetAbility().GetRiderVerticalOffset ~= nil then
			vHeroPosition.z = vHeroPosition.z + self:GetAbility():GetRiderVerticalOffset()
		end
	
		self:GetHero():SetAbsOrigin( vHeroPosition )
	end
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:OnHorizontalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:OnVerticalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:StartHop()
	self.bIsHopping = true
	self.vHopStart = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
	self.vHopTarget = GetGroundPosition( self.vHopStart + self:GetParent():GetForwardVector() * self.hop_distance, self:GetParent() )
	self.vHopTarget = GetClearSpaceForUnit(self:GetParent(), self.vHopTarget)

	self.flHopTime = GameRules:GetDOTATime(false, true)
	self:CalcHopParabola()
	
	self:GetParent():StartGesture( self:GetAbility():GetAnimation_Movement() )

	if self:GetAbility().OnHopStart ~= nil then
		self:GetAbility():OnHopStart()
	end
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:CalcHopParabola()
		--[[
		y = ax^2 + bx + c
		let x be a (0-1) lerp alpha, let y be (0-hop_height) relative height value
		Therefore 3 points on parabola are (0, 0), (0.5, hop_height[hh]), (1.0, height_diff[hd])

		Plug in points, solve the system of equations
		Point 1: 0 = a(0)^2 + b(0) + c 			->	c = 0
		Point 2: hh = a(0.5)^2 + b(0.5) + c		->	hh = a(0.25) + b(0.5)
		Point 3: hd = a(1)^2 + b(1) + c			->	hd = a + b

		Substitution method
		hh = 0.25a + 0.5(hd - a)
		hh = 0.25a + 0.5hd - 0.5a
		hh - 0.5hd = -0.25a
		(hh - 0.5hd) / -0.25 = a

		a = -4 * (hh - 0.5hd)
		b = hd - a
		--]]

		local flHeightDif = self.vHopTarget.z - self.vHopStart.z
		local flHopHeight = self.hop_height
		if self.can_move_up_cliffs then
			-- ensure points are never colinear
			flHopHeight = math.max(self.hop_height, flHeightDif, 1)
		end
		self.flHopParabolaA = -4 * ( flHopHeight - 0.5 * flHeightDif )
		self.flHopParabolaB = flHeightDif - self.flHopParabolaA
		--print("Parabola Calculated - A: "..self.flHopParabolaA..", B: "..self.flHopParabolaB)
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:EndHop( me, vEndPos )
	self.bIsHopping = false
	self.flHopTime = GameRules:GetDOTATime(false, true) + self.hop_pause
	self:GetParent():FadeGesture( self:GetAbility():GetAnimation_Movement() )

	-- Set owner cooldown to the same as ours for a visual indicator of when the next hop is
	--[[ Disabling because it prevents dismounting by using the ability
	local hSummonAbility = self:GetCaster():GetOwnerEntity():FindAbilityByName("summon_penguin")
	if hSummonAbility ~= nil and self:IsHeroRiding() then
		hSummonAbility:StartCooldown( math.max( self:GetAbility():GetCooldownTimeRemaining(), self.hop_pause ) )
	end
	--]]
	
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.nTreeDestroyRadius, false )
	local vEndPos = GetClearSpaceForUnit( me, vEndPos )
	me:SetOrigin( vEndPos )

	local bHit = false
	local bHitHero = false

	local nTargetFlags = DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local hUnits = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbility():GetAbilityTargetType(), nTargetFlags, 0, false )
	for _, hUnit in pairs( hUnits ) do
		if hUnit ~= nil and hUnit:IsNull() == false and hUnit:GetUnitName() ~= "npc_dota_radiant_bucket_soldier" and hUnit:GetUnitName() ~= "npc_dota_dire_bucket_soldier" then
			if not hUnit:HasModifier("modifier_mount_hit_cooldown") and not hUnit:HasModifier("modifier_mounted") and not hUnit:HasModifier("modifier_mount_movement") and not hUnit:HasModifier("modifier_mount_hop_movement") then
				if not hUnit:IsInvulnerable() then
					-- Damage
					if self.base_damage > 0 or self.damage_per_level > 0 then
						local nHeroLevel = self:GetHero():GetLevel()
						local nDamage = self.base_damage + self.damage_per_level * nHeroLevel

						local DamageInfo =
						{
							victim = hUnit,
							attacker = self:GetParent(),
							ability = self:GetAbility(),
							damage = nDamage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
						}
						local nDamageDealt = ApplyDamage( DamageInfo )
					end

					-- Knock back
					if self.knockback_distance > 0 and self.knockback_duration > 0 then
						local vLocation = self:GetParent():GetAbsOrigin() + ( self:GetParent():GetForwardVector() * 50 )
						local kv =
						{
							center_x = vLocation.x,
							center_y = vLocation.y,
							center_z = vLocation.z,
							should_stun = self.impact_stun, 
							duration = self.knockback_duration + 0.2,
							knockback_duration = self.knockback_duration,
							knockback_distance = self.knockback_distance,
							knockback_height = 50,
						}

						hUnit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv )
					end
					
					hUnit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_hit_cooldown", { duration = 1 })
					
					bHit = true
					bHitHero = bHitHero or hUnit:IsHero()

					local hAbility = self:GetAbility()
					if hAbility ~= nil and hAbility.OnImpact ~= nil then
						hAbility:OnImpact( hUnit )
					end

					if hUnit:IsRealHero() or IsGreevil(hUnit) then
						GameRules.Winter2022:GrantEventAction( self:GetHero():GetPlayerID(), "winter2022_hit_enemies_with_mount", 1 )
					end
				end
			end
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/mounts/mount_land_impact.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	if self:GetAbility().OnHopEnd ~= nil then
		self:GetAbility():OnHopEnd()
	end
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:IsHeroRiding()
	local hHero = self:GetHero()
	if hHero ~= nil and hHero:IsNull() == false then
		local hSummonAbility = hHero:FindAbilityByName( "summon_penguin" )
		return hHero:HasModifier("modifier_mounted") and hSummonAbility ~= nil and hSummonAbility.hMount == self:GetParent()
	end

	return false
end

--------------------------------------------------------------------------------
function modifier_mount_hop_movement:GetHero()
	return self:GetParent():GetOwnerEntity()
end