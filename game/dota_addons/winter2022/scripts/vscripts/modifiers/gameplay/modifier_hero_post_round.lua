
if modifier_hero_post_round == nil then
	modifier_hero_post_round = class( {} )
end

-----------------------------------------------------------------------------

function modifier_hero_post_round:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_hero_post_round:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_hero_post_round:OnCreated( kv )
	if IsServer() then
		self:GetParent():Interrupt()
		self:GetParent():Stop()
		self:GetParent():Hold()
	end
end

-----------------------------------------------------------------------------

function modifier_hero_post_round:CheckState()
	local state =
	{
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
