
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hGooAbility = thisEntity:FindAbilityByName( "creature_bristleback_viscous_nasal_goo" )
	hQuillAbility = thisEntity:FindAbilityByName( "creature_bristleback_quill_spray" )

	thisEntity:SetContextThink( "EimermoleThink", EimermoleThink, 1 )
end

--------------------------------------------------------------------------------

function EimermoleThink()
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
	if hRandomPlayer and hGooAbility and hGooAbility:IsCooldownReady() then
		CastGooAbility( hRandomPlayer )
		return RandomFloat( 0.5, 1.5 )
	end

	if hQuillAbility and hQuillAbility:IsCooldownReady() then
		CastQuillAbility()
		return RandomFloat( 0.5, 1.5 )
	end

	return RandomFloat( 0.5, 1.5 )
end

--------------------------------------------------------------------------------

function CastGooAbility( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = hGooAbility:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CastQuillAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hQuillAbility:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------
