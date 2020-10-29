
modifier_roshan_end_game_cinematic = class({})

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.01 )
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:OnIntervalThink()
	if IsServer() == false then
		return
	end

	self:GetParent():SetAbsAngles( 0, 270, 0 )
end

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_roshan_end_game_cinematic:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_STUNNED ] = false
	end

	return state
end

--------------------------------------------------------------------------------