if CWinter2022 == nil then
	CWinter2022 = class({})
	_G.CWinter2022 = CWinter2022
end

--------------------------------------------------------------------------------

require( "winter2022_utility_functions" )
require( "winter2022_constants" )
require( "winter2022_events" )
require( "winter2022_game_configuration" )
require( "winter2022_precache" )
require( "winter2022_think" )
require( "winter2022_wave_manager" )
require( "winter2022_mount_select" )

--------------------------------------------------------------------------------

function Precache( context )
	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end

	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameSync( Unit, context, -1 )
	end

	for _,tWaveData in pairs ( _G.WINTER2022_WAVES ) do
		for _,tCreepData in pairs( tWaveData.Units ) do
			PrecacheUnitByNameSync( tCreepData.name, context, -1 )
			if tCreepData.nameDire ~= nil then
				PrecacheUnitByNameSync( tCreepData.nameDire, context, -1 )
			end
		end
	end

	for _,Model in pairs( g_ModelPrecache ) do
		PrecacheResource( "model", Model, context )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context )
	end

	for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
		PrecacheResource( "particle_folder", Particle, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

--------------------------------------------------------------------------------

-- Create the game mode when we activate
function Activate()
	GameRules.Winter2022 = CWinter2022()
	GameRules.Winter2022:InitGameMode()
end

--------------------------------------------------------------------------------
function CWinter2022:InitGameMode()
	self._bDevMode = false
	self.bForceLosingCandy = {}
	self.bForceLosingCandy[DOTA_TEAM_GOODGUYS] = false
	self.bForceLosingCandy[DOTA_TEAM_BADGUYS] = false

	self.m_nRoundNumber = 0
	self.m_nLastRoundStartSound = 0
	self.m_nLastRoundStartShown = 0
	self.m_nTeamScore = {}
	self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] = 0
	self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] = 0
	self.m_nCandyOnGround = 0

	self.bAwardedFirstScarecrowStashKill = false
	self.bAwardedFirstCandyWellKill = false
	self.bAwardedFirstCandySteal = false

	GameRules:SetNextRuneSpawnTime( 999999999 )
	GameRules:SetNextBountyRuneSpawnTime( 999999999 )

	self.vNeutralBucketsToSpawn = {}
	self.bPlayAllRounds = false

	self.vecRoundTimerCues = {}
	self.vecRoundTimerCues[1] = true
	self.vecRoundTimerCues[2] = true
	self.vecRoundTimerCues[3] = true
	self.vecRoundTimerCues[4] = true
	self.vecRoundTimerCues[5] = true
	self.vecRoundTimerCues[10] = true

	self.bDayTime = false

	self:SetupGameConfiguration()
	self:RegisterGameEvents()
	self:RegisterConCommands()

	self:CacheBuildingLocs()
	self:CacheRoshan()
	self:CacheGolemSpawns()

	self.tRemainingCandyBuckets = {}
	self.tRemainingCandyBuckets[ DOTA_TEAM_GOODGUYS ] = WINTER2022_BUCKET_COUNT
	self.tRemainingCandyBuckets[ DOTA_TEAM_BADGUYS ] = WINTER2022_BUCKET_COUNT

	local winter2022Constants = {}
	for k,v in pairs( _G ) do
		if k:find( '^WINTER2022_' ) then
			winter2022Constants[k] = v
		end
	end
	CustomNetTables:SetTableValue( "globals", "constants", winter2022Constants )
	self:ResetCandy()

	self.m_GameState = WINTER2022_GAMESTATE_PREGAME
	self.m_flTimeRoundStarted = 0
	self.m_flTimeRoundEnds = 0

	-- Create announcer Units
	self.m_hRadiantAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = DOTA_TEAM_GOODGUYS }, Vector( 0, 0, 0 ) )
	self.m_hDireAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = DOTA_TEAM_BADGUYS }, Vector( 0, 0, 0 ) )
	self.m_hSpectatorAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = TEAM_SPECTATOR }, Vector( 0, 0, 0 ) )
	self.m_hGlobalAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = TEAM_SPECTATOR }, Vector( 0, 0, 0 ) )

	self.m_flNextSpawnTime = -1
	self.m_nWave = 0
	self.m_nRoundWave = 0
	self.m_nState = _G.WINTER2022_STATE_SLEEPING
	self.m_nStateRoundNumber = 0
	self.m_flTimeStateEnds = -1
	self.m_bGreevilsActive = false
	self.m_bSpawningInitialGreevilWave = true
	self.nGreevilFillingTypeOverride = _G.WINTER2022_GREEVIL_FILLING_TYPE_INVALID

	self.EventMetaData = {}
	self.EventMetaData[ "event_name" ]  = "winter2022"
	self.SignOutTable = {}
	self.SignOutTable["stats"] = {}

	-- Individual player stats
	self.SignOutTable["stats"]["player_stats"] = {}
	-- A list of roshan attacks and data surrounding it.
	self.SignOutTable["stats"]["roshan_attacks"] = {}

	-- Initialize player stats 
	printf( "Initializing player stats" )
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local PlayerStats = {}
		PlayerStats["player_id"] = nPlayerID
		PlayerStats["per_round_data"] = {}

		self.SignOutTable["stats"]["player_stats"][nPlayerID] = PlayerStats
	end

	self.nGreevilSpawnCount = WINTER2022_GREEVIL_SPAWN_COUNT_BASE

	self.tCandyBuckets = {}
	self.tCandyBuckets[ DOTA_TEAM_GOODGUYS ] = {}
	self.tCandyBuckets[ DOTA_TEAM_BADGUYS ] = {}
	self.tAllCandyBucketsData = {}
	self.tCandyLeaderBuilding = nil
	self.tCandyBuildingOtherTeam = nil
	self.tGreevilSpawnData = {}

--[[
	self.m_hEventGameDetails = GetLobbyEventGameDetails()
	printf( "[WINTER2022] EventGameDetails table:" )
	if self.m_hEventGameDetails then
	    DeepPrintTable(self.m_hEventGameDetails)
	else
		printf( "NOT FOUND!!" )
	end
--]]

	self.SignOutTable["stats"].StateDurations = {}
	self.SignOutTable["stats"].CandyCounts = {}
	self.SignOutTable["stats"]["CandyCounts"]["generated"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["generated_neutral"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["expired"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["candy_picked_up"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["candy_scored"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["candy_lost"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["fed"] = 0
	self.SignOutTable["stats"]["CandyCounts"]["candy_dropped"] = 0
	
	--[[GameRules:SetPostGameLayout( DOTA_POST_GAME_LAYOUT_SINGLE_COLUMN )
	GameRules:SetPostGameColumns( {
		DOTA_POST_GAME_COLUMN_LEVEL,
		DOTA_POST_GAME_COLUMN_ITEMS,
		DOTA_POST_GAME_COLUMN_KILLS,
		DOTA_POST_GAME_COLUMN_DEATHS,
		DOTA_POST_GAME_COLUMN_ASSISTS,
		DOTA_POST_GAME_COLUMN_NET_WORTH,
		DOTA_POST_GAME_COLUMN_DAMAGE,
		DOTA_POST_GAME_COLUMN_HEALING,
	} )--]]
	self:NewPerRoundData()
end

--------------------------------------------------------------------------------

function CWinter2022:GetRemainingCandyBuckets( nTeamNumber )
	return self.tRemainingCandyBuckets[ nTeamNumber ]
end

--------------------------------------------------------------------------------
function CWinter2022:GetTeamAnnouncer( nTeamNumber )
	if nTeamNumber == DOTA_TEAM_GOODGUYS then
		return self.m_hRadiantAnnouncer.AI
	elseif nTeamNumber == DOTA_TEAM_BADGUYS then
		return self.m_hDireAnnouncer.AI
	elseif nTeamNumber == TEAM_SPECTATOR then
		return self.m_hSpectatorAnnouncer.AI
	end
	return nil
end

--------------------------------------------------------------------------------
function CWinter2022:GetGlobalAnnouncer()
	return self.m_hGlobalAnnouncer.AI
end

--------------------------------------------------------------------------------
function CWinter2022:RestartGameCheatCommand()
	self.m_nRoundNumber = 0
	self.m_nTeamScore = {}
	self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] = 0
	self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] = 0
	self.m_bGreevilsActive = false;
	CustomNetTables:SetTableValue( "candy_collected", string.format("%d", DOTA_TEAM_GOODGUYS), { total_candy = 0 } )
	CustomNetTables:SetTableValue( "candy_collected", string.format("%d", DOTA_TEAM_BADGUYS), { total_candy = 0 } )

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )	
		if hPlayerHero ~= nil then
			local hNewHero = PlayerResource:ReplaceHeroWith( nPlayerID, hPlayerHero:GetUnitName(), 0, 0 )
			UTIL_Remove( hPlayerHero )
		end
	end
	self:RespawnAllPlayers()
	self.m_GameState = WINTER2022_GAMESTATE_PREGAME
end

--------------------------------------------------------------------------------
function CWinter2022:ThinkLootExpiry()
	local flCutoffTime = GameRules:GetDOTATime( false, true ) - _G.WINTER2022_ITEM_EXPIRE_TIME

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if containedItem ~= nil and containedItem:IsNull() == false and item.bIsLootDrop then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:ThinkCandyExpiry()
	self.m_nCandyOnGround = 0

	local flCutoffTime = GameRules:GetDOTATime( false, true ) - _G.WINTER2022_CANDY_EXPIRY_SECONDS
	local vRoshanPos = nil
	if self.hRoshan ~= nil and self.hRoshan:IsNull() == false then
		vRoshanPos = self.hRoshan:GetAbsOrigin()
	end
	for _,item in pairs( Entities:FindAllByClassname( "item_lua" )) do
		if item:GetAbilityName() == "item_candy" or item:GetAbilityName() == "item_candy_bag" then
			local container = item:GetContainer()
			if ( item.flSpawnTime >= 0 and  item.flSpawnTime <= flCutoffTime ) 
				or ( _G.WINTER2022_CANDY_EXPIRY_ROSHAN_RANGE >= 0 and vRoshanPos ~= nil and container ~= nil and container:IsNull() == false and (container:GetAbsOrigin() - vRoshanPos):Length2D() < _G.WINTER2022_CANDY_EXPIRY_ROSHAN_RANGE ) then
				if container then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
					ParticleManager:SetParticleControl( nFXIndex, 0, container:GetOrigin() )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					UTIL_RemoveImmediate( container )
				end
				UTIL_RemoveImmediate( item )
				self.SignOutTable["stats"].CandyCounts.expired = self.SignOutTable["stats"].CandyCounts.expired + 1
			else
				self.m_nCandyOnGround = self.m_nCandyOnGround + item:GetCurrentCharges()
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:_ProcessItemForLootExpiry( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	local inventoryItem = item:GetContainedItem()
	if inventoryItem == nil or inventoryItem:IsNull() then
		UTIL_RemoveImmediate( item )
		return false
	end

	if inventoryItem:GetPurchaseTime() >= flCutoffTime then
		return true
	end
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	UTIL_RemoveImmediate( inventoryItem )
	UTIL_RemoveImmediate( item )
	return false
end

--------------------------------------------------------------------------------

function CWinter2022:GetPlayedTime()
	if self.m_flTimeGameStarted ~= nil then
		return GameRules:GetDOTATime( false, true ) - self.m_flTimeGameStarted
	end

	return GameRules:GetDOTATime( false, true ) - self.m_flTimeRoundEnds
end

--------------------------------------------------------------------------------

function CWinter2022:IsGameInProgress()
	return self.m_GameState == _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS or self.m_GameState == _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS_BETWEEN_ROUNDS
end

--------------------------------------------------------------------------------
function CWinter2022:IsPrepOrInProgress()
	return self.m_GameState == _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS or self.m_GameState == _G.WINTER2022_GAMESTATE_PREP_TIME
end

--------------------------------------------------------------------------------
function CWinter2022:GrantGoldAndXP( hHero, nGoldToGrant, nXPToGrant, szReason )
	if hHero == nil or hHero:IsNull() == true then
		return
	end
	
	local hOwnedHero = PlayerResource:GetSelectedHeroEntity( hHero:GetPlayerOwnerID() )
	if hOwnedHero ~= nil and hOwnedHero:IsNull() == false and hOwnedHero ~= hHero then
		hHero = hOwnedHero
	end

	if nXPToGrant > 0 then
		self.bLetXPThrough = true
		if hHero:IsAlive() == false then
			nXPToGrant = math.ceil( nXPToGrant * _G.WINTER2022_REWARD_XP_MULT_DEAD )
		end

		local nXPReason = DOTA_ModifyXP_Outpost

		if szReason == "lasthit" then
			nXPReason = DOTA_ModifyXP_CreepKill
		elseif szReason == "candy" then
			nXPReason = DOTA_ModifyXP_Unspecified
		end

		hHero:AddExperience( nXPToGrant, nXPReason, false, true )	

		self.bLetXPThrough = nil
	end
	if nGoldToGrant > 0 then
		self.bLetGoldThrough = true
		--printf( " *** Grant %d gold to %s", nGoldToGrant, hHero:GetUnitName() )
		if hHero:IsAlive() == false then
			nGoldToGrant = math.ceil( nGoldToGrant * _G.WINTER2022_REWARD_GOLD_MULT_DEAD )
		end
		hHero:ModifyGold( nGoldToGrant, true, DOTA_ModifyGold_Unspecified )
		self.bLetGoldThrough = nil
		
		--self:UpdateResourceStats( "tGoldStats", hHero:GetPlayerOwnerID(), nGoldToGrant, szReason )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:GrantGoldAndXPToTeam( nTeamNumber, nGold, nXP )
	if nTeamNumber ~= DOTA_TEAM_GOODGUYS and nTeamNumber ~= DOTA_TEAM_BADGUYS then
		return
	end

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
			self:GrantGoldAndXP( PlayerResource:GetSelectedHeroEntity( nPlayerID ), nGold, nXP, szReason )
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:StartPrepTime()
	GameRules:SetGlyphCooldown( DOTA_TEAM_GOODGUYS, 99999 )
	GameRules:SetGlyphCooldown( DOTA_TEAM_BADGUYS, 99999 )
	local nHeroesDire = 0
	local nHeroesRadiant = 0
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			if Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				nHeroesRadiant = nHeroesRadiant + 1
			elseif Hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				nHeroesDire = nHeroesDire + 1
			end
		end
	end
	if nHeroesRadiant ~= nHeroesDire then
		printf("WARNING: mismatched number of heroes on teams, radiant = %d, dire = %d", nHeroesRadiant, nHeroesDire )
	end
	self.m_nNumHeroesPerTeam = min( 5, max( nHeroesRadiant, nHeroesDire ) )
	printf( " -- Heroes per team: %d", self.m_nNumHeroesPerTeam )

	self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
	self.m_flTimeRoundEnds = self.m_flTimeRoundStarted + ( ( self.m_bFastPlay and 5 ) or _G.WINTER2022_PREGAME_TIME )
	self.m_GameState = _G.WINTER2022_GAMESTATE_PREP_TIME

	self:SetMountChoices()

	local hAbility = self.hRoshan:FindAbilityByName( "roshan_go_to_sleep" )
	if hAbility ~= nil then
		print( 'PREP TIME PUTTING ROSH TO SLEEP!' )
		ExecuteOrderFromTable({
			UnitIndex = self.hRoshan:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
			Queue = false,
		})
	end

	print( "Advance to Prep Time!" )
end

--------------------------------------------------------------------------------

function CWinter2022:ToggleDayNight()
	self.bDayTime = not self.bDayTime
	self:SetTimeOfDay()
end

--------------------------------------------------------------------------------

function CWinter2022:SetTimeOfDay()
	if self.bDayTime then
		GameRules:SetTimeOfDay( _G.WINTER2022_TIME_OF_DAY_DAY )
	else
		GameRules:SetTimeOfDay( _G.WINTER2022_TIME_OF_DAY_NIGHT )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:KillBucketSoldiers()
	-- Now, technically the modifier's OnDestroy will also forcekill them all
	-- but we're doing this just to be sure, in case some get lost or order of operations busts things

	local hRadiantSoldiers = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, soldier in ipairs( hRadiantSoldiers ) do
		if soldier:GetUnitName() == "npc_dota_radiant_bucket_soldier" then
			soldier:AddEffects( EF_NODRAW )
			soldier:ForceKill( false )
		end
	end

	local hDireSoldiers = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, soldier in ipairs( hDireSoldiers ) do
		if soldier:GetUnitName() == "npc_dota_dire_bucket_soldier" then
			soldier:AddEffects( EF_NODRAW )
			soldier:ForceKill( false )
		end
	end

	local hNeutralSoldiers = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, soldier in ipairs( hNeutralSoldiers ) do
		if soldier:GetUnitName() == "npc_dota_neutral_bucket_soldier" then
			soldier:AddEffects( EF_NODRAW )
			soldier:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:AddCandyBucketModifiers( hBucket, nTier, bInvulnerable )
	-- Setup soldier buff
	local flBuffLevel = 0
	local flDmgBuffLevel = 0
	local nBase = nTier --self:GetRoundNumber() - 1
	flBuffLevel = math.max( 0, nBase + nBase * nBase * 0.1 )
	flDmgBuffLevel = flBuffLevel -- same, for now

	local kv = {}

	kv =
	{
		building_hp_buff_pct = math.floor( flBuffLevel * WINTER2022_OUTER_BUCKET_HEALTH_BUFF_MULTIPLIER ),
		soldier_count = WINTER2022_BUCKET_SOLDIERS_MAX,
		is_home = 0,
		tier = nTier,
	}

	if _G.WINTER2022_BUILDING_CANDY_GAIN_AMOUNT > 0 then
		hBucket:AddNewModifier( nil, nil, "modifier_bucket_gain_candy", kv )
	end

	hBucket:RemoveModifierByName( "modifier_invulnerable" )
	if bInvulnerable == true then
		hBucket:AddNewModifier( nil, nil, "modifier_candy_bucket_invulnerable", nil )
	end

	hBucket:AddNewModifier( nil, nil, "modifier_building_dispelssmoke", nil )

	hBucket:AddNewModifier( nil, nil, "modifier_candy_bucket_soldiers", kv )
end

--------------------------------------------------------------------------------
function CWinter2022:ShouldBuildingEmitCandy(hBuilding, nDamageDealt)
	return 0
end

--------------------------------------------------------------------------------

function CWinter2022:CacheBuildingLocs()
	self.m_BuildingDamage = {}
	self.m_BuildingCreepCounter = {}

	local hRadiantBuckets = Entities:FindAllByName( "radiant_candy_bucket" )
	self.vRadiantBucketLocs = {}
	for _, hRadiantBucket in pairs ( hRadiantBuckets ) do
		local vPos = hRadiantBucket:GetOrigin()
		table.insert( self.vRadiantBucketLocs, hRadiantBucket:GetOrigin() )
	end

	local hRadiantHomeBuckets = Entities:FindAllByName( "radiant_home_candy_bucket" )
	self.vRadiantHomeBucketLocs = {}
	for _, hRadiantBucket in pairs ( hRadiantHomeBuckets ) do
		local vPos = hRadiantBucket:GetOrigin()
		table.insert( self.vRadiantHomeBucketLocs, hRadiantBucket:GetOrigin() )
		self.m_BuildingDamage[hRadiantBucket] = 0
		self.m_BuildingCreepCounter[hRadiantBucket] = 0
	end

	--PrintTable( self.vRadiantBucketLocs, " -- " )

	local hDireBuckets = Entities:FindAllByName( "dire_candy_bucket" )
	self.vDireBucketLocs = {}
	for _, hDireBucket in pairs ( hDireBuckets ) do
		local vPos = hDireBucket:GetOrigin()
		table.insert( self.vDireBucketLocs, hDireBucket:GetOrigin() )
	end

	local hDireHomeBuckets = Entities:FindAllByName( "dire_home_candy_bucket" )
	self.vDireHomeBucketLocs = {}
	for _, hDireBucket in pairs ( hDireHomeBuckets ) do
		local vPos = hDireBucket:GetOrigin()
		table.insert( self.vDireHomeBucketLocs, hDireBucket:GetOrigin() )
		self.m_BuildingDamage[hDireBucket] = 0
		self.m_BuildingCreepCounter[hDireBucket] = 0
	end

	--PrintTable( self.vDireBucketLocs, " -- " )

	-- Neutral wells
	local hNeutralBuckets = Entities:FindAllByName( "neutral_candy_bucket" )
	local nIndex = 1
	self.vNeutralBucketLocs = {}
	for _, hNeutralBucket in pairs ( hNeutralBuckets ) do
		local vPos = hNeutralBucket:GetOrigin()
		self.vNeutralBucketLocs[ nIndex ] = hNeutralBucket:GetOrigin()
		hNeutralBucket.nNeutralBucketIndex = nIndex
		nIndex = nIndex + 1
	end

	local hGreevilSpawners = Entities:FindAllByName( "greevil_spawner" )
	self.vGreevilSpawnLocs = {}
	for _, hGreevilSpawner in pairs ( hGreevilSpawners ) do
		--print( 'FOUND GREEVIL SPAWNER!' )
		table.insert( self.vGreevilSpawnLocs, hGreevilSpawner:GetOrigin() )
	end

	local hGreevilCandyStealLocation = Entities:FindAllByName( "greevil_candy_steal_location" )
	self.vGreevilCandyStealLocation = nil
	if #hGreevilCandyStealLocation > 0 then
		--print( 'FOUND GREEVIL CANDY STEAL LOCATION!' )
		self.vGreevilCandyStealLocation = hGreevilCandyStealLocation[1]:GetOrigin()
	end

	local hGreevilFleeLocations = Entities:FindAllByName( "greevil_flee_location" )
	self.vGreevilFleeLocs = {}
	for _, hGreevilFleeLoc in pairs ( hGreevilSpawners ) do
		--print( 'FOUND GREEVIL FLEE LOCATION!' )
		table.insert( self.vGreevilFleeLocs, hGreevilFleeLoc:GetOrigin() )
	end

	-- gather special locations that are favored to either radiant or dire - kind of hacky but a rubber band to potentially help the losing team
	hGreevilFleeLocations = Entities:FindAllByName( "greevil_flee_location_radiant_favored" )
	self.vGreevilFleeLocsRadiantFavored = {}
	for _, hGreevilFleeLoc in pairs ( hGreevilSpawners ) do
		table.insert( self.vGreevilFleeLocsRadiantFavored, hGreevilFleeLoc:GetOrigin() )
	end

	hGreevilFleeLocations = Entities:FindAllByName( "greevil_flee_location_dire_favored" )
	self.vGreevilFleeLocsDireFavored = {}
	for _, hGreevilFleeLoc in pairs ( hGreevilSpawners ) do
		table.insert( self.vGreevilFleeLocsDireFavored, hGreevilFleeLoc:GetOrigin() )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:CacheRoshan()
	local hRoshanSpawner = Entities:FindAllByName( "roshan_spawner" )
	if #hRoshanSpawner == 0 then
		print( "failed to find roshan spawner" )
		return
	end
	self.hRoshanSpawner = hRoshanSpawner[1]
	self.hRoshan = CreateUnitByName( "npc_dota_roshan_diretide", self.hRoshanSpawner:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_CUSTOM_1 )
	self.hRoshan:SetAbsAngles( 0, 270, 0 )
	self.hRoshan.vecLastTargets = {}
	self.hRoshan.nTrickOrTreatTeam = 0
	
	self.hRoshan.nTrickOrTreatAskMax = 0
	self.hRoshan.nTrickOrTreatAskCurrent = 0

	local hRoshPitCenter = Entities:FindAllByName( "rosh_pit_center" )
	if #hRoshPitCenter == 0 then
		print( "failed to find roshan pit center" )
		return
	end
	self.hRoshanPitCenter = hRoshPitCenter[1]
end

--------------------------------------------------------------------------------
function CWinter2022:GetRoshanRequestCounter( nTeam )
	if self.hRoshan == nil or self.hRoshan.nTrickOrTreatAskMax == nil or ( nTeam ~= DOTA_TEAM_GOODGUYS and nTeam ~= DOTA_TEAM_BADGUYS ) then
		return 0
	end
	return self.hRoshan.nTrickOrTreatAskCurrent
end

--------------------------------------------------------------------------------
function CWinter2022:CacheGolemSpawns()
	--print("CWinter2022:CacheGolemSpawns()")

	local vecGolemSpawns = Entities:FindAllByName( "candy_drop_spawner" )
	if #vecGolemSpawns == 0 then
		print( "Failed to find any golem_spawner entities" )
	end
	self.m_vecGolemSpawns = {}
	local nIndex = 1
	for _,hGolemSpawner in pairs(vecGolemSpawns) do
		-- single-position version
		--print( "^^^FOUND A GOLEM POSITION!" )
		self.m_vecGolemSpawns[nIndex] = hGolemSpawner:GetAbsOrigin()
		nIndex = nIndex + 1
	end
end

--------------------------------------------------------------------------------

function CWinter2022:RegisterConCommands()
	local eCommandFlags = FCVAR_CHEAT
	
	Convars:RegisterCommand( "winter2022_respawn", function( commandName, nPlayerID )
		if nPlayerID == nil then
			nPlayerID = 0
		end
		return self:RespawnPlayerID( nPlayerID )
	end, "Respawn your hero/monster", eCommandFlags )

	Convars:RegisterCommand( "winter2022_respawnall", function( ...)
		return self:RespawnAllPlayers()
	end, "Respawn all hero/monsters", eCommandFlags )

	Convars:RegisterCommand( "winter2022_endround", function(...)
		-- if we trigger this command in the interstitial phase we need to start the next round before we end it
		if self.m_GameState == _G.WINTER2022_GAMESTATE_INTERSTITIAL_ROUND_PHASE or self.m_GameState == _G.WINTER2022_GAMESTATE_PREP_TIME then
			self:StartRound()
		end

		if self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] > self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] then
			return self:EndRound( DOTA_TEAM_BADGUYS )
		else
			return self:EndRound( DOTA_TEAM_GOODGUYS )
		end
	end, "End the round - awards the point to the losing team", eCommandFlags )

	Convars:RegisterCommand( "winter2022_releaseroshan", function(...)
		if self.bRoshanActive ~= true then
			self:RoshanRetarget()
		end
	end, "Release roshan", eCommandFlags )

	Convars:RegisterCommand( "winter2022_goto_round", function( commandName, szRoundNumber )
		local nRoundNumber = tonumber( szRoundNumber ) 
		print( "GOTO ROUND " .. nRoundNumber )
		if nRoundNumber <= self.m_nRoundNumber then
			print( "Requested round number is earlier in the sequence! We can't go back. :(" )
			return
		end
		while self.m_nRoundNumber < nRoundNumber do
			-- if we trigger this command in the interstitial phase we need to start the next round before we end it
			if self.m_GameState == _G.WINTER2022_GAMESTATE_INTERSTITIAL_ROUND_PHASE or self.m_GameState == _G.WINTER2022_GAMESTATE_PREP_TIME then
				self:StartRound()
			end

			self:EndRound()
		end
	end, "End the round - awards the point to the losing team", eCommandFlags )

	Convars:RegisterCommand( "winter2022_set_greevil_filling_override", function( commandName, szFillingType )
		local nFillingType = tonumber( szFillingType ) 
		print( "OVERRIDE GREEVIL FILLING TO " .. nFillingType )
		self.nGreevilFillingTypeOverride = nFillingType
	end, "Set the Greevil Filling Type Override to guarantee that every Greevil is full of the same thing. Valid fillings are 1-8", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_curse", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "team_cursed", {
			cursed_team = nTeamNumber,
		} )
	end, "Show curse message, argument = team number, 2 or 3 (negative means treat client as spectator)", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_roshan", function( commandName, szTeamNumber, szPlayer )
		local nTeamNumber = tonumber( szTeamNumber ) 
		local nPlayer = ( tonumber( szPlayer ) == 1 and 1 ) or 0
		FireGameEvent( "roshan_target_switch", {
			team = nTeamNumber,
			ent_index = 1090, -- whatever, something random
			force_you = nPlayer
		} )
	end, "Show roshan target message, arguments = team number, 2 or 3 (negative means treat client as spectator); and whether to say targeting you, 1 or 0", eCommandFlags )


	Convars:RegisterCommand( "winter2022_message_bucket", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "candy_bucket_attacked", {
			team = nTeamNumber,
		} )
	end, "Show bucket attacked message, argument = team number, 2 or 3", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_timeleft", function( commandName, szTime )
		local nTime = tonumber( szTime ) 
		print( 'TIME LEFT' .. nTime )
		FireGameEvent( "time_left", {
			time_left = nTime,
		} )
	end, "Show time left message, argument = time left (1/2/3/10/20)", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_stashrespawn", function( ... )
		FireGameEvent( "stash_respawn", {
		} )
	end, "Show stash respawn message", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_greevilspawn", function( ... )
		FireGameEvent( "greevil_spawn", {
		} )
	end, "Show greevil spawn message", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_roshanreleased", function( ... )
		FireGameEvent( "roshan_released", {
		} )
	end, "Show roshan released message", eCommandFlags )

	Convars:RegisterCommand( "winter2022_message_welltargeted", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "well_targeted", {
			team = nTeamNumber,
		} )
	end, "Show roshan released message", eCommandFlags )

	Convars:RegisterCommand( "winter2022_anim_lose_candy_toggle", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		self.bForceLosingCandy[nTeamNumber] = not self.bForceLosingCandy[nTeamNumber]
	end, "Toggles showing the lose candy anim on candy score, argument = team number, 2 or 3", eCommandFlags )

	Convars:RegisterCommand( "winter2022_test_disconnect", function( commandName, szPlayerID )
		local nPlayerID = tonumber( szPlayerID ) 
		self:OnPlayerDisconnect( { PlayerID = nPlayerID } )
	end, "Pretend a player disconnected", eCommandFlags )
	
	Convars:RegisterCommand( "winter2022_test_reconnect", function( commandName, szPlayerID )
		local nPlayerID = tonumber( szPlayerID ) 
		self:OnPlayerReconnected( { PlayerID = nPlayerID } )
	end, "Pretend a player reconnected", eCommandFlags )

	Convars:RegisterCommand( "winter2022_spawngreevils", function(...)
		self:SpawnGreevils()
	end, "Spawn Greevils", eCommandFlags )

	Convars:RegisterCommand( "winter2022_despawngreevils", function(...)
		self:DespawnGreevils()
	end, "Despawn Greevils", eCommandFlags )

	Convars:RegisterCommand( "winter2022_spawngreevilthieves", function(...)
		self:SpawnGreevilThieves()
	end, "Spawn Greevil Thieves from Candy Wells that have Candy - Dev Only function", eCommandFlags )

	Convars:RegisterCommand( "winter2022_win", function(...) self:DebugWin() end, "Force a win", eCommandFlags )
	Convars:RegisterCommand( "winter2022_statetransition", function(...) self:StateTransition() end, "Transition to the next state", eCommandFlags )

	Convars:RegisterCommand( "winter2022_createcandy", function(...) self:Dev_CreateCandyFromPlayer() end, "Make a piece of candy from the player", eCommandFlags )
	Convars:RegisterCommand( "winter2022_createcandysack", function(...) self:Dev_CreateCandySackFromPlayer() end, "Make a sack of candy from the player", eCommandFlags )
	Convars:RegisterCommand( "winter2022_killgreevils", function(...) self:Dev_KillGreevils() end, "Kill all greevils, except for the leader", eCommandFlags )
	Convars:RegisterCommand( "winter2022_generateroundcandyreport", function(...) self:Dev_GenerateRoundCandyReport() end, "Generate a report of how much candy is created by creeps each round", eCommandFlags )
	Convars:RegisterCommand( "winter2022_playendgamecinematic", function( commandName, szLosingTeam, szBucketNumber ) self:Dev_PlayEndGameCinematic( szLosingTeam, szBucketNumber ) end, "Play the endgame cinematic for one of the teams", eCommandFlags )
	Convars:RegisterCommand( "winter2022_play_roshan_anim", function( commandName, szActivity ) self:Dev_PlayRoshanAnim( szActivity ) end, "Play a specific animation on Roshan", eCommandFlags )
	Convars:RegisterCommand( "winter2022_fade_to_black", function( commandName, szFadeDown ) self:Dev_FadeToBlack( szFadeDown ) end, "Debug for the fade to black", eCommandFlags )
	Convars:RegisterConvar( "winter2022_candymult", "1", "Multiply candy drops by this", 0 )

	Convars:RegisterCommand( "winter2022_resetmounts", function() self:Dev_ResetMounts() end, "Remove and re-offer Mount choices", FCVAR_CHEAT )
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_PlayRoshanAnim( szActivity )
	self:ResetRoshan()

	local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
	if hBuff ~= nil then
		hBuff:ResetHero()
		hBuff:Reset()
		hBuff:StopThinking()
	end

	self.hRoshan:StartGesture( _G[ szActivity ] )
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_FadeToBlack( szFadeDown )
	local nFade = tonumber( szFadeDown )
	FireGameEvent( "fade_to_black", {
		fade_down = nFade,
		} )
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_CreateCandyFromPlayer()
	local hPlayer = Entities:GetLocalPlayerPawn()
	self:DropCandyAtPosition( hPlayer:GetAbsOrigin(), hPlayer, nil, false, 1.0 )
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_CreateCandySackFromPlayer()
	local hPlayer = Entities:GetLocalPlayerPawn()
	self:DropCandyAtPosition( hPlayer:GetAbsOrigin(), hPlayer, nil, true, 1.0 )
end


--------------------------------------------------------------------------------

function CWinter2022:Dev_KillGreevils()
	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )
	local bFoundGreevil = false

	for i=#hCreatures,1,-1 do
		if hCreatures[i] ~= nil and hCreatures[i]:IsNull() == false and hCreatures[i]:IsAlive() and IsGreevil( hCreatures[i], false ) then
			hCreatures[i]:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_GenerateRoundCandyReport()
	print( 'GENERATING CANDY REPORT' )
	print( '***********************' )
	for i, tWaveData in ipairs( _G.WINTER2022_WAVES ) do
		local nCandy = 0
		for _,v in pairs( tWaveData.Units ) do
			nCandy = nCandy + v.candyTotal
		end
		print( 'ROUND ' .. i .. ': CANDY PRODUCED = ' .. nCandy )
	end
	print( '***********************' )
end

--------------------------------------------------------------------------------
function CWinter2022:GetRoundNumber()
	return self.m_nRoundNumber -- 0 if pre-game or after game-over
end

--------------------------------------------------------------------------------
function CWinter2022:GetRadiantCandy()
	return self:GetTeamCandy( DOTA_TEAM_GOODGUYS )
end

--------------------------------------------------------------------------------
function CWinter2022:GetDireCandy()
	return self:GetTeamCandy( DOTA_TEAM_BADGUYS )
end

--------------------------------------------------------------------------------
function CWinter2022:GetTeamCandy( nTeamNumber )
	local key = string.format( "%d", nTeamNumber )
	local t = CustomNetTables:GetTableValue( "candy_collected", key )
	if t == nil or t['total_candy'] == nil then
		return 0
	else
		return t['total_candy']
	end
end

--------------------------------------------------------------------------------
function CWinter2022:SetTeamCandy( nTeamNumber, nCandyCount )
	local key = string.format("%d", nTeamNumber )
	local t = CustomNetTables:GetTableValue("candy_collected", key) 
	if t == nil then
		t = { total_candy =  nCandyCount }
	end
	t['total_candy'] = nCandyCount
	CustomNetTables:SetTableValue( "candy_collected", key, t  )
end

--------------------------------------------------------------------------------
function CWinter2022:GetCurrentCandyHeldByTeam( nTeamNumber )
	local nCandy = 0
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:HasSelectedHero( nPlayerID ) then
			local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hHero ~= nil then
				if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
					nCandy = nCandy + hHero:GetCandyCount()
				end
			end
		end
	end
	return nCandy
end

function CWinter2022:NewPerRoundData()
	printf( "NewPerRoundData being called")
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local tRoundData = {}

		tRoundData['candy_picked_up'] = 0
		tRoundData['candy_lost'] = 0
		tRoundData['candy_scored'] = 0
		tRoundData['candy_dropped'] = 0

		table.insert( self.SignOutTable["stats"]["player_stats"][nPlayerID]["per_round_data"], tRoundData )
	end
end

--------------------------------------------------------------------------------
function CWinter2022:StartRound()
	self.m_GameState = _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS

	self:NewPerRoundData()

	if self:GetRoundNumber() == 1 then
		self.bRoshanActive = false
		self.m_nPreviousLead = _G.DOTA_TEAM_NONE
		self.m_nRoshanOverrides = 0

		self.m_vecCandyScores = {}
		self.m_vecCandyScores[DOTA_TEAM_GOODGUYS] = 0
		self.m_vecCandyScores[DOTA_TEAM_BADGUYS] = 0

		GameRules:SetNextRuneSpawnTime( GameRules:GetDOTATime( false, true ) + _G.WINTER2022_RUNE_START_TIME )
		GameRules:GetGameModeEntity():SetPowerRuneSpawnInterval( _G.WINTER2022_RUNE_INTERVAL )
	end

	local flDuration = _G.WINTER2022_WAVES[ self:GetRoundNumber() ].duration - _G.WINTER2022_END_OF_ROUND_TIME_SLOP
	self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
	self.m_flNextSpawnTime = self.m_flTimeRoundStarted
	self.m_flTimeRoundEnds = self.m_flTimeRoundStarted + flDuration
	self.m_nRoundWave = 0
	printf( "Starting round %d at %f, ending at %f (duration %f)", self:GetRoundNumber(), self.m_flTimeRoundStarted, self.m_flTimeRoundEnds, flDuration )

	local hRadiantBuildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hRadiantBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" then
			local hBuff = building:FindModifierByName( "modifier_candy_bucket_soldiers" )
			if hBuff ~= nil then
				hBuff:UpdateSoldiers()
			end
		end
	end

	local hDireBuildings = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hDireBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" then
			local hBuff = building:FindModifierByName( "modifier_candy_bucket_soldiers" )
			if hBuff ~= nil then
				hBuff:UpdateSoldiers()
			end
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:EndPrepTime()
	self.m_nRoundNumber = 1
	self.m_flTimeGameStarted = GameRules:GetDOTATime( false, true )
	self.m_flGolemSpawnTime = _G.WINTER2022_GOLEM_INITIAL_SPAWN_TIME + GameRules:GetDOTATime( false, true )

	self.m_vecGolemRespawns = {}
	for k,v in pairs(self.m_vecGolemSpawns) do
		--print( "^^^Setting respawn timer for mapcandy position " .. k )
		self.m_vecGolemRespawns[k] = true
	end
	self.m_vecNeutralItemDrops = {}

	-- Release everyone from being locked in mount choice stun, just in case something went wrong
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero ~= nil then
			hHero:RemoveModifierByName( "modifier_hero_selecting_mount" )
		end
	end
	self:StartRound()

	print(" ********** END PREP TIME" )
	self:StateTransition()
end

--------------------------------------------------------------------------------
function CWinter2022:StateTransition()
	local nOldState = self.m_nState
	local nNewState = nOldState + 1
	-- TEMP: Skip the the sleeping phase
	if nNewState == _G.WINTER2022_STATE_SLEEPING then
		nNewState = nNewState + 1
	end
	if nNewState > _G.WINTER2022_STATE_MAX then
		nNewState = 1
	end

	self:DirectStateTransition( nNewState )
end

--------------------------------------------------------------------------------
function CWinter2022:DirectStateTransition( nNewState, bEndOld )
	if bEndOld ~= false then
		self:StateEnd( self.m_nState )
	end

	local nOldState = self.m_nState
	local flTime = GameRules:GetDOTATime( false, true )

	-- set up new state, times
	self.m_nState = nNewState
	if bEndOld ~= false then
		self.m_flTimeStateStarted = flTime
	end
	
	self.m_flTimeStateEnds = _G.WINTER2022_STATE_TIMES[ nNewState ]
	if self.m_flTimeStateEnds > 0 then
		self.m_flTimeStateEnds = flTime + self.m_flTimeStateEnds
	end
	
	printf( "STATE: Transitioned from %s to %s ending at %f", _G.WINTER2022_STATE_NAMES[ nOldState ], _G.WINTER2022_STATE_NAMES[ nNewState ], _G.WINTER2022_STATE_TIMES[ nNewState ] )
	self:StateStart( nNewState )
end


--------------------------------------------------------------------------------
function CWinter2022:StateEnd( nOldState )
	if nOldState == 0 then -- we were in prep time
		return
	end

	-- add duration stat
	if self.m_flTimeStateStarted ~= nil then
		local tDuration = {}
		tDuration.state = nOldState
		tDuration.name = _G.WINTER2022_STATE_NAMES[ nOldState ]
		tDuration.duration = GameRules:GetDOTATime( false, true ) - self.m_flTimeStateStarted
		table.insert( self.SignOutTable["stats"].StateDurations, tDuration )
	end

	if nOldState == _G.WINTER2022_STATE_GOHOME then
		self.hRoshan.nTrickOrTreatAskMax = 0
		self.hRoshan.nTrickOrTreatAskCurrent = 0
	elseif nOldState == _G.WINTER2022_STATE_GREEVILS then
		-- nothing
	elseif nOldState == _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS then
		self:DespawnGreevils()
		self.hRoshan.hGreevilLeader = nil
	elseif nOldState == _G.WINTER2022_STATE_ROSHAN then
		self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN
		-- JUST IN CASE let's kill the soundloop on all players.
		self:KillRoshanChaseSound()
		
		local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
		if hBuff ~= nil then
			hBuff:Reset()
		end
		self:ClosePitGates()

		self:SpawnGreevilThieves()
	end
end

--------------------------------------------------------------------------------
function CWinter2022:StateStart( nNewState )
	-- do regardless of state
	for k,v in pairs( self.vecRoundTimerCues ) do
		self.vecRoundTimerCues[k] = true
	end

	if nNewState == _G.WINTER2022_STATE_GOHOME then
		self:ToggleDayNight()

	elseif nNewState == _G.WINTER2022_STATE_GREEVILS then
		self.m_nStateRoundNumber = self.m_nStateRoundNumber + 1
	elseif nNewState == _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS then
		self:OpenPitGates()
		self.hRoshan.chaseStartTime = nil

		self:ToggleDayNight()

		--self:TransitionGreevilsToFleeRandomly()
		--self.hRoshan.hGreevilLeader = nil
		
		EmitGlobalSound( "RoshanDT.Scream" )
		FireGameEvent( "roshan_released", {
		} )		
		self.hRoshan.nTreatMode = _G.ROSHAN_TRICK_OR_TREAT_MODE_WAKE_UP
		self.hRoshan.nGreevilsEaten = 0
		self.hRoshan.nEatGreevilState = -1
		self:GetGlobalAnnouncer():OnRoshanAwakes()
	elseif nNewState == _G.WINTER2022_STATE_ROSHAN then
		print( "Retarget: ENTER STATE" )
		self:OpenPitGates()
		--EmitGlobalSound( "RoshanDT.Scream" )
		--FireGameEvent( "roshan_released", {
		--} )
		self.hRoshan.bCanAttackWell = true
		self.hRoshan.nNumAsks = 1
		self.hRoshan.hGreevilLeader = nil
		self.bFirstRoshanTarget = true
		self:RoshanRetarget()
	end
end

--------------------------------------------------------------------------------
function CWinter2022:StateThink()
	if self.m_nState == _G.WINTER2022_STATE_GREEVILS or self.m_nState == _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS then
		-- Do greevil spawning and despawning
		local fStateTime = GameRules:GetDOTATime( false, true ) - self.m_flTimeStateStarted
		local bInActiveInterval = false
		
		local fSpawn = 8 --spawnData.fTime
		local fDespawn = _G.WINTER2022_STATE_TIMES[ _G.WINTER2022_STATE_GREEVILS ] + _G.WINTER2022_STATE_TIMES[ _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS ] --spawnData.fTime + spawnData.fDuration
		if fStateTime > fSpawn and fStateTime < fDespawn then
			bInActiveInterval = true
		end

		--[[if self.m_bGreevilsActive and not bInActiveInterval then
			self:DespawnGreevils()
		else--]]
		if bInActiveInterval then
			if self.m_bGreevilsActive then
				-- the Rosh-hunting-greevils phase. Make sure we keep the number correct.
				if ( self.m_nState == _G.WINTER2022_STATE_ROSHAN_KILL_GREEVILS or self.m_nState == _G.WINTER2022_STATE_GREEVILS ) and self.m_bSpawningInitialGreevilWave == false then
					local nNumGreevils = self.nGreevilSpawnCount - self:CountGreevils( false )
					if nNumGreevils > 0 then
						printf( 'SPAWNING A NEW GREEVIL CURRENT NEEDED TO REPLACE = %d.', nNumGreevils )
						for i=1,nNumGreevils do
							local vPos = self.vGreevilSpawnLocs[ RandomInt( 1, #self.vGreevilSpawnLocs ) ]
							local hGreevil = self:SpawnSingleGreevil( vPos )
							if hGreevil ~= nil then
								hGreevil.AI:SetStateChaseLeader()
							end
						end
					end
				end
			else
				self:SpawnGreevils()
			end
		end
	elseif self.m_nState == _G.WINTER2022_STATE_ROSHAN then
		-- Round Timer Countdown VO
		local flTimeRemaining = self.m_flTimeStateEnds - GameRules:GetDOTATime( false, true )
		local nSecondsToSpeak = -1
		for k,v in pairs( self.vecRoundTimerCues ) do
			if v == true and k > nSecondsToSpeak and k >= flTimeRemaining - _G.WINTER2022_ANNOUNCER_TIMER_OFFSET then
				nSecondsToSpeak = k
			end
		end

		if nSecondsToSpeak >= 0 then
			self.vecRoundTimerCues[nSecondsToSpeak] = false
			--print( "*** Announcer: Seconds left: " .. nSecondsToSpeak )
			self:GetGlobalAnnouncer():OnCountdown( nSecondsToSpeak )
			FireGameEvent( "time_left", {
				time_left = nSecondsToSpeak,
			} )
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:StateRemainingTime()
	if self.m_flTimeStateEnds == nil or self.m_flTimeStateEnds < 0 then
		return -1
	end
	
	return self.m_flTimeStateEnds - GameRules:GetDOTATime( false, true )
end

--------------------------------------------------------------------------------
function CWinter2022:GoToState( nState )
	if self.m_nState == nState then
		return
	end
	for i=1,_G.WINTER2022_STATE_MAX,1 do
		self:StateTransition()
		if self.m_nState == nState then
			return
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:GoToStateDirect( nState )
	if self.m_nState == nState then
		return
	end
	self:DirectStateTransition( nState )
end

--------------------------------------------------------------------------------
--[[function CWinter2022:BucketFull()
	if self.m_nState ~= _G.WINTER2022_STATE_ROSHAN then
		self:GoToState( _G.WINTER2022_STATE_ROSHAN )
		return
	end

	local hTarget = self.hRoshan.hTrickOrTreatTarget
	if hTarget == nil or hTarget:IsNull() == true or hTarget:IsBuilding() == false then
		self:RoshanRetarget()
	end
end]]--

--------------------------------------------------------------------------------
function CWinter2022:RoundTimeExpired()
	self:EndRound()
end

--------------------------------------------------------------------------------
function CWinter2022:EndRound()
	print( 'Ending the round' )
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		if self._currentWaves ~= nil then
			self._currentWaves[nTeam]:End( true )
		end
	end
	self._currentWaves = nil

	self.vNeutralBucketsToSpawn = {}

	-- Advance to the next round...
	if self.m_nRoundNumber == nil or self.m_nRoundNumber == 0 then
		self.m_nRoundNumber = 1
	end
	if self.m_nRoundNumber + 1 <= #_G.WINTER2022_WAVES then
		self.m_nRoundNumber = self.m_nRoundNumber + 1
	end
	print( "Advancing to round number " .. self.m_nRoundNumber )
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		PlayerResource:SetCustomIntParam( nPlayerID, self.m_nRoundNumber )
	end
	
	-- Reset ward counts in shop
	for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		--GameRules:SetItemStockCount( 2, nTeamNumber, "item_ward_observer", -1 )
		GameRules:SetItemStockCount( 5, nTeamNumber, "item_ward_sentry", -1 )
	end

	-- reset round start, end times
	self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
	self.m_flTimeRoundEnds = self.m_flTimeRoundStarted + _G.WINTER2022_END_OF_ROUND_TIME_SLOP
	self.m_GameState = _G.WINTER2022_GAMESTATE_GAME_IN_PROGRESS_BETWEEN_ROUNDS

	self:StartRound()
end

--------------------------------------------------------------------------------

function CWinter2022:CleanupCandy()
	-- Seek and destroy all item_candies, literally anywhere.
	local vCandyItems = Entities:FindAllByClassname( "item_lua" )
	if vCandyItems ~= nil then
		for _, hCandy in ipairs( vCandyItems ) do
			if hCandy:GetAbilityName() == "item_candy" or hCandy:GetAbilityName() == "item_candy_bag" then
				local hContainer = hCandy:GetContainer()
				if hContainer ~= nil then
					UTIL_RemoveImmediate( hContainer )
				end
				if not hCandy:IsNull() then
					UTIL_RemoveImmediate( hCandy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:ResetHeroCandy()
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			local hBucketAbility = Hero:FindAbilityByName( "hero_candy_bucket" )
			if hBucketAbility then
				hBucketAbility:SetCandy( 0 )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:EndGame()
	--GameRules:SetPostGameTeamScores( { self:GetRadiantCandy(), self:GetDireCandy() } )
	GameRules:MakeTeamLose( FlipTeamNumber( self.nWinningTeam ) )
end

--------------------------------------------------------------------------------

function CWinter2022:RespawnAllPlayers()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if not PlayerResource:IsValidTeamPlayerID( nPlayerID ) then
			return
		end
	
		-- Is this the hero they'd selected? If not, swap them back!
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		hHero:RespawnHero( false, false )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:DropCandyAtPosition( vDropTarget, hVictim, hKiller, bIsBigBag, flRandomOffsetScale, vDropTargetOffset )
	if self:IsPrepOrInProgress() == false then
		return
	end
	local szItemName = ( bIsBigBag and "item_candy_bag" ) or "item_candy"
	local newItem = CreateItem( szItemName, nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( ( bIsBigBag and _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG ) or 1 )

	local flScale = flRandomOffsetScale
	if hVictim ~= nil then
		flScale = hVictim:GetModelScale()
	end

	local vOrigin = vDropTarget
	if _G.WINTER2022_CANDY_MAX_LAUNCH_DISTANCE > 0 and hKiller ~= nil and hKiller:IsNull() == false and hKiller:IsHero() then
		vDropTarget = hKiller:GetAbsOrigin() + RandomVector( RandomFloat( 20, 50 ) * flRandomOffsetScale )
		local vToDropTarget = vDropTarget - vOrigin
		local flLength = vToDropTarget:Length()
		if flLength > _G.WINTER2022_CANDY_MAX_LAUNCH_DISTANCE then
			vDropTarget = vOrigin + ( vToDropTarget:Normalized() * _G.WINTER2022_CANDY_MAX_LAUNCH_DISTANCE )
		end
	else
		if flRandomOffsetScale > 0 then
			vDropTarget = vDropTarget + RandomVector( RandomFloat( 100, 275 ) * flScale )
			if vDropTargetOffset ~= nil then
				vDropTarget = vDropTarget + vDropTargetOffset
			end
		end
	end

	local drop = CreateItemOnPositionForLaunch( vOrigin, newItem )
	if bIsBigBag == true then
		drop:SetModelScale( 2 )
	end

	if hVictim ~= nil and hVictim:IsNull() == false and hVictim.IsRealHero ~= nil and hVictim:IsRealHero() then
		drop:GetContainedItem().nDroppedByTeam = hVictim:GetTeamNumber()
	end
	
	-- make sure target is pathable
	local vOldOrigin = drop:GetAbsOrigin()
	FindClearSpaceForUnit( drop, vDropTarget, true )
	vDropTarget = drop:GetAbsOrigin()
	drop:SetAbsOrigin( vOldOrigin )

	newItem:LaunchLoot( true, math.max( 15, math.min( flRandomOffsetScale, 1.0 ) * RandomFloat( 75, 225 ) ), math.max( 0.1, math.sqrt( math.max( 0.3, math.min( flRandomOffsetScale, 1.0 ) ) ) * RandomFloat( 0.5, 1.25 ) ), vDropTarget )

	local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/hw_candy_drop.vpcf", PATTACH_ABSORIGIN_FOLLOW, ( hVictim ~= nil and hVictim ) or drop )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, drop, PATTACH_ABSORIGIN_FOLLOW, nil, drop:GetAbsOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return newItem
end

function CWinter2022:ModifyCandyStat(stat, nPlayerID, nNumToAdd)
	--print("ModifyCandyStat: " .. stat .. " " .. nPlayerID .. " " .. nNumToAdd)
	self.EventMetaData[ nPlayerID ][stat] = self.EventMetaData[ nPlayerID ][stat] + nNumToAdd
	self.SignOutTable["stats"]["CandyCounts"][stat] = self.SignOutTable["stats"]["CandyCounts"][stat] + nNumToAdd
	self.SignOutTable["stats"]["player_stats"][nPlayerID]["per_round_data"][self:GetRoundNumber()][stat] = self.SignOutTable["stats"]["player_stats"][nPlayerID]["per_round_data"][self:GetRoundNumber()][stat] + nNumToAdd
end

--------------------------------------------------------------------------------

function CWinter2022:ScoreCandy( nTeamNumber, hScorer, nNumCandy )
	local nTotalCandy = self:GetTeamCandy( nTeamNumber ) + nNumCandy
	self:SetTeamCandy( nTeamNumber, nTotalCandy )

	if hScorer == nil or hScorer:IsNull() then
		return
	end

	local hPlayerOwner = hScorer:GetPlayerOwner()
	if hPlayerOwner == nil then
		return
	end

	EmitSoundOnClient( "Candy.Score", hPlayerOwner )

	local nPlayerID = hScorer:GetPlayerOwnerID()
	--print( '{STATS} candy_scored - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
	self:ModifyCandyStat("candy_scored", nPlayerID, nNumCandy)

	--[[self.m_vecCandyScores[nTeamNumber] = self.m_vecCandyScores[nTeamNumber] + nNumCandy
	if self.m_vecCandyScores[nTeamNumber] >= _G.WINTER2022_NUM_CANDY_SCORED_TO_TRIGGER_ANNOUNCER then
		self.m_vecCandyScores[nTeamNumber] = 0
	end--]]

	self:GrantGoldAndXP( hScorer, CANDY_SCORE_GOLD_PER_CANDY * nNumCandy, CANDY_SCORE_XP_PER_CANDY * nNumCandy, "candy" )
	if CANDY_SCORE_XP_PER_CANDY > 0 then
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/candy/candy_xp_gain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hScorer ) )
	end

	self:UpdateLead()
end

--------------------------------------------------------------------------------

function CWinter2022:UpdateLead()
	local nRadiantCandy = self:GetRadiantCandy()
	local nDireCandy = self:GetDireCandy()
	local bLeadChange = false
	if ( nRadiantCandy > nDireCandy and self.m_nPreviousLead ~= _G.DOTA_TEAM_GOODGUYS ) then
		self.m_nPreviousLead = _G.DOTA_TEAM_GOODGUYS
		bLeadChange = true
	elseif ( nDireCandy > nRadiantCandy and self.m_nPreviousLead ~= _G.DOTA_TEAM_BADGUYS ) then
		self.m_nPreviousLead = _G.DOTA_TEAM_BADGUYS
		bLeadChange = true
	end
	--[[if bLeadChange == true then
		self:PlayTeamSound( "CandyCount.Winning.Stinger", "CandyCount.Losing.Stinger", self.m_nPreviousLead )
		self:GetTeamAnnouncer( self.m_nPreviousLead ):OnCandyScoreAlly()
		self:GetTeamAnnouncer( FlipTeamNumber( self.m_nPreviousLead ) ):OnCandyScoreEnemy()
	end--]]
end

--------------------------------------------------------------------------------

function CWinter2022:GetCandyBuckets( nTeamNumber )
	if nTeamNumber == DOTA_TEAM_GOODGUYS then
		return Entities:FindAllByName( "radiant_candy_bucket" )
	end

	return Entities:FindAllByName( "dire_candy_bucket" )
end

--------------------------------------------------------------------------------

function CWinter2022:GetRoshanDamageAmount()
	local fGameTime = GameRules:GetGameTime()
	local fDamage = WINTER2022_ROSHAN_DAMAGE_BASE + ( ( fGameTime / 60 ) * WINTER2022_ROSHAN_DAMAGE_PER_MIN )
	--print( 'ROSHAN DAMAGE = ' .. fDamage )

	return fDamage
end

--------------------------------------------------------------------------------

function CWinter2022:CleanupUnits()
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, unit in pairs( units ) do
		if unit ~= nil and unit:IsNull() == false then
			local bDestroy = false
			if unit:IsOwnedByAnyPlayer() and unit:IsRealHero() == false then
				bDestroy = true
			elseif unit:GetUnitName() == "npc_dota_weaver_swarm" then
				bDestroy = true
			elseif unit:IsOther() then -- Wards, but also catches other stuff
				bDestroy = true
			end
			if bDestroy and unit:GetUnitName() ~= "npc_dota_wisp_spirit" and unit:GetUnitName() ~= "dota_death_prophet_exorcism_spirit" and unit:GetUnitName() ~= "npc_dota_beastmaster_axe" then
				unit:ForceKill( false )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:CleanupDroppedItems()
	for _, hItem in pairs( Entities:FindAllByClassname( "dota_item_drop" ) ) do
		local szItemName = hItem:GetContainedItem():GetAbilityName()
		if szItemName == "item_candy" or szItemName == "item_candy_bag" or szItemName == "item_mango" or szItemName == "item_enchanted_mango" then
			UTIL_Remove( hItem )
		end
	end
	for _, hItem in pairs( Entities:FindAllByClassname( "dota_item_rune" ) ) do
		UTIL_Remove( hItem )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:ResetCandy()
	for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local key = string.format("%d", nTeamNumber )
		local t = CustomNetTables:GetTableValue("candy_collected", key) 
		if t == nil then
			t = { total_candy =  0 }
		end
		t['total_candy'] = 0
		CustomNetTables:SetTableValue( "candy_collected", key, t  )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:ResetRoshan()
	if self.hRoshan == nil then
		self.hRoshan = CreateUnitByName( "npc_dota_roshan_diretide", hRoshanSpawner:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_CUSTOM1 )
	else
		self.hRoshan:Interrupt()
	end

	self.nQueueRoshanForTeam = nil

	-- JUST IN CASE let's kill the soundloop on all players.
	self:KillRoshanChaseSound()

	self.hRoshan:SetAbsAngles( 0, 270, 0 )
	self.hRoshan.nCandyAttackTeam = nil
	self.hRoshan.nTrickOrTreatTeam = 0
	self.hRoshan.nTrickOrTreatAskMax = 0
	self.hRoshan.nTrickOrTreatAskCurrent = 0
	self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	self.hRoshan.vecCurseTimes = {}
	FindClearSpaceForUnit( self.hRoshan, self.hRoshanSpawner:GetAbsOrigin(), true )

	local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
	if hBuff ~= nil then
		hBuff:ResetHero()
		hBuff:Reset()
	end

	self.hRoshan.vecLastTargets = {}

	self:ClosePitGates()
end

--------------------------------------------------------------------------------

function CWinter2022:ClosePitGates()
	-- Reset the Roshan Gates
	--print("Reseting Roshan Gates")
	local radiantRelay = Entities:FindAllByName( "roshan_gate_reset_radiant" )
	if radiantRelay ~= nil then
		for _, rRelay in pairs( radiantRelay ) do
			rRelay:Trigger( nil, nil )
		end
	end
	local direRelay = Entities:FindAllByName( "roshan_gate_reset_dire" )
	if direRelay ~= nil then
		for _, dRelay in pairs( direRelay ) do
			dRelay:Trigger( nil, nil )
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:OpenPitGates()
	-- Open the Roshan Gates
	--print("Opening Roshan Gates")
	local radiantRelay = Entities:FindAllByName( "roshan_gate_open_radiant" )
	if radiantRelay ~= nil then
		for _, rRelay in pairs( radiantRelay ) do
			rRelay:Trigger( nil, nil )
		end
	end
	local direRelay = Entities:FindAllByName( "roshan_gate_open_dire" )
	if direRelay ~= nil then
		for _, dRelay in pairs( direRelay ) do
			dRelay:Trigger( nil, nil )
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:ReleaseRoshanForTeam( nWinningTeam )
	print( "Attempting to unleash roshan for team: " .. nWinningTeam )
	if self.hRoshan and self.hRoshan.nCandyAttackTeam == nil then
		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		if nWinningTeam == DOTA_TEAM_GOODGUYS then
			self.hRoshan.nCandyAttackTeam = DOTA_TEAM_BADGUYS
			gameEvent["message"] = "#DOTA_HUD_RoshanAttackDire_Toast"
		else
			self.hRoshan.nCandyAttackTeam = DOTA_TEAM_GOODGUYS
			gameEvent["message"] = "#DOTA_HUD_RoshanAttackRadiant_Toast"
		end

	
		FireGameEvent( "dota_combat_event_message", gameEvent )
		--EmitGlobalSound( "RoshanDT.Scream" )
	end
end

--------------------------------------------------------------------------------

function CWinter2022:CandyWellAttackedByRoshan( hCandyWell )
	hCandyWell.fLastRoshAttackTime = fCurrentTime

	-- play sound
	EmitSoundOn( "RoshanDT.Attacked.CandyWell", self.hRoshan )

	-- ping map
	GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, hCandyWell:GetOrigin().x, hCandyWell:GetOrigin().y, hCandyWell, 31 )
	GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, hCandyWell:GetOrigin().x, hCandyWell:GetOrigin().y, hCandyWell, 31 )

	FireGameEvent( "well_targeted", {
		team = hCandyWell:GetTeamNumber(),
	} )
end

--------------------------------------------------------------------------------

function CWinter2022:KillRoshanChaseSound()
	-- JUST IN CASE let's kill the soundloop on all players.
	StopGlobalSound( "RoshanTarget.Loop.Ally" )
	StopGlobalSound( "RoshanTarget.Loop.Enemy" )
end

--------------------------------------------------------------------------------

function CWinter2022:RecordCandyScored( hCandyWell, nCandy )
	printf( "Recording candy scored into %s", hCandyWell:GetName() )
	for _,tBucketData in pairs( self.tAllCandyBucketsData ) do
		if tBucketData.hEntity == hCandyWell then
			tBucketData.fLastScoreTime = GameRules:GetDOTATime( false, true )
			tBucketData.nCandy = nCandy
			return
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:GetBestCandyBuilding( nTeamNumber )
	local tBestBucket = nil

	for _,tBucketData in pairs( self.tAllCandyBucketsData ) do
		hUnit = tBucketData.hEntity
		if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and hUnit:GetTeamNumber() == nTeamNumber then
			if tBucketData.nCandy > 0 and ( tBestBucket == nil or tBucketData.nCandy > tBestBucket.nCandy or ( tBucketData.nCandy == tBestBucket.nCandy and tBucketData.fLastScoreTime < tBestBucket.fLastScoreTime ) ) then
				tBestBucket = tBucketData
			end
		end
	end
	return tBestBucket
end
--------------------------------------------------------------------------------

function CWinter2022:UpdateCandyLeaderBuilding( bAllowEarlyOut )
	if bAllowEarlyOut == true and _G.WINTER2022_ROSHAN_ALLOW_RETARGET ~= true and self.m_nState == _G.WINTER2022_STATE_ROSHAN then
		return
	end

	self.tCandyLeaderBuilding = nil
	self.tCandyBuildingOtherTeam = nil

	local tRadiant = self:GetBestCandyBuilding( DOTA_TEAM_GOODGUYS )
	local tDire = self:GetBestCandyBuilding( DOTA_TEAM_BADGUYS )

	if tRadiant ~= nil or tDire ~= nil then
		if tRadiant ~= nil and tDire ~= nil then
			if tRadiant.nCandy > tDire.nCandy or ( tRadiant.nCandy == tDire.nCandy and tRadiant.fLastScoreTime < tDire.fLastScoreTime ) then
				self.tCandyLeaderBuilding = tRadiant
				self.tCandyBuildingOtherTeam = tDire
			else
				self.tCandyLeaderBuilding = tDire
				self.tCandyBuildingOtherTeam = tRadiant
			end
		elseif tRadiant ~= nil then
			self.tCandyLeaderBuilding = tRadiant
		else
			self.tCandyLeaderBuilding = tDire
		end
	end

	local sCandyLeaderBuilding = ""
	if self.tCandyLeaderBuilding ~= nil then
		sCandyLeaderBuilding = self.tCandyLeaderBuilding.hEntity:GetName()
	end
	UpdateNetTableValueProperty( "globals", "values", "CandyLeaderBuilding", sCandyLeaderBuilding )
end

--------------------------------------------------------------------------------

function CWinter2022:UpdateCurrentRoshanTrickOrTreatAsk( hHero )
	if hHero == nil or hHero:IsNull() == true then
		return
	end

	print( '^^^CWinter2022:UpdateCurrentRoshanTrickOrTreatAsk - updating for hero = ' .. hHero:GetUnitName() )

	if self.hRoshan.hTrickOrTreatTarget == hHero then
		print( '^^^CWinter2022:UpdateCurrentRoshanTrickOrTreatAsk - THIS IS OUR TARGET' )
		local nCandy = GetCandyCount( hHero )	

		-- Rosh ask counter should NEVER go up
		if nCandy < self.hRoshan.nTrickOrTreatAskCurrent then
			printf( '^^^CWinter2022:UpdateCurrentRoshanTrickOrTreatAsk - Current ask = %d, Updating to new minimum = %d', self.hRoshan.nTrickOrTreatAskCurrent, nCandy )
			self.hRoshan.nTrickOrTreatAskCurrent = nCandy

			local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
			if hBuff ~= nil then
				hBuff:UpdateCandyAskCounter()
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:FindRoshanTarget()
	if self.hRoshan.bCanAttackWell == true then
		--print( 'NO UNITS WITH CANDY! Time to smash the Candy Leader Building!' )
		return ( self.tCandyLeaderBuilding and self.tCandyLeaderBuilding.hEntity ) or nil
	end
	
	return nil
end

--------------------------------------------------------------------------------

function CWinter2022:RoshanRetarget()
	--DONT CLEAR THIS YET! self.hRoshan.nTrickOrTreatTeam = 0 -- we'll set this later, if we succeed

	-- JUST IN CASE let's kill the soundloop on all players.
	self:KillRoshanChaseSound()

	-- catch running this during round ending
	if self:IsGameInProgress() == false then
		print("Roshan trick or treating aborted, round not in progress")
		return
	end

	self.hRoshan.bNeedsReset = true

	local hBestTarget = self:FindRoshanTarget()
	if hBestTarget == nil then
		print( '^^^CANNOT FIND A ROSHAN TARGET' )
		self:StateTransition()
		return
	end

	if _G.WINTER2022_ROSHAN_ALLOW_RETARGET ~= true then
		if self:OnLastWellMaybeDestroyed( hBestTarget ) then
			return
		end
	end

	if self.bFirstRoshanTarget == true then
		self:GetGlobalAnnouncer():OnRoshanTargetsWell()
		self.bFirstRoshanTarget = false
	else
		self:GetGlobalAnnouncer():OnRoshanRetargets()
	end

	self:SetTrickOrTreatTarget( hBestTarget )
	hBestTarget.nCandyOnAcquire = CandyCount( hBestTarget )
	hBestTarget.nRoshanHits = 0
	hBestTarget.nCandyToRemove = 1

	self.hRoshan.bMustAttackTarget = nil
	self.hRoshan.flTargetSwitchPauseTimer = nil
	if hBestTarget:IsHero() then
		self.hRoshan:Stop()
		self.hRoshan:StartGesture( ACT_DOTA_CAST_ABILITY_3 )
		self.hRoshan.bMustAttackTarget = true
		self.hRoshan.flTargetSwitchPauseTimer = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ROSHAN_TARGET_SWITCH_PAUSE_TIME
	else
		self:CandyWellAttackedByRoshan( hBestTarget )
	end
	
	print( "Roshan is trick or treating to " .. self.hRoshan.hTrickOrTreatTarget:GetUnitName() )

	self.hRoshan.hTrickOrTreatTarget:AddNewModifier( nil, nil, "modifier_provide_roshan_vision", {} )
	self.hRoshan.hTrickOrTreatTarget:AddNewModifier( self.hRoshan, nil, "modifier_truesight", {} )

	self:PlayTeamSound( "RoshanTarget.Loop.Ally", "RoshanTarget.Loop.Enemy", hBestTarget:GetTeamNumber() )

	if self.bRoshanActive ~= true then
		self.bRoshanActive = true
	end

	if self.hRoshan.hTrickOrTreatTarget:IsBuilding() == false then
		local gameEvent = {}
		gameEvent["player_id"] = self.hRoshan.hTrickOrTreatTarget:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_RoshanTrickOrTreat_Target_Toast"
		FireGameEvent( "dota_combat_event_message", gameEvent )
		self:GetTeamAnnouncer( self.hRoshan.hTrickOrTreatTarget:GetTeamNumber() ):OnRoshanTarget( self.hRoshan.hTrickOrTreatTarget )
	else
		local gameEvent = {}
		gameEvent["teamnumber"] = -self.hRoshan.hTrickOrTreatTarget:GetTeamNumber()
		gameEvent["locstring_value"] = self.hRoshan.hTrickOrTreatTarget:GetUnitName()
		gameEvent["message"] = "#DOTA_HUD_RoshanTrickOrTreat_TargetBuilding_Toast"
		FireGameEvent( "dota_combat_event_message", gameEvent )
		self:GetTeamAnnouncer( self.hRoshan.hTrickOrTreatTarget:GetTeamNumber() ):OnRoshanTarget( self.hRoshan.hTrickOrTreatTarget )
	end

	FireGameEvent( "roshan_target_switch", {
		team = self.hRoshan.hTrickOrTreatTarget:GetTeamNumber(),
		ent_index = self.hRoshan.hTrickOrTreatTarget:entindex(),
		force_you = 0,
	} )
end

----------------------------------------------------------------------------------------

function CWinter2022:SetTrickOrTreatTarget( hTarget )
	local hOldTarget = self.hRoshan.hTrickOrTreatTarget
	if self.hRoshan.hTrickOrTreatTarget ~= nil then
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil and hHero:GetTeamNumber() == self.hRoshan.hTrickOrTreatTarget:GetTeamNumber() then
					print( '^^^REMOVING ROSHAN INTERACT BUFF FROM ' .. hHero:GetUnitName() )
					hHero:RemoveModifierByName( "modifier_enable_feedable_roshan_interact" )
				end
			end
		end
	end

	-- Store a roshan attack record in the stats
	local roshan_attack = {}
	roshan_attack["game_time"] = GameRules:GetDOTATime( false, true )
	for _,tBucketData in pairs( self.tAllCandyBucketsData ) do
		hUnit = tBucketData.hEntity
		if hUnit ~= nil and hUnit:IsNull() == false then
			local key_value_key = _G.WINTER2022_TOWER_NAME_TO_KV_KEY[ tBucketData.hEntity:GetName() ]
			roshan_attack[key_value_key] = tBucketData.nCandy
		end
	end

	table.insert( self.SignOutTable["stats"]["roshan_attacks"], roshan_attack)

	self.hRoshan.hTrickOrTreatTarget = hTarget
	if self.hRoshan.hTrickOrTreatTarget ~= nil then
		self.hRoshan.nTrickOrTreatTeam = hTarget:GetTeamNumber()
		if self.hRoshan.hTrickOrTreatTarget:IsBuilding() then
			self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_ATTACK

			-- Grant redirect_roshan quest
			if hOldTarget ~= nil and hOldTarget:IsNull() == false and hOldTarget:IsBuilding() then
				local nOldTeam = hOldTarget:GetTeamNumber()
				if nOldTeam ~= self.hRoshan.nTrickOrTreatTeam and ( self.hRoshan.nTrickOrTreatTeam  == DOTA_TEAM_GOODGUYS or self.hRoshan.nTrickOrTreatTeam == DOTA_TEAM_BADGUYS ) then
					-- ensure this is only granted once per game per team
					local bShouldGrant = false
					if nOldTeam == DOTA_TEAM_GOODGUYS and self.bRadiantHasRedirectedRoshan == nil then
						self.bRadiantHasRedirectedRoshan = true
						bShouldGrant = true
					elseif nOldTeam == DOTA_TEAM_BADGUYS and self.bDireHasRedirectedRoshan == nil then
						self.bDireHasRedirectedRoshan = true
						bShouldGrant = true
					end

					if bShouldGrant then
						for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
							if PlayerResource:HasSelectedHero( nPlayerID ) and PlayerResource:GetTeam( nPlayerID ) == nOldTeam then
								GameRules.Winter2022:GrantEventAction( nPlayerID, "winter2022_redirect_roshan", 1 )
							end
						end
					end
				end
			end
		else
			self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_REQUEST
		end
	end

	local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
	if hBuff ~= nil then
		hBuff:ResetChaseTimer()
	end

	if self.hRoshan.hTrickOrTreatTarget ~= nil then

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil and hHero:GetTeamNumber() == self.hRoshan.hTrickOrTreatTarget:GetTeamNumber() then
					print( '^^^ADDING ROSHAN INTERACT BUFF TO ' .. hHero:GetUnitName() )
					hHero:AddNewModifier( self.hRoshan, nil, "modifier_enable_feedable_roshan_interact", {} )
				end
			end
		end

		if self.hRoshan.nTargetFx == nil then
			local nKnockbackRadius = 250
			local hRoshanPassive = self.hRoshan:FindAbilityByName( "diretide_roshan_passive" )
			if hRoshanPassive ~= nil then
				nKnockbackRadius = hRoshanPassive:GetLevelSpecialValueFor( "KnockbackHitRadius", nKnockbackRadius )
			end

			self.hRoshan.nTargetFx = ParticleManager:CreateParticle( "particles/ui_mouseactions/range_finder_tower_aoe.vpcf", PATTACH_CUSTOMORIGIN, self.hRoshan )
			ParticleManager:SetParticleControlEnt( self.hRoshan.nTargetFx, 0, self.hRoshan, PATTACH_ABSORIGIN_FOLLOW, nil, self.hRoshan:GetAbsOrigin(), false ) -- center of range ring
			ParticleManager:SetParticleControlEnt( self.hRoshan.nTargetFx, 2, self.hRoshan, PATTACH_ABSORIGIN_FOLLOW, nil, self.hRoshan:GetAbsOrigin(), false ) -- start of line
			ParticleManager:SetParticleControl( self.hRoshan.nTargetFx, 3, Vector( nKnockbackRadius, 0, 0 ) ) -- range ring radius
			ParticleManager:SetParticleControl( self.hRoshan.nTargetFx, 4, Vector( 220, 50, 50 ) ) -- range ring color
			ParticleManager:SetParticleControl( self.hRoshan.nTargetFx, 6, Vector( 1, 0, 0 ) ) -- alpha of line
		end
		ParticleManager:SetParticleControlEnt( self.hRoshan.nTargetFx, 7, self.hRoshan.hTrickOrTreatTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hRoshan.hTrickOrTreatTarget:GetAbsOrigin(), false ) -- end of line
	else
		if self.hRoshan.nTargetFx ~= nil then
			ParticleManager:DestroyParticle( self.hRoshan.nTargetFx, false )
			self.hRoshan.nTargetFx = nil
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnSingleGreevil( vPos )
	local hGreevil = CreateUnitByName( "npc_dota_greevil", vPos, true, nil, nil, DOTA_TEAM_NEUTRALS )
	if hGreevil ~= nil then
		hGreevil:SetBodygroupByName( "default", RandomInt( 1, WINTER2022_GREEVIL_MAX_BODY_GROUPS ) )

		local nSkinType = RandomInt( 1, WINTER2022_GREEVIL_MAX_SKINS )
		if self.nGreevilFillingTypeOverride ~= WINTER2022_GREEVIL_FILLING_TYPE_INVALID then
			print( 'OVERRIDING GREEVIL FILLING TYPE TO ' .. self.nGreevilFillingTypeOverride )
			nSkinType = self.nGreevilFillingTypeOverride
		end
		hGreevil:SetSkin( nSkinType )
		
		local hFillingBuff = hGreevil:FindModifierByName( "modifier_greevil_filling" )
		if hFillingBuff then
			--print( 'FOUND GREEVIL FILLING!' )
			hFillingBuff:SetFillingType( nSkinType )
		end
	end

	return hGreevil
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnGreevils()
	local vLeaderPos = self.vGreevilSpawnLocs[ RandomInt( 1, #self.vGreevilSpawnLocs ) ]
	local hGreevilLeader = CreateUnitByName( "npc_dota_greevil_leader", vLeaderPos, true, nil, nil, DOTA_TEAM_NEUTRALS )

	if hGreevilLeader ~= nil then
		GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, hGreevilLeader:GetOrigin().x, hGreevilLeader:GetOrigin().y, hGreevilLeader, 0 )
		GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, hGreevilLeader:GetOrigin().x, hGreevilLeader:GetOrigin().y, hGreevilLeader, 0 )

		self.hRoshan.hGreevilLeader = hGreevilLeader

		-- we want to count existing Greevil Thieves that popped out of the candy buckets
		local nNumGreevils = math.max( 0, self.nGreevilSpawnCount - self:CountGreevils( false ) )
		--printf( 'SPAWNING %d GREEVILS FROM THE LEADER SCRIPT', nNumGreevils )
		self.m_bSpawningInitialGreevilWave = true
		hGreevilLeader:SetContextThink( "greevil_spawn", function()
			if nNumGreevils <= 0 then
				self.m_bSpawningInitialGreevilWave = false
				return
			end

			local vPos = self.vGreevilSpawnLocs[ RandomInt( 1, #self.vGreevilSpawnLocs ) ]
			self:SpawnSingleGreevil( vPos )

			nNumGreevils = nNumGreevils - 1
			return 0.25
		end, 0 )

		self.nGreevilSpawnCount = math.min( self.nGreevilSpawnCount + WINTER2022_GREEVIL_SPAWN_COUNT_INCREMENT, WINTER2022_GREEVIL_SPAWN_COUNT_MAX )
		self.m_bGreevilsActive = true
	end

	local nNumRadiantBuckets = self:GetRemainingCandyBuckets( DOTA_TEAM_GOODGUYS )
	local nNumDireBuckets = self:GetRemainingCandyBuckets( DOTA_TEAM_BADGUYS )
	local bFinalRound = ( nNumRadiantBuckets + nNumDireBuckets ) == 2

	self:GetGlobalAnnouncer():OnRoundStart( self.m_nStateRoundNumber, bFinalRound )

	FireGameEvent( "greevil_spawn", {
		} )
end

--------------------------------------------------------------------------------

function CWinter2022:DespawnGreevils()

	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )
	local bFoundGreevil = false

	for i=#hCreatures,1,-1 do
		if hCreatures[i] ~= nil and hCreatures[i]:IsNull() == false and hCreatures[i]:IsAlive() and IsGreevil( hCreatures[i] ) then
			if hCreatures[i].AI ~= nil then
				hCreatures[i].AI:Burrow()
				bFoundGreevil = true
			end
		end
	end

	if bFoundGreevil then
		EmitGlobalSound( "Greevil.Despawn" )
	end
	
	self.m_bGreevilsActive = false
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnGreevilThieves()
	-- Remove candy from remaining wells and spawn a Greevil Thief at each one!
	if _G.WINTER2022_CANDY_PORTION_KEPT_ON_ROUND_END < 1 then
		for _,tBucketData in pairs( self.tAllCandyBucketsData ) do
			hUnit = tBucketData.hEntity
			if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() then
				if tBucketData.nCandy > 0 then
					local hAbility = hUnit:FindAbilityByName( "building_candy_bucket" )
					if hAbility ~= nil and hAbility:IsNull() == false then
						--print( 'REDUCING CANDY IN BUCKET ' .. hUnit:GetName() )
						local nNewCandy = math.ceil( tBucketData.nCandy * _G.WINTER2022_CANDY_PORTION_KEPT_ON_ROUND_END )
						local nCandyDelta = tBucketData.nCandy - nNewCandy

						-- special case for 1 candy - it won't be reduced below 1 so there's no thief to spawn here!
						if tBucketData.nCandy > 1 then
							-- spawn greevil thieves based on the candy delta
							-- clip to a reasonable number per well
							local nThievesToSpawn = math.max( 1, math.floor( nCandyDelta * WINTER2022_GREEVIL_THIEVES_SPAWNED_PER_CANDY ) )
							nThievesToSpawn = math.min( nThievesToSpawn, WINTER2022_GREEVIL_THIEVES_MAX_PER_WELL )

							-- clip globally to make sure we don't get out hand
							local nTotalCurrentGreevils = self:CountGreevils( false )
							nThievesToSpawn = math.min( nThievesToSpawn, WINTER2022_GREEVIL_COUNT_ABSOLUTE_MAX - nTotalCurrentGreevils )

							for i=1, nThievesToSpawn do
								self:SpawnGreevilThief( hUnit )
							end
						end

						hAbility:SetCandy( nNewCandy )
						-- update the last scored time to sort first by amount of candy (so relative ordering is preserved)
						-- and secondly by time in case of ties.
						-- we do this and set candy manually since SetCandy only does it if candy > oldcandy
						if tBucketData.fLastScoreTime < 100 then
							tBucketData.fLastScoreTime = tBucketData.fLastScoreTime + math.ceil( -tBucketData.fLastScoreTime / 10000 ) * 10000
						end
						tBucketData.fLastScoreTime = tBucketData.fLastScoreTime - tBucketData.nCandy * 10000
						tBucketData.nCandy = nNewCandy
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnGreevilThief( hBuilding )
	if hBuilding ~= nil then
		--print( 'SPAWNING A GREEVIL THIEF AT BUILDING ' .. hBuilding:GetName() )
		local vPos = GetRandomPathablePositionWithin( hBuilding:GetAbsOrigin(), 200 )
		local hGreevil = self:SpawnSingleGreevil( vPos )
		if hGreevil ~= nil and hGreevil.AI ~= nil then
			hGreevil.AI:SetStateStealFromWell( hBuilding )
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:TransitionGreevilsToFleeRandomly()
	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )

	for i=#hCreatures,1,-1 do
		if hCreatures[i] ~= nil and hCreatures[i]:IsNull() == false and hCreatures[i]:IsAlive() and IsGreevil( hCreatures[i] ) and hCreatures[i].AI ~= nil then
			if hCreatures[i]:GetUnitName() == "npc_dota_greevil_leader" then
				-- leader goes away
				hCreatures[i].AI:Burrow()
			else
				-- non-leaders go into scatter mode
				hCreatures[i].AI:FleeRandomly()
			end
		end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:CanGreevilsDespawn()
	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )

	for i=#hCreatures,1,-1 do
		local hUnit = hCreatures[i]
		if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and IsGreevil( hUnit ) then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------

function CWinter2022:CountGreevils( bIncludeLeader )
	local nCount = 0

	local hCreatures = Entities:FindAllByClassname( "npc_dota_creature" )

	for i=#hCreatures,1,-1 do
		local hUnit = hCreatures[i]
		if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsAlive() and IsGreevil( hUnit, bIncludeLeader ) then
			nCount = nCount + 1
		end
	end

	return nCount
end

--------------------------------------------------------------------------------

function CWinter2022:OnGolemKilled( hKilledUnit, hAttacker )
	if hKilledUnit.nGolemIndex ~= nil then
		nCandy = _G.WINTER2022_GOLEM_DEATH_CANDY_COUNT
		self.m_vecGolemRespawns[ hKilledUnit.nGolemIndex ] = true
		self.m_flGolemSpawnTime = RandomFloat( _G.WINTER2022_GOLEM_SPAWN_INTERVAL_MIN, _G.WINTER2022_GOLEM_SPAWN_INTERVAL_MAX ) + GameRules:GetDOTATime( false, true )

	end

	if hAttacker and hAttacker:IsOwnedByAnyPlayer() then
		local hDropHero = nil
		if hAttacker:IsRealHero() then
			hDropHero = hAttacker
		else
			local hPlayer = hAttacker:GetPlayerOwner()
			if hPlayer then
				hDropHero = hPlayer:GetAssignedHero()
			end
		end

		if hDropHero ~= nil then
			--[[
			if self.bAwardedFirstScarecrowStashKill == false then
				PlayerResource:AddCandyEvent( hDropHero:GetPlayerID(), 5 )	-- k_ECandyReasonEventGameScarecrowDestroyed
				self.bAwardedFirstScarecrowStashKill = true
			end
			]]--

			local nTier = 1
			local fGameTime = self:GetPlayedTime()
			if fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_5 * 60 ) then
				nTier = 5
			elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_4 * 60 ) then
				nTier = 4
			elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_3 * 60 ) then
				nTier = 3
			elseif fGameTime >= ( WINTER2022_NEUTRAL_ITEM_DROP_TIME_TIER_2 * 60 ) then
				nTier = 2
			end

			--print( 'NEUTRAL DROP! TIME = ' .. fGameTime .. '. Tier = ' .. nTier )
			for i = 1, _G.WINTER2022_GOLEM_DEATH_NEUTRAL_ITEM_COUNT do
				local szItemDrop = GetPotentialNeutralItemDrop( nTier, hDropHero:GetTeamNumber() )
				if szItemDrop ~= nil then
					local hItem = DropNeutralItemAtPositionForHeroWithOffset( szItemDrop, hKilledUnit:GetAbsOrigin(), hDropHero, nTier, true, RandomVector( 50 * i ) )
					if hItem ~= nil then
						local nKey = hKilledUnit.nGolemIndex
						hItem.nGolemIndex = nKey
						hItem.nItemIndex = i
						hItem.nHeroPlayerID = hDropHero:GetPlayerOwnerID()
						hItem.nTeam = hDropHero:GetTeamNumber()
						local tItemTable = self.m_vecNeutralItemDrops[nKey]
						if tItemTable == nil then
							tItemTable = {}
						end
						tItemTable[i] = hItem
						self.m_vecNeutralItemDrops[nKey] = tItemTable
					end
				end
			end

			local fGameTime = GameRules:GetGameTime()
			local nGold = math.floor( WINTER2022_GOLEM_KILL_GOLD_BASE + ( ( fGameTime / 60 ) * WINTER2022_GOLEM_KILL_GOLD_PER_MIN ) )
			local nXP = math.floor( WINTER2022_GOLEM_KILL_XP_BASE + ( ( fGameTime / 60 ) * WINTER2022_GOLEM_KILL_XP_PER_MIN ) )
			--printf( "^^^GOLEM KILL! Granting %d GOLD and %d XP to team %d", nGold, nXP, hDropHero:GetTeamNumber() )
			self:GrantGoldAndXPToTeam( hDropHero:GetTeamNumber(), nGold, nXP )
			-- TODO: show overhead gold message for each player of the killing team
			--SendOverheadEventMessage( hAttacker:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hKilledUnit, nTotalGold, nil )

			-- combat message
			local gameEvent = {}
			gameEvent["teamnumber"] = -1
			if hDropHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				gameEvent["message"] = "#DOTA_HUD_GolemKill_Radiant"
				FireGameEvent( "dota_combat_event_message", gameEvent )
			elseif hDropHero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				gameEvent["message"] = "#DOTA_HUD_GolemKill_Dire"
				FireGameEvent( "dota_combat_event_message", gameEvent )
			end			
		end
	end
	
	while nCandy > 0 do
		-- explicitly only drop single candies.
		self:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hAttacker, false, 1.0 )
		nCandy = nCandy - 1
	end
	
	-- drop item_candy_shield
	--[[
	local hCandyShield = CreateItem( "item_candy_shield", nil, nil )
	hCandyShield:SetPurchaseTime( 0 )
	CreateItemOnPositionSync( hKilledUnit:GetAbsOrigin(), hCandyShield )
	--]]
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnGolem( nKey )
	for _, tItems in pairs( self.m_vecNeutralItemDrops ) do
		for _, hItem in pairs( tItems ) do
			if hItem ~= nil and hItem:IsNull() == false and hItem.nGolemIndex == nKey then
				hItem:SetAbsOrigin( hItem:GetAbsOrigin() + RandomVector( 150 ) )
			end
		end
	end
				
	--print( "Respawning Golem at location " .. nKey )
			
	local vPos = self.m_vecGolemSpawns[ nKey ]
	local szGolemName = nil
	if RandomInt(0,1) == 1 then
		szGolemName = "npc_dota_dire_bucket_soldier"
	else
		szGolemName = "npc_dota_radiant_bucket_soldier"
	end
	
	local hNewGolem = CreateUnitByName( szGolemName, vPos, false, nil, nil, DOTA_TEAM_NEUTRALS )

	if hNewGolem ~= nil then
		hNewGolem.bIsGolem = true
		--self:AddCandyBucketModifiers( hNewGolem, false, false, false )

		--hNewGolem:AddNewModifier( nil, nil, "modifier_neutral_candy_bucket", { duration = -1 } )

		-- Knockback any units around where this unit spawns, since FindClearSpace isn't working
		local fKnockbackRadius = 150
		local nFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
		local hEnemies = FindUnitsInRadius( hNewGolem:GetTeamNumber(), hNewGolem:GetOrigin(), hNewGolem, fKnockbackRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, nFlags , 0, false )
		if #hEnemies > 0 then
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy ~= nil and hEnemy:IsNull() == false then
					local kv =
					{
						center_x = hNewGolem:GetAbsOrigin().x,
						center_y = hNewGolem:GetAbsOrigin().y,
						center_z = hNewGolem:GetAbsOrigin().z,
						should_stun = false,
						duration = 0.3,
						knockback_duration = 0.3,
						knockback_distance = 150,
						knockback_height = 50,
					}

					hEnemy:AddNewModifier( hNewGolem, nil, "modifier_knockback", kv )
				end
			end
		end

		--FindClearSpaceForUnit( hNewGolem, hNewGolem:GetAbsOrigin(), true )

		hNewGolem.nGolemIndex = nKey

		MinimapEvent( DOTA_TEAM_GOODGUYS, hNewGolem, hNewGolem:GetAbsOrigin().x, hNewGolem:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
		MinimapEvent( DOTA_TEAM_BADGUYS, hNewGolem, hNewGolem:GetAbsOrigin().x, hNewGolem:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 10.0 )
		--GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, vPos.x, vPos.y, hNewGolem, 0 )
		--GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, vPos.x, vPos.y, hNewGolem, 0 )

		local nSpawnFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hNewGolem )
		ParticleManager:SetParticleControl( nSpawnFXIndex, 0, hNewGolem:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( nSpawnFXIndex )

		-- beef up our golems as we advance through the game - set the tier based off of clock time
		hNewGolem:AddNewModifier( hNewGolem, nil, "modifier_creature_buff_dynamic", {} )
	end
end

--------------------------------------------------------------------------------

-- plays a sound on all clients. Spectators get Radiant sound
function CWinter2022:PlayTeamSound( szSoundA, szSoundB, nTeamA )
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer ~= nil then
			local nPlayerTeam = PlayerResource:GetTeam( nPlayerID )
			if nPlayerTeam == nTeamA then
				EmitSoundOnClient( szSoundA, hPlayer )
			elseif nPlayerTeam == FlipTeamNumber( nTeamA ) then
				EmitSoundOnClient( szSoundB, hPlayer )
			end
		end
	end
	EmitAnnouncerSoundForTeam( ( nTeamA == DOTA_TEAM_GOODGUYS and szSoundA ) or szSoundB, TEAM_SPECTATOR )
end

--------------------------------------------------------------------------------

function CWinter2022:Dev_PlayEndGameCinematic( szLosingTeam, szBucketNumber )
	local nLosingTeam = _G[ szLosingTeam ]
	if nLosingTeam == nil then
		nLosingTeam = DOTA_TEAM_GOODGUYS
	end

	print( 'LOSING TEAM = ' .. nLosingTeam )
	
	local nBucketNumber = nil
	if szBucketNumber == nil then
		nBucketNumber = 4
	else
		nBucketNumber = tonumber( szBucketNumber )
	end
	print( 'BUCKET NUMBER = ' .. nBucketNumber )

	local szCandyBucketName = nil
	if nLosingTeam == DOTA_TEAM_GOODGUYS then
		szCandyBucketName = "radiant_candy_bucket_" .. tostring( nBucketNumber )
	else
		szCandyBucketName = "dire_candy_bucket_" .. tostring( nBucketNumber )
	end
	
	local vecPos = Vector(0,0,0)
	local hBuckets = Entities:FindAllByName( szCandyBucketName )
	for _, hBucket in pairs( hBuckets ) do
		if hBucket then
			vecPos = hBucket:GetAbsOrigin()
			hBucket:AddEffects( EF_NODRAW )
			hBucket:RemoveModifierByName( "modifier_candy_bucket_invulnerable" )
		end
	end

	self.nWinningTeam = FlipTeamNumber( nLosingTeam )
	self:PlayEndGameCinematic( nLosingTeam, vecPos )

	--self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ENDING_CINEMATIC_TIME
	self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + 10000
	self.m_GameState = _G.WINTER2022_GAMESTATE_ENDING_CINEMATIC
end

--------------------------------------------------------------------------------

function CWinter2022:PlayEndGameCinematic( nLosingTeam, vecPos )
	self:GetTeamAnnouncer( self.nWinningTeam ):OnWin()
	self:GetTeamAnnouncer( FlipTeamNumber( self.nWinningTeam ) ):OnLoss()
	self:GetTeamAnnouncer( TEAM_SPECTATOR ):OnSpectatorWinLoss( self.nWinningTeam )

	GameRules:GetGameModeEntity():SetCameraZRange( 100, 5000 )

	FireGameEvent( "fade_to_black", {
		fade_down = 0,
		} )

	-- shut down all movement
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			Hero:AddNewModifier( Hero, nil, "modifier_hero_post_round", { duration = -1 } )
		end
	end

	-- Dynamically spawn in the cinematic sky
	self:SpawnSky()

	self:KillBucketSoldiers()

	local hBuildings = FindUnitsInRadius( nLosingTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hBuildings ) do
		if building:GetUnitName() == "home_candy_bucket" then
			building:AddEffects( EF_NODRAW )
			building:ForceKill( false )
		end
	end

	-- teleport roshan to bucket location
	self:ResetRoshan()
	self.hRoshan.bActive = false
	local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
	if hBuff ~= nil then
		hBuff:ResetHero()
		hBuff:Reset()
		hBuff:StopThinking()
	end
	self.hRoshan:Interrupt()
	self.hRoshan:Stop()
	self.hRoshan:Hold()
	self.hRoshan:SetAbsOrigin( vecPos )
	self.hRoshan:SetAbsAngles( 0, 270, 0 )

	-- stun rosh so he doesn't move
	self.hRoshan:AddNewModifier( self.hRoshan, nil, "modifier_roshan_end_game_cinematic", { duration = -1.0 } )

	-- add vision
	self.hRoshan:AddNewModifier( self.hRoshan, nil, "modifier_provide_vision", { duration = -1.0 } )

	self.hRoshan:StartGesture( ACT_DOTA_CHANNEL_ABILITY_4 )

	CustomGameEventManager:Send_ServerToAllClients( "begin_end_game_cinematic", { ent_index = self.hRoshan:entindex() } )
end

--------------------------------------------------------------------------------

function CWinter2022:SetupCandyBucketByName( szCandyBucketName, nTier, bInvulnerable )
	CustomNetTables:SetTableValue( "candy_buckets", szCandyBucketName, { is_alive = true, is_invulnerable = false, total_candy = 0 } )

	local hBuckets = Entities:FindAllByName( szCandyBucketName )
	for _, hBucket in pairs( hBuckets ) do
		self:AddCandyBucketModifiers( hBucket, nTier, bInvulnerable )
		--if bInvulnerable ~= true then 
			table.insert( self.tCandyBuckets[ hBucket:GetTeamNumber() ], hBucket )
			table.insert( self.tAllCandyBucketsData, { hEntity = hBucket, fLastScoreTime = 0, nCandy = 0 } )
			local hDummy = CreateUnitByName( "npc_dota_dummy_caster", hBucket:GetAbsOrigin(), false, nil, nil, FlipTeamNumber( hBucket:GetTeamNumber() ) )
			hBucket.hDummy = hDummy
		--end
	end
end

--------------------------------------------------------------------------------

function CWinter2022:FindNearestVulnerableCandyBucket( vPosition, nTargetTeam )
	local hBuckets = TableFilter( self.tCandyBuckets[ nTargetTeam ], function ( bucket ) return bucket ~= nil and bucket:IsNull() == false and bucket:IsAlive() and bucket:IsInvulnerable() == false end )
	return TableMinBy( hBuckets, function ( bucket ) return ( bucket:GetAbsOrigin() - vPosition ):Length2D() end )
end

--------------------------------------------------------------------------------

function CWinter2022:SetupGreevilSpawnSchedule()

	-- Hard coded schedule for now with dumb repetition, but could be different
	local tRound1SpawnTimes = {}
	table.insert( tRound1SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 1 ] = tRound1SpawnTimes
	
	local tRound2SpawnTimes = {}
	table.insert( tRound2SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 2 ] = tRound2SpawnTimes

	local tRound3SpawnTimes = {}
	table.insert( tRound3SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 3 ] = tRound3SpawnTimes

	local tRound4SpawnTimes = {}
	table.insert( tRound4SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 4 ] = tRound4SpawnTimes

	local tRound5SpawnTimes = {}
	table.insert( tRound5SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 5 ] = tRound5SpawnTimes

	local tRound6SpawnTimes = {}
	table.insert( tRound6SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 6 ] = tRound6SpawnTimes

	local tRound7SpawnTimes = {}
	table.insert( tRound7SpawnTimes, { fTime=5, fDuration=150 } )
	self.tGreevilSpawnData[ 7 ] = tRound7SpawnTimes
end

function CWinter2022:DebugWin()
	-- hack to force a win.
	self.nWinningTeam = 1
	self:PlayEndGameCinematic( 1, Vector(0,0,0))
	self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ENDING_CINEMATIC_TIME
	self.m_GameState = _G.WINTER2022_GAMESTATE_ENDING_CINEMATIC
	self:StateEnd( GameRules.Winter2022.m_nState )
end

--------------------------------------------------------------------------------

function CWinter2022:OnLastWellMaybeDestroyed( hKilledUnit )
	local nBuildingTeamNumber = hKilledUnit:GetTeamNumber()
	local nCount = 0
	for _,v in pairs( self.tCandyBuckets[ nBuildingTeamNumber ] ) do
		nCount = nCount + 1
		if v ~= nil and v:IsNull() == false then
			printf( "Examining building %s", v:GetName() )
			if v ~= hKilledUnit and v:IsAlive() then
				printf( "Found alive building!" )
				return false
			end
		end
	end

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hChangeHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hChangeHero ~= nil and hChangeHero:IsNull() == false then
			hChangeHero:SetRespawnsDisabled( true )
		end
	end
	self.nWinningTeam = FlipTeamNumber( nBuildingTeamNumber )
	self:PlayEndGameCinematic( nBuildingTeamNumber, hKilledUnit:GetAbsOrigin() )
	hKilledUnit:AddEffects( EF_NODRAW )
	self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ENDING_CINEMATIC_TIME
	self.m_GameState = _G.WINTER2022_GAMESTATE_ENDING_CINEMATIC
	self:StateEnd( GameRules.Winter2022.m_nState )
	return true
end

--------------------------------------------------------------------------------

function CWinter2022:SpawnSky()
	print("Spawning sky")

	if self.hSkyDome ~= nil then
		UTIL_Remove( self.hSkyDome )
	end

	if self.hSkyDomeClouds ~= nil then
		UTIL_Remove( self.hSkyDomeClouds )
	end

	if self.hSkyDomeMoon ~= nil then
		UTIL_Remove( self.hSkyDomeMoon )
	end

	local skyDomeTable = 
	{
		origin = "0 0 -48",
		angles = "0 296 0",
		targetname = "sky_dome",
		model = "models/diretide_intro_sky_dome.vmdl",
		scales = "330 330 330",
		defaultanim = "hold",
		holdanimation = "1",
		rendercolor = "255 255 255 255",
		glowcolor = "0 0 0 255",
		skin = "8",
		bodygroups = "{uv_set = 1}"
	}
	self.hSkyDome = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeTable )
	self.hSkyDome:SetEntityName("sky_dome")

	local skyDomeCloudsTable = 
	{
		origin = "0 0 -500",
		angles = "0 267 0",
		targetname = "sky_dome_dynamic_clouds",
		model = "models/diretide_intro_sky_dome.vmdl",
		scales = "320 320 320",
		defaultanim = "hold",
		holdanimation = "1",
		glowcolor = "0 0 0 255",
		rendercolor = "200 200 200 255",
		skin = "8_alpha",
		bodygroups = "{uv_set = 1}"
	}
	self.hSkyDomeClouds = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeCloudsTable )
	self.hSkyDomeClouds:SetEntityName("sky_dome_dynamic_clouds")

	local skyDomeMoonTable = 
	{
		origin = "0 0 -48",
		angles = "-8 246 4",
		targetname = "sky_dome_moon",
		model = "models/diretide_intro_sky_dome_expand.vmdl",
		scales = "325 325 325",
		defaultanim = "diretide_intro_sky_expand_anim",
		holdanimation = "1",
		glowcolor = "0 0 0 255",
		rendercolor = "255 255 255 255",
		skin = "8",
		bodygroups = "{uv_set = 1}"
	}
	self.hSkyDomeMoon = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeMoonTable )
	self.hSkyDomeMoon:SetEntityName("sky_dome_moon")
end

--------------------------------------------------------------------------------

function CWinter2022:GrantEventAction( nPlayerID, szActionName, nQuantity )
	local eEventAudit_PlayedMatch = 35
	local unAuditData = 0
	print("Granting Action: "..szActionName.." "..nQuantity.." to player "..nPlayerID)
	PlayerResource:RecordEventActionGrantForPrimaryEvent( nPlayerID, szActionName, eEventAudit_PlayedMatch, nQuantity, unAuditData )
end

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_creature_buff", "modifiers/gameplay/modifier_creature_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_bucket_soldiers", "modifiers/gameplay/modifier_candy_bucket_soldiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_provide_roshan_vision", "modifiers/gameplay/modifier_provide_roshan_vision", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_respawn_time_penalty", "modifiers/gameplay/modifier_diretide_respawn_time_penalty", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_home_bucket_heal", "modifiers/gameplay/modifier_diretide_home_bucket_heal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bucket_gain_candy", "modifiers/gameplay/modifier_bucket_gain_candy", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_prevent_invisibility", "modifiers/gameplay/modifier_prevent_invisibility", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_post_round", "modifiers/gameplay/modifier_hero_post_round", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutral_candy_bucket", "modifiers/gameplay/modifier_neutral_candy_bucket", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_end_game_cinematic", "modifiers/gameplay/modifier_roshan_end_game_cinematic", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_respawn_time", "modifiers/gameplay/modifier_hero_respawn_time", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_buff_dynamic", "modifiers/gameplay/modifier_creature_buff_dynamic", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_shield", "modifiers/items/modifier_candy_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_purge", "modifiers/gameplay/modifier_purge", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_candy_bucket_invulnerable", "modifiers/gameplay/modifier_candy_bucket_invulnerable", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_spit_out", "modifiers/creatures/modifier_spider_spit_out", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_hero_selecting_mount", "modifiers/gameplay/modifier_hero_selecting_mount", LUA_MODIFIER_MOTION_NONE )