if CDiretide == nil then
	CDiretide = class({})
	_G.CDiretide = CDiretide
end

--------------------------------------------------------------------------------

require( "diretide_utility_functions" )
require( "diretide_constants" )
require( "diretide_events" )
require( "diretide_game_configuration" )
require( "diretide_precache" )
require( "diretide_think" )
require( "diretide_wave_manager" )
require( "diretide_game_spawner" )

--------------------------------------------------------------------------------

function Precache( context )
	for _,Item in pairs( g_ItemPrecache ) do
		PrecacheItemByNameSync( Item, context )
	end

	for _,Unit in pairs( g_UnitPrecache ) do
		PrecacheUnitByNameSync( Unit, context, -1 )
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
	GameRules.Diretide = CDiretide()
	GameRules.Diretide:InitGameMode()
end

--------------------------------------------------------------------------------
function CDiretide:InitGameMode()
	self._bDevMode = false
	self._bDevNoRounds = false
	self.bForceLosingCandy = {}
	self.bForceLosingCandy[DOTA_TEAM_GOODGUYS] = false
	self.bForceLosingCandy[DOTA_TEAM_BADGUYS] = false

	self.m_nRoundNumber = 0
	self.m_nLastRoundStartSound = 0
	self.m_nLastRoundStartShown = 0
	self.m_nTotalNumOvertimes = 0
	self.m_nTeamScore = {}
	self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] = 0
	self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] = 0

	self.nXPRemaining = {}
	self.nGoldRemaining = {}

	self.bAwardedFirstScarecrowStashKill = false
	self.bAwardedFirstCandyWellKill = false
	self.bAwardedFirstCandySteal = false

	GameRules:SetNextRuneSpawnTime( 999999999 )
	GameRules:SetNextBountyRuneSpawnTime( 999999999 )

	self.vNeutralBucketsToSpawn = {}
	self.bPlayAllRounds = false


	self:SetupGameConfiguration()
	self:RegisterGameEvents()
	self:RegisterConCommands()

	self:CacheDestructibleBuildingLocs()
	self:CacheRoshan()
	self:CacheMapCandySpawns()

	local diretideConstants = {}
	for k,v in pairs( _G ) do
		if k:find( '^DIRETIDE_' ) then
			diretideConstants[k] = v
		end
	end
	CustomNetTables:SetTableValue( "globals", "constants", diretideConstants )
	self:ResetCandy()

	self.m_GameState = DIRETIDE_GAMESTATE_PREGAME
	self.m_flTimeRoundStarted = 0
	self.m_flTimeRoundEnds = 0

	-- Create announcer Units
	self.m_hRadiantAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = DOTA_TEAM_GOODGUYS }, Vector( 0, 0, 0 ) )
	self.m_hDireAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = DOTA_TEAM_BADGUYS }, Vector( 0, 0, 0 ) )
	self.m_hSpectatorAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = TEAM_SPECTATOR }, Vector( 0, 0, 0 ) )
	self.m_hGlobalAnnouncer = CreateUnitFromTable( { MapUnitName = "npc_dota_announcer_diretide", teamnumber = TEAM_SPECTATOR }, Vector( 0, 0, 0 ) )

	self.vecRoundTimerCues = {}
	self.vecRoundTimerCues[1] = true
	self.vecRoundTimerCues[2] = true
	self.vecRoundTimerCues[3] = true
	-- self.vecRoundTimerCues[4] = true -- Don't have a queue for 4 seconds, because 4 cuts off 5.
	self.vecRoundTimerCues[5] = true
	self.vecRoundTimerCues[10] = true
	self.vecRoundTimerCues[20] = true
	self.vecRoundTimerCues[30] = true

	self.EventMetaData = {}
	self.EventMetaData[ "event_name" ]  = "diretide2020"
	self.SignOutTable = {}
	self.SignOutTable["stats"] = {}
	self.SignOutTable["rounds"] = {}

--[[
	self.m_hEventGameDetails = GetLobbyEventGameDetails()
	printf( "[DIRETIDE2020] EventGameDetails table:" )
	if self.m_hEventGameDetails then
	    DeepPrintTable(self.m_hEventGameDetails)
	else
		printf( "NOT FOUND!!" )
	end
--]]
end

--------------------------------------------------------------------------------
function CDiretide:GetTeamAnnouncer( nTeamNumber )
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
function CDiretide:GetGlobalAnnouncer()
	return self.m_hGlobalAnnouncer.AI
end

--------------------------------------------------------------------------------
function CDiretide:RestartGameCheatCommand()
	self.m_nRoundNumber = 0
	self.m_nTeamScore = {}
	self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] = 0
	self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] = 0
	CustomNetTables:SetTableValue( "candy_collected", string.format("%d", DOTA_TEAM_GOODGUYS), { total_candy = _G.DIRETIDE_STARTING_CANDY } )
	CustomNetTables:SetTableValue( "candy_collected", string.format("%d", DOTA_TEAM_BADGUYS), { total_candy = _G.DIRETIDE_STARTING_CANDY } )

	-- Blast the items and gold
	self.m_hSavedHeroStates = deepcopy( self.m_InitialHeroState )
	for k,v in pairs( self.m_hSavedHeroStates) do
		v.hInventory = {}
		v.nGold = 1500
	end

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )	
		if hPlayerHero ~= nil then
			local hNewHero = PlayerResource:ReplaceHeroWith( nPlayerID, hPlayerHero:GetUnitName(), 0, 0 )
			UTIL_Remove( hPlayerHero )
		end
	end
	self:RespawnAllPlayers()
	self.m_GameState = DIRETIDE_GAMESTATE_PREGAME
end

--------------------------------------------------------------------------------

-- Verify spawners if random is set
function CDiretide:ChooseRandomSpawnInfo()
	--print( "CDiretide:ChooseRandomSpawnInfo" )

	if #self._vRandomSpawnsList == 0 then
		error( "Attempt to choose a random spawn, but no random spawns are specified in the data." )
		return nil
	end

	return self._vRandomSpawnsList[ RandomInt( 1, #self._vRandomSpawnsList ) ]
end

--------------------------------------------------------------------------------

function CDiretide:GetSpawnInfos()
	return self._vRandomSpawnsList
end

--------------------------------------------------------------------------------

function CDiretide:_ThinkLootExpiry()
	if self._flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetDOTATime( false, true ) - self._flItemExpireTime
	local bExpire = ( self:GetRoundNumber() ~= 5 )

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if ( containedItem ~= nil and containedItem:IsNull() == false and ( containedItem:GetAbilityName() == "item_bag_of_gold" or item.Holdout_IsLootDrop ) ) and bExpire then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------
function CDiretide:ThinkCandyExpiry()
	local flCutoffTime = GameRules:GetDOTATime( false, true ) - _G.DIRETIDE_CANDY_EXPIRY_SECONDS
	for _,item in pairs( Entities:FindAllByClassname( "item_lua" )) do
		if item:GetAbilityName() == "item_candy" or item:GetAbilityName() == "item_candy_bag" then
			if item.flSpawnTime >= 0 and  item.flSpawnTime <= flCutoffTime then
				local container = item:GetContainer()
				if container then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
					ParticleManager:SetParticleControl( nFXIndex, 0, container:GetOrigin() )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					UTIL_RemoveImmediate( container )
				end
				UTIL_RemoveImmediate( item )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CDiretide:_ProcessItemForLootExpiry( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end

--------------------------------------------------------------------------------

function CDiretide:IsRoundInProgress()
	return self.m_GameState == _G.DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS
end

--------------------------------------------------------------------------------

function CDiretide:SetRemainingXPForTeam( nTeamNumber, nXP )
	--printf( "CDiretide:SetXPLimitForTeam - setting limit for team %d to %d xp", nTeamNumber, nXP )
	self.nXPRemaining[ nTeamNumber ] = nXP
end

--------------------------------------------------------------------------------

function CDiretide:GetRemainingXPForTeam( nTeamNumber )
	return self.nXPRemaining[ nTeamNumber ]
end

--------------------------------------------------------------------------------

function CDiretide:SetRemainingGoldForTeam( nTeamNumber, nGold )
	--printf( "CDiretide:SetGoldLimitForTeam - setting limit for team %d to %d gold", nTeamNumber, nGold )
	self.nGoldRemaining[ nTeamNumber ] = nGold
end

--------------------------------------------------------------------------------

function CDiretide:GetRemainingGoldForTeam( nTeamNumber )
	return self.nGoldRemaining[ nTeamNumber ]
end

--------------------------------------------------------------------------------

function CDiretide:GrantGoldAndXPToTeam( nTeamNumber, nGold, nXP )
	if nTeamNumber ~= DOTA_TEAM_GOODGUYS and nTeamNumber ~= DOTA_TEAM_BADGUYS then
		return
	end

	local playersToChange = {}
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
			table.insert( playersToChange, nPlayerID )
		end
	end

	local nTotalAllowedXP = math.min( nXP, self.nXPRemaining[ nTeamNumber ] )
	local nTotalAllowedGold = math.min( nGold, self.nGoldRemaining[ nTeamNumber ] )

	local nXPToGrant = math.max( 0, nTotalAllowedXP )
	local nGoldToGrant =  math.max( 0, nTotalAllowedGold )
	for _,nPlayerID in pairs( playersToChange ) do
		hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero ~= nil then
			if nXPToGrant > 0 then
				self.bLetXPThrough = true
				hHero:AddExperience( nXPToGrant, DOTA_ModifyXP_CreepKill, false, true )	
				self.bLetXPThrough = nil
			end
			if nGoldToGrant > 0 then
				self.bLetGoldThrough = true
				hHero:ModifyGold( nGoldToGrant, true, DOTA_ModifyGold_Unspecified )
				self.bLetGoldThrough = nil
			end
		end
	end

	self.nXPRemaining[ nTeamNumber ] = self.nXPRemaining[ nTeamNumber ] - nTotalAllowedXP
	self.nGoldRemaining[ nTeamNumber ] = self.nGoldRemaining[ nTeamNumber ] - nTotalAllowedGold
end

--------------------------------------------------------------------------------

function CDiretide:FixupTeamXP()

	local nDesiredXP = 0
	for _,waveManager in pairs( self._vWaveManagers[DOTA_TEAM_GOODGUYS] ) do
		if waveManager._nRoundNumber < self:GetRoundNumber() then
			nDesiredXP = nDesiredXP + waveManager:GetTotalXP()
		end
	end

	local playersToChange = {}
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		local nTeam = PlayerResource:GetTeam( nPlayerID )
		if nTeam == DOTA_TEAM_GOODGUYS or nTeam == DOTA_TEAM_BADGUYS then
			table.insert( playersToChange, nPlayerID )
		end
	end

	for _,nPlayerID in pairs( playersToChange ) do
		hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero ~= nil then
			local nCurrentXP = hHero:GetCurrentXP()
			if nCurrentXP < nDesiredXP then
				print( "%%%% Error! Hero " .. hHero:GetUnitName() .. " has " .. nCurrentXP .. " but is supposed to have " .. nDesiredXP )
				self.bLetXPThrough = true
				hHero:AddExperience( nDesiredXP - nCurrentXP, DOTA_ModifyXP_CreepKill, false, true )	
				self.bLetXPThrough = nil
			end
		end
	end
end

--------------------------------------------------------------------------------

function CDiretide:RefreshPlayers()
	GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept( true )
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS 
			or PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil then
					--			 PositiveBuffs, NegativeBuffs, FrameOnly, RemoveStuns, RemoveExceptions
					hHero:Purge( true,		  	true,		   false,	  true,		   false )
					hHero:RespawnHero( false, false )
					--Respawn Wraith King at the fountain
					local szHeroName = hHero:GetUnitName()
					if szHeroName == "npc_dota_hero_skeleton_king" then
						--print("Wraith King Respawn")
						local nHeroTeam = PlayerResource:GetTeam( nPlayerID )
						--print("Team = " .. nHeroTeam)
						local szFountainName = "info_player_start_goodguys"
						if nHeroTeam == DOTA_TEAM_BADGUYS then
							szFountainName = "info_player_start_badguys"
						end
						local hFountainTable = Entities:FindAllByClassname( szFountainName )
						if hFountainTable ~= nil then
							local hFountain = hFountainTable[1]
							local vecFountain = hFountain:GetAbsOrigin()
							FindClearSpaceForUnit( hHero, vecFountain, true )
						end
					end
					hHero:SetHealth( hHero:GetMaxHealth() )
					hHero:SetMana( hHero:GetMaxMana() )
					hHero:SetBuybackCooldownTime( 0 )
					hHero:RemoveModifierByName("modifier_diretide_roshan_curse_debuff")

		 			CenterCameraOnUnit( nPlayerID, hHero )

					if DIRETIDE_LIMITED_LIVES_PER_ROUND == true then
						hHero.nRespawnsRemaining = DIRETIDE_LIVES_PER_ROUND
						CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hHero:entindex() ), { respawns = hHero.nRespawnsRemaining } )
					end

					for i = 0,DOTA_MAX_ABILITIES-1 do
						local hAbility = hHero:GetAbilityByIndex( i )
						if hAbility then
							if hAbility:IsRefreshable() then
								hAbility:SetFrozenCooldown( false )
								hAbility:EndCooldown()
								hAbility:RefreshCharges()
							end
							-- DO NOT DO THIS without testing if ability is trained/etc. hAbility:RefreshIntrinsicModifier()
						end
					end

					for j = 0,DOTA_ITEM_INVENTORY_SIZE-1 do
						local hItem = hHero:GetItemInSlot( j )
						if hItem then
							if hItem:IsRefreshable()  then
								hItem:SetFrozenCooldown( false )
								hItem:EndCooldown()
								hItem:RefreshCharges()
							end
						end
					end

					local hTpScroll = hHero:GetItemInSlot( DOTA_ITEM_TP_SCROLL )
					if hTpScroll then
						if hTpScroll:IsRefreshable()  then
							hTpScroll:SetFrozenCooldown( false )
							hTpScroll:EndCooldown()
							hTpScroll:RefreshCharges()
						end
					end

					local hDeathPenaltyModifier = hHero:FindModifierByName( "modifier_diretide_respawn_time_penalty" )
					if hDeathPenaltyModifier then
						hDeathPenaltyModifier:SetStackCount( 0 )
					end
				end
			end
		end
	end
	GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept( false )
end

--------------------------------------------------------------------------------

function CDiretide:KillBucketSoldiers()
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

function CDiretide:AddCandyBucketModifiers( hBucket, bHomeBucket, bIsTeamBucket )
	-- Setup soldier buff
	local flBuffLevel = 0
	local flDmgBuffLevel = 0
	local nBase = self:GetRoundNumber() - 1
	flBuffLevel = math.max( 0, nBase + math.pow(nBase, 2.0) * 0.1 )
	flDmgBuffLevel = flBuffLevel -- same, for now

	local kv = {}

	if bHomeBucket == true then
		kv =
		{
			-- home buckets are invulnerable-ish, so no need to buff health
			building_hp_buff_pct = 0,
			damage_buff_pct = math.floor( flBuffLevel * DIRETIDE_BUCKET_SOLDIERS_HOME_BUCKET_BUFF_MULTIPLIER ),
			hp_buff_pct = math.floor( flDmgBuffLevel * DIRETIDE_BUCKET_SOLDIERS_HOME_BUCKET_BUFF_MULTIPLIER ),
			armor_buff = self:GetRoundNumber() * DIRETIDE_BUCKET_SOLDIERS_ROUND_ARMOR_BONUS,
			model_scale = 1.0 + flBuffLevel * DIRETIDE_BUCKET_SOLDIERS_HOME_BUCKET_MODEL_SCALE_MULTIPLIER,
			soldier_count = ( bIsTeamBucket and DIRETIDE_BUCKET_SOLDIERS_MAX_HOME ) or 0,
			is_home = 1,
		}
	else
		kv =
		{
			building_hp_buff_pct = math.floor( flBuffLevel * DIRETIDE_OUTER_BUCKET_HEALTH_BUFF_MULTIPLIER ),
			damage_buff_pct = math.floor( flBuffLevel * DIRETIDE_BUCKET_SOLDIERS_OUTER_BUCKET_BUFF_MULTIPLIER ),
			hp_buff_pct = math.floor( flDmgBuffLevel * DIRETIDE_BUCKET_SOLDIERS_OUTER_BUCKET_BUFF_MULTIPLIER ),
			armor_buff = self:GetRoundNumber() * DIRETIDE_BUCKET_SOLDIERS_ROUND_ARMOR_BONUS,
			model_scale = 1.0 + flBuffLevel * DIRETIDE_BUCKET_SOLDIERS_OUTER_BUCKET_MODEL_SCALE_MULTIPLIER,
			soldier_count = ( bIsTeamBucket and DIRETIDE_BUCKET_SOLDIERS_MAX ) or 0,
			is_home = 0,
		}
	end

	if bHomeBucket == true then
		hBucket:AddNewModifier( nil, nil, "modifier_diretide_home_bucket_heal", nil )
		self.m_BuildingDamage[hBucket] = 0
		self.m_BuildingCreepCounter[hBucket] = 0
	else
		if _G.DIRETIDE_BUILDING_CANDY_GAIN_AMOUNT > 0 then
			hBucket:AddNewModifier( nil, nil, "modifier_bucket_gain_candy", kv )
		end
	end
	if bIsTeamBucket == true then
		hBucket:AddNewModifier( nil, nil, "modifier_invulnerable", nil )
	else
		hBucket:RemoveModifierByName( "modifier_invulnerable" )
	end

	hBucket:AddNewModifier( nil, nil, "modifier_candy_bucket_soldiers", kv )

end

--------------------------------------------------------------------------------

function CDiretide:RespawnBuildings()
	self:_PhaseAllUnits( true )

	-- Remove all the destructible buckets
	local hRadiantBuildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hRadiantBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" or building:GetUnitName() == "home_candy_bucket" then
			building:AddEffects( EF_NODRAW )
			building:ForceKill( false )
		end
	end

	local hDireBuildings = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hDireBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" or building:GetUnitName() == "home_candy_bucket" then
			building:AddEffects( EF_NODRAW )
			building:ForceKill( false )
		end
	end

	local hNeutralBuildings = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hNeutralBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" or building:GetUnitName() == "home_candy_bucket" then
			building:AddEffects( EF_NODRAW )
			building:ForceKill( false )
		end
	end

	-- Make new buckets
	for _, vPos in pairs( self.vRadiantBucketLocs ) do
		local hNewBucket = CreateUnitByName( "candy_bucket", vPos, false, nil, nil, DOTA_TEAM_GOODGUYS )
		if hNewBucket ~= nil then
			self:AddCandyBucketModifiers( hNewBucket, false, true )
		end
	end
	for _, vPos in pairs( self.vRadiantHomeBucketLocs ) do
		local hNewBucket = CreateUnitByName( "home_candy_bucket", vPos, false, nil, nil, DOTA_TEAM_GOODGUYS )
		if hNewBucket ~= nil then
			self:AddCandyBucketModifiers( hNewBucket, true, true )
		end
	end

	for _, vPos in pairs( self.vDireBucketLocs ) do
		local hNewBucket = CreateUnitByName( "candy_bucket", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
		if hNewBucket ~= nil then
			self:AddCandyBucketModifiers( hNewBucket, false, true )
		end
	end
	for _, vPos in pairs( self.vDireHomeBucketLocs ) do
		local hNewBucket = CreateUnitByName( "home_candy_bucket", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
		if hNewBucket ~= nil then
			self:AddCandyBucketModifiers( hNewBucket, true, true )
		end
	end

	self:_PhaseAllUnits( false )
end

--------------------------------------------------------------------------------

function CDiretide:_PhaseAllUnits( bPhase )
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, 0, FIND_ANY_ORDER, false )
	for _,unit in ipairs(units) do
		if bPhase then
			unit:AddNewModifier( units[i], nil, "modifier_phased", {} )
		else
			unit:RemoveModifierByName( "modifier_phased" )
		end
	end
end

--------------------------------------------------------------------------------
function CDiretide:ShouldBuildingEmitCandy(hBuilding, nDamageDealt)
	if self:IsRoundInProgress() == false then
		return 0
	end
	local nEmitCandyAfterThisMuchDamage = _G.DIRETIDE_BUILDING_DAMAGE_TO_CANDY_DIVISOR
	if hBuilding:GetUnitName() == "home_candy_bucket" then
		nEmitCandyAfterThisMuchDamage = _G.DIRETIDE_HOME_BUCKET_DAMAGE_TO_CANDY_DIVISOR
	end

	if nEmitCandyAfterThisMuchDamage == 0 then
		return 0
	end
	local nTeamCandy = self:GetTeamCandy( hBuilding:GetTeamNumber() )
	nTeamCandy = nTeamCandy + math.max( 0, nTeamCandy - self:GetTeamCandy( FlipTeamNumber( hBuilding:GetTeamNumber() ) ) )
	
	local flCandyScalar = 1
	-- the clamping was working strangely, so do it here.
	if nTeamCandy < 5 then
		flCandyScalar = 10
	elseif nTeamCandy > 100 then
		flCandyScalar = 0.75
	else
		flCandyScalar = RemapValClampedPower( nTeamCandy, 5, 100, 15, 1, 0.25 )
	end
	nEmitCandyAfterThisMuchDamage = nEmitCandyAfterThisMuchDamage * ( 1 + ( ( self:GetRoundNumber() - 1 ) / 2 ) ) * flCandyScalar

	local nTotalDamage = 0
	if self.m_BuildingDamage[hBuilding] ~= nil then
		nTotalDamage = self.m_BuildingDamage[hBuilding]
	end

	nTotalDamage = nTotalDamage + nDamageDealt

	local nCandyToEmit = 0
	if nTotalDamage > nEmitCandyAfterThisMuchDamage then
		nCandyToEmit = math.floor( nTotalDamage / nEmitCandyAfterThisMuchDamage )
		nTotalDamage = nTotalDamage - ( nCandyToEmit * nEmitCandyAfterThisMuchDamage )
	end

	self.m_BuildingDamage[hBuilding] = nTotalDamage

	return math.min( nCandyToEmit, _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG )
end

--------------------------------------------------------------------------------

function CDiretide:CacheDestructibleBuildingLocs()
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
end

--------------------------------------------------------------------------------

function CDiretide:CacheRoshan()
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
	self.hRoshan.nTrickOrTreatCounter = {}
	self.hRoshan.nTrickOrTreatCounter[DOTA_TEAM_GOODGUYS] = -1
	self.hRoshan.nTrickOrTreatCounter[DOTA_TEAM_BADGUYS] = -1
end

--------------------------------------------------------------------------------
function CDiretide:GetRoshanRequestCounter( nTeam )
	if self.hRoshan == nil or self.hRoshan.nTrickOrTreatCounter == nil or ( nTeam ~= DOTA_TEAM_GOODGUYS and nTeam ~= DOTA_TEAM_BADGUYS ) then
		return 0
	end
	return self.hRoshan.nTrickOrTreatCounter[nTeam]
end

--------------------------------------------------------------------------------
function CDiretide:CacheMapCandySpawns()
	--print("CDiretide:CacheMapCandySpawns")

	local vecCandySpawns = Entities:FindAllByName( "candy_drop_spawner" )
	if #vecCandySpawns == 0 then
		print( "Failed to find any candy_drop_spawner entities" )
	end
	self.m_vecMapCandySpawns = {}
	local nIndex = 1
	for _,hCandySpawner in pairs(vecCandySpawns) do
		-- single-position version
		self.m_vecMapCandySpawns[nIndex] = hCandySpawner:GetAbsOrigin()
		nIndex = nIndex + 1

		-- multiple drops per position version
		--[[for i=1,_G.DIRETIDE_MAP_CANDY_COUNT do
			local vLoc = hCandySpawner:GetAbsOrigin()
			if _G.DIRETIDE_MAP_CANDY_COUNT > 1 then
				local flDist = _G.DIRETIDE_MAP_CANDY_BASE_DISPERSION * _G.DIRETIDE_MAP_CANDY_COUNT / 2.0
				local flVal = ( i - 1.0 ) / _G.DIRETIDE_MAP_CANDY_COUNT * 2 * math.pi
				vLoc.x = vLoc.x + flDist * math.sin( flVal )
				vLoc.y = vLoc.y + flDist * math.cos( flVal )
			end
			self.m_vecMapCandySpawns[nIndex] = vLoc
			nIndex = nIndex + 1
		end--]]
	end
end

--------------------------------------------------------------------------------

function CDiretide:RegisterConCommands()
	local eCommandFlags = FCVAR_CHEAT
	
	Convars:RegisterCommand( "diretide_respawn", function( commandName, nPlayerID )
		if nPlayerID == nil then
			nPlayerID = 0
		end
		return self:RespawnPlayerID( nPlayerID )
	end, "Respawn your hero/monster", eCommandFlags )

	Convars:RegisterCommand( "diretide_respawnall", function( ...)
		return self:RespawnAllPlayers()
	end, "Respawn all hero/monsters", eCommandFlags )

	Convars:RegisterCommand( "diretide_endround", function(...)
		-- if we trigger this command in the interstitial phase we need to start the next round before we end it
		if self.m_GameState == _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
			self:StartRound()
		end

		if self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] > self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] then
			return self:EndRound( DOTA_TEAM_BADGUYS )
		else
			return self:EndRound( DOTA_TEAM_GOODGUYS )
		end
	end, "End the round - awards the point to the losing team", eCommandFlags )

	Convars:RegisterCommand( "diretide_releaseroshan", function(...)
		if self.bRoshanActive ~= true then
			self:TrickOrTreatToTeam( 0, true )
		end
	end, "Release roshan", eCommandFlags )

	Convars:RegisterCommand( "diretide_goto_round", function( commandName, szRoundNumber )
		local nRoundNumber = tonumber( szRoundNumber ) 
		print( "GOTO ROUND " .. nRoundNumber )
		if nRoundNumber <= self.m_nRoundNumber then
			print( "Requested round number is earlier in the sequence! We can't go back. :(" )
			return
		end
		while self.m_nRoundNumber < nRoundNumber do
			-- if we trigger this command in the interstitial phase we need to start the next round before we end it
			if self.m_GameState == _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
				self:StartRound()
			end

			if self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] > self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] then
				self:EndRound( DOTA_TEAM_BADGUYS )
			end
			self:EndRound( DOTA_TEAM_GOODGUYS )
		end
	end, "End the round - awards the point to the losing team", eCommandFlags )


	Convars:RegisterCommand( "diretide_message_curse", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "team_cursed", {
			cursed_team = nTeamNumber,
		} )
	end, "Show curse message, argument = team number, 2 or 3 (negative means treat client as spectator)", eCommandFlags )

	Convars:RegisterCommand( "diretide_message_roshan", function( commandName, szTeamNumber, szPlayer )
		local nTeamNumber = tonumber( szTeamNumber ) 
		local nPlayer = ( tonumber( szPlayer ) == 1 and 1 ) or 0
		FireGameEvent( "roshan_target_switch", {
			team = nTeamNumber,
			ent_index = 1090, -- whatever, something random
			force_you = nPlayer
		} )
	end, "Show roshan target message, arguments = team number, 2 or 3 (negative means treat client as spectator); and whether to say targeting you, 1 or 0", eCommandFlags )


	Convars:RegisterCommand( "diretide_message_bucket", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "candy_bucket_attacked", {
			team = nTeamNumber,
		} )
	end, "Show bucket attacked message, argument = team number, 2 or 3", eCommandFlags )

	Convars:RegisterCommand( "diretide_message_overtime", function( ... )
		FireGameEvent( "start_overtime", {
			extra_time = _G.DIRETIDE_OVERTIME_TIME,
		} )
	end, "Show overtime message", eCommandFlags )

	Convars:RegisterCommand( "diretide_message_timeleft", function( commandName, szTime )
		local nTime = tonumber( szTime ) 
		FireGameEvent( "time_left", {
			time_left = nTime,
		} )
	end, "Show time left message, argument = time left (1/2/3/10/20)", eCommandFlags )

	Convars:RegisterCommand( "diretide_message_stashrespawn", function( ... )
		FireGameEvent( "stash_respawn", {
		} )
	end, "Show stash respawn message", eCommandFlags )

	Convars:RegisterCommand( "diretide_anim_lose_candy_toggle", function( commandName, szTeamNumber )
		local nTeamNumber = tonumber( szTeamNumber ) 
		self.bForceLosingCandy[nTeamNumber] = not self.bForceLosingCandy[nTeamNumber]
	end, "Toggles showing the lose candy anim on candy score, argument = team number, 2 or 3", eCommandFlags )

	Convars:RegisterCommand( "diretide_test_disconnect", function( commandName, szPlayerID )
		local nPlayerID = tonumber( szPlayerID ) 
		self:OnPlayerDisconnect( { PlayerID = nPlayerID } )
	end, "Pretend a player disconnected", eCommandFlags )


	Convars:RegisterCommand( "diretide_createcandy", function(...) self:Dev_CreateCandyFromPlayer() end, "Make a piece of candy from the player", eCommandFlags )
	Convars:RegisterCommand( "diretide_generateroundcandyreport", function(...) self:Dev_GenerateRoundCandyReport() end, "Generate a report of how much candy is created by creeps each round", eCommandFlags )
	Convars:RegisterCommand( "diretide_playendgamecinematic", function( commandName, szLosingTeam ) self:Dev_PlayEndGameCinematic( szLosingTeam ) end, "Play the endgame cinematic for one of the teams", eCommandFlags )
	Convars:RegisterCommand( "diretide_play_roshan_anim", function( commandName, szActivity ) self:Dev_PlayRoshanAnim( szActivity ) end, "Play a specific animation on Roshan", eCommandFlags )
	Convars:RegisterCommand( "diretide_fade_to_black", function( commandName, szFadeDown ) self:Dev_FadeToBlack( szFadeDown ) end, "Debug for the fade to black", eCommandFlags )
	Convars:RegisterCommand( "diretide_show_round_start_ui", function( commandName, szRoundNumber ) self:Dev_ShowRoundStartUI( szRoundNumber ) end, "Debug to show the Round Start UI for a particular round", eCommandFlags )
	Convars:RegisterConvar( "diretide_candymult", "1", "Multiply candy drops by this", 0 )
end

--------------------------------------------------------------------------------

function CDiretide:Dev_ShowRoundStartUI( szRoundNumber )
	local nRoundNumber = 1
	if szRoundNumber then
		nRoundNumber = tonumber( szRoundNumber )
	end
	
	local waveManager = self._vWaveManagers[DOTA_TEAM_GOODGUYS][nRoundNumber]
	local szRoundName = waveManager._szRoundQuestTitle

	-- Kick off an event to declare one team the winner of the round, client-side.
	FireGameEvent( "round_start", {
		round_number = nRoundNumber,
		round_name = szRoundName,
	 } )
end

--------------------------------------------------------------------------------

function CDiretide:Dev_PlayRoshanAnim( szActivity )
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

function CDiretide:Dev_FadeToBlack( szFadeDown )
	local nFade = tonumber( szFadeDown )
	FireGameEvent( "fade_to_black", {
		fade_down = nFade,
		} )
end

--------------------------------------------------------------------------------

function CDiretide:Dev_CreateCandyFromPlayer()
	local hPlayer = Entities:GetLocalPlayer()
	self:DropCandyAtPosition( hPlayer:GetAbsOrigin(), hPlayer, nil, false, 1.0 )
end

--------------------------------------------------------------------------------

function CDiretide:Dev_GenerateRoundCandyReport()
	print( 'GENERATING CANDY REPORT' )
	print( '***********************' )
	for i, hWaveManager in ipairs( self._vWaveManagers[DOTA_TEAM_GOODGUYS] ) do
		local nCandy = hWaveManager:GetTotalCandy()
		print( 'WAVE ' .. i .. ': CANDY PRODUCED = ' .. nCandy )
	end
	print( '***********************' )
end

--------------------------------------------------------------------------------
function CDiretide:GetRoundNumber()
	return self.m_nRoundNumber -- 0 if pre-game or after game-over
end

--------------------------------------------------------------------------------
function CDiretide:GetRadiantCandy()
	return self:GetTeamCandy( DOTA_TEAM_GOODGUYS )
end

--------------------------------------------------------------------------------
function CDiretide:GetDireCandy()
	return self:GetTeamCandy( DOTA_TEAM_BADGUYS )
end

--------------------------------------------------------------------------------
function CDiretide:GetTeamCandy( nTeamNumber )
	local key = string.format( "%d", nTeamNumber )
	local t = CustomNetTables:GetTableValue( "candy_collected", key )
	if t == nil or t['total_candy'] == nil then
		return 0
	else
		return t['total_candy']
	end
end

--------------------------------------------------------------------------------
function CDiretide:SetTeamCandy( nTeamNumber, nCandyCount )
	local key = string.format("%d", nTeamNumber )
	local t = CustomNetTables:GetTableValue("candy_collected", key) 
	if t == nil then
		t = { total_candy =  nCandyCount }
	end
	t['total_candy'] = nCandyCount
	CustomNetTables:SetTableValue( "candy_collected", key, t  )
end

--------------------------------------------------------------------------------
function CDiretide:GetTeamExtraCandy( nTeamNumber )
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

--------------------------------------------------------------------------------
function CDiretide:GetTeamTotalCandy( nTeamNumber )
	if nTeamNumber == 0 then
		return 0
	end
	return self:GetTeamCandy( nTeamNumber ) + self:GetTeamExtraCandy( nTeamNumber )
end

--------------------------------------------------------------------------------
function CDiretide:StartRound()
	self:ResetCandy()
	self.m_GameState = _G.DIRETIDE_GAMESTATE_ROUND_IN_PROGRESS
	self.bRoshanActive = false
	self.m_nPreviousLead = _G.DOTA_TEAM_NONE
	self.m_nNumOvertimes = 0
	if self.vExtraSpawns == nil then
		self.vExtraSpawns = {}
	end
	self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
	self.m_flTimeRoundEnds =  self.m_flTimeRoundStarted + _G.DIRETIDE_ROUND_TIME

	self.m_nRoshanOverrides = 0

	self.m_vecCandyScores = {}
	self.m_vecCandyScores[DOTA_TEAM_GOODGUYS] = 0
	self.m_vecCandyScores[DOTA_TEAM_BADGUYS] = 0

	GameRules:SetNextRuneSpawnTime( GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_RUNE_START_TIME )
	GameRules:GetGameModeEntity():SetPowerRuneSpawnInterval( _G.DIRETIDE_RUNE_INTERVAL )

	self.m_flCandySpawnTime = _G.DIRETIDE_MAP_CANDY_INITIAL_SPAWN_INTERVAL + GameRules:GetDOTATime( false, true )
	self.m_vecMapCandyRespawns = {}
	self.m_vecMapCandyRespawnBuckets = {}
	for k,v in pairs(self.m_vecMapCandySpawns) do
		--print( "Setting respawn timer for mapcandy position " .. k )
		--self.m_vecMapCandyRespawns[k] = true
		self.m_vecMapCandyRespawnBuckets[k] = true
	end
	self.m_vecNeutralItemDrops = {}

	if _G.DIRETIDE_RESET_GLYPH_PER_ROUND == true then
		GameRules:SetGlyphCooldown( DOTA_TEAM_GOODGUYS, 0.0 )
		GameRules:SetGlyphCooldown( DOTA_TEAM_BADGUYS, 0.0 )
	end

	local hRadiantBuildings = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hRadiantBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" then
			building:RemoveModifierByName( "modifier_invulnerable" )
			local hBuff = building:FindModifierByName( "modifier_candy_bucket_soldiers" )
			if hBuff ~= nil then
				hBuff:UpdateSoldiers()
			end
		end
	end

	local hDireBuildings = FindUnitsInRadius( DOTA_TEAM_BADGUYS, Vector( 0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, building in ipairs( hDireBuildings ) do
		if building:GetUnitName() == "candy_bucket" or building:GetUnitName() == "neutral_candy_bucket" then
			building:RemoveModifierByName( "modifier_invulnerable" )
			local hBuff = building:FindModifierByName( "modifier_candy_bucket_soldiers" )
			if hBuff ~= nil then
				hBuff:UpdateSoldiers()
			end
		end
	end

	self._currentWaves = {}

	-- start both wave managers for each team
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local waveManager = self._vWaveManagers[nTeam][self:GetRoundNumber()]
		waveManager:Begin()
		waveManager:Precache()
		self._currentWaves[nTeam] = waveManager
	end

	self:GetGlobalAnnouncer():OnRoundStart( self:GetRoundNumber() )
end

--------------------------------------------------------------------------------
function CDiretide:RoundTimeExpired()
	local nRadiantCandy = self:GetRadiantCandy()
	local nDireCandy = self:GetDireCandy()

	if nRadiantCandy == nDireCandy then
		self.m_flTimeRoundEnds = self.m_flTimeRoundEnds + _G.DIRETIDE_OVERTIME_TIME
		self.m_nNumOvertimes = self.m_nNumOvertimes + 1
		self.m_nTotalNumOvertimes = self.m_nTotalNumOvertimes + 1
		for k,v in pairs( self.vecRoundTimerCues ) do
			self.vecRoundTimerCues[k] = true
		end

		EmitGlobalSound( "RoundOvertime.Stinger" )

		FireGameEvent( "start_overtime", {
			extra_time = _G.DIRETIDE_OVERTIME_TIME,
		 } )
		return
	end

	
	local nScoringTeam = DOTA_TEAM_BADGUYS
	if nRadiantCandy > nDireCandy then
		nScoringTeam = DOTA_TEAM_GOODGUYS
	end

	--print( 'ROUND TIME EXPIRED: Radiant Candy = %d. Dire Candy = %d. SCORING TEAM is %d', nRadiantCandy, nDireCandy, nScoringTeam )

	self:EndRound( nScoringTeam )
end

--------------------------------------------------------------------------------
function CDiretide:EndRound( nScoringTeam )
	print( 'Ending the round with scoring team being ' .. nScoringTeam )
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		if self._currentWaves ~= nil then
			self._currentWaves[nTeam]:End( true )
		end
	end
	self._currentWaves = nil

	self.vNeutralBucketsToSpawn = {}

	if self.m_GameState ~= _G.DIRETIDE_GAMESTATE_DISPLAY_FINAL_ROUND_RESULTS then
		local hRoundStats = {}
		hRoundStats["round_number"] = self:GetRoundNumber()
		if self.m_nNumOvertimes > 0 then
			hRoundStats["overtimes"] = self.m_nNumOvertimes
		end
		hRoundStats["candy_dire"] = self:GetDireCandy()
		hRoundStats["candy_radiant"] = self:GetRadiantCandy()
		hRoundStats["winner"] = nScoringTeam
		table.insert( self.SignOutTable["rounds"], hRoundStats )
	end

	GameRules:SetNextRuneSpawnTime( 999999999 )

	-- clean up all living enemies that were spawned out of band
	if self.vExtraSpawns ~= nil then
		for i, unit in pairs( self.vExtraSpawns ) do
			if unit and unit:IsNull() == false then
				UTIL_Remove( unit )
			end
		end
	end
	self.vExtraSpawns = {}

	for k,v in pairs( self.vecRoundTimerCues ) do
		self.vecRoundTimerCues[k] = true
	end

	self.m_nTeamScore[ nScoringTeam ] = self.m_nTeamScore[ nScoringTeam ] + 1
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local nPlayerTeam = PlayerResource:GetTeam( nPlayerID )
			if nPlayerTeam == FlipTeamNumber( nTeam ) then
				EmitSoundOnClient( "RoshanDT.Curse.Enemy", PlayerResource:GetPlayer( nPlayerID ) )
			end
		end
	end
	self:PlayTeamSound( "RoundEnd.Win", "RoundEnd.Lose", nScoringTeam )

	local bFinalRound = 0

	-- Should the game be over?
	local nDireScore = self.m_nTeamScore[ DOTA_TEAM_BADGUYS ]
	local nRadiantScore = self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ]
	if self:GetRoundNumber() >= _G.DIRETIDE_NUM_ROUNDS 
		or ( nDireScore >= math.ceil( _G.DIRETIDE_NUM_ROUNDS / 2 ) and not self.bPlayAllRounds )
		or ( nRadiantScore >= math.ceil( _G.DIRETIDE_NUM_ROUNDS / 2 ) and not self.bPlayAllRounds )
	then
		-- Pick a winner...
		self.nWinningTeam = (( nRadiantScore > nDireScore and DOTA_TEAM_GOODGUYS ) or DOTA_TEAM_BADGUYS )

		self.m_GameState = _G.DIRETIDE_GAMESTATE_DISPLAY_FINAL_ROUND_RESULTS
		self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
		self.m_flTimeRoundEnds =  self.m_flTimeRoundStarted + _G.DIRETIDE_DISPLAY_FINAL_ROUND_RESULTS_TIME
		
		bFinalRound = 1
	end

	-- Kick off an event to declare one team the winner of the round, client-side.
	FireGameEvent( "round_end", {
		scoring_team = nScoringTeam,
		radiant_candy = self:GetRadiantCandy(),
		dire_candy = self:GetDireCandy(),
		is_final_round = bFinalRound,
		round_number = self:GetRoundNumber(),
	 } )

	if bFinalRound == 1 then
		-- partial endround stuff
		self:ResetHeroCandy()
		self:CleanupDroppedItems()
		self:CleanupCandy()
		return
	end

	self:GetGlobalAnnouncer():OnRoundEnd()

	-- Advance to the next round...
	if self.m_nRoundNumber == nil or self.m_nRoundNumber == 0 then
		self.m_nRoundNumber = 1
	end
	if self.m_nRoundNumber + 1 <= self.m_nTotalRounds then
		self.m_nRoundNumber = self.m_nRoundNumber + 1
	end
	print( "Advancing to round number " .. self.m_nRoundNumber )
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		PlayerResource:SetCustomIntParam( nPlayerID, self.m_nRoundNumber )
	end
	
	-- Set interstitial state BEFORE doing all the refreshing.
	self.m_GameState = _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE

	-- Reset ward counts in shop
	for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		--GameRules:SetItemStockCount( 2, nTeamNumber, "item_ward_observer", -1 )
		GameRules:SetItemStockCount( 5, nTeamNumber, "item_ward_sentry", -1 )
	end

	-- Heal + respawn all players
	self:RefreshPlayers()
	self:FixupTeamXP()

	-- Kill all defenders
	self:KillBucketSoldiers()

	-- remove items on the ground
	self:CleanupDroppedItems()

	-- remove player units
	self:CleanupUnits()

	-- Respawn all buildings
	self:RespawnBuildings()

	-- Remove all temp trees except mango trees
	local vTempTrees = Entities:FindAllByClassname( "dota_temp_tree" )
	if vTempTrees ~= nil then
		for _, hTree in ipairs( vTempTrees ) do
			if IsMangoTree( hTree ) == false then
				UTIL_RemoveImmediate( hTree )
			end
		end
	end

	GridNav:RegrowAllTrees()

	self:CleanupCandy()

	for _, hItem in pairs( self.m_vecNeutralItemDrops ) do
		if hItem ~= nil and hItem:IsNull() == false then
			PlayerResource:AddNeutralItemToStash( hItem.nHeroPlayerID, hItem.nTeam, hItem:GetContainedItem() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_CUSTOMORIGIN, nil ) 
			ParticleManager:SetParticleControl( nFXIndex, 0, hItem:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "NeutralItem.TeleportToStash", hItem )

			UTIL_Remove( hItem )
		end
	end
	self.m_vecNeutralItemDrops = {} -- round start also does this but eh.

	self:ResetHeroCandy()

	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			-- Remove all temporary modifiers
			local hBuffs = Hero:FindAllModifiers()
			for _, hBuff in pairs( hBuffs ) do
				if hBuff ~= nil and hBuff:IsNull() == false then
					if hBuff:GetDuration() > 0 and hBuff:DestroyOnExpire() then
						--printf( "Destroying buff named %s", hBuff:GetName() )
						hBuff:Destroy()
					end
				end
			end

			-- Remove some modifiers that spawn their own units. We can't kill the units
			-- ourselves, so let's nuke the modifiers and let them clean up.
			Hero:RemoveModifierByName( "modifier_death_prophet_exorcism" )
			Hero:RemoveModifierByName( "modifier_wisp_spirits" )
			Hero:RemoveModifierByName( "modifier_beastmaster_wild_axes" )
			Hero:RemoveModifierByName( "modifier_life_stealer_infest" )
			Hero:RemoveModifierByName( "modifier_pudge_rot" )
			Hero:RemoveModifierByName( "modifier_kunkka_x_marks_the_spot_marker" )
			Hero:RemoveModifierByName( "modifier_kunkka_x_marks_the_spot" )

			Hero:AddNewModifier( Hero, nil, "modifier_hero_post_round", { duration = 2.0 } )

			--[[local hWardObs = Hero:FindItemInInventory( "item_ward_observer" )
			if hWardObs ~= nil then
				Hero:RemoveItem( hWardObs )
			end
			local hWardSentry = Hero:FindItemInInventory( "item_ward_sentry" )
			if hWardSentry ~= nil then
				Hero:RemoveItem( hWardSentry )
			end
			local hWardDisp = Hero:FindItemInInventory( "item_ward_dispenser" )
			if hWardDisp ~= nil then
				Hero:RemoveItem( hWardDisp )
			end--]]
		end
	end
	-- Also remove some thinkers
	local vecThinkers = Entities:FindAllByClassname( "npc_dota_thinker" )
	if vecThinkers ~= nil then
		for _, hThinker in ipairs( vecThinkers ) do
			if hThinker ~= nil and hThinker:IsNull() == false then
				local hBuff = hThinker:FindModifierByName( "modifier_kunkka_x_marks_the_spot_thinker" )
				if hBuff ~= nil and hBuff:IsNull() == false then
					hBuff:GetCaster():UnHideAbilityToSlot( "kunkka_x_marks_the_spot", "kunkka_return" )
					UTIL_Remove( hThinker )
				else
					hThinker:RemoveModifierByName( "modifier_dark_seer_wall_of_replica" ) -- will kill thinker since the modifier's OnDestroy does so.
				end
			end
		end
	end

	-- Just in case, kill any extra skellies
	local vecSkels = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
	for _, hSkel in ipairs( vecSkels ) do
		if hSkel ~= nil and hSkel:IsNull() == false and hSkel:IsAlive() and hSkel:GetUnitName() == "npc_dota_creature_skeleton" then
			hSkel:ForceKill( false )
		end
	end

	self:ResetCandy()
	self:ResetRoshan()
	
	-- Skip to interstitial (need logic to end)
	self.m_flTimeRoundStarted = GameRules:GetDOTATime( false, true )
	self.m_flTimeRoundEnds = self.m_flTimeRoundStarted + DIRETIDE_INTERSTITIAL_TIME
end

--------------------------------------------------------------------------------

function CDiretide:CleanupCandy()
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

function CDiretide:ResetHeroCandy()
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			local hCandy = Hero:FindAbilityByName( "hero_candy_bucket" )
			if hCandy then
				hCandy:SetCurrentAbilityCharges( 0 )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CDiretide:EndGame()
	GameRules:MakeTeamLose( FlipTeamNumber( self.nWinningTeam ) )
end

--------------------------------------------------------------------------------

function CDiretide:RespawnAllPlayers()
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

function CDiretide:GetWaveManagerForTeam( nTeam )
	return self._vWaveManagers[ nTeam ][ self:GetRoundNumber() ]
end

--------------------------------------------------------------------------------

function CDiretide:DropCandyAtPosition( vDropTarget, hVictim, hKiller, bIsBigBag, flRandomOffsetScale )
	if self:IsRoundInProgress() == false then
		return
	end
	local szItemName = ( bIsBigBag and "item_candy_bag" ) or "item_candy"
	local newItem = CreateItem( szItemName, nil, nil )
	newItem:SetPurchaseTime( 0 )
	newItem:SetCurrentCharges( ( bIsBigBag and _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG ) or 1 )

	local flScale = flRandomOffsetScale
	if hVictim ~= nil then
		flScale = hVictim:GetModelScale()
	end

	local vOrigin = vDropTarget
	if _G.DIRETIDE_CANDY_MAX_LAUNCH_DISTANCE > 0 and hKiller ~= nil and hKiller:IsNull() == false and hKiller:IsHero() then
		vDropTarget = hKiller:GetAbsOrigin() + RandomVector( RandomFloat( 20, 50 ) * flRandomOffsetScale )
		local vToDropTarget = vDropTarget - vOrigin
		local flLength = vToDropTarget:Length()
		if flLength > _G.DIRETIDE_CANDY_MAX_LAUNCH_DISTANCE then
			vDropTarget = vOrigin + ( vToDropTarget:Normalized() * _G.DIRETIDE_CANDY_MAX_LAUNCH_DISTANCE )
		end
	else
		if flRandomOffsetScale > 0 then
			vDropTarget = vDropTarget + RandomVector( RandomFloat( 100, 275 ) * flScale )
		end
	end

	local drop = CreateItemOnPositionSync( vOrigin, newItem )
	if bIsBigBag == true then
		drop:SetModelScale( 2 )
	end
	newItem:LaunchLoot( true, math.max( 15, math.min( flRandomOffsetScale, 1.0 ) * RandomFloat( 75, 225 ) ), math.max( 0.1, math.sqrt( math.max( 0.3, math.min( flRandomOffsetScale, 1.0 ) ) ) * RandomFloat( 0.5, 1.25 ) ), vDropTarget )

	local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/hw_candy_drop.vpcf", PATTACH_ABSORIGIN_FOLLOW, ( hVictim ~= nil and hVictim ) or drop )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, drop, PATTACH_ABSORIGIN_FOLLOW, nil, drop:GetAbsOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return newItem
end

--------------------------------------------------------------------------------

function CDiretide:ScoreCandy( nTeamNumber, hScorer, nNumCandy )
	local nTotalCandy = self:GetTeamCandy( nTeamNumber ) + nNumCandy
	self:SetTeamCandy( nTeamNumber, nTotalCandy )

	if hScorer ~= nil and hScorer:IsNull() == false and hScorer:IsRealHero() then
		EmitSoundOnClient( "Candy.Score", hScorer:GetPlayerOwner() )

		local nPlayerID = hScorer:GetPlayerOwnerID()
		--print( '{STATS} candy_scored - Adding ' .. nNumCandy .. ' to PlayerID ' .. nPlayerID )
		GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_scored"] =  GameRules.Diretide.EventMetaData[ nPlayerID ]["candy_scored"] + nNumCandy

		self.m_vecCandyScores[nTeamNumber] = self.m_vecCandyScores[nTeamNumber] + nNumCandy
		if self.m_vecCandyScores[nTeamNumber] >= _G.DIRETIDE_NUM_CANDY_SCORED_TO_TRIGGER_ANNOUNCER then
			self.m_vecCandyScores[nTeamNumber] = 0
			--Changing these to play when lead changes; we have no VO for this anymore.
			--[[self:GetTeamAnnouncer( nTeamNumber ):OnCandyScoreAlly()
			self:GetTeamAnnouncer( FlipTeamNumber( nTeamNumber ) ):OnCandyScoreEnemy()--]]
		end
	end

	if nTotalCandy >= _G.DIRETIDE_CANDY_ROSHAN_TRICK_OR_TREAT_START_COUNT and self.bRoshanActive ~= true then
		self:TrickOrTreatToTeam( FlipTeamNumber( nTeamNumber ), true )
	end

	self:UpdateLead()
end

--------------------------------------------------------------------------------

function CDiretide:LoseCandy( nTeamNumber, nNumCandy )
	local nCandy = self:GetTeamCandy( nTeamNumber )
	nCandy = math.max( 0, nCandy - nNumCandy )
	self:SetTeamCandy( nTeamNumber, nCandy )
	if nCandy == 0 and _G.DIRETIDE_LOSE_ALL_CANDY_ENDS_ROUND == true then
		self:EndRound( FlipTeamNumber( nTeamNumber ) )
		return
	end
	self:UpdateLead()
	local gameEvent = {}
	gameEvent["teamnumber"] = nTeamNumber
	gameEvent["candy_lost"] = nNumCandy
	FireGameEvent( "diretide_team_lost_candy", gameEvent )
end

--------------------------------------------------------------------------------

function CDiretide:UpdateLead()
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
	if bLeadChange == true then
		self:PlayTeamSound( "CandyCount.Winning.Stinger", "CandyCount.Losing.Stinger", self.m_nPreviousLead )
		self:GetTeamAnnouncer( self.m_nPreviousLead ):OnCandyScoreAlly()
		self:GetTeamAnnouncer( FlipTeamNumber( self.m_nPreviousLead ) ):OnCandyScoreEnemy()
	end
end

--------------------------------------------------------------------------------

function CDiretide:GetCandyBuckets( nTeamNumber )
	if nTeamNumber == DOTA_TEAM_GOODGUYS then
		return Entities:FindAllByName( "radiant_candy_bucket" )
	end

	return Entities:FindAllByName( "dire_candy_bucket" )
end

--------------------------------------------------------------------------------

function CDiretide:CleanupUnits()
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

function CDiretide:CleanupDroppedItems()
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

function CDiretide:ResetCandy()
	for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local key = string.format("%d", nTeamNumber )
		local t = CustomNetTables:GetTableValue("candy_collected", key) 
		if t == nil then
			t = { total_candy =  0 }
		end
		t['total_candy'] = _G.DIRETIDE_STARTING_CANDY
		CustomNetTables:SetTableValue( "candy_collected", key, t  )
	end
end

--------------------------------------------------------------------------------

function CDiretide:ResetRoshan()
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
	self.hRoshan.nTrickOrTreatCounter = {}
	self.hRoshan.nTrickOrTreatCounter[DOTA_TEAM_GOODGUYS] = -1
	self.hRoshan.nTrickOrTreatCounter[DOTA_TEAM_BADGUYS] = -1
	self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_NONE
	self.hRoshan.vecCurseTimes = {}
	FindClearSpaceForUnit( self.hRoshan, self.hRoshanSpawner:GetAbsOrigin(), true )

	local hBuff = self.hRoshan:FindModifierByName( "modifier_diretide_roshan_passive" )
	if hBuff ~= nil then
		hBuff:ResetHero()
		hBuff:Reset()
	end

	self.hRoshan.vecLastTargets = {}

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

function CDiretide:ReleaseRoshanForTeam( nWinningTeam )
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

function CDiretide:KillRoshanChaseSound()
	-- JUST IN CASE let's kill the soundloop on all players.
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer ~= nil then
			StopSoundEvent( "RoshanTarget.Loop", hPlayer )
		end
	end
end

--------------------------------------------------------------------------------

function CDiretide:TrickOrTreatToTeam( nTeam, bIncrementCounter )
	self.hRoshan.nTrickOrTreatTeam = 0 -- we'll set this later, if we succeed

	-- JUST IN CASE let's kill the soundloop on all players.
	self:KillRoshanChaseSound()

	-- catch running this during round ending
	if self:IsRoundInProgress() == false then
		print("Roshan trick or treating aborted, round not in progress")
		return
	end
	local bResetOverrideCounter = true
	if bIncrementCounter and _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM == true then
		--print("+++++++++++++ Finding random team for Roshan to attack")
		local vecCandy = {}
		vecCandy[DOTA_TEAM_GOODGUYS] = self:GetTeamCandy( DOTA_TEAM_GOODGUYS )
		vecCandy[DOTA_TEAM_BADGUYS] = self:GetTeamCandy( DOTA_TEAM_BADGUYS )

		--[[for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil and hHero:IsNull() == false then
					vecCandy[hHero:GetTeamNumber()] = vecCandy[hHero:GetTeamNumber()] + PlayerResource:GetKills( nPlayerID )
				end
			end
		end--]]
		if nTeam ~= 0 then
			vecCandy[nTeam] = vecCandy[nTeam] + self.m_nRoshanOverrides * _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_EXTRA_PER_OVERRIDE
		end

		local nMax = 0 math.max( vecCandy[DOTA_TEAM_GOODGUYS], vecCandy[DOTA_TEAM_BADGUYS] )
		local nMin = 0 math.min( vecCandy[DOTA_TEAM_GOODGUYS], vecCandy[DOTA_TEAM_BADGUYS] )
		local nBiggerTeam = 0 
		if vecCandy[DOTA_TEAM_GOODGUYS] > vecCandy[DOTA_TEAM_BADGUYS] then
			nMax = vecCandy[DOTA_TEAM_GOODGUYS]
			nMin = vecCandy[DOTA_TEAM_BADGUYS]
			nBiggerTeam = DOTA_TEAM_GOODGUYS
			print( "+++++ Roshan Blueshell logic: RADIANT has more, " .. nMax .. ", vs " .. nMin .. " ( counter = " .. self.m_nRoshanOverrides .. ")" )
		else
			nMax = vecCandy[DOTA_TEAM_BADGUYS]
			nMin = vecCandy[DOTA_TEAM_GOODGUYS]
			nBiggerTeam = DOTA_TEAM_BADGUYS
			print( "+++++ Roshan Blueshell logic: DIRE has more, " .. nMax .. ", vs " .. nMin .. " ( counter = " .. self.m_nRoshanOverrides .. ")" )
		end

		if nBiggerTeam ~= nTeam and nMax >= _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_THRESHOLD_CANDY_FOR_OVERRIDE
			and (nMax - nMin) >= _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_THRESHOLD_CANDY_DIFF_FOR_OVERRIDE
			and ( nMin == 0 or nMax / nMin >= _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_THRESHOLD_RATIO_FOR_OVERRIDE ) then

			local nPctChanceFromRatio = math.ceil( ( nMax + _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_BASE ) / ( nMax + nMin + _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_BASE * 2 ) * _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_RATIO_MULT )
			local nPctChanceFromDiff = ( nMax - nMin ) * _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_DIFF_MULT
			local nTest = math.min( 90, math.max( nPctChanceFromRatio, nPctChanceFromDiff ) )
			local nSelector = RandomInt( 1, 100 )
			print( "&&&& Testing override, chance from ratio " .. nPctChanceFromRatio .. ", from diff " .. nPctChanceFromDiff .. ". So testing " .. nSelector .. " vs " .. nTest )
			--if RandomInt( 1, nMax + nMin + _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_BASE * 2 ) <= nMax + _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_TEAM_BASE then
			if nSelector <= nTest then
				nTeam = nBiggerTeam
				self.m_nRoshanOverrides = self.m_nRoshanOverrides + 1
				print( "%%%%%%%%%%% Overriding team selection, total overrides now " .. self.m_nRoshanOverrides )
				bResetOverrideCounter = false
			end
		end
	end
	if nTeam == 0 then
		local nDire = self:GetTeamTotalCandy( DOTA_TEAM_BADGUYS )
		local nRadiant = self:GetTeamTotalCandy( DOTA_TEAM_GOODGUYS )
		if nDire > nRadiant then
			nTeam = DOTA_TEAM_BADGUYS
		elseif nRadiant > nDire then
			nTeam = DOTA_TEAM_GOODGUYS
		else
			nTeam = RandomInt( DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS )
		end
	end
	if bResetOverrideCounter then
		self.m_nRoshanOverrides = 0
	end

	-- if it's PVE, send against yourself.
	if DoPlayersExistOnTeam( nTeam ) == false then
		nTeam = FlipTeamNumber( nTeam )
	end

	local hHeroes = FindUnitsInRadius( nTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for i=#hHeroes,1,-1 do
		local hHero = hHeroes[ i ]
		if hHero and ( hHero:IsNull() == true or hHero:IsRealHero() == false ) then
			table.remove( hHeroes, i )
		end
	end

	self.hRoshan.bNeedsReset = true
	if #hHeroes == 0 then
		self.nQueueRoshanForTeam = nTeam
		self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN
		return
	end

	self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_REQUEST

	if _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_PLAYER == true then
		local nCandyCounts = {}
		local nTotalCandy = 0
		local bFound = false
		for i=1,#hHeroes do
			local hHero = hHeroes[ i ]
			local nCandy = 0
			local bValid = hHero:IsOutOfGame() == false and ( self.hRoshan.vecLastTargets[hHero] == nil or self.hRoshan.vecLastTargets[hHero] <= GameRules:GetDOTATime( false, true ) )
			if bValid == true then
				nCandy = hHero:GetCandyCount()
				if nCandy > 0 or _G.DIRETIDE_ROSHAN_ALLOW_NO_CANDY == true then
					bFound = true
				end
				nCandy = nCandy + _G.DIRETIDE_ROSHAN_WEIGHTED_RANDOM_PLAYER_BASE
			else
				if hHero:IsOutOfGame() then
					--print( "$$xx Hero " .. hHero:GetUnitName() .. " is out of game" )
				else
					--print("$$$$ Hero " .. hHero:GetUnitName() .. " is immune to Roshan for another " .. ( self.hRoshan.vecLastTargets[hHero] - GameRules:GetDOTATime( false, true ) ) .. "s" )
				end
			end
			nCandyCounts[i] = nCandy
			nTotalCandy = nTotalCandy + nCandy
		end
		if bFound == false then
			if bIncrementCounter == true then
				self.nQueueRoshanForTeam = nTeam
			else
				self.nQueueRoshanForTeam = -nTeam
			end
			self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN
			return
		end
		local nDesired = RandomInt( 0, nTotalCandy - 1 )
		--print("------------ Finding random hero on team. Total = " .. nTotalCandy .. " and selector " .. nDesired )
		local nCurrent = 0
		for i=1,#hHeroes do
			nCurrent = nCurrent + nCandyCounts[i]
			if nCurrent > nDesired then
				--print("Selecting hero " .. i .. ", " .. hHeroes[i]:GetUnitName() .. "(" .. nCandyCounts[i] .. " candy)" )
				self.hRoshan.hTrickOrTreatTarget = hHeroes[i]
				break
			end
		end
	else
		local vBestHeros = {}
		local nBestCandy = 0
		for i=#hHeroes,1,-1 do
			local hHero = hHeroes[ i ]
			local bValid = ( self.hRoshan.vecLastTargets[hHero] == nil or self.hRoshan.vecLastTargets[hHero] <= GameRules:GetDOTATime( false, true ) )
			if bValid == true then
				local nCandy = hHero:GetCandyCount()
				if nCandy > nBestCandy then
					vBestHeros = {}
					nBestCandy = nCandy
				end
				-- fall through
				if nCandy >= nBestCandy then
					table.insert( vBestHeros, hHero )
				end
			end
		end
		if nBestCandy == 0 and _G.DIRETIDE_ROSHAN_ALLOW_NO_CANDY == false then
			if bIncrementCounter == true then
				self.nQueueRoshanForTeam = nTeam
			else
				self.nQueueRoshanForTeam = -nTeam
			end
			self.hRoshan.nTreatMode = ROSHAN_TRICK_OR_TREAT_MODE_RETURN
			self.hRoshan.bNeedsReset = true
			return
		end
		self.hRoshan.hTrickOrTreatTarget = vBestHeros[ RandomInt( 1, #vBestHeros ) ]
	end
	self.hRoshan.vecLastTargets[self.hRoshan.hTrickOrTreatTarget] = GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_ROSHAN_HERO_TARGET_IMMUNITY_TIME -- we'll reset that when Roshan is fed / kills this hero.
	self.hRoshan.nTrickOrTreatTeam = nTeam
	if bIncrementCounter then
		self.hRoshan.nTrickOrTreatCounter[nTeam] = self.hRoshan.nTrickOrTreatCounter[nTeam] + 1
	end
	
	print( "Roshan is trick or treating to " .. self.hRoshan.hTrickOrTreatTarget:GetUnitName() )

	self.hRoshan.hTrickOrTreatTarget:AddNewModifier( nil, nil, "modifier_provide_roshan_vision", {} )
	self.hRoshan.hTrickOrTreatTarget:AddNewModifier( self.hRoshan, nil, "modifier_truesight", {} )

	local hPlayer = self.hRoshan.hTrickOrTreatTarget:GetPlayerOwner()
	if hPlayer then
		EmitSoundOnClient( "RoshanTarget.Loop", hPlayer )
	end

	if self.bRoshanActive ~= true then
		self.bRoshanActive = true
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
		EmitGlobalSound( "RoshanDT.Scream" )
	end

	local gameEvent = {}
	gameEvent["player_id"] = self.hRoshan.hTrickOrTreatTarget:GetPlayerOwnerID()
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#DOTA_HUD_RoshanTrickOrTreat_Target_Toast"
	FireGameEvent( "dota_combat_event_message", gameEvent )
	self:GetTeamAnnouncer( self.hRoshan.hTrickOrTreatTarget:GetTeamNumber() ):OnRoshanTarget( self.hRoshan.hTrickOrTreatTarget )

	FireGameEvent( "roshan_target_switch", {
		team = self.hRoshan.hTrickOrTreatTarget:GetTeamNumber(),
		ent_index = self.hRoshan.hTrickOrTreatTarget:entindex(),
		force_you = 0,
	} )
end

--------------------------------------------------------------------------------

function CDiretide:AddExtraSpawnedUnit( hUnit )
	if hUnit == nil or hUnit:IsNull() == true then
		error( "INVALID UNIT ADDED TO EXTRA SPAWNS" )
		return
	end

	if self.vExtraSpawns == nil then
		self.vExtraSpawns = {}
	end

	table.insert( self.vExtraSpawns, hUnit )
end

--------------------------------------------------------------------------------

-- plays a sound on all clients. Spectators get Radiant sound
function CDiretide:PlayTeamSound( szSoundA, szSoundB, nTeamA )
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

function CDiretide:Dev_PlayEndGameCinematic( szLosingTeam )
	local nLosingTeam = _G[ szLosingTeam ]
	if nLosingTeam == nil then
		nLosingTeam = DOTA_TEAM_GOODGUYS
	end
	self.nWinningTeam = FlipTeamNumber( nLosingTeam )
	self:PlayEndGameCinematic( nLosingTeam )

	self.m_flTimeRoundEnds = GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_ENDING_CINEMATIC_TIME
	self.m_GameState = _G.DIRETIDE_GAMESTATE_ENDING_CINEMATIC
end

--------------------------------------------------------------------------------

function CDiretide:PlayEndGameCinematic( nLosingTeam )
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

	local vecPos = nil
	if nLosingTeam == DOTA_TEAM_GOODGUYS then
		vecPos = self.vRadiantHomeBucketLocs[ 1 ]
	else
		vecPos = self.vDireHomeBucketLocs[ 1 ]
	end

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

function CDiretide:SpawnSky()
	print("Spawning sky")
	local skyDomeTable = 
	{
		origin = "0 0 -48",
		angles = "0 296 0",
		targetname = "sky_dome",
		model = "models/diretide_intro_sky_dome.vmdl",
		scales = "250 250 250",
		defaultanim = "hold",
		holdanimation = "1",
		rendercolor = "255 255 255 255",
		glowcolor = "0 0 0 255",
		skin = "8",
		bodygroups = "{uv_set = 1}"
	}
	local hSkyDome = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeTable )
	hSkyDome:SetEntityName("sky_dome")

	local skyDomeCloudsTable = 
	{
		origin = "0 0 -500",
		angles = "0 267 0",
		targetname = "sky_dome_dynamic_clouds",
		model = "models/diretide_intro_sky_dome.vmdl",
		scales = "240 240 240",
		defaultanim = "hold",
		holdanimation = "1",
		glowcolor = "0 0 0 255",
		rendercolor = "200 200 200 255",
		skin = "8_alpha",
		bodygroups = "{uv_set = 1}"
	}
	local hSkyDomeClouds = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeCloudsTable )
	hSkyDomeClouds:SetEntityName("sky_dome_dynamic_clouds")

	local skyDomeMoonTable = 
	{
		origin = "0 0 -48",
		angles = "-8 246 4",
		targetname = "sky_dome_moon",
		model = "models/diretide_intro_sky_dome_expand.vmdl",
		scales = "245 245 245",
		defaultanim = "diretide_intro_sky_expand_anim",
		holdanimation = "1",
		glowcolor = "0 0 0 255",
		rendercolor = "255 255 255 255",
		skin = "8",
		bodygroups = "{uv_set = 1}"
	}
	local hSkyDomeMoon = SpawnEntityFromTableSynchronous( "prop_dynamic", skyDomeMoonTable )
	hSkyDomeMoon:SetEntityName("sky_dome_moon")
	
end


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