modifier_blessing_magic_damage_bonus = class({})

--------------------------------------------------------------------------------

function modifier_blessing_magic_damage_bonus:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_damage_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_magic_damage_bonus:GetModifierSpellAmplify_Percentage( params )
	return self:GetStackCount()
end


--------------------------------------------------------------------------------
function modifier_blessing_magic_damage_bonus:IsPermanent()
	return true
end