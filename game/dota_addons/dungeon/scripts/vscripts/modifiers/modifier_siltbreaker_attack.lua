
modifier_siltbreaker_attack = class({})

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_attack:GetTexture()
	return "slardar_amplify_damage"
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_attack:OnCreated( kv )
	self.nArmorReductionPerStack = math.max( math.floor( self:GetAbility():GetSpecialValueFor( "caustic_armor_reduction_pct" ) * self:GetParent():GetPhysicalArmorValue() / 100 ), 1 )
	if IsServer() then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
	end
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_attack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_attack:GetModifierPhysicalArmorBonus()
	if self.nArmorReductionPerStack == nil then
		return 0
	end
	return self.nArmorReductionPerStack * self:GetStackCount() * -1
end

-----------------------------------------------------------------------------------------

