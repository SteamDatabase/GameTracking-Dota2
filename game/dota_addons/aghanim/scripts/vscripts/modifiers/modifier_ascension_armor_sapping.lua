
modifier_ascension_armor_sapping = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_armor_sapping:GetTexture()
	return "events/aghanim/interface/hazard_armorshred"
end

----------------------------------------

function modifier_ascension_armor_sapping:OnCreated( kv )
	self.model_scale_per_stack = self:GetAbility():GetSpecialValueFor( "model_scale_per_stack" )
	self.armor_reduction_per_stack = self:GetAbility():GetSpecialValueFor( "armor_reduction_per_stack" )

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/medallion_of_courage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true );
	self:AddParticle( nFXIndex, false, false, -1, false, true );	
end

--------------------------------------------------------------------------------

function modifier_ascension_armor_sapping:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_ascension_armor_sapping:GetModifierModelScale( params )
	local flScale = self.model_scale_per_stack * self:GetStackCount() 
	if flScale < 50 then
		return -flScale
	else
		return -50
	end
end

--------------------------------------------------------------------------------

function modifier_ascension_armor_sapping:GetModifierPhysicalArmorBonus( params )
	return -self.armor_reduction_per_stack * self:GetStackCount() 
end
