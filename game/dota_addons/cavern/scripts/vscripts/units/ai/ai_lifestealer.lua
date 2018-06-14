
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.ModelScales = { 0.5, 0.8, 1.1, 1.4, 1.7 }

	hRageAbility = thisEntity:FindAbilityByName( "creature_life_stealer_rage" )
	hOpenWoundsAbility = thisEntity:FindAbilityByName( "creature_life_stealer_open_wounds" )

	thisEntity:SetContextThink( "LifestealerThink", LifestealerThink, 0.05 )
end

--------------------------------------------------------------------------------

function LifestealerThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	if not thisEntity.bCustomInitialized then
		local nLevelUpAmt = thisEntity.nRoomLevel - 1
		thisEntity:CreatureLevelUp( nLevelUpAmt )

		local fModelScale = thisEntity.ModelScales[ thisEntity.nRoomLevel ]
		thisEntity:SetModelScale( fModelScale )
		thisEntity.bCustomInitialized = true
	end

	local nAggroRange = 1000
	local enemies = GetNoteworthyVisibleEnemiesNearby( thisEntity, nAggroRange )
	local hClosestPlayer = enemies[ RandomInt( 0, #enemies ) ]

	if not hClosestPlayer then
		return 1
	end

	if hClosestPlayer and hOpenWoundsAbility and hOpenWoundsAbility:IsFullyCastable() then
		CastOpenWoundsAbility( hClosestPlayer )
		return 0.5
	end

	local fMyHealthPct = thisEntity:GetHealthPercent()
	if fMyHealthPct < 50 and hRageAbility and hRageAbility:IsCooldownReady() then
		CastRageAbility()
		return 0.5
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastRageAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hRageAbility:entindex(),
	})
end

--------------------------------------------------------------------------------

function CastOpenWoundsAbility( hTarget )
	assert( hTarget ~= nil, "ERROR: CastOpenWoundsAbility -- hTarget is nil" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hOpenWoundsAbility:entindex(),
		TargetIndex = hTarget:entindex(),
	})
end

--------------------------------------------------------------------------------
