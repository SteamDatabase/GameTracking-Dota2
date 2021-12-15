
modifier_ascension_magic_immunity = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:GetTexture()
	return "events/aghanim/interface/hazard_magicimmune"
end

----------------------------------------

function modifier_ascension_magic_immunity:OnCreated( kv )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
	EmitSoundOn( "DOTA_Item.BlackKingBar.Activate", self:GetParent() )
end

-----------------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:GetModifierModelScale( params )
	return self.model_scale 
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

--------------------------------------------------------------------------------

function modifier_ascension_magic_immunity:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
