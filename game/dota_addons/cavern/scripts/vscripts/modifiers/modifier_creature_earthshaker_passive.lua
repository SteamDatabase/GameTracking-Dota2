
modifier_creature_earthshaker_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_earthshaker_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_earthshaker_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_earthshaker_passive:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------
