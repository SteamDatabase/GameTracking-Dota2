modifier_sand_king_boss_caustic_finale = class({})

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:GetTexture()
	return "sandking_caustic_finale"
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:OnCreated( kv )
	self.caustic_radius = self:GetAbility():GetSpecialValueFor( "caustic_radius" ) 
	self.caustic_damage = self:GetAbility():GetSpecialValueFor( "caustic_damage" )
	self.nArmorReductionPerStack = math.max( math.floor( self:GetAbility():GetSpecialValueFor( "caustic_armor_reduction_pct" ) * self:GetParent():GetPhysicalArmorValue() / 100 ), 1 )
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
	end
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:GetModifierPhysicalArmorBonus()
	if self.nArmorReductionPerStack == nil then
		return 0
	end
	return self.nArmorReductionPerStack * self:GetStackCount() * -1
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_caustic_finale:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			EmitSoundOn( "Ability.SandKing_CausticFinale", self:GetParent() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.caustic_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,hEnemy in pairs( enemies ) do
				if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self.caustic_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}
					ApplyDamage( damageInfo )


				end
			end
		end
	end
	return 0
end