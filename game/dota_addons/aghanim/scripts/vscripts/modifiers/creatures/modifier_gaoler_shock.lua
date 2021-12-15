modifier_gaoler_shock = class({})
----------------------------------------------------

function modifier_gaoler_shock:IsHidden()
	return true
end

----------------------------------------------------

function modifier_gaoler_shock:IsPurgable()
	return false
end

----------------------------------------------------

function modifier_gaoler_shock:OnCreated( kv )
	self.shock_interval = self:GetAbility():GetSpecialValueFor( "shock_interval" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.start_radius = self:GetAbility():GetSpecialValueFor( "start_radius" )
	self.radius_step = self:GetAbility():GetSpecialValueFor( "radius_step" )
	if IsServer() then
		self.nCurrentRadius = self.start_radius

		self:OnIntervalThink()
		self:StartIntervalThink( self.shock_interval )
	end
end

----------------------------------------------------

function modifier_gaoler_shock:OnIntervalThink()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/gaoler/gaoler_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 500, self.nCurrentRadius + self.radius_step, 1.0 ) )
		self:AddParticle( nFXIndex, false, false, -1, false, false )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.nCurrentRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}

				ApplyDamage( damageInfo )
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_razor/razor_base_attack_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				EmitSoundOn( "Ability.PlasmaFieldImpact", enemy )
			end
		end
		self.nCurrentRadius = self.nCurrentRadius + self.radius_step
	end
end

----------------------------------------------------