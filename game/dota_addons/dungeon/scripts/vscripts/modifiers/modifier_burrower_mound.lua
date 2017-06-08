
modifier_burrower_mound = class({})

--------------------------------------------------------------------------------

function modifier_burrower_mound:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_burrower_mound:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function modifier_burrower_mound:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_ATTACK_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------
