
modifier_disable_autoattack = class({})

--------------------------------------------------------------------------------

function modifier_disable_autoattack:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_disable_autoattack:CanParentBeAutoAttacked()
	return false
end


function modifier_disable_autoattack:OnCreated( kv )
	if IsServer() then
	end
end

--[[
--------------------------------------------------------------------------------

function modifier_disable_autoattack:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_disable_autoattack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_disable_autoattack:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_disable_autoattack:OnDeath( params )
	if IsServer() then
		if ( params.unit == self:GetParent() ) then
		end
	end
end

-----------------------------------------------------------------------

]]--