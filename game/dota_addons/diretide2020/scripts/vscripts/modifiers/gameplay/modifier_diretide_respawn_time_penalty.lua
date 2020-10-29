if modifier_diretide_respawn_time_penalty == nil then
modifier_diretide_respawn_time_penalty = class({})
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:IsHidden()
	local nStackCount = self:GetStackCount()
	return nStackCount <= 0
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:GetRespawnPenalty()
	local nStackCount = self:GetStackCount()
	local nRespawnPenalty = nStackCount * 5
	return nRespawnPenalty
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:GetModifierStackingRespawnTime( params )
	local nRespawnPenalty = self:GetRespawnPenalty()
	--print( 'RESPAWN TIME PENALTY = ' .. nRespawnPenalty )
	return nRespawnPenalty
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:OnTooltip( params )
	local nRespawnPenalty = self:GetRespawnPenalty()
	return nRespawnPenalty
end

--------------------------------------------------------------------------------

function modifier_diretide_respawn_time_penalty:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			--print( 'modifier_diretide_respawn_time_penalty:OnDeath - increasing stack count!' )
			self:SetStackCount( self:GetStackCount() + 1 )
		end
	end
end
