
modifier_creature_invoker = class({})

--------------------------------------------------------------------------------

function modifier_creature_invoker:GetStatusEffectName()  
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
	--return "particles/status_fx/status_effect_burn.vpcf"
end

--------------------------------------------------------------------------------

function modifier_creature_invoker:StatusEffectPriority()
	return 20010
end

--------------------------------------------------------------------------------

function modifier_creature_invoker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_invoker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_invoker:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_BLIND ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------
