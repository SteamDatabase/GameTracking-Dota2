
modifier_dragon_knight_egg_smasher_ground_blast = class({})

--------------------------------------------------------------------------------

function modifier_dragon_knight_egg_smasher_ground_blast:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_egg_smasher_ground_blast:OnCreated( kv )
	if IsServer() then
		self.area_of_effect = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )

		if IsServer() then
			StartSoundEventFromPositionReliable( "Ability.PreLightStrikeArray", self:GetParent():GetAbsOrigin() )

			self.nTargetFX1 = ParticleManager:CreateParticle( "particles/act_2/amoeba_marker.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( self.nTargetFX1, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( self.nTargetFX1, 1, Vector( self.area_of_effect, -self.area_of_effect, -self.area_of_effect ) )
			ParticleManager:SetParticleControl( self.nTargetFX1, 2, Vector( self.delay, 0, 0 ) );
			ParticleManager:ReleaseParticleIndex( self.nTargetFX1 )	

			self.nTargetFX2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( self.nTargetFX2, 0, self:GetParent():GetAbsOrigin() )
			ParticleManager:SetParticleControl( self.nTargetFX2, 1, Vector( self.area_of_effect, 1, 1 ) )
			ParticleManager:ReleaseParticleIndex( self.nTargetFX2 )

			self:StartIntervalThink( self.delay )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_dragon_knight_egg_smasher_ground_blast:OnIntervalThink()
	if IsServer() then

		EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Ability.LightStrikeArray", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nTargetFX1, false )
		ParticleManager:DestroyParticle( self.nTargetFX2, false )

		local nBlastFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() );
		ParticleManager:SetParticleControl( nBlastFX, 0, self:GetParent():GetAbsOrigin() );
		ParticleManager:SetParticleControl( nBlastFX, 1,Vector( self.area_of_effect, 1, 1 )  );
		ParticleManager:ReleaseParticleIndex( nBlastFX );

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(),
				self:GetCaster(), self.area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false
		)

		print( "modifier_dragon_knight_egg_smasher_ground_blast: aoe %d", self.area_of_effect )
		print( "modifier_dragon_knight_egg_smasher_ground_blast: #enemies %d", #enemies )

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
				print( "modifier_dragon_knight_egg_smasher_ground_blast: Applying damage" )
				ApplyDamage( DamageInfo )
			end
		end

		self:Destroy()
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------