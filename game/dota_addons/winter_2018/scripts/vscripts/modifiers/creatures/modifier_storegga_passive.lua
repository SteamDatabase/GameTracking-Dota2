
modifier_storegga_passive = class({})

--------------------------------------------------------------------------------

function modifier_storegga_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_passive:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[ MODIFIER_STATE_STUNNED ] = false,
			[ MODIFIER_STATE_SILENCED ] = false,
		}
	end
	
	return state
end

--------------------------------------------------------------------------------
