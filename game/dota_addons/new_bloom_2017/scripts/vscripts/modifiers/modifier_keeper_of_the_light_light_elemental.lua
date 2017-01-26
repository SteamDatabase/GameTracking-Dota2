modifier_keeper_of_the_light_light_elemental = class({})

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf";
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:StatusEffectPriority()
	return 20
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:OnCreated( kv )
	if IsServer() then
		self:GetParent():SetRenderColor( 248, 248, 255 )
	end
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_keeper_of_the_light_light_elemental:GetModifierInvisibilityLevel( params )
	return 0.45
end