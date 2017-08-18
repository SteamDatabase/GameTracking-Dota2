
modifier_siltbreaker_waves = class({})

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:GetActivityTranslationModifiers( params )
	return "channelling"
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:OnCreated( kv )
	if IsServer() then
		self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
		self.projectile_radius = self:GetAbility():GetSpecialValueFor( "projectile_radius" )
		self.cast_range = self:GetAbility():GetSpecialValueFor( "cast_range" )
		self.tick_interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
		self.pulses = self:GetAbility():GetSpecialValueFor( "pulses" )
		self.pulse_width = self:GetAbility():GetSpecialValueFor( "pulse_width" )

		self.bOffset = false

		self:StartIntervalThink( self.tick_interval )
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:OnDestroy()
	if IsServer() then
	end
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_waves:OnIntervalThink()
	if IsServer() then
		EmitSoundOn( "SandKing.Epicenter.PulsesBegin", self:GetCaster() )

		local angle = QAngle( 0, 0, 0 )
		local nOffset = 0

		for i = 1, self.pulses do
			local info = {
				EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", 
				Ability = self:GetAbility(),
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = self.projectile_radius,
				fEndRadius = self.projectile_radius,
				fDistance = self.cast_range,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bProvidesVision = true,
				iVisionRadius = self.projectile_radius,
				iVisionTeamNumber = self:GetParent():GetTeamNumber(),
			}
			info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.projectile_speed

			local proj = {}
			proj.handle = ProjectileManager:CreateLinearProjectile( info )

			self.last_y = angle.y

			if self.bOffset and i == 1 then
				nOffset = ( 360 / self.pulses ) / 2
			else
				nOffset = 0
			end

			angle.y = self.last_y + ( ( 360 / self.pulses ) + nOffset )

			table.insert( self:GetAbility().Projectiles, proj )

			EmitSoundOn( "Siltbreaker.Waves.Cast", self:GetParent() )
		end

		self.bOffset = ( not self.bOffset )
	end
end