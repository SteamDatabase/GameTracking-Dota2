
modifier_statue_inactive = class({})

--------------------------------------------------------------------------------

function modifier_statue_inactive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_statue_inactive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_statue_inactive:GetStatusEffectName()  
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

--------------------------------------------------------------------------------

function modifier_statue_inactive:StatusEffectPriority()
	return 20010
end

--------------------------------------------------------------------------------

function modifier_statue_inactive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_statue_inactive:GetOverrideAnimation( params )
	return ACT_DOTA_IDLE_STATUE
end

--------------------------------------------------------------------------------

