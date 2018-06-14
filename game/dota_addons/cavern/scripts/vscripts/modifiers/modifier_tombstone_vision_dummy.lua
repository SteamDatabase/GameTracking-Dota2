
modifier_tombstone_vision_dummy = class({})

--------------------------------------------------------------------------------

function modifier_tombstone_vision_dummy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_tombstone_vision_dummy:IsHidden()
	return true
end

--------------------------------------------------------------------------------

--[[
function modifier_tombstone_vision_dummy:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end
]]

--------------------------------------------------------------------------------

function modifier_tombstone_vision_dummy:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_UNSELECTABLE ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_DISARMED ] = true

	end
	
	return state
end

--------------------------------------------------------------------------------
