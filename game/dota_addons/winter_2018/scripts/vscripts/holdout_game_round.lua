
--[[
	CHoldoutGameRound - A single round of Holdout
]]

require( "constants" )

--------------------------------------------------------------------------------

if CHoldoutGameRound == nil then
	CHoldoutGameRound = class({})
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:ReadConfiguration( kv, gameMode, roundNumber )
	self._gameMode = gameMode
	self._nRoundNumber = roundNumber
	self._szRoundQuestTitle = kv.round_name or "#DOTA_Quest_Holdout_Round"
	self._szRoundTitle = kv.round_title or string.format( "Round%d", roundNumber )
	self._szRoundDescription = kv.round_description

	self._nMaxGold = tonumber( kv.MaxGold or 0 )
	self._nBagCount = tonumber( kv.BagCount or 0 )
	self._nBagVariance = tonumber( kv.BagVariance or 0 )
	self._nFixedXP = tonumber( kv.FixedXP or 0 )
	self._nGoldFromBagsCollected = 0
	self._nStarRanking = 0

	self._bVisionApplied = false
	self._bPrecached = false
	self._nPointReward = tonumber( kv.PointReward or 0 )
	self._bFinalRound = kv.FinalRound or false
	self._bTimedRound = tonumber(kv.TimedRound)==1 or false
	self._flTimedRoundDuration = tonumber(kv.TimedRoundDuration or 60)
	self._flTimedRoundPostGame = tonumber(kv.TimedRoundPostGame or 0)
	
	self._vSpawners = {}
	for k, v in pairs( kv ) do
		if type( v ) == "table" and v.NPCName then
			local spawner = CHoldoutGameSpawner()
			spawner:ReadConfiguration( k, v, self )
			self._vSpawners[ k ] = spawner
		end
	end

	for _, spawner in pairs( self._vSpawners ) do
		spawner:PostLoad( self._vSpawners )
	end

	self._vPlayerStats = {}
	for nPlayerID = 0, DOTA_DEFAULT_MAX_TEAM-1 do
		self._vPlayerStats[ nPlayerID ] = {
			nCreepsKilled = 0,
			nGoldBagsCollected = 0,
			nDeathsThisRound = 0,
			nPriorRoundDeaths = PlayerResource:GetDeaths( nPlayerID ),
			nPlayersResurrected = 0,
			nGoldFromBags = 0,
			nPotionsTaken = 0,
			nClutches = 0,
			nKillsWithoutDying = 0,
			nKillsInWindow = 0,
		}
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:Precache()
	if self._bPrecached == true then
		return
	end

	for _, spawner in pairs( self._vSpawners ) do
		spawner:Precache()
	end

	--self:ManualPrecache()

	self._roundAwards = CHoldoutGameAwards()
	self._roundAwards:Init( self._gameMode, self )
	self._roundAward = nil

	self._bPrecached = true
end

--------------------------------------------------------------------------------

--[[
function CHoldoutGameRound:ManualPrecache()
	for round, v in pairs( self._roundResources ) do
		print( "round == " .. round )
		for _, precacheCall in round do
			print( "precacheCall == " .. precacheCall )
			precacheCall
		end
	end

	--if GetRoundNumber() == 2 then
		--PrecacheResource( "particle_folder", "particles/units/heroes/hero_dazzle", context )
		--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context )
	--end
end
]]

--------------------------------------------------------------------------------

function CHoldoutGameRound:Begin()
	self._vEnemiesRemaining = {}
	self._vEventHandles = {
		ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CHoldoutGameRound, "OnNPCSpawned" ), self ),
		ListenToGameEvent( "entity_killed", Dynamic_Wrap( CHoldoutGameRound, "OnEntityKilled" ), self ),
		ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CHoldoutGameRound, "OnItemPickedUp_DuringRound" ), self ),
		ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CHoldoutGameRound, "OnHoldoutReviveComplete" ), self )
	}

	self._nGoldRemainingInRound = self._nMaxGold
	self._nGoldBagsRemaining = self._nBagCount
	self._nGoldBagsExpired = 0
	self._nCoreUnitsTotal = 0
	self._nTowers = 0
	self._flRoundStartTime = GameRules:GetGameTime()
	self._nGiftsDroppedThisRound = 0

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_ANY_ORDER, false ) ) do
		if unit:IsTower() then
			self._nTowers = self._nTowers + 1
		end
	end
	self._nTowersStanding = self._nTowers

	for _, spawner in pairs( self._vSpawners ) do
		spawner:Begin()
		self._nCoreUnitsTotal = self._nCoreUnitsTotal + spawner:GetTotalUnitsToSpawn()
	end
	self._nCoreUnitsKilled = 0

	-- are we a bonus round?
	if self._nRoundNumber == 5 or self._nRoundNumber == 10 then
		print( "play bonus round sound" )
		EmitGlobalSound( "Frosthaven.MusicLoop" )
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:End( bRoundSummary )
	for _, eID in pairs( self._vEventHandles ) do
		StopListeningToGameEvent( eID )
	end
	self._vEventHandles = {}

	for _,unit in pairs( FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )) do
		if not unit:IsTower() then
			UTIL_RemoveImmediate( unit )
		end
	end

	for _,spawner in pairs( self._vSpawners ) do
		spawner:End()
	end	

	local nNumPlayersAlive = 0
	local nSurvivingPlayingID = -1
	for nPlayerID = 0, DOTA_DEFAULT_MAX_TEAM-1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hero then
				if hero:IsAlive() then
					print( "Player " .. nPlayerID .. " survived" )
					nNumPlayersAlive = nNumPlayersAlive + 1
					nSurvivingPlayingID = nPlayerID 
				end
				local playerStats = self._vPlayerStats[ nPlayerID ]
				if playerStats then
					playerStats.nKillsWithoutDying = self._gameMode:GetPlayerKillsWithoutDying( nPlayerID )
				end
			end
		end
	end

	if nNumPlayersAlive == 1 then
		local playerStats = self._vPlayerStats[ nSurvivingPlayingID ]
		if playerStats then
			print( "Player " .. nSurvivingPlayingID .. " received a clutch" )
			playerStats.nClutches = playerStats.nClutches + 1
		end
	end


	if bRoundSummary == true then
		self._roundAward = self._roundAwards:EvaluateRoundForAwards( self._vPlayerStats )
		self:DoRoundSummary( award )
	end

	-- are we a bonus round?
	if self._nRoundNumber == 5 or self._nRoundNumber == 10 then
		print( "stop Frosthaven.MusicLoop" )
		StopGlobalSound( "Frosthaven.MusicLoop" )
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:DoRoundSummary()
	self._nTowersStandingGoldReward = self._gameMode:ComputeTowerBonusGold( self._nTowers, self._nTowersStanding )
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do 
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			PlayerResource:ModifyGold( nPlayerID, self._nTowersStandingGoldReward, true, DOTA_ModifyGold_Unspecified )
		end
	end

	self:CalculateStarRanking()
	
	self._gameMode:_SendScoresToClient( true )
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:GetRoundAward()
	return self._roundAward
end

function CHoldoutGameRound:GetTotalTowers()
	return self._nTowers
end

function CHoldoutGameRound:GetTowersRemaining()
	return self._nTowersStanding
end

function CHoldoutGameRound:GetTotalGoldBags()
	return self._nBagCount
end

function CHoldoutGameRound:GetGoldBagsExpired()
	return self._nGoldBagsExpired
end

function CHoldoutGameRound:Think()
	for _, spawner in pairs( self._vSpawners ) do
		spawner:Think()
	end
end


function CHoldoutGameRound:ChooseRandomSpawnInfo()
	return self._gameMode:ChooseRandomSpawnInfo()
end

function CHoldoutGameRound:ChooseRandomSneakySpawnInfo()
	return self._gameMode:ChooseRandomSneakySpawnInfo()
end

function CHoldoutGameRound:IsFinished()

	local flNow = GameRules:GetGameTime()

	for _, spawner in pairs( self._vSpawners ) do
		if not spawner:IsFinishedSpawning() then
			return false
		end
	end

	if self._bTimedRound and self._flRoundStartTime then
		if (flNow - self._flRoundStartTime) > (self._flTimedRoundDuration + self._flTimedRoundPostGame) then
			for i, unit in pairs( self._vEnemiesRemaining ) do
				--unit:Kill(nil, nil)

				if unit ~= nil and unit:IsNull() == false then
					unit:Destroy()
				else
					print( "WARNING - CHoldoutGameRound:IsFinished() - attempted to destroy a unit that doesn't exist anymore.  Some units (e.g. dummies) remove themselves so this is not necessarily a problem." )
				end
			end	
			return true
		else
			return false
		end
	end

	local nEnemiesRemaining = 0

	for i, unit in pairs( self._vEnemiesRemaining ) do
		if unit and not unit:IsNull() then
			nEnemiesRemaining = nEnemiesRemaining + 1
		end
	end	

	if nEnemiesRemaining == 0 then
		if self._bFinalRound then
			if self._gameMode:HasBossDied() == false then
				if self._gameMode:HasBossSpawned() == false then
					self._gameMode:SpawnBoss()
				end
				return false
			end
		end

		return true
	end

	if not self._lastEnemiesRemaining == nEnemiesRemaining then
		self._lastEnemiesRemaining = nEnemiesRemaining
		print ( string.format( "%d enemies remaining in the round...", #self._vEnemiesRemaining ) )
	end

	--if ( (flNow - self._flRoundStartTime > 60) ) and nEnemiesRemaining < 20 then
	if nEnemiesRemaining <= 10 then
		for i, unit in pairs( self._vEnemiesRemaining ) do
			if unit and not unit:IsNull() and self._nRoundNumber ~= 15 then
				printf("REMAINING ENEMY %d is %s at %s", i, unit.unitName, unit:GetAbsOrigin())
			end
		end	
	end

	return false
end


-- Rather than use the xp granting from the units keyvalues file,
-- we let the round determine the xp per unit to grant as a flat value.
-- This is done to make tuning of rounds easier.
function CHoldoutGameRound:GetXPPerCoreUnit()
	if self._nCoreUnitsTotal == 0 then
		return 0
	else
		return math.floor( self._nFixedXP / self._nCoreUnitsTotal )
	end
end


function CHoldoutGameRound:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:IsPhantom() or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:GetUnitName() == "" or spawnedUnit:GetClassname() == "npc_dota_techies_land_mine" then
		return
	end

	if spawnedUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		spawnedUnit:SetMustReachEachGoalEntity(true)
		table.insert( self._vEnemiesRemaining, spawnedUnit )
		spawnedUnit:SetDeathXP( 0 )
		spawnedUnit.unitName = spawnedUnit:GetUnitName()
	end
end


function CHoldoutGameRound:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if not killedUnit then
		return
	end

	--printf("unit killed %s", killedUnit.unitName )

	for i, unit in pairs( self._vEnemiesRemaining ) do
		if killedUnit == unit then
			--printf("removing unit %s", killedUnit.unitName )
			table.remove( self._vEnemiesRemaining, i )
			break
		end
	end	

	if killedUnit:GetUnitName() == "npc_dota_hero_rubick" then
		print( "Big Rubick died" )
		self._gameMode._bBossHasDied = true
		self:End( false )
	end

	if killedUnit.Holdout_IsCore then
		self._nCoreUnitsKilled = self._nCoreUnitsKilled + 1
		self:_CheckForGoldBagDrop( killedUnit )
		self._gameMode:CheckForLootItemDrop( killedUnit )
		self:CheckForGiftItemDrop( killedUnit )

		local heroes = HeroList:GetAllHeroes()
		for i=1,#heroes do
			local hero = heroes[i]
			if hero ~= nil and hero:IsRealHero() and hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				hero:AddExperience( math.ceil( self:GetXPPerCoreUnit() / 5 ), DOTA_ModifyXP_CreepKill, false, true )
			end
		end
	end

	if killedUnit and killedUnit:IsTower() then
		self._nTowersStanding = self._nTowersStanding - 1
	end

	if killedUnit and killedUnit:IsRealHero() then
		print( "Hero died" )
		local nPlayerID = killedUnit:GetPlayerOwnerID()
		if PlayerResource:IsValidTeamPlayerID( nPlayerID ) then
			local playerStats = self._vPlayerStats[ nPlayerID ]
			if playerStats then
				print( "Added a death this round")
				playerStats.nDeathsThisRound = playerStats.nDeathsThisRound + 1
			end
		end
	end

	local attackerUnit = EntIndexToHScript( event.entindex_attacker or -1 )
	if attackerUnit and killedUnit:GetUnitName() ~= "npc_dota_zeus_cloud" then
		local playerID = attackerUnit:GetPlayerOwnerID()
		local playerStats = self._vPlayerStats[ playerID ]
		if playerStats then
			playerStats.nCreepsKilled = playerStats.nCreepsKilled + 1
		end

		if PlayerResource:IsValidTeamPlayerID( playerID ) then
			self._gameMode:IncrementKillsWithoutDying( playerID )
			self._gameMode:IncrementKillsInWindow( playerID )
			local nKillsInWindow = self._gameMode:GetKillsInWindow( playerID )
			if nKillsInWindow ~= nil and nKillsInWindow > playerStats.nKillsInWindow then
				playerStats.nKillsInWindow = nKillsInWindow
			end
		end	
	end


end


function CHoldoutGameRound:OnHoldoutReviveComplete( event )
	local castingHero = EntIndexToHScript( event.caster )
	local targetHero = EntIndexToHScript( event.target )
	if castingHero then
		local nPlayerID = castingHero:GetPlayerOwnerID()
		local playerStats = self._vPlayerStats[ nPlayerID ]
		if playerStats then
			playerStats.nPlayersResurrected = playerStats.nPlayersResurrected + 1
		end

		if targetHero then
			local gameEvent = {}
			gameEvent["player_id"] = castingHero:GetPlayerID()
			gameEvent["teamnumber"] = castingHero:GetTeamNumber()
			gameEvent["locstring_value"] = targetHero:GetUnitName()
			gameEvent["message"] = "#Frosthaven_PlayerHelpedReviveAlly"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
end


function CHoldoutGameRound:OnItemPickedUp_DuringRound( event )
	if event.itemname == "item_bag_of_gold" then
		local playerStats = self._vPlayerStats[ event.PlayerID ]
		if playerStats then
			playerStats.nGoldBagsCollected = playerStats.nGoldBagsCollected + 1
			local item = EntIndexToHScript( event.ItemEntityIndex )
			if item ~= nil then
				playerStats.nGoldFromBags = playerStats.nGoldFromBags + item:GetCurrentCharges()
			end
		end
	end

	if event.itemname == "item_mana_potion" or event.itemname == "item_health_potion" then
		local playerStats = self._vPlayerStats[ event.PlayerID ]
		if playerStats then
			playerStats.nPotionsTaken = playerStats.nPotionsTaken + 1
		end
	end
end


function CHoldoutGameRound:_CheckForGoldBagDrop( killedUnit )
	if self._nGoldRemainingInRound <= 0 then
		return
	end

	local nGoldToDrop = 0
	local nCoreUnitsRemaining = self._nCoreUnitsTotal - self._nCoreUnitsKilled
	if nCoreUnitsRemaining <= 0 then
		nGoldToDrop = self._nGoldRemainingInRound
	else
		local flCurrentDropChance = self._nGoldBagsRemaining / (1 + nCoreUnitsRemaining)
		if RandomFloat( 0, 1 ) <= flCurrentDropChance then
			if self._nGoldBagsRemaining <= 1 then
				nGoldToDrop = self._nGoldRemainingInRound
			else
				nGoldToDrop = math.floor( self._nGoldRemainingInRound / self._nGoldBagsRemaining )
				nCurrentGoldDrop = math.max(1, RandomInt( nGoldToDrop - self._nBagVariance, nGoldToDrop + self._nBagVariance  ) )
			end
		end
	end
	
	nGoldToDrop = math.min( nGoldToDrop, self._nGoldRemainingInRound )
	if nGoldToDrop <= 0 then
		return
	end
	self._nGoldRemainingInRound = math.max( 0, self._nGoldRemainingInRound - nGoldToDrop )
	self._nGoldBagsRemaining = math.max( 0, self._nGoldBagsRemaining - 1 )

	local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( nGoldToDrop )
	local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
	local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
	newItem:LaunchLoot( true, 300, 0.75, dropTarget )
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:CheckForGiftItemDrop( killedUnit )
	if self._nGiftsDroppedThisRound >= MAX_GIFT_DROPS_PER_ROUND then
		return
	end

	--local fGiftDropChance = GIFT_DROP_CHANCE_PER_CREATURE
	local fGiftDropChance = 0

	local nCoreUnitsRemaining = self._nCoreUnitsTotal - self._nCoreUnitsKilled
	if nCoreUnitsRemaining <= 0 and self._nGiftsDroppedThisRound == 0 then
		fGiftDropChance = GIFT_LAST_CREATURE_BASE_DROP_PCT_CHANCE + ( GIFT_DROP_PCT_CHANCE_INCREASE_PER_ROUND * self:GetRoundNumber() )
	end

	local fRandomRoll = RandomFloat( 0, 100 )
	local bSpawnGift = fRandomRoll > ( 100 - fGiftDropChance )

	--print( string.format( "fRandomRoll == %.2f, bSpawnGift == %s", fRandomRoll, tostring( bSpawnGift ) ) )

	if bSpawnGift then
		local nRandomIndex = RandomInt( 1, #self._gameMode._vGiftItemDropsList )
		local itemDropInfo = self._gameMode._vGiftItemDropsList[ nRandomIndex ]

		local newItem = CreateItem( itemDropInfo.szItemName, nil, nil )
		newItem:SetPurchaseTime( 0 )
		if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
			item:SetStacksWithOtherOwners( true )
		end

		local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
		drop.Holdout_IsLootDrop = true
		local dropTarget = killedUnit:GetAbsOrigin() + RandomVector( RandomFloat( 50, 350 ) )
		newItem:LaunchLoot( true, 300, 0.75, dropTarget )

		self._nGiftsDroppedThisRound = self._nGiftsDroppedThisRound + 1
	end
end

--------------------------------------------------------------------------------

function CHoldoutGameRound:StatusReport( )
	print( string.format( "Enemies remaining: %d", #self._vEnemiesRemaining ) )
	for _,e in pairs( self._vEnemiesRemaining ) do
		if e:IsNull() then
			print( string.format( "<Unit %s Deleted from C++>", e.unitName ) )
		else
			print( e:GetUnitName() )
		end
	end
	print( string.format( "Spawners: %d", #self._vSpawners ) )
	for _,s in pairs( self._vSpawners ) do
		s:StatusReport()
	end
end

function CHoldoutGameRound:GetTotalUnits()
	return self._nCoreUnitsTotal
end

function CHoldoutGameRound:GetRemainingUnits()
	return #self._vEnemiesRemaining
end

function CHoldoutGameRound:GetTotalUnitsKilled()
	return self._nCoreUnitsKilled
end

function CHoldoutGameRound:GetPlayerStats( nPlayerID )
	return self._vPlayerStats[ nPlayerID ]
end

function CHoldoutGameRound:GetRoundNumber()
	return self._nRoundNumber
end

function CHoldoutGameRound:GetRoundTitle()
	return self._szRoundQuestTitle 
end

function CHoldoutGameRound:GetRoundDescription()
	return self._szRoundDescription
end

function CHoldoutGameRound:OnGoldBagExpired()
	self._nGoldBagsExpired = self._nGoldBagsExpired + 1
end

function CHoldoutGameRound:ApplyVisionToRemainingEnemies()
	local enemies = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil and enemy:GetUnitName() ~= "npc_dota_hero_rubick" then
				enemy:AddNewModifier( enemy, nil, "modifier_razor_link_vision", { duration = -1 } )
			end
		end
	end
end

function CHoldoutGameRound:GetPointReward( nPlayerID )

	local szSteamID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )
	local bDailyBonusActive = self._gameMode._hEventGameDetails and self._gameMode._hEventGameDetails[szSteamID] ~= nil and self._gameMode._hEventGameDetails[szSteamID] < 1 

	if bDailyBonusActive then 
		if self:GetRoundNumber() < 5 then
			return self._nPointReward
		elseif self:GetRoundNumber() == 5 then
			return self._gameMode._periodic_points_bonus_normal_event_points
		else
			return self._nPointReward * self._gameMode._periodic_points_scale_normal_event_points
		end
	end

	return self._nPointReward
end

function CHoldoutGameRound:IsFinalRound()
	return self._bFinalRound
end

function CHoldoutGameRound:GetStarRanking()
	return self._nStarRanking
end

function CHoldoutGameRound:GetTotalDeaths()
	return self._nTotalDeaths 
end

function CHoldoutGameRound:CalculateStarRanking()
	local nStarFromBags = 0
	if self._nGoldBagsExpired <= 3 then
		nStarFromBags = 3
	end
	if self._nGoldBagsExpired > 3 then
		nStarFromBags = 2
	end
	if self._nGoldBagsExpired >= 8 then
		nStarFromBags = 1
	end

	local nStarFromDeaths = 0
	self._nTotalDeaths = 0
	for nPlayerID = 0, DOTA_DEFAULT_MAX_TEAM-1 do
		local playerStats = self._vPlayerStats[nPlayerID]
		if playerStats then
			self._nTotalDeaths = self._nTotalDeaths + playerStats.nDeathsThisRound
		end
	end

	print( "Total deaths " .. self._nTotalDeaths )

	if self._nTotalDeaths <= 1 then
		nStarFromDeaths = 3
	end
	if self._nTotalDeaths > 1 then
		nStarFromDeaths = 2
	end
	if self._nTotalDeaths > 3 then
		nStarFromDeaths = 1
	end

	self._nStarRanking = math.min( nStarFromDeaths, nStarFromBags )
end

--------------------------------------------------------------------------------
