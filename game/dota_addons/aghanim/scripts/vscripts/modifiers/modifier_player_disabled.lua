modifier_player_disabled = class({})

--------------------------------------------------------------------------------

function modifier_player_disabled:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_player_disabled:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_player_disabled:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_player_disabled:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	
	return state
end

--------------------------------------------------------------------------------

function modifier_player_disabled:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_player_disabled:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------
--[[
function modifier_player_disabled:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddActivityModifier( 'injured' )
	end
end

--------------------------------------------------------------------------------

function modifier_player_disabled:OnDestroy()
	if IsServer() then
		self:GetParent():ClearActivityModifiers()
	end
end
]]--
