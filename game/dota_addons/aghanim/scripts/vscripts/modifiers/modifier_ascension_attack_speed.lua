
modifier_ascension_attack_speed = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_attack_speed:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_attack_speed:GetTexture()
	return "events/aghanim/interface/hazard_enrage_2"
end

----------------------------------------

function modifier_ascension_attack_speed:OnCreated( kv )
	self:OnRefresh( kv )

	EmitSoundOn( "DOTA_Item.MaskOfMadness.Activate", self:GetParent() )
end

----------------------------------------

function modifier_ascension_attack_speed:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
end

--------------------------------------------------------------------------------

function modifier_ascension_attack_speed:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_attack_speed:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_attack_speed:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
