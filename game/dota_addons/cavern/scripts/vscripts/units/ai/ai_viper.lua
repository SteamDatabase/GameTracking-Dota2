
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hNethertoxinAbility = thisEntity:FindAbilityByName( "creature_viper_nethertoxin" )

	thisEntity:SetContextThink( "ViperThink", ViperThink, 1 )
end

--------------------------------------------------------------------------------

function ViperThink()
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
	if hRandomPlayer and hNethertoxinAbility and hNethertoxinAbility:IsCooldownReady() then
		CastNethertoxinAbility( hRandomPlayer:GetAbsOrigin() )
		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastNethertoxinAbility( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hNethertoxinAbility:entindex(),
		Position = vPos,
	})
end

--------------------------------------------------------------------------------
