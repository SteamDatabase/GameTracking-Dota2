modifier_aghanim_crystal_attack_active = class({})

---------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_active:GetEffectName()
	return "particles/creatures/aghanim/aghanim_pulse_ambient.vpcf"; 
end

---------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_active:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_active:OnCreated( kv )
	self.pulse_radius = self:GetAbility():GetSpecialValueFor( "pulse_radius" )
	self.pulse_damage = self:GetAbility():GetSpecialValueFor( "pulse_damage" )
	self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.pulse_damage_pct = self:GetAbility():GetSpecialValueFor( "pulse_damage_pct" )
end

--------------------------------------------------------------------------------

function modifier_aghanim_crystal_attack_active:Pulse()
	if IsServer() then

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_self_dmg.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.pulse_radius, self.pulse_radius, self.pulse_radius ) )

		EmitSoundOn( "Hero_Lich.IceAge.Tick", self:GetParent() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.pulse_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsAttackImmune() == false then
				
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghanim_crystal_attack_debuff", { duration = self.debuff_duration } )
				
				local flDamage = enemy:GetMaxHealth() * self.pulse_damage_pct / 100

				local damage = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = flDamage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self:GetAbility(),
				}
		
				ApplyDamage( damage )


				local nFXIndex2 = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
				ParticleManager:ReleaseParticleIndex( nFXIndex2 )

				EmitSoundOn( "Hero_Leshrac.Pulse_Nova_Strike", enemy )
			end
		end
	end
end