
channel_ability_building = class({})

--------------------------------------------------------------------------------

function channel_ability_building:Precache( context )
end

--------------------------------------------------------------------------------

function channel_ability_building:IsCosmetic()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:OnAbilityPhaseStart()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:OnAbilityPhaseInterrupted()
end


--------------------------------------------------------------------------------

function channel_ability_building:OnChannelThink( flInterval )
	return
end

--------------------------------------------------------------------------------

function channel_ability_building:OnChannelFinish( bInterrupted )
	if bInterrupted then
		return
	end

	local hCaster = self:GetCaster()
	local hBuilding = self:GetCursorTarget()
	local hAbility = hBuilding.hBuildingAbility
	local nPlayerID = hCaster:GetPlayerOwnerID()

	hCaster:Stop()

	if ( bitand( hAbility:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE ) == 0 ) and ( bitand( hAbility:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == 0 ) then
		if hAbility.IsChannelerTargeted ~= nil and hAbility:IsChannelerTargeted() then
			ExecuteOrderFromTable({
				UnitIndex = hBuilding:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hAbility:entindex(),
				TargetIndex = hCaster:entindex(),	
				Queue = false,
			})
			return
		end
		hBuilding:SetControllableByPlayer( nPlayerID, true )
		hBuilding.nLastControlPlayerID = nPlayerID
		hBuilding.nLastCastingPlayerID = nPlayerID
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "player_execute_ability", { ability_ent_index = hBuilding.hBuildingAbility:entindex(), caster_ent_index = hBuilding:entindex(), is_quick_cast = 0, } )
	else
		hBuilding.nLastCastingPlayerID = nPlayerID
		hAbility:CastAbility()
	end
end

--------------------------------------------------------------------------------

function channel_ability_building:IsCosmetic( hEnt )
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function channel_ability_building:IsStealable()
	return false
end

--------------------------------------------------------------------------------

function channel_ability_building:IsHiddenAbilityCastable()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:OtherAbilitiesAlwaysInterruptChanneling()
	return true
end

--------------------------------------------------------------------------------

function channel_ability_building:CastFilterResultTarget( hTarget )
	if hTarget == nil or hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function channel_ability_building:GetCustomCastErrorTarget( hTarget )
	return "#dota_hud_error_already_capturing"
end

--------------------------------------------------------------------------------

function channel_ability_building:OnSpellStart()
end

