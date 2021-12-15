
modifier_tinker_turret_ground_blast = class({})

--------------------------------------------------------------------------------

function modifier_tinker_turret_ground_blast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tinker_turret_ground_blast:OnCreated( kv )
	if IsServer() then
		self.area_of_effect = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		self.start_delay = kv[ "start_delay" ]

		--printf( "self.start_delay: %.2f", self.start_delay )

		if IsServer() then
			self:StartIntervalThink( self.start_delay )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_tinker_turret_ground_blast:OnIntervalThink()
	if IsServer() then
		if not self.bStarted then
			EmitSoundOn( "TinkerTurret.SunStrike.Charge", self:GetCaster() )

			local nPreviewFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nPreviewFX, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nPreviewFX, 1, Vector( 50, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( nPreviewFX )

			self.bStarted = true

			self:StartIntervalThink( -1 )

			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_tinker_turret_ground_blast:OnDestroy()
	if IsServer() then
		EmitSoundOn( "TinkerTurret.SunStrike.Ignite", self:GetCaster() )

		local nBlastFX = ParticleManager:CreateParticle( "particles/creatures/tinker_turret/tinker_turret_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nBlastFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nBlastFX, 1, Vector( self.area_of_effect, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nBlastFX )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(),
				self:GetCaster(), self.area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false
		)

		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				local DamageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
				}

				ApplyDamage( DamageInfo )
			end
		end
	end
end

--------------------------------------------------------------------------------
