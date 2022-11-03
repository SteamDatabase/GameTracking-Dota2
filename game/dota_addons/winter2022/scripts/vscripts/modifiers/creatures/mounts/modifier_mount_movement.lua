modifier_mount_movement = class({})

----------------------------------------------------------------------------------
function modifier_mount_movement:IsHidden()
	return true
end

----------------------------------------------------------------------------------
function modifier_mount_movement:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_mount_movement:CheckState()
	local state = 
	{
		[ MODIFIER_STATE_STUNNED ] = true,
	}
	return state
end

--------------------------------------------------------------------------------
function modifier_mount_movement:DeclareFunctions()
	local funcs = 
	{
		--MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-----------------------------------------------------------------------
function modifier_mount_movement:GetOverrideAnimation( params )
	return self:GetAbility():GetAnimation_Movement()
end

--------------------------------------------------------------------------------
function modifier_mount_movement:GetModifierDisableTurning( params )
	return 1
end

----------------------------------------------------------------------------------------
function modifier_mount_movement:OnDeath( params )
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
function modifier_mount_movement:OnCreated( kv )
	if not IsServer() then return end

	self.flCreationTime = GameRules:GetDOTATime( false, true )

	local hAbility = self:GetAbility()

	-- Movement
	self.max_speed = hAbility:GetSpecialValueFor("max_speed")
	self.acceleration = hAbility:GetSpecialValueFor("acceleration")
	self.deceleration = hAbility:GetSpecialValueFor("deceleration")
	self.turn_rate_min = hAbility:GetSpecialValueFor( "turn_rate_min" )
	self.turn_rate_max = hAbility:GetSpecialValueFor( "turn_rate_max" )

	-- Impact
	self.impact_radius = hAbility:GetSpecialValueFor("impact_radius")
	self.impact_stun = hAbility:GetSpecialValueFor("impact_stun")
	self.base_damage = hAbility:GetSpecialValueFor("base_damage")
	self.damage_per_level = hAbility:GetSpecialValueFor("damage_per_level")
	self.knockback_distance = hAbility:GetSpecialValueFor("knockback_distance")
	self.knockback_duration = hAbility:GetSpecialValueFor("knockback_duration")

	-- Misc
	self.flCurrentSpeed = self.max_speed / 2.0
	self.flDespawnTime = 0.5
	self.nTreeDestroyRadius = 75
	self.bMaxSpeedNotified = false
	self.bCrashScheduled = false
	self.hCrashScheduledUnit = nil

	if self:GetParent().flDesiredYaw == nil then
		self:GetParent().flDesiredYaw = self:GetParent():GetAnglesAsVector().y
	end

	if hAbility:GetAnimation_Movement() ~= nil then
		self:GetParent():StartGesture( hAbility:GetAnimation_Movement() )
	end

	if self:ApplyHorizontalMotionController() == false then 
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
function modifier_mount_movement:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController( self )
	
	local hAbility = self:GetAbility()
	if hAbility ~= nil then
		if hAbility.GetAnimation_Movement ~= nil and hAbility:GetAnimation_Movement() ~= nil then
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
function modifier_mount_movement:UpdateHorizontalMotion( me, dt )
	if not IsServer() or not self:GetParent() then return end

	if self.bCrashScheduled then
		self:Crash( self.hCrashScheduledUnit )
		return
	end

	local bHeroIsRiding = self:IsHeroRiding()

	-- Calculate turning
	local curAngles = self:GetParent():GetAnglesAsVector()
	local flAngleDiff = bHeroIsRiding and AngleDiff( self:GetParent().flDesiredYaw, curAngles.y ) or 0

	local flTurnAmount = dt * ( self.turn_rate_min + self:GetSpeedMultiplier() * ( self.turn_rate_max - self.turn_rate_min ) )
	flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )

	if flAngleDiff < 0.0 then
		flTurnAmount = flTurnAmount * -1
	end

	if flAngleDiff ~= 0.0 then
		curAngles.y = curAngles.y + flTurnAmount
		me:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
	end

	-- Acceleration
	local flMaxSpeed = self.max_speed
	if bHeroIsRiding then
		local flSpeedModifier = self:GetHero():GetIdealSpeed() / self:GetHero():GetBaseMoveSpeed()
		if flSpeedModifier < 1.0 then
			flMaxSpeed = flMaxSpeed * flSpeedModifier
		end
	end

	if flMaxSpeed <= 0 and self.max_speed > 0 then
		self:GetHero():RemoveModifierByName( "modifier_mounted" )
		self:Destroy()
		print("Max speed is zero")
		return
	end
	local flAcceleration = bHeroIsRiding and self.acceleration or -self.deceleration
	self.flCurrentSpeed = math.max( math.min( self.flCurrentSpeed + ( dt * flAcceleration ), flMaxSpeed ), 0 )

	-- Check to despawn penguin
	if self.flCurrentSpeed <= 0 and not bHeroIsRiding then
		self:Destroy()
		return
	end

	-- Move
	local vNewPos = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector() * ( dt * self.flCurrentSpeed )
	if not GridNav:CanFindPath( me:GetOrigin(), vNewPos ) then
		-- if we are just crashing into trees, we can keep moving but will still slow down
		GridNav:DestroyTreesAroundPoint( vNewPos, self.nTreeDestroyRadius, true )
		if GridNav:CanFindPath( me:GetOrigin(), vNewPos ) then
			self:Crash( nil, true )
		else
			self:Crash()
			return
		end
	end

	me:SetOrigin( vNewPos )

	-- Set Hero Position too. Set here instead of in modifier_mounted so that update order doesn't matter
	if bHeroIsRiding then
		local vHeroPosition = vNewPos
		if self:GetAbility() ~= nil and self:GetAbility().GetRiderVerticalOffset ~= nil then
			vHeroPosition.z = vHeroPosition.z + self:GetAbility():GetRiderVerticalOffset()
		end
	
		self:GetHero():SetAbsOrigin( vHeroPosition )
		self:GetHero():SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
	end

	-- Max Speed FX
	if self.flCurrentSpeed >= self.max_speed and not self.bMaxSpeedNotified and self.max_speed > 0 then
		self.bMaxSpeedNotified = true
	
		local hAbility = self:GetAbility()
		if hAbility ~= nil and hAbility.OnMaxSpeed ~= nil then
			hAbility:OnMaxSpeed()
		end
	end

	self.bHeroWasRiding = bHeroIsRiding
end

--------------------------------------------------------------------------------
function modifier_mount_movement:OnHorizontalMotionInterrupted()
	if not IsServer() then return end
	self:Destroy()
end

--------------------------------------------------------------------------------
function modifier_mount_movement:OnIntervalThink()
	if not IsServer() then return end
	
	local bHit = false
	local bHitHero = false

	local nTargetFlags = DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local hUnits = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_BOTH, self:GetAbility():GetAbilityTargetType(), nTargetFlags, 0, false )
	for _, hUnit in pairs( hUnits ) do
		if hUnit ~= nil and hUnit:IsNull() == false then
			local unitName = hUnit:GetUnitName()
			local nHeroTeam = self:GetHero():GetTeamNumber()

			if hUnit:IsBuilding() then
				self:Crash()
				return
			elseif ( unitName == "npc_dota_radiant_bucket_soldier" and nHeroTeam == DOTA_TEAM_BADGUYS ) or ( unitName == "npc_dota_dire_bucket_soldier" and nHeroTeam == DOTA_TEAM_GOODGUYS ) then
		   		if not hUnit:HasModifier("modifier_mount_hit_cooldown") then
					hUnit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_hit_cooldown", { duration = 3 })
					self:Crash( hUnit )
					return
		   		end
	   		end

			if hUnit:GetTeamNumber() ~= nHeroTeam and not hUnit:HasModifier("modifier_mount_hit_cooldown") then
				-- crash when impacting enemy mounts
				local hEnemyMountMovement = hUnit:FindModifierByName("modifier_mount_movement")
				local hEnemyMountHopMovement = hUnit:FindModifierByName("modifier_mount_hop_movement")
				if hEnemyMountMovement ~= nil then
					self:Crash( hUnit )
					hEnemyMountMovement:ScheduleCrash( self:GetParent() )
					return
				elseif hEnemyMountHopMovement ~= nil and not hEnemyMountHopMovement.bIsHopping and not hEnemyMountHopMovement:GetHero():HasModifier("modifier_mount_hit_cooldown") then
					self:Crash( hUnit, true )
					hEnemyMountHopMovement:GetHero():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_hit_cooldown", { duration = 0.5 })
					return
				elseif not hUnit:IsInvulnerable() and not hUnit:HasModifier("modifier_mounted") and self.flCurrentSpeed > 0.0 then
					-- Damage
					if self.base_damage > 0 or self.damage_per_level > 0 then
						local nHeroLevel = self:GetHero():GetLevel()
						local nDamage = self.base_damage + self.damage_per_level * nHeroLevel
						nDamage = nDamage * self:GetSpeedMultiplier()

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
					if self.knockback_distance > 0 and self.knockback_duration > 0 and self.flCurrentSpeed >= 100 then
						local vLocation = self:GetParent():GetAbsOrigin() + ( self:GetParent():GetForwardVector() * 50 )
						local kv =
						{
							center_x = vLocation.x,
							center_y = vLocation.y,
							center_z = vLocation.z,
							should_stun = self.impact_stun > 0, 
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
	
	local hAbility = self:GetAbility()
	if hAbility ~= nil and hAbility.OnMovementThink ~= nil then
		hAbility:OnMovementThink()
	end
end

function modifier_mount_movement:ScheduleCrash( hHitUnit )
	self.bCrashScheduled = true
	self.hCrashScheduledUnit = hHitUnit
end

function modifier_mount_movement:Crash( hHitUnit, bHitTree )
	if bHitTree == nil then bHitTree = false end

	if not bHitTree then
		--print("CRASH INFO - Hit Unit: "..(hHitUnit ~= nil and hHitUnit:GetUnitName() or "none")..", Scheduled: "..(self.bCrashScheduled and "true" or "false")..", Recent: "..((self.flLastCrashTime ~= nil and GameRules:GetDOTATime(false, true) - self.flLastCrashTime <= 0.25) and "true" or "false")..", Last Unit: "..(self.hLastCrashUnit ~= nil and self.hLastCrashUnit:GetUnitName() or "none"))
		if self.flLastCrashTime ~= nil and GameRules:GetDOTATime(false, true) - self.flLastCrashTime <= 0.1 then
			if self.hLastCrashUnit ~= nil and self.hLastCrashUnit == hHitUnit then
				-- prevent crashes into other mounts temporarily
				self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_hit_cooldown", { duration = 2 })
				hHitUnit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_hit_cooldown", { duration = 2 })
				print("Mount Crash: Stuck on another hero")
				return
			elseif self.hLastCrashUnit == nil and hHitUnit == nil then
				-- force dismount if we are crashing repeatedly into buildings or cliffs
				self:GetHero():RemoveModifierByName( "modifier_mounted" )
				self:GetParent():AddNewModifier( nil, nil, "modifier_kill", { duration = 7 } ) -- ability cooldown time + 2, prevents you from spawning a penguin immediately in the same problem spot
				self:Destroy()
				print("Mount Crash: Stuck on a building or cliff")
				return
			end
		end
		self.flLastCrashTime = GameRules:GetDOTATime(false, true)
		self.hLastCrashUnit = hHitUnit
	end

	-- Start a screenshake with the following parameters: vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
	ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )

	self.bMaxSpeedNotified = false

	if not bHitTree then
		local resetDistance = GameRules:GetDOTATime(false, true) - self.flCreationTime <= 0.1 and 200 or 100
		local vResetPos = self:GetParent():GetAbsOrigin() - ( self:GetParent():GetForwardVector() * resetDistance )
		local vAngles = self:GetParent():GetAngles()

		self:GetParent():SetOrigin( vResetPos )
		self:GetParent():SetAbsAngles(vAngles.x, vAngles.y + 180, vAngles.z)
		FindClearSpaceForUnit( self:GetParent(), vResetPos, false )
		self:GetParent().flDesiredYaw = self:GetParent():GetAnglesAsVector().y

		-- trigger VO if we smashed into another mount
		if hHitUnit ~= nil and hHitUnit:IsNull() == false and hHitUnit:FindModifierByName( "modifier_mount_movement" ) then
			GameRules.Winter2022:GetTeamAnnouncer( self:GetHero():GetTeamNumber() ):OnMountCrash( self:GetHero() )
		end

		--self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_impairment", { duration = 2.0 } )
		--self:GetHero():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_mount_impairment", { duration = 2.0 } )
	end
	
	self.flCurrentSpeed = self:IsHeroRiding() and 100 or 0
	self.bCrashScheduled = false
	self.hCrashScheduledUnit = nil
	
	local hAbility = self:GetAbility()
	if hAbility ~= nil and hAbility.OnCrash ~= nil then
		hAbility:OnCrash( bHitTree )
	end
end

--------------------------------------------------------------------------------
function modifier_mount_movement:IsHeroRiding()
	local hHero = self:GetHero()
	if hHero ~= nil and hHero:IsNull() == false then
		local hSummonAbility = hHero:FindAbilityByName( "summon_penguin" )
		return hHero:HasModifier("modifier_mounted") and hSummonAbility ~= nil and hSummonAbility.hMount == self:GetParent()
	end

	return false
end

--------------------------------------------------------------------------------
function modifier_mount_movement:GetHero()
	return self:GetParent():GetOwnerEntity()
end

--------------------------------------------------------------------------------
function modifier_mount_movement:GetSpeedMultiplier()
	return 0.5 + 0.5 * (self.flCurrentSpeed / self.max_speed)
end