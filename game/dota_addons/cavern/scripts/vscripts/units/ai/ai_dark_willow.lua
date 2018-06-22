
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hBrambleAbility = thisEntity:FindAbilityByName( "creature_dark_willow_bramble_maze" )

	thisEntity:SetContextThink( "DarkWillowThink", DarkWillowThink, 1 )
end

--------------------------------------------------------------------------------

function DarkWillowThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local nAggroRange = thisEntity:GetAcquisitionRange()

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity, nAggroRange )
	if not hClosestPlayer then
		return 1
	end

	local hVisiblePlayers = GetVisibleEnemyHeroesInRoom( thisEntity, nAggroRange )
	if #hVisiblePlayers <= 0 then
		return 0.5
	end

	local hRandomPlayer = hVisiblePlayers[ RandomInt( 1, #hVisiblePlayers ) ]
	if hRandomPlayer == nil then
		return 0.5
	end

	if thisEntity:GetHealthPercent() < 90 and hBrambleAbility and hBrambleAbility:IsFullyCastable() then
		CastBrambleAbility( hRandomPlayer )
		return RandomFloat( 1.0, 2.0 )
	end

	return RandomFloat( 0.5, 1.5 )
end

--------------------------------------------------------------------------------

function CastBrambleAbility( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = hBrambleAbility:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

