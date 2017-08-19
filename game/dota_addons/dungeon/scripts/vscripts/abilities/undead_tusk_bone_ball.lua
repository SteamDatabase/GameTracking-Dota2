undead_tusk_bone_ball = class({})
LinkLuaModifier( "modifier_undead_tusk_bone_ball", "modifiers/modifier_undead_tusk_bone_ball", LUA_MODIFIER_MOTION_HORIZONTAL )

-----------------------------------------------------------------------

function undead_tusk_bone_ball:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function undead_tusk_bone_ball:OnSpellStart()
	if IsServer() then
		if self:GetCursorTarget() == nil then
			return
		end
		self.hPrimaryTarget = self:GetCursorTarget()
		self:SetStolen( true )

		self.windup = self:GetSpecialValueFor( "windup" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.grow_rate = self:GetSpecialValueFor( "grow_rate" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.speed = self:GetSpecialValueFor( "speed" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.damage = self:GetSpecialValueFor( "damage" )

		self.vProjectileLocation = self:GetCaster():GetOrigin()
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_undead_tusk_bone_ball", { duration = self.windup + self.duration } )
		if hBuff == nil then
			return
		end
		hBuff:StartIntervalThink( self.windup )

		self.ProjectileInfo =
		{
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			bDodgeable = false,
			iMoveSpeed = self.speed,
		}

		self.ContainedUnits = {}
		self.HitUnits = {}

		self.bEndingBoneBall = false
		self.flBoneBallStartTime = 0.0
		
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tusk_snowball_movement", { duration = self.windup + self.duration } )
		self.hPrimaryTarget:AddNewModifier( self:GetCaster(), self, "modifier_tusk_snowball_visible", { duration = self.windup + self.duration } )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/undead_bone_ball_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.hPrimaryTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hPrimaryTarget:GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 0.01, self.windup, 0.01 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 0, self.grow_rate, self.radius ) )

		EmitSoundOn( "Hero_Tusk.Snowball.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_Tusk.Snowball.Loop", self:GetCaster() )
	end
end

-----------------------------------------------------------------------

function undead_tusk_bone_ball:LaunchBoneBall()
	if IsServer() then
		if self.hPrimaryTarget == nil or self.hPrimaryTarget:IsNull() then
			self:EndBoneBall()
			return
		end

		ParticleManager:DestroyParticle( self.nFXIndex, true )
		self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/undead_bone_ball.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.hPrimaryTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hPrimaryTarget:GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( self.speed, self.windup, self.speed ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( self.radius, self.grow_rate, self.radius ) )

		ProjectileManager:CreateTrackingProjectile( self.ProjectileInfo )
		self.flBoneBallStartTime = GameRules:GetGameTime()
	end
end

-----------------------------------------------------------------------

function undead_tusk_bone_ball:EndBoneBall( bHitTarget )
	if IsServer() then
		if self.bEndingBoneBall == true then
			return
		end

		self.bEndingBoneBall = true
		if self.nFXIndex ~= -1 then
			ParticleManager:DestroyParticle( self.nFXIndex, false )
			self.nFXIndex = -1
		end

		local bWasMoving = false
		if self:GetCaster() ~= nil then
			bWasMoving = self:GetCaster():FindModifierByName( "modifier_tusk_snowball_movement" ) ~= nil
			self:GetCaster():RemoveModifierByName( "modifier_tusk_snowball_movement" )
			for _,Unit in pairs( self.ContainedUnits ) do
				if Unit ~= nil and Unit:IsNull() == false then
					Unit:RemoveModifierByName( "modifier_tusk_snowball_movement_friendly" )
					if Unit:GetUnitName() == "npc_dota_creature_spectral_tusk" then
						local hAbility = Unit:FindAbilityByName( "undead_tusk_bone_ball" )
						if hAbility ~= nil then
							hAbility:StartCooldown( 10.0 )
						end
					end
					if self.hPrimaryTarget ~= nil and bHitTarget then
						FindClearSpaceForUnit( Unit, self.hPrimaryTarget:GetOrigin(), false )
					else
						FindClearSpaceForUnit( Unit, self:GetCaster():GetOrigin(), false )
					end
				end
			end

			StopSoundOn( "Hero_Tusk.Snowball.Loop", self:GetCaster() )
			self.vProjectileLocation = self:GetCaster():GetOrigin()
		end
		self.ContainedUnits = {}
		if bWasMoving and bHitTarget then
			if self.hPrimaryTarget ~= nil and self.hPrimaryTarget:IsNull() == false then
				self.hPrimaryTarget:RemoveModifierByName( "modifier_tusk_snowball_visible" )
			end
		end

		for _, enemy in pairs ( self.HitUnits ) do
			local damageInfo =
			{
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageInfo )
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
			EmitSoundOn( "Hero_Tusk.Snowball.ProjectileHit", enemy )
		end
	end
end

-----------------------------------------------------------------------

function undead_tusk_bone_ball:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.bExpired == false then
			self.vProjectileLocation = vLocation
		end
		self:EndBoneBall( true )
	end

	return false
end

-----------------------------------------------------------------------

function undead_tusk_bone_ball:OnProjectileThink( vLocation )
	if IsServer() then
		self.vProjectileLocation = vLocation
		local flElapsedTime = GameRules:GetGameTime() - self.flBoneBallStartTime
		local hBuff = self:GetCaster():FindModifierByName( "modifier_tusk_snowball_movement" )
		if hBuff ~= nil then
			if self:GetCaster():FindModifierByName( "modifier_undead_tusk_bone_ball" ) == nil then
				hBuff:Destroy()
				self.bExpired = true
				self:EndBoneBall( false )
			end

			if self.bExpired == true then
				return
			end

			local nRadiusMod = self.radius + self.grow_rate * flElapsedTime
			ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( nRadiusMod, self.grow_rate, self.radius ) )

			local bHitPrimaryTarget = false

			local entities = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), nRadiusMod, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
			for _,ent in pairs( entities ) do
				if ent ~= nil then
					if ent:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:HasHitTarget( ent ) == false then	
						self:AddHitTarget( ent )
						if ent == self.hPrimaryTarget then
							bHitPrimaryTarget = true
						end
					end
					if self:HasLoadedUnit( ent ) == false and ent ~= self:GetCaster() and ent ~= self.hPrimaryTarget and ent:GetUnitName() ~= "npc_dota_creature_undead_ogre_seal" then
						self:LoadUnit( ent )
					end
				end
			end

			if bHitPrimaryTarget == true then
				self:EndBoneBall( true )
			end
		end
	end
end

-----------------------------------------------------------------------

function undead_tusk_bone_ball:LoadUnit( hUnit )
	if IsServer() then
		if hUnit == nil or hUnit:IsNull() or hUnit == self.hPrimaryTarget then
			return
		end

		local hBuff = self:GetCaster():FindModifierByName( "modifier_tusk_snowball_movement" ) 
		if hBuff == nil then
			return
		end

		hUnit:AddNewModifier( self:GetCaster(), self, "modifier_tusk_snowball_movement_friendly", { duration = hBuff:GetRemainingTime() } )
		table.insert( self.ContainedUnits, hUnit )
	end
end

--------------------------------------------------------------------------------

function undead_tusk_bone_ball:HasLoadedUnit( hUnit )
	for _, unit in pairs( self.ContainedUnits ) do
		if unit == hUnit then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function undead_tusk_bone_ball:HasHitTarget( hTarget )
	for _, target in pairs( self.HitUnits ) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

--------------------------------------------------------------------------------

function undead_tusk_bone_ball:AddHitTarget( hTarget )
	table.insert( self.HitUnits, hTarget )
end

--------------------------------------------------------------------------------
