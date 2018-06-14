
modifier_lycan_invuln = class({})

--------------------------------------------------------------------------------

function modifier_lycan_invuln:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lycan_invuln:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_lycan_invuln:OnCreated( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_lycan_invuln:CheckState()
	local state = {}
	state[ MODIFIER_STATE_INVULNERABLE ] = true
	return state
end

--------------------------------------------------------------------------------
