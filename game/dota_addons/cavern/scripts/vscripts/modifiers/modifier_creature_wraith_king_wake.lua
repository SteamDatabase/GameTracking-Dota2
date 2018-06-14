modifier_creature_wraith_king_wake = class({})

---------------------------------------------------------

function modifier_creature_wraith_king_wake:IsHidden()
	return false
end

---------------------------------------------------------

function modifier_creature_wraith_king_wake:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_creature_wraith_king_wake:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_wraith_king_wake:GetOverrideAnimation( params )
	return ACT_DOTA_SPAWN
end

-------------------------------------------------------------------------------

function modifier_creature_wraith_king_wake:GetOverrideAnimationRate( params )
	return 0.4
end