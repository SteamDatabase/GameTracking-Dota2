require( "modifiers/modifier_blessing_base" )

modifier_blessing_respawn_time_reduction = class( modifier_blessing_base )

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:OnBlessingCreated( kv )
	self.respawn_time_reduction = kv.respawn_time_reduction
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:GetRespawnTimeReduction()
	return self.respawn_time_reduction
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:GetModifierPercentageRespawnTime( params )
	return self.respawn_time_reduction
end

--------------------------------------------------------------------------------

function modifier_blessing_respawn_time_reduction:OnTooltip( params )
	local nRespawnReduction = ( self.respawn_time_reduction * 100.0 )
	return nRespawnReduction
end
