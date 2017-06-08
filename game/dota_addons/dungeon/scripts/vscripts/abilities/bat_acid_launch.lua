bat_acid_launch = class ({})
--LinkLuaModifier( "modifier_bat_acid_thinker", "modifiers/modifier_bat_acid_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function bat_acid_launch:OnSpellStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.heal_amount = self:GetSpecialValueFor( "heal_amount" )

		local vTargetPos = nil
		if self:GetCursorTarget() then
			vTargetPos = self:GetCursorTarget():GetOrigin()
		else
			vTargetPos = self:GetCursorPosition()
		end

		local vDirection = vTargetPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local fRangeToTarget =  ( self:GetCaster():GetOrigin() - vTargetPos ):Length2D()

		local projectile =
		{
			Target = vTargetPos,
			Source = self:GetCaster(),
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin() + Vector( 0, 0, 200 ), 
			fStartRadius = 10,
			fEndRadius = 10,
			vVelocity = vDirection * self.projectile_speed,
			fDistance = fRangeToTarget,
			EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile_linear.vpcf", --"particles/units/heroes/hero_viper/viper_viper_strike_beam.vpcf",
			iMoveSpeed = self.projectile_speed,
			vSourceLoc = self:GetCaster():GetOrigin(),
			bDodgeable = false,
			bProvidesVision = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( projectile )

		self.fTimeAcidLaunched = GameRules:GetGameTime()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_invulnerable", { duration = self.duration } )

		self:GetCaster():Heal( self.heal_amount, self )

		--EmitSoundOn( "Hero_OgreMagi.Ignite.Cast", self:GetCaster() )
	end
end

----------------------------------------------------------------------------------------

function bat_acid_launch:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local fDuration = self.duration - ( GameRules:GetGameTime() - self.fTimeAcidLaunched )
		CreateModifierThinker( self:GetCaster(), self, "modifier_alchemist_acid_spray_thinker", { duration = fDuration }, vLocation, self:GetCaster():GetTeamNumber(), false )
	end

	return true
end

----------------------------------------------------------------------------------------
