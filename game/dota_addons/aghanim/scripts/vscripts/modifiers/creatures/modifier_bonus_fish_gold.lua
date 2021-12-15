
modifier_bonus_fish_gold = class({})

-----------------------------------------------------------------------------------------

function modifier_bonus_fish_gold:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_fish_gold:GetEffectName()
	return "particles/creatures/bonus_fish/bonus_fish_gold_bottom_ring.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bonus_fish_gold:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end


--------------------------------------------------------------------------------

function modifier_bonus_fish_gold:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bonus_fish_gold:GetModifierModelChange( params )
	return "models/items/hex/fish_hex_retro/fish_hex_retro.vmdl"
end