
modifier_boss_tinker_laser_dummy = class({})

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_dummy:IsHidden()
	return true
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_dummy:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_dummy:CheckState()
	local state =
	{
		[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_INVISIBLE ] = true,
		--[ MODIFIER_PROPERTY_PROVIDES_FOW_POSITION ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
