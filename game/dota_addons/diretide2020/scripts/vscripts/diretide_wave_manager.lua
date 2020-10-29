
--[[
	CDiretideWaveManager - A single round of Diretide
]]

--------------------------------------------------------------------------------

require( "diretide_utility_functions" )

--------------------------------------------------------------------------------

if CDiretideWaveManager == nil then
	CDiretideWaveManager = class({})
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:ReadConfiguration( kv, roundNumber, nTeam )
	--print( "CDiretideWaveManager:ReadConfiguration" )
	self.nTeam = nTeam

	self._nRoundNumber = roundNumber
	self._szRoundQuestTitle = kv.round_name or "#DOTA_Quest_Holdout_Round"
	self._szRoundTitle = kv.round_title or string.format( "Round%d", roundNumber )
	self._szRoundDescription = kv.round_description
	self._szSoundName = kv.StartSoundName or ""

	self._vExtraWaveEnemiesRemaining = {}

	self._nMaxGold = tonumber( kv.MaxGold or 0 )
	self._nFixedXP = tonumber( kv.FixedXP or 0 )
	self._nStarRanking = 0
	self._nMaxDenies = tonumber( kv.DeniesBeforeLimitRewards or 0 )

	self._bPrecached = false

	self._vWaves = {}
	for k, v in pairs( kv.Waves) do
		local spawner = CDiretideGameSpawner()
		spawner:ReadConfiguration( k, v, self, self.nTeam )
		table.insert( self._vWaves, spawner )
		--print( "wave count now " .. #self._vWaves )
	end
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:Precache()
	if self._bPrecached == true then
		return
	end

	for _,spawner in ipairs( self._vWaves ) do
		spawner:Precache()
	end

	--self:ManualPrecache()

	self._bPrecached = true
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:Begin()
	--print( string.format( "CDiretideWaveManager:Begin(): Starting up %d waves", #self._vWaves ) )
	self._vEnemiesRemaining = {}
	self._vExtraWaveEnemiesRemaining = {}
	self._vEventHandles = {
		ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDiretideWaveManager, "OnEntityKilled" ), self ),
	}

	self._flRoundStartTime = GameRules:GetDOTATime( false, true )
	self._nGiftsDroppedThisRound = 0

	self:CountCoreUnits()
	self._nCoreUnitsKilled = 0
	self._nNPCSpawnedUnitsKilled = 0

	local nTeamToCheck = self.nTeam
	if _G.DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS == true then
		nTeamToCheck = FlipTeamNumber( self.nTeam )
	end

	GameRules.Diretide:SetRemainingXPForTeam( nTeamToCheck, self._nFixedXP )
	GameRules.Diretide:SetRemainingGoldForTeam( nTeamToCheck, self._nMaxGold )

	for _,spawner in ipairs( self._vWaves ) do
		spawner:Begin()
	end

	-- we only play for GOODGUYS because there are two sets of these spawners, one per team.
	-- and we're playing a global sound, so we don't want to play it twice.
	if self.nTeam == DOTA_TEAM_GOODGUYS and self._szSoundName ~= nil and self._szSoundName ~= "" then
		EmitGlobalSound( self._szSoundName )
	end
end

--------------------------------------------------------------------------------
function CDiretideWaveManager:GetTotalXP()
	return self._nFixedXP or 0
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:CountCoreUnits()
	self._nCoreUnitsTotal = 0
	for _, spawner in ipairs( self._vWaves ) do
		self._nCoreUnitsTotal = self._nCoreUnitsTotal + spawner:GetTotalUnitsToSpawn()
	end
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:GetTotalCandy()
	local nTotalCandy = 0
	for _, spawner in ipairs( self._vWaves ) do
		nTotalCandy = nTotalCandy + spawner:GetTotalCandy()
	end

	return nTotalCandy
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:End( bRoundSummary )
	for _, eID in pairs( self._vEventHandles ) do
		StopListeningToGameEvent( eID )
	end
	self._vEventHandles = {}

	-- clean up all living enemies
	for i, unit in pairs( self._vEnemiesRemaining ) do
		if unit and not unit:IsNull() then
			UTIL_Remove( unit )
		end
	end	
	self._vEnemiesRemaining = nil

	for i, unit in pairs( self._vExtraWaveEnemiesRemaining ) do
		if unit and not unit:IsNull() then
			UTIL_Remove( unit )
		end
	end	
	self._vExtraWaveEnemiesRemaining = nil
	
	local nTeamToCheck = self.nTeam
	if _G.DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS == true then
		nTeamToCheck = FlipTeamNumber( self.nTeam )
	end
	GameRules.Diretide:GrantGoldAndXPToTeam( nTeamToCheck, GameRules.Diretide:GetRemainingGoldForTeam( nTeamToCheck ), GameRules.Diretide:GetRemainingXPForTeam( nTeamToCheck ) )

	for _, spawner in ipairs( self._vWaves ) do
		spawner:End()
	end
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:Think()
	local nTeamToCheck = self.nTeam
	if _G.DIRETIDE_FLIP_SPAWNER_TEAM_NUMBERS == false then
		nTeamToCheck = FlipTeamNumber( self.nTeam )
	end
	if _G.DIRETIDE_ONLY_SPAWN_IF_TEAM_HAS_PLAYERS == true and ( not DoPlayersExistOnTeam( nTeamToCheck ) ) then
		return
	end

	for _, spawner in ipairs( self._vWaves ) do
		spawner:Think()
	end
end

-- Rather than use the xp granting from the units keyvalues file,
-- we let the round determine the xp per unit to grant as a flat value.
-- This is done to make tuning of rounds easier.
function CDiretideWaveManager:GetXPPerCoreUnit()
	if self._nCoreUnitsTotal == 0 then
		return 0
	else
		return math.ceil( self._nFixedXP / math.max( 1, self._nCoreUnitsTotal - self._nMaxDenies ) )
	end
end

-- Rather than use the gold granting from the units keyvalues file,
-- we let the round determine the gold per unit to grant as a flat value.
-- This is done to make tuning of rounds easier.
function CDiretideWaveManager:GetGoldPerCoreUnit()
	if self._nCoreUnitsTotal == 0 then
		return 0
	else
		return math.ceil( self._nMaxGold / math.max( 1, self._nCoreUnitsTotal - self._nMaxDenies ) )
	end
end

function CDiretideWaveManager:AddSpawnedUnit( hUnit, bIsExtraUnit )
	if hUnit == nil or hUnit:IsNull() == true then
		error( "INVALID UNIT ADDED TO WAVE MANAGER" )
		return
	end

	if bIsExtraUnit then
		table.insert( self._vExtraWaveEnemiesRemaining, hUnit )
	else
		table.insert( self._vEnemiesRemaining, hUnit )
	end

	hUnit.unitName = hUnit:GetUnitName()
end

function CDiretideWaveManager:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if not killedUnit then
		return
	end

	--printf( "CDiretideWaveManager:OnEntityKilled - unit killed %s", killedUnit:GetUnitName() )

	-- first check if it's an extra-wave enemy
	for i, unit in pairs( self._vExtraWaveEnemiesRemaining ) do
		if killedUnit == unit then
			--printf( "removing extra unit %s", killedUnit.unitName )
			table.remove(self._vExtraWaveEnemiesRemaining, i )
			break
		end
	end

	-- normal-wave find logic
	local bFoundUnit = false
	for i, unit in pairs( self._vEnemiesRemaining ) do
		if killedUnit == unit then
			--printf("removing unit %s", killedUnit:GetUnitName() )
			bFoundUnit = true
			table.remove( self._vEnemiesRemaining, i )
			break
		end
	end	

	if bFoundUnit == false then
		return
	end

	local hKillerUnit = EntIndexToHScript( event.entindex_attacker )

	if killedUnit.Diretide_bIsCore then
		self._nCoreUnitsKilled = self._nCoreUnitsKilled + 1 

		if hKillerUnit ~= nil and hKillerUnit:IsNull() == false and hKillerUnit:GetTeamNumber() ~= killedUnit:GetTeamNumber() then
			local bGrantXP = true
			if hKillerUnit:IsRealHero() == false and _G.DIRETIDE_CREEPS_GIVE_GOLD_XP_ONLY_IF_HERO_NEAR == true then
				local hHeroes = FindUnitsInRadius( hKillerUnit:GetTeamNumber(), killedUnit:GetOrigin(), hKillerUnit, _G.DIRETIDE_CREEPS_GIVE_GOLD_XP_HERO_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false )
				bGrantXP = #hHeroes > 0
			end

			if bGrantXP then
				GameRules.Diretide:GrantGoldAndXPToTeam( hKillerUnit:GetTeamNumber(), self:GetGoldPerCoreUnit(), self:GetXPPerCoreUnit() )
			end
		end
	end

	if killedUnit.Holdout_IsNPCSpawnedUnit then
		self._nNPCSpawnedUnitsKilled = self._nNPCSpawnedUnitsKilled + 1
	end

	-- Candy logic
	if _G.DIRETIDE_CREEPS_DROP_CANDY == true and killedUnit.Diretide_nCandy ~= nil and killedUnit.Diretide_nCandy > 0 then
		-- special clause here for suiciding exploders - if you kill yourself it should not be counted as a deny
		local bDeny = hKillerUnit ~= nil and hKillerUnit:IsNull() == false and hKillerUnit:GetTeamNumber() == killedUnit:GetTeamNumber() and hKillerUnit:GetEntityIndex() ~= killedUnit:GetEntityIndex()
		bDeny = false -- ignore deny logic for now.
		if bDeny == false then
			local nNumCandy = killedUnit.Diretide_nCandy
			local nCandyMult = Convars:GetInt( "diretide_candymult" ) or 1
			if nCandyMult > 1 then
				nNumCandy = nNumCandy * nCandyMult
			end

			local nNumBigBags = math.floor( nNumCandy / _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG )
			if nNumBigBags > 0 then
				nNumCandy = nNumCandy - nNumBigBags * _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG
				for i = 1, nNumBigBags do
					GameRules.Diretide:DropCandyAtPosition( killedUnit:GetAbsOrigin(), killedUnit, hKillerUnit, true, 1.0 )
				end
			end
			for i = 1, nNumCandy do
				GameRules.Diretide:DropCandyAtPosition( killedUnit:GetAbsOrigin(), killedUnit, hKillerUnit, false, 1.0 )
			end

			--[[local bIsBigBag = nNumCandy > 1
			local szItemName = ( bIsBigBag and "item_candy_bag" ) or "item_candy"
			local newItem = CreateItem( szItemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( nNumCandy )
			local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
			if bIsBigBag == true then
				drop:SetModelScale( 3 )
			end
			local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
			newItem:LaunchLoot( true, 300, 0.75, dropTarget )--]]
		end

		-- Clean up, just in case
		killedUnit.Diretide_nCandy = nil
	end
end

--------------------------------------------------------------------------------

function CDiretideWaveManager:StatusReport( )
	print( string.format( "Enemies remaining: %d", #self._vEnemiesRemaining ) )
	for _,e in pairs( self._vEnemiesRemaining ) do
		if e:IsNull() then
			print( string.format( "<Unit %s Deleted from C++>", e.unitName ) )
		else
			print( e:GetUnitName() )
		end
	end
	print( string.format( "Spawners: %d", #self._vWaves ) )
	for _, spawner in pairs( self._vWaves ) do
		spawner:StatusReport()
	end
end

function CDiretideWaveManager:GetTotalUnits()
	return self._nCoreUnitsTotal
end

function CDiretideWaveManager:GetRemainingUnits()
	return #self._vEnemiesRemaining
end

function CDiretideWaveManager:GetTotalUnitsKilled()
	return self._nCoreUnitsKilled + self._nNPCSpawnedUnitsKilled
end

function CDiretideWaveManager:GetRoundNumber()
	return self._nRoundNumber
end

function CDiretideWaveManager:GetRoundTitle()
	return self._szRoundQuestTitle 
end

function CDiretideWaveManager:GetRoundDescription()
	return self._szRoundDescription
end

