modifier_blessing_respawn_time_reduction = class({})

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
	}
	return funcs	
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:GetModifierPercentageRespawnTime( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_blessing_respawn_time_reduction:IsPermanent()
	return true
end