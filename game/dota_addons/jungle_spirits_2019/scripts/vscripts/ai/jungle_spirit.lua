
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.fThinkInterval = 0.1
	thisEntity.fCommonSpellBufferInterval = 0.25
	thisEntity.fBigSpellBufferInterval = 7
	thisEntity.flNextBigSpellAvailableTime = 0.0

	thisEntity.fAllySearchRangeMedium = 1200
	thisEntity.fEnemySearchRangeMedium = 1200
	thisEntity.fEnemySearchRangeNear = 600

	-- For finding enemies in a circle without the inner ring 
	thisEntity.fEnemyRingRangeMin = 500

	thisEntity.hAbilities = {}

	thisEntity:SetContextThink( "JungleSpiritThink", JungleSpiritThink, thisEntity.fThinkInterval )
end

--------------------------------------------------------------------------------

function EvaluateFunctionForBranchID( nBranchID, hUnits )
	if nBranchID == SPIRIT_BRANCH_JUNGLE then
		return EvaluateJungleHealBeam( hUnits )
	end
	if nBranchID == SPIRIT_BRANCH_STORM then
		return EvaluateStormCyclone( hUnits )
	end
	if nBranchID == SPIRIT_BRANCH_VOLCANO then
		return EvaluateVolcanoEruption( hUnits )
	end

	return nil
end

--------------------------------------------------------------------------------

function JungleSpiritThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.01
	end

	if thisEntity:IsControllableByAnyPlayer() then
		return thisEntity.fThinkInterval
	end

	if thisEntity.bIsActive == false then
		return thisEntity.fThinkInterval
	end

	if thisEntity:IsChanneling() then
		return thisEntity.fThinkInterval
	end

	FindNewAbilities()

	-- print( string.format( "%s on %s is thinking", thisEntity:GetUnitName(), GetTeamName( thisEntity:GetTeamNumber() ) ) )

	local hUnits = {}

	-- Allied heroes at medium distance
	hUnits.hAlliedHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, thisEntity.fAllySearchRangeMedium, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	--local hAlliedHeroesShuffled = ShuffledList( hUnits.hAlliedHeroes )

	-- Enemy heroes at medium distance
	hUnits.hEnemyHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, thisEntity.fEnemySearchRangeMedium, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	hUnits.hEnemyHeroesShuffled = ShuffledList( hUnits.hEnemyHeroes )

	-- Enemy heroes nearby
	hUnits.hEnemyHeroesNearby = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, thisEntity.fEnemySearchRangeNear, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	hUnits.hEnemyHeroesNearbyShuffled = ShuffledList( hUnits.hEnemyHeroesNearby )

	-- Enemy units nearby
	hUnits.hEnemyUnitsNearby = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, thisEntity.fEnemySearchRangeNear, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	hUnits.hEnemyUnitsNearbyShuffled = ShuffledList( hUnits.hEnemyUnitsNearby )
	if thisEntity:GetAggroTarget() ~= nil then
		table.insert( hUnits.hEnemyUnitsNearbyShuffled, 1, thisEntity:GetAggroTarget() )
	end

	-- Farthest Enemy heroes in a ring between Min and Max range
	hUnits.hFarthestEnemyHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, thisEntity.fEnemySearchRangeMedium, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false )
								  
	--hUnits.hEnemyHeroesRingShuffled = ShuffledList( hUnits.hEnemyHeroesRing )

	--print( string.format( "> fRoll == %.2f, fOffensiveChance == %.2f", fRoll, fOffensiveChance ) )
	if thisEntity.BranchData == nil then
		print( "BranchData is nil" )
		return thisEntity.fThinkInterval
	end

	local branches = {}
	for i = SPIRIT_BRANCH_JUNGLE, SPIRIT_BRANCH_VOLCANO do 
		table.insert( branches, i, i )
	end

	local orderedBranches = {}

	while #branches > 0 do
		local nHighestBranch = -1
		local nHighestTier = -1
		local nToRemove = nil

		for k,v in pairs( branches ) do
			if thisEntity.BranchData[v].nCurrentTier > nHighestTier then
				nHighestTier = thisEntity.BranchData[v].nCurrentTier
				nHighestBranch = v
				nToRemove = k
			end
		end

		table.insert( orderedBranches, nHighestBranch )
		table.remove( branches, nToRemove )
	end

	local flBigSpellThink = nil
	if GameRules:GetGameTime() > thisEntity.flNextBigSpellAvailableTime then
		for _,branch in pairs( orderedBranches ) do
			flBigSpellThink = EvaluateFunctionForBranchID( branch, hUnits )
			if flBigSpellThink ~= nil then
				thisEntity.flNextBigSpellAvailableTime = GameRules:GetGameTime() + thisEntity.fBigSpellBufferInterval
				 -- Don't return flBigSpellThink because we still want to be able to think again soon
				 -- in order to common abilities like MeleeSmash
				return flBigSpellThink
			end
		end
	end
	
	local flMeleeThink = EvaluateMeleeSmash( hUnits )
	if flMeleeThink ~= nil then
		return flMeleeThink
	end

	local flRangeThink = EvaluateRangeAttack( hUnits )
	if flRangeThink ~= nil then
		return flRangeThink
	end

	return thisEntity.fThinkInterval
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- INDIVIDUAL ABILITY EVALUATIONS
--------------------------------------------------------------------------------

function EvaluateVolcanoEruption( hUnits )
	--print( ">> EvaluateVolcanoEruption()" )
	if thisEntity.hAbilities.hVolcanoEruption and thisEntity.hAbilities.hVolcanoEruption:IsFullyCastable() then
		for _, hEnemyHero in pairs( hUnits.hEnemyHeroesNearby ) do
			if hEnemyHero then
				-- Should change this to do a radial search around target candidate to try to get 2+ heroes in the VolcanoEruption
				return CastVolcanoEruption( hEnemyHero )
			end
		end
	end
end

--------------------------------------------------------------------------------

function EvaluateStormCyclone( hUnits )
	--print( ">> EvaluateVolcanoEruption()" )
	if thisEntity.hAbilities.hStormCyclone and thisEntity.hAbilities.hStormCyclone:IsFullyCastable() then
		for _, hEnemyHero in pairs( hUnits.hEnemyHeroesNearby ) do
			if hEnemyHero then
				-- Should change this to do a radial search around target candidate to try to get 2+ heroes in the StormCyclone
				return CastStormCyclone( hEnemyHero )
			end
		end
	end
end
--------------------------------------------------------------------------------

function EvaluateJungleHealBeam( hUnits )
	--print( ">> EvaluateVolcanoEruption()" )
	if thisEntity.hAbilities.hJungleHealBeam and thisEntity.hAbilities.hJungleHealBeam:IsFullyCastable() then
		for _, hEnemyHero in pairs( hUnits.hEnemyHeroesNearby ) do
			if hEnemyHero then
				-- Should change this to do a radial search around target candidate to try to get 2+ heroes in the StormCyclone
				return CastJungleHealBeam( hEnemyHero )
			end
		end
	end
end


--------------------------------------------------------------------------------

function EvaluateMeleeSmash( hUnits )
	if thisEntity.hAbilities.hMeleeSmash and thisEntity.hAbilities.hMeleeSmash:IsFullyCastable() and not thisEntity.hAbilities.hMeleeSmash:IsInAbilityPhase() then
		for _, hEnemy in pairs( hUnits.hEnemyUnitsNearbyShuffled ) do
			if hEnemy then
				local vPos = hEnemy:GetAbsOrigin()
				if hEnemy:IsBuilding() then
					local flHullRadius = hEnemy:GetHullRadius()
					local vToBeast = thisEntity:GetAbsOrigin() - hEnemy:GetAbsOrigin()
					vToBeast = vToBeast:Normalized()
					vPos = hEnemy:GetAbsOrigin() + ( vToBeast * flHullRadius )

				end
				return CastMeleeSmash( vPos )
			end
		end
	end

	return nil
end

--------------------------------------------------------------------------------

function EvaluateRangeAttack( hUnits )
	--print( ">> EvaluateRangeAttack()" )
	if thisEntity.hAbilities.hRangeAttack and thisEntity.hAbilities.hRangeAttack:IsFullyCastable() then
		for _, hEnemyHero in pairs( hUnits.hFarthestEnemyHeroes ) do
			if hEnemyHero and ( thisEntity:GetAbsOrigin() - hEnemyHero:GetAbsOrigin()):Length() >= thisEntity.fEnemyRingRangeMin then
				return CastRangeAttack( hEnemyHero )
			end
		end
	end

	return nil
end


--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- CAST ORDERS
--------------------------------------------------------------------------------

function CastMeleeSmash( vTargetPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hAbilities.hMeleeSmash:entindex(),
		Queue = false,
	})

	return thisEntity.hAbilities.hMeleeSmash:GetCastPoint() + thisEntity.fCommonSpellBufferInterval
end

--------------------------------------------------------------------------------

function CastRangeAttack( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hAbilities.hRangeAttack:entindex(),
		Queue = false,
	})

	return thisEntity.hAbilities.hRangeAttack:GetCastPoint() + thisEntity.fCommonSpellBufferInterval
end


--------------------------------------------------------------------------------

function CastJungleHealBeam()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hAbilities.hJungleHealBeam:entindex(),
		Queue = false,
	})

	return thisEntity.hAbilities.hJungleHealBeam:GetCastPoint() + thisEntity.fCommonSpellBufferInterval
end

--------------------------------------------------------------------------------

function CastStormCyclone( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hAbilities.hStormCyclone:entindex(),
		Queue = false,
	})

	return thisEntity.hAbilities.hStormCyclone:GetCastPoint() + thisEntity.fCommonSpellBufferInterval
end

--------------------------------------------------------------------------------

function CastVolcanoEruption( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hAbilities.hVolcanoEruption:entindex(),
		Queue = false,
	})

	return thisEntity.hAbilities.hVolcanoEruption:GetCastPoint() + thisEntity.fCommonSpellBufferInterval
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function FindNewAbilities()
	if not thisEntity.hAbilities.hMeleeSmash then
		thisEntity.hAbilities.hMeleeSmash = thisEntity:FindAbilityByName( "jungle_spirit_melee_smash" )
	end

	if not thisEntity.hAbilities.hRangeAttack then
		thisEntity.hAbilities.hRangeAttack = thisEntity:FindAbilityByName( "jungle_spirit_range_attack" )
	end

	if not thisEntity.hAbilities.hJungleHealBeam then
		thisEntity.hAbilities.hJungleHealBeam = thisEntity:FindAbilityByName( "morokai_jungle_heal_beam" )
	end

	if not thisEntity.hAbilities.hStormCyclone then
		thisEntity.hAbilities.hStormCyclone = thisEntity:FindAbilityByName( "jungle_spirit_storm_cyclone" )
	end

	if not thisEntity.hAbilities.hVolcanoEruption then
		thisEntity.hAbilities.hVolcanoEruption = thisEntity:FindAbilityByName( "junglespirit_volcano_eruption" )
	end
end

--------------------------------------------------------------------------------
