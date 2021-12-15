modifier_hero_ambient_effects = class({})

--------------------------------------------------------------------------------

function modifier_hero_ambient_effects:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_hero_ambient_effects:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_hero_ambient_effects:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

-----------------------------------------------------------------------------------------

function modifier_hero_ambient_effects:GetEffectName()
	return "particles/gameplay/hero_ground_light.vpcf"
end
