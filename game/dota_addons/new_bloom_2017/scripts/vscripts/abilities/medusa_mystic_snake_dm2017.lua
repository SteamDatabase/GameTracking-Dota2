require( "utils" )

medusa_mystic_snake_dm2017 = class({})

--------------------------------------------------------------------------------

function medusa_mystic_snake_dm2017:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget == nil or hTarget:IsInvulnerable() then
		return
	end

	self.radius = self:GetSpecialValueFor( "radius" )
	self.initial_speed = self:GetSpecialValueFor( "initial_speed" )
	self.snake_damage = self:GetSpecialValueFor( "snake_damage" )
	self.snake_mana_steal = self:GetSpecialValueFor( "snake_mana_steal" )
	self.snake_scale = self:GetSpecialValueFor( "snake_scale" )
	self.snake_jumps = self:GetSpecialValueFor( "snake_jumps" )
	self.return_speed = self:GetSpecialValueFor( "return_speed" )
	self.stone_duration = self:GetSpecialValueFor( "stone_duration" )

	local info = {
		EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_initial.vpcf",
		Ability = self,
		iMoveSpeed = self.initial_speed,
		Source = self:GetCaster(),
		Target = self:GetCursorTarget(),
		bDodgeable = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 300,
	}

	ProjectileManager:CreateTrackingProjectile( info )

	EmitSoundOn( "Hero_Medusa.MysticSnake.Cast", self:GetCaster() )

	self.nCurJumpCount = 0;
	self.nTotalMana = 0;
	self.hHitEntities = {}

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_mystic_snake_cast.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------------

function medusa_mystic_snake_dm2017:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and not ( hTarget == self:GetCaster() ) then
			-- Do damage and mana steal
			if ( hTarget:GetMaxMana() > 0 ) and hTarget:IsAlive() and not hTarget:IsIllusion() then
				local flManaSteal = math.min( hTarget:GetMana(), hTarget:GetMaxMana() * self.snake_mana_steal / 100 )

				hTarget:ReduceMana( flManaSteal )

				self.nTotalMana = self.nTotalMana + flManaSteal
			end

			local iDamageType = DAMAGE_TYPE_MAGICAL;

			if ( hTarget:FindModifierByName( "modifier_medusa_stone_gaze_stone" ) ) then
				iDamageType = DAMAGE_TYPE_PURE;
			end

			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				ability = self,
				damage = self.snake_damage,
				damage_type = iDamageType,
			}

			ApplyDamage( damage )

			-- turn unit to stone
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_medusa_stone_gaze_stone", { duration = self.stone_duration } )

			-- Scale up the damage now
			self.snake_damage = self.snake_damage + ( self.snake_damage * self.snake_scale ) / 100;
			self.nCurJumpCount = self.nCurJumpCount + 1

			table.insert( self.hHitEntities, hTarget )
			EmitSoundOn( "Hero_Medusa.MysticSnake.Target", hTarget )
		end

		-- Snake is hitting Medusa, give her the collected mana
		if ( hTarget == self:GetCaster() ) then
			hTarget:GiveMana( self.nTotalMana )
			SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, hTarget, self.nTotalMana, nil )

			for k in pairs( self.hHitEntities ) do
				self.hHitEntities[ k ] = nil
			end

			EmitSoundOn( "Hero_Medusa.MysticSnake.Return", self:GetCaster() )

			return true
		end

		self:LaunchNextProjectile( hTarget )
	end

	return false
end

--------------------------------------------------------------------------------

function medusa_mystic_snake_dm2017:LaunchNextProjectile( hTarget )
	-- Find a new target
	if hTarget and self.nCurJumpCount < self.snake_jumps then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

		local hJumpTarget
		while #enemies > 0 do
			local hPotentialJumpTarget = enemies[ 1 ]
			if hPotentialJumpTarget == nil or TableContains( self.hHitEntities, hPotentialJumpTarget ) then
				table.remove( enemies, 1 )
			else
				hJumpTarget = hPotentialJumpTarget
				break
			end
		end

		-- We didn't find any jump targets, return to Medusa
		if #enemies == 0 then
			local info = {
				EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf",
				Ability = self,
				iMoveSpeed = self.return_speed,
				Source = hTarget,
				Target = self:GetCaster(),
				bDodgeable = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				bProvidesVision = true,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				iVisionRadius = 300,
			}

			ProjectileManager:CreateTrackingProjectile( info )

			return
		end

		-- Go to another target
		if hJumpTarget then
			local info = {
				EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
				Ability = self,
				iMoveSpeed = self.initial_speed,
				Source = hTarget,
				Target = hJumpTarget,
				bDodgeable = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				bProvidesVision = true,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				iVisionRadius = 300,
			}

			ProjectileManager:CreateTrackingProjectile( info )

			return
		end

		-- Should be impossible to not trigger one of the above conditions.
		Assert( false )
	end

	-- We're out of jump targets, so return to the caster from here.
	self:LaunchReturnProjectile( hTarget );
end

--------------------------------------------------------------------------------

function medusa_mystic_snake_dm2017:LaunchReturnProjectile( hSource )
	local info = {
		EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf",
		Ability = self,
		iMoveSpeed = self.return_speed,
		Source = hSource,
		Target = self:GetCaster(),
		bDodgeable = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bProvidesVision = true,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		iVisionRadius = 300,
	}

	ProjectileManager:CreateTrackingProjectile( info )
end

--------------------------------------------------------------------------------
