
if modifier_ghost_fear == nil then
	modifier_ghost_fear = class( {} ) 
end

----------------------------------------------------------------------------------------

function modifier_ghost_fear:IsDebuff()
	return true
end

-----------------------------------------------------------------------------

function modifier_ghost_fear:GetEffectName()
	return "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf"
end

-----------------------------------------------------------------------------

function modifier_ghost_fear:GetStatusEffectName()
	return "particles/status_fx/status_effect_lone_druid_savage_roar.vpcf"
end

-----------------------------------------------------------------------------

function modifier_ghost_fear:StatusEffectPriority()
	return 35
end

-----------------------------------------------------------------------------

function modifier_ghost_fear:OnCreated( kv )
	if IsServer() then
		-- Issue command to travel towards home bucket
		local vTargetPos = nil

		local hBuildings = FindUnitsInRadius( self:GetParent():GetTeamNumber(), Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for _, hBuilding in ipairs( hBuildings ) do
			if hBuilding:GetUnitName() == "home_candy_bucket" then
				vPosition = hBuilding:GetOrigin()
			end
		end

		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vTargetPos,
			Queue = false,
		})
	end
end

-----------------------------------------------------------------------------

function modifier_ghost_fear:CheckState()
	local state =
	{
		[ MODIFIER_STATE_FEARED ] = true,
		[ MODIFIER_STATE_COMMAND_RESTRICTED ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_SILENCED ] = true,
		[ MODIFIER_STATE_MUTED ] = true,
	}

	return state
end

-----------------------------------------------------------------------------
