
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	thisEntity.hSummonEggsAbility = thisEntity:FindAbilityByName( "kidnap_spider_summon_eggs" )
	thisEntity.hLassoAbility = thisEntity:FindAbilityByName( "aghsfort_batrider_flaming_lasso" )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )

	thisEntity.vCurrentRunAwayPos = nil
	thisEntity.nLassoDragDistance = thisEntity.hLassoAbility:GetSpecialValueFor( "drag_distance" )

	thisEntity.hEntityKilledGameEvent = ListenToGameEvent( "entity_killed", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), "OnEntityKilled" ), nil )

	thisEntity:SetContextThink( "KidnapSpiderThink", KidnapSpiderThink, 1 )
end

--------------------------------------------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.hEntityKilledGameEvent )
end

--------------------------------------------------------------------------------

function KidnapSpiderThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	-- This script was being broken by SetInitialGoalEntity in the encounter's OnSpawnerFinished
	if not thisEntity.bGoalEntCleared then
		thisEntity:SetInitialGoalEntity( nil )
		thisEntity.bGoalEntCleared = true
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 5000,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	if #hEnemies == 0 then
		return 0.1
	end

	-- Summon Eggs
	if thisEntity.hSummonEggsAbility and thisEntity.hSummonEggsAbility:IsFullyCastable() then
		return CastSummonEggs()
	end

	-- Try to Lasso
	if thisEntity.hLassoAbility  and thisEntity.hLassoAbility:IsFullyCastable() then
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsRealHero() and hEnemy:IsAlive() and ( not hEnemy:HasModifier( "modifier_batrider_flaming_lasso" ) ) then
				-- Ensure I have vision
				local hVisionBuff = hEnemy:FindModifierByName( "modifier_provide_vision" )
				if hVisionBuff == nil then
					hVisionBuff = hEnemy:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 15 } )
				end

				return CastLasso( hEnemy )
			end
		end
	end

	if thisEntity.vCurrentRunAwayPos ~= nil then
		--printf( "Have I arrived?" )
		local fDistToRunAwayPos = ( thisEntity.vCurrentRunAwayPos - thisEntity:GetAbsOrigin() ):Length2D()
		--printf( "fDistToRunAwayPos: %d", fDistToRunAwayPos )
		local nDistThreshold = 50
		if fDistToRunAwayPos <= nDistThreshold then
			--printf( "I've arrived close enough to current RunAway position: %s", thisEntity.vCurrentRunAwayPos )
			thisEntity.vCurrentRunAwayPos = nil
			return 3.0
		else
			--printf( "Have not arrived at current RunAway position of: %s", thisEntity.vCurrentRunAwayPos )
			return 0.1
		end
	end

	-- Find eggs at appropriate distances
	local nMinEggDistance = 1400
	local nMinEggFarDistance = 2800
	local nMaxEggDistance = 4500
	local hEggs = {}
	local hFarEggs = {}
	local hAllies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nMaxEggDistance,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false
	)

	for _, hAlly in pairs( hAllies ) do
		if hAlly:GetUnitName() == "npc_dota_spider_sac" then
			--printf( "found \"npc_dota_spider_sac\" ally" )
			local fDistToEgg = ( hAlly:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if fDistToEgg >= nMinEggFarDistance then
				table.insert( hFarEggs, hAlly )
			elseif fDistToEgg >= nMinEggDistance then
				table.insert( hEggs, hAlly )
			end
		end
	end

	-- I can't cast Lasso, and whether I currently have a hero Lasso'd or not I want to run away
	-- First try to find a good position using any distant eggs I found
	local vRunTargetPos = nil

	ShuffleListInPlace( hFarEggs )

	if #hFarEggs > 0 then
		--printf( "we have %d far egg candidates within %d-%d range", #hFarEggs, nMinEggDistance, nMaxEggDistance )
		for _, hEgg in pairs( hFarEggs ) do
			local vToEgg = hEgg:GetOrigin() - thisEntity:GetOrigin()
			local fDistToEgg = vToEgg:Length2D()
			vToEgg.z = 0.0
			vToEgg = vToEgg:Normalized()

			local nDistPastEgg = thisEntity.nLassoDragDistance
			vRunTargetPos = thisEntity:GetAbsOrigin() + ( vToEgg * ( fDistToEgg + nDistPastEgg ) )

			--printf( "evaluating far egg position's pathability" )
			if GridNav:CanFindPath( thisEntity:GetOrigin(), vRunTargetPos ) then
				--printf( "found valid far egg position, so break early -- %s", vRunTargetPos )
				break
			end
		end
	else
		--printf( "no far egg candidates" )
	end

	-- If I didn't get a good distant egg position, look through any medium-range eggs
	if vRunTargetPos == nil then
		ShuffleListInPlace( hEggs )

		if #hEggs > 0 then
			--printf( "we have %d egg candidates within %d-%d range", #hEggs, nMinEggDistance, nMaxEggDistance )
			for _, hEgg in pairs( hEggs ) do
				local vToEgg = hEgg:GetOrigin() - thisEntity:GetOrigin()
				local fDistToEgg = vToEgg:Length2D()
				vToEgg.z = 0.0
				vToEgg = vToEgg:Normalized()

				local nDistPastEgg = thisEntity.nLassoDragDistance
				vRunTargetPos = thisEntity:GetAbsOrigin() + ( vToEgg * ( fDistToEgg + nDistPastEgg ) )

				--printf( "evaluating egg position's pathability" )
				if GridNav:CanFindPath( thisEntity:GetOrigin(), vRunTargetPos ) then
					--printf( "found valid egg position, so break early -- %s", vRunTargetPos )
					break
				end
			end
		else
			--printf( "no medium distance egg candidates" )
		end
	end

	-- If I didn't find any egg positions at all
	if vRunTargetPos == nil then
		vRunTargetPos = FindRandomPointInRoom( thisEntity:GetAbsOrigin(), 1500, 3000 )
		--printf( "had no vRunTargetPos after all the egg searching, so trying random point in room: %s", vRunTargetPos )
	end

	if vRunTargetPos then
		--printf( "  going to position: %s", vRunTargetPos )
		return RunAway( vRunTargetPos )
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastSummonEggs()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hSummonEggsAbility:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hSummonEggsAbility:GetCastPoint() + 0.2
	return fReturnTime
end

--------------------------------------------------------------------------------

function CastLasso( unit )
	--printf( "kidnap_spider - CastLasso" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = unit:entindex(),
		AbilityIndex = thisEntity.hLassoAbility:entindex(),
		Queue = false,
	})

	thisEntity.vCurrentRunAwayPos = nil -- find a new destination

	return thisEntity.hLassoAbility:GetCastPoint() + 0.2
end

--------------------------------------------------------------------------------

function RunAway( vPos )
	--printf( "kidnap_spider - RunAway" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos,
		Queue = true,
	})

	thisEntity.vCurrentRunAwayPos = vPos

	return 1 --11
end

--------------------------------------------------------------------------------

function OnEntityKilled( event )
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	-- Cleanup
	for nPlayerID = 0, ( AGHANIM_PLAYERS - 1 ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			local hMyBuff = hPlayerHero:FindModifierByNameAndCaster( "modifier_provide_vision", thisEntity ) 
			if hMyBuff then
				hMyBuff:Destroy()
				--printf( "kidnap_spider - OnEntityKilled: removing vision buff" )
			end
		end
	end
end

--------------------------------------------------------------------------------
