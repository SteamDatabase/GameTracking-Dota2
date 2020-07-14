modifier_sand_king_boss_epicenter = class({})

-----------------------------------------------------------------------------

function modifier_sand_king_boss_epicenter:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_sand_king_boss_epicenter:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_sand_king_boss_epicenter:OnCreated( kv )
	if IsServer() then
		if self:GetAbility().nCastCount == nil then
			self:GetAbility().nCastCount = 1 
		else
			self:GetAbility().nCastCount = self:GetAbility().nCastCount + 1 
		end
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
		self.pulse_width = self:GetAbility():GetSpecialValueFor( "pulse_width" )
		self.pulse_end_width = self:GetAbility():GetSpecialValueFor( "pulse_end_width" )
		self.pulse_speed = math.min( self:GetAbility():GetSpecialValueFor( "min_pulse_speed" ) + self:GetAbility():GetSpecialValueFor( "speed_step" ) * self:GetAbility().nCastCount, self:GetAbility():GetSpecialValueFor( "max_pulse_speed" ) )
		self.pulse_distance = self:GetAbility():GetSpecialValueFor( "pulse_distance" )
		self.random_pulses_step = self:GetAbility():GetSpecialValueFor( "random_pulses_step" )
		self.random_pulses = math.min( self:GetAbility():GetSpecialValueFor( "min_random_pulses" ) + ( self:GetAbility().nCastCount * self.random_pulses_step ), self:GetAbility():GetSpecialValueFor( "max_random_pulses" ) )
		self:StartIntervalThink( self.interval )
	end
end

-----------------------------------------------------------------------------

function modifier_sand_king_boss_epicenter:OnDestroy()
	if IsServer() then
	end
end

-----------------------------------------------------------------------------

function modifier_sand_king_boss_epicenter:OnIntervalThink()
	if IsServer() then
		EmitSoundOn( "SandKing.Epicenter.PulsesBegin", self:GetCaster() )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil then
				local vDirection = ( enemy:GetOrigin() + RandomVector( 1 ) * self.pulse_width ) - self:GetCaster():GetOrigin()
				vDirection.z = 0.0
				vDirection = vDirection:Normalized()

				local info = 
				{
					Ability = self:GetAbility(),
					vSpawnOrigin = self:GetCaster():GetOrigin(), 
					fStartRadius = self.pulse_width,
					fEndRadius = self.pulse_end_width,
					vVelocity = vDirection * self.pulse_speed,
					fDistance = self.pulse_distance,
					Source = self:GetCaster(),
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				}

				local proj = {}
				proj.handle = ProjectileManager:CreateLinearProjectile( info )
				proj.nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sand_king_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( proj.nFXIndex, 0, self:GetParent():GetOrigin() )
				ParticleManager:SetParticleControl( proj.nFXIndex, 1, vDirection * self.pulse_speed )
				ParticleManager:SetParticleControl( proj.nFXIndex, 2, Vector( self.pulse_width, self.pulse_width, 0 ) )
				ParticleManager:SetParticleControl( proj.nFXIndex, 4, Vector( self.pulse_distance / self.pulse_speed + 1, 0, 0 ) )

				table.insert( self:GetAbility().Projectiles, proj )
				EmitSoundOn( "SandKing.Epicenter.Pulse", self:GetParent() )
			end
		end

		for i=1,self.random_pulses do 
			local vDirection = ( self:GetCaster():GetOrigin() + ( RandomVector( 1 ) * self.pulse_distance ) ) - self:GetCaster():GetOrigin()
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()

			local info = 
			{
				Ability = self:GetAbility(),
				vSpawnOrigin = self:GetCaster():GetOrigin(), 
				fStartRadius = self.pulse_width,
				fEndRadius = self.pulse_end_width,
				vVelocity = vDirection * self.pulse_speed,
				fDistance = self.pulse_distance,
				Source = self:GetCaster(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			}

			local proj = {}
			proj.handle = ProjectileManager:CreateLinearProjectile( info )
			proj.nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sand_king_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( proj.nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( proj.nFXIndex, 1, vDirection * self.pulse_speed )
			ParticleManager:SetParticleControl( proj.nFXIndex, 2, Vector( self.pulse_width, self.pulse_width, 0 ) )
			ParticleManager:SetParticleControl( proj.nFXIndex, 4, Vector( self.pulse_distance / self.pulse_speed + 1, 0, 0 ) )

			table.insert( self:GetAbility().Projectiles, proj )
			EmitSoundOn( "SandKing.Epicenter.Pulse", self:GetParent() )
		end
	end
end