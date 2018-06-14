require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "LichThink", LichThink, 1 )
	thisEntity.hChainFrostAbility = thisEntity:FindAbilityByName( "creature_lich_chain_frost" )

	thisEntity.bUpgraded = false
	
	thisEntity.TeamsEntered = {}
	thisEntity.bCasted = false

end

--------------------------------------------------------------------------------

function LichThink()
	if thisEntity.bUpgraded == false then
		for i = 2,thisEntity.hRoom:GetRoomLevel() do
			printf("upgrading chainfrost %d", i)
			thisEntity.hChainFrostAbility:UpgradeAbility(true)
		end
		thisEntity.bUpgraded = true
	end

	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hEnemies = GetEnemyHeroesInRoom( thisEntity )

	for _,hEnemy in pairs(hEnemies) do
		if thisEntity:IsAlive() and thisEntity.TeamsEntered[hEnemy:GetTeamNumber()] == nil and (thisEntity:GetAbsOrigin() - hEnemy:GetAbsOrigin()):Length2D() < 900 then
			CastChainFrostAbility( GetRandomUnique(thisEntity.Statues, {}, true) )
			thisEntity.TeamsEntered[hEnemy:GetTeamNumber()] = true
		end
	end

	return 0.2
end

--------------------------------------------------------------------------------

function CastChainFrostAbility( hUnit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hChainFrostAbility:entindex(),
		TargetIndex = hUnit:GetEntityIndex(),
		Queue = true,
	})
end

--------------------------------------------------------------------------------
