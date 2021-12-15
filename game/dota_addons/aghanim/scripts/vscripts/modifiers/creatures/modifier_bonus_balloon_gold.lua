
modifier_bonus_balloon_gold = class({})

-----------------------------------------------------------------------------------------

function modifier_bonus_balloon_gold:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_balloon_gold:GetEffectName()
	return "particles/creatures/bonus_fish/bonus_fish_gold_bottom_ring.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bonus_balloon_gold:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end


--------------------------------------------------------------------------------

function modifier_bonus_balloon_gold:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bonus_balloon_gold:GetModifierModelChange( params )
	return "models/courier/lockjaw/lockjaw_flying.vmdl"
end