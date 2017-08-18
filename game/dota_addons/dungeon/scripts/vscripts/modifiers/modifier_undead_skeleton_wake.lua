modifier_undead_skeleton_wake = class({})

---------------------------------------------------------

function modifier_undead_skeleton_wake:IsHidden()
	return true
end

---------------------------------------------------------

function modifier_undead_skeleton_wake:IsPurgable()
	return false
end

---------------------------------------------------------

function modifier_undead_skeleton_wake:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_undead_skeleton_wake:GetOverrideAnimation( params )
	return ACT_DOTA_SPAWN
end

-------------------------------------------------------------------------------

function modifier_undead_skeleton_wake:GetOverrideAnimationRate( params )
	return 0.25
end