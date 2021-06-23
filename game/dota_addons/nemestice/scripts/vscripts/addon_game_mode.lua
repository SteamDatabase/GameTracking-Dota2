print( "addon_game_mode.lua loaded." )

if CNemestice == nil then
	CNemestice = class({})
	_G.CNemestice = CNemestice
end

--------------------------------------------------------------------------------

require( "nemestice_utility_functions" )
require( "nemestice_constants" )
require( "nemestice_events" )
require( "nemestice_game_configuration" )
require( "nemestice_precache" )
require( "nemestice_think" )
require( "nemestice_triggers" )

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
	for _,Model in pairs( _G.NEMESTICE_METEOR_SHARD_MODELS ) do
		PrecacheResource( "model", Model, context )
	end

	for _,Particle in pairs( g_ParticlePrecache ) do
		PrecacheResource( "particle", Particle, context )
	end

	for _,Sound in pairs( g_SoundPrecache ) do
		PrecacheResource( "soundfile", Sound, context )
	end
end

--------------------------------------------------------------------------------

-- Create the game mode when we activate
function Activate()
	print( "###### Nemestice game activated!" )
	GameRules.Nemestice = CNemestice()
	GameRules.Nemestice:InitGameMode()
end

--------------------------------------------------------------------------------
function CNemestice:InitGameMode()
	self._bDevMode = false
	self._bDevNoRounds = false

	self.EventMetaData = {}
	self.EventMetaData["event_name"] = "nemestice"
	self.SignOutTable = {}
	self.SignOutTable[ "player_list" ] = {}

	self.m_hEventGameDetails = GetLobbyEventGameDetails()

	self.m_BPGrants = {}
	for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		self.m_BPGrants[ nTeamNumber ] = {}
		self.m_BPGrants[ nTeamNumber ][ "first_tower" ] = 0
		self.m_BPGrants[ nTeamNumber ][ "meteor_stun" ] = 0
		self.m_BPGrants[ nTeamNumber ][ "shrine_teamfight" ] = 0
		self.m_BPGrants[ nTeamNumber ][ "neutral_steal" ] = 0
		self.m_BPGrants[ nTeamNumber ][ "full_channel" ] = 0
	end

	self.m_nRoundNumber = 0
	self.m_nLastRoundNumber = 1
	self.m_nLastRoundStartSound = 0
	self.m_nLastRoundStartShown = 0
	self.m_nTotalNumOvertimes = 0
	self.m_nTeamScore = {}
	self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] = 0
	self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] = 0

	self.bFirstTowerKilled = false

	self.m_bMapStateUpdated = false

	self.hBigMeteor = nil

	self.m_flPlayedTime = 0

	self.flEndMeteorScreenTime = 9999999
	self.nFXMeteorScreenParticleIndices = {}
	
	self.m_flNextSmallMeteorCrashTime = 0
	self.m_flNextMediumMeteorCrashTime = 0
	self.m_flNextLargeMeteorCrashTime = 0
	self.m_nLargeMeteorState = NEMESTICE_METEOR_STATE_WAITING
	
	self.m_vecMeteorDropLocations = {}
	for _,hTarget in pairs( Entities:FindAllByClassname( "info_target" ) ) do
		if string.starts( hTarget:GetName(), "meteor_drop_" ) then
			local vLoc = hTarget:GetAbsOrigin()
			table.insert( self.m_vecMeteorDropLocations, {
				x = vLoc.x,
				y = vLoc.y,
				name = hTarget:GetName(),
				fairness = 99999,
			} )
		end
	end

	self.hRadiantFountain = Entities:FindByName( nil, "radiant_fountain" )
	self.hDireFountain = Entities:FindByName( nil, "dire_fountain" )

	self.nActiveLanes = {}
	self.flRewardTickXP = 0
	self.flRewardTickGold = 0
	self.m_nNumHeroesPerTeam = 0

	self.m_vecTowerHealthHistory = {}
	self.m_vecAllTowersPercentHealthHistory = {}
	self.m_vecTowerOwnershipHistory = {}
	
	self.m_vecGlyphHistory = {}
	self.m_vecGlyphHistory[ tostring( DOTA_TEAM_BADGUYS ) ] = {}
	self.m_vecGlyphHistory[ tostring( DOTA_TEAM_GOODGUYS ) ] = {}
	
	self.m_vecShrineHistory = {}
	self.m_vecShrineHistory[ tostring( DOTA_TEAM_BADGUYS ) ] = {}
	self.m_vecShrineHistory[ tostring( DOTA_TEAM_GOODGUYS ) ] = {}

	self.m_tGlyphsUsed = {}
	self.m_tGlyphsUsed[DOTA_TEAM_GOODGUYS] = 0
	self.m_tGlyphsUsed[DOTA_TEAM_BADGUYS] = 0

	self.m_tShrinesUsed = {}
	self.m_tShrinesUsed[DOTA_TEAM_GOODGUYS] = 0
	self.m_tShrinesUsed[DOTA_TEAM_BADGUYS] = 0
	
	self.m_vecTowerUpgradeHistory = {}
	self.m_vecTowerCreepDamageHistory = {}
	self.m_vecTowerCreepDamageAccumulator = {}
	
	self:SetupGameConfiguration()
	self:RegisterGameEvents()
	self:RegisterConCommands()

	local nemesticeConstants = {}
	for k,v in pairs( _G ) do
		if k:find( '^NEMESTICE_' ) then
			nemesticeConstants[k] = v
		end
	end
	CustomNetTables:SetTableValue( "globals", "constants", nemesticeConstants )

	self.m_GameState = NEMESTICE_GAMESTATE_PREGAME
	self.m_flTimePhaseStarted = 0
	self.m_flTimePhaseEnds = 0
	self.m_flNextTowerHealthTickTime = -1

	SetTeamCustomHealthbarColor( DOTA_TEAM_CUSTOM_1, 204, 204, 71 )

	self.SpawnedBreakables = {}
	self.tCreepSpawners = {}
	self.m_flNextSpawnTime = -1
	self.m_nWave = -1
	self.tMeteorStats = {} -- Nested structure [round][player][reason] = number

	self.m_tDummyCasters = {}
	
	self:InitializeTowers()

	local hNeutralStashes = Entities:FindAllByClassname( "ent_dota_neutral_item_stash" )
	for _,hStash in pairs ( hNeutralStashes ) do
		if hStash then
			hStash:AddNewModifier( hStash, nil, "modifier_not_on_minimap", {} )
		end
	end

	self.m_tExludePositions = {}
	--[[for _,vPos in ipairs( self.vLabeledLocations ) do
		table.insert( self.m_tExludePositions, vPos )
	end--]]
	table.insert( self.m_tExludePositions, self.hRadiantFountain:GetAbsOrigin() )
	table.insert( self.m_tExludePositions, self.hDireFountain:GetAbsOrigin() )
	for _,tSpawner in pairs(self.tCreepSpawners) do
		table.insert( self.m_tExludePositions, tSpawner.building:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------------------
function CNemestice:GetPlayedTime()
	local flTime = self.m_flPlayedTime
	if self:IsGameInProgress() then
		flTime = flTime + GameRules:GetDOTATime( false, true ) - self.m_flTimePhaseStarted
	end
	return flTime
end

--------------------------------------------------------------------------------
function CNemestice:SpawnMangoTrees()
	local vSpawnPos = {}

	vSpawnPos[ DOTA_TEAM_GOODGUYS ] = Vector( -504.022797, -4974.22803, 640.0 )
	vSpawnPos[ DOTA_TEAM_BADGUYS ] = Vector( 524.267151, 4711.02148, 640.0 )

	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local hCaster = CreateUnitByName( "npc_dota_dummy_caster", vSpawnPos[nTeam], false, nil, nil, nTeam )
		if hCaster ~= nil then
			local hItem = hCaster:AddItemByName( "item_mango_tree" )
			if hItem ~= nil then
				--printf( "Casting Mango tree on position %f, %f, %f", vSpawnPos[nTeam].x, vSpawnPos[nTeam].y, vSpawnPos[nTeam].z )
				hCaster:CastAbilityOnPosition( vSpawnPos[nTeam], hItem, -1 )
			end
		end
		UTIL_Remove( hCaster )
	end
end

--------------------------------------------------------------------------------
function CNemestice:IsGameInProgress()
	return self.m_GameState == _G.NEMESTICE_GAMESTATE_IN_PROGRESS or self.m_GameState == _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH
end

--------------------------------------------------------------------------------
function CNemestice:IsPrepOrInProgress()
	return self.m_GameState == _G.NEMESTICE_GAMESTATE_IN_PROGRESS or self.m_GameState == _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH or self.m_GameState == _G.NEMESTICE_GAMESTATE_PREP_TIME
end

--------------------------------------------------------------------------------
function CNemestice:GrantGoldAndXP( hHero, nGoldToGrant, nXPToGrant, szReason )
	if hHero == nil or hHero:IsNull() == true then
		return
	end
	if hHero:IsRealHero() == false then
		hHero = PlayerResource:GetSelectedHeroEntity( hHero:GetPlayerOwnerID() )
	end
	if nXPToGrant > 0 then
		self.bLetXPThrough = true
		if hHero:IsAlive() == false then
			nXPToGrant = math.ceil( nXPToGrant * NEMESTICE_REWARD_XP_MULT_DEAD )
		end
		hHero:AddExperience( nXPToGrant, DOTA_ModifyXP_CreepKill, false, true )	
		self.bLetXPThrough = nil
	end
	if nGoldToGrant > 0 then
		self.bLetGoldThrough = true
		--printf( " *** Grant %d gold to %s", nGoldToGrant, hHero:GetUnitName() )
		if hHero:IsAlive() == false then
			nGoldToGrant = math.ceil( nGoldToGrant * NEMESTICE_REWARD_GOLD_MULT_DEAD )
		end
		hHero:ModifyGold( nGoldToGrant, true, DOTA_ModifyGold_Unspecified )
		self.bLetGoldThrough = nil
		
		self:UpdateResourceStats( "tGoldStats", hHero:GetPlayerOwnerID(), nGoldToGrant, szReason )
	end
end

--------------------------------------------------------------------------------
function CNemestice:GrantGoldAndXPToTeam( nTeamNumber, nGold, nXP, szReason )
	if nTeamNumber ~= DOTA_TEAM_GOODGUYS and nTeamNumber ~= DOTA_TEAM_BADGUYS then
		return
	end

	local playersToChange = {}
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
			table.insert( playersToChange, nPlayerID )
		end
	end

	for _,nPlayerID in pairs( playersToChange ) do
		hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero ~= nil then
			self:GrantGoldAndXP( hHero, nGold, nXP, szReason )
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:RecordTeamTowerUpgradesHistory( nTime )
	local tUpgradesByTeam = {}
	tUpgradesByTeam[ DOTA_TEAM_GOODGUYS] = self:GetCurrentUpgradesForTeam( DOTA_TEAM_GOODGUYS )
	tUpgradesByTeam[ DOTA_TEAM_BADGUYS ] = self:GetCurrentUpgradesForTeam( DOTA_TEAM_BADGUYS )
	self.m_vecTowerUpgradeHistory[ nTime ] = tUpgradesByTeam
end

--------------------------------------------------------------------------------
function CNemestice:RecordTowerOwnership( sTowerKey, sAttackerName, nTeam, nUpgradesDestroyed, flTime )
	if flTime ~= nil then
		local nTime = math.ceil( flTime )

		-- tower ownership history
		local tTowerInfo = self.m_vecTowerOwnershipHistory[ sTowerKey ]
		if tTowerInfo == nil then
			tTowerInfo = {}
		end
		local position = tTowerInfo[ "position" ]
		if position == nil then
			local nTowerKey = tonumber( sTowerKey )
			local hTowers = Entities:FindAllByClassname( "npc_dota_tower" )
			if hTowers ~= nil and hTowers[ nTowerKey ] ~= nil then
				tTowerInfo[ "position" ] = hTowers[ nTowerKey ]:GetAbsOrigin()
			end
		end
		local tTowerHistory = tTowerInfo[ "ownership" ]
		if tTowerHistory == nil then
			tTowerHistory = {}
		end
		local tTowerOwnerChange = {}
		tTowerOwnerChange[ "sDestroyerName" ] = sAttackerName
		tTowerOwnerChange[ "nTeam" ] = nTeam
		tTowerOwnerChange[ "nUpgradesDestroyed" ] = nUpgradesDestroyed
		tTowerHistory[ nTime ] = tTowerOwnerChange
		tTowerInfo[ "ownership" ] = tTowerHistory
		self.m_vecTowerOwnershipHistory[ sTowerKey ] = tTowerInfo

		self:RecordTeamTowerUpgradesHistory( nTime )
	end
end

--------------------------------------------------------------------------------
function CNemestice:InitializeTowers()
	local hTowers =  Entities:FindAllByClassname( "npc_dota_tower" )

	print(hTowers)

	for nIndex,hTower in pairs( hTowers ) do
		hTower.bIsTower = true
		hTower.sKeyName = tostring(nIndex)
		hTower.nTowerLevel = 0
		hTower.nTowerAllyLevel = 0
		
		if self:IsGameInProgress() then
			hTower:RemoveModifierByName( "modifier_invulnerable" )
		end
		
		self:BuffTower( hTower )

	--	print ( "tower name: " .. hTower:GetName() )

		local tCreepSpawnerInfo = {}
		local nTeam = _G.NEMESTICE_TOWER_TEAMS[ hTower:GetName() ] or DOTA_TEAM_CUSTOM_1
		local szName = hTower:GetName()
		tCreepSpawnerInfo[ "sTowerKeyName" ] = hTower.sKeyName
		tCreepSpawnerInfo[ "name" ] = szName
		tCreepSpawnerInfo[ "building" ] = hTower
		tCreepSpawnerInfo[ "position" ] = hTower:GetAbsOrigin()
		tCreepSpawnerInfo[ "starting_team" ] = nTeam
		self:RecordTowerOwnership( hTower.sKeyName, "", nTeam, 0, 0 )
		local hTargets = {}
		for i = 1,10 do
			local hTarget = Entities:FindByName( nil, szName .. "_upgrade_" .. i )
			if hTarget ~= nil and hTarget:IsNull() == false then
				table.insert( hTargets, hTarget )
			end
		end
		tCreepSpawnerInfo[ "buildingPositions" ] = hTargets
		tCreepSpawnerInfo[ "shrinePosition" ] = Entities:FindByName( nil, szName .. "_upgrade_shrine" )
		tCreepSpawnerInfo[ "mortarPosition" ] = Entities:FindByName( nil, szName .. "_upgrade_mortar" )
		hTower.freeBuildingPositions = deepcopy( hTargets )
		hTower.shrinePosition = tCreepSpawnerInfo[ "shrinePosition" ]
		hTower.mortarPosition = tCreepSpawnerInfo[ "mortarPosition" ]

		-- add dummy building
		tCreepSpawnerInfo.dummyBuilding = CreateUnitByName( "npc_dota_dummy_caster", hTower:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_CUSTOM_1 )

		self.tCreepSpawners[ szName ] = tCreepSpawnerInfo
	end

	self.m_tTowerGraph = deepcopy( _G.NEMESTICE_TOWER_LANES )

	self.m_bMapStateUpdated = true
end

--------------------------------------------------------------------------------
function CNemestice:TowerDestroyed( hOldTower, hAttacker, nNewTeam )
	local sAttackerName = ""
	if ( hAttacker ~= nil ) then
		sAttackerName = hAttacker:GetName()
	end
	printf( " ++++ Tower destroyed by %s!", sAttackerName )
	
	if hAttacker:IsOwnedByAnyPlayer() then
		local nAttackerPlayerID = hAttacker:GetPlayerOwnerID()
		self.SignOutTable[ "player_list" ][ nAttackerPlayerID ][ "tower_kills" ] = self.SignOutTable[ "player_list" ][ nAttackerPlayerID ][ "tower_kills" ] + 1
	end

	if self.bFirstTowerKilled == false then
		self.bFirstTowerKilled = true
		self:GrantTeamBattlePoints( nNewTeam, BATTLE_POINT_DROP_FIRST_TOWER, "first_tower" )
		self.m_nfirstTowerFallTime = math.floor( self:GetPlayedTime() )
	end

	local nLosingTeam = FlipTeamNumber( nNewTeam )
	local nTowersRemaining = self:GetTowersControlledBy( nLosingTeam, false )

	if nTowersRemaining > 0 then
		--print( '^^^FIRING GAME EVENT = tower_destroyed for TEAM ' .. nLosingTeam  )
		FireGameEvent( "tower_destroyed", { team_id = nLosingTeam, towers_remaining = nTowersRemaining, } )

		if nLosingTeam == DOTA_TEAM_GOODGUYS then
			EmitGlobalSound( "MegaCreeps.Radiant" )
		else
			EmitGlobalSound( "MegaCreeps.Dire" )
		end
	end

	for sName,tCreepSpawner in pairs ( self.tCreepSpawners ) do
		if tCreepSpawner[ "building" ] == hOldTower then
			printf( "     tower name: %s", sName )
			self:TakeSnapshotOfTowerCreepDamage()

			tCreepSpawner[ "death_time" ] = self:GetPlayedTime()
			
			-- redo graph
			local tTowersToCheckLanes = {}
			for sCounterpartName,tCounterpartCreepSpawner in pairs( self.tCreepSpawners ) do
				local hCounterpartSpawner = tCounterpartCreepSpawner[ "building" ]
				if hCounterpartSpawner ~= nil and hCounterpartSpawner:IsNull() == false and hCounterpartSpawner:IsAlive() and hCounterpartSpawner:GetTeamNumber() ~= hOldTower:GetTeamNumber() then
					for nIndex = #self.m_tTowerGraph[ sCounterpartName ],1,-1 do
						local szAdjacentName = self.m_tTowerGraph[ sCounterpartName ][ nIndex ]
						if szAdjacentName == sName then
							table.remove( self.m_tTowerGraph[ sCounterpartName ], nIndex )
							table.insert( tTowersToCheckLanes, sCounterpartName )
							break
						end
					end
				end
			end
			printf( "Found %d towers affected by death of %s", #tTowersToCheckLanes, sName )
			for _,sCounterpartName in pairs( tTowersToCheckLanes ) do
				local tAdjacentSpawnerNames = self.m_tTowerGraph[ sCounterpartName ]
				if #tAdjacentSpawnerNames == 0 then
					for _,sFallbackbackName in pairs( _G.NEMESTICE_TOWER_GRAPH_FALLBACK[ sCounterpartName ] ) do
						local hFallbackSpawner = self.tCreepSpawners[ sFallbackbackName ][ "building" ]
						if hFallbackSpawner ~= nil and hFallbackSpawner:IsNull() == false and hFallbackSpawner:IsAlive() and hFallbackSpawner:GetTeamNumber() == hOldTower:GetTeamNumber() then
							print( "Found a fallback target %s for tower %s", sFallbackbackName, sCounterpartName )
							table.insert( self.m_tTowerGraph[ sCounterpartName ], sFallbackbackName )
							table.insert( self.m_tTowerGraph[ sFallbackbackName ], sCounterpartName )
							break
						end
					end
				end
			end
			local nNetWorthReAdd = 0

			local nUpgradesDestroyed = hOldTower.nNumUpgrades or 0
					
			self:RecordTowerOwnership( tostring( hOldTower.sKeyName ), sAttackerName, DOTA_TEAM_CUSTOM_1, nUpgradesDestroyed, self:GetPlayedTime() )

			local nNumBuildingsDestroyed = 0

			for i = 0, DOTA_MAX_ABILITIES-1 do
				local hOldAbility = hOldTower:GetAbilityByIndex( i )
				if hOldAbility then
					-- special case - skip the default ability of towers
					if hOldAbility:GetAbilityName() == "tower_upgrade_spawn_lane_creeps" or hOldAbility:GetAbilityName() == "nemestice_tower_death_ring" then
						goto continue
					end

					if hOldAbility.tUpgradeBuildings ~= nil then
						print( "num upgrade buildings:" .. #hOldAbility.tUpgradeBuildings )
						for nBuildingIndex = #hOldAbility.tUpgradeBuildings,1,-1 do
							local hBuilding = hOldAbility.tUpgradeBuildings[ nBuildingIndex ]
							if hBuilding then
								print( "try to kill building" )
								hBuilding:ForceKill( false )

								if hBuilding:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
									local nFXIndex = ParticleManager:CreateParticle( "particles/radiant_fx/radiant_melee_barracks001_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
									ParticleManager:SetParticleControl( nFXIndex, 0, hBuilding:GetAbsOrigin() )
									ParticleManager:ReleaseParticleIndex( nFXIndex )
								else
									local nFXIndex = ParticleManager:CreateParticle( "particles/dire_fx/bad_barracks001_melee_destroy.vpcf", PATTACH_CUSTOMORIGIN, nil )
									ParticleManager:SetParticleControl( nFXIndex, 0, hBuilding:GetAbsOrigin() )
									ParticleManager:ReleaseParticleIndex( nFXIndex )
								end
										

								EmitSoundOn( "Building_Generic.Destruction", hBuilding )

								UTIL_Remove( hBuilding )

								table.remove( hOldAbility.tUpgradeBuildings, nBuildingIndex )
								nNumBuildingsDestroyed = nNumBuildingsDestroyed + 1
							end
						end
					end
				end
				::continue::
			end

			if nNumBuildingsDestroyed > 0 then
				--EmitSoundOn( "Building_Generic.Destruction", hTower )
			end


			-- Upgrade remaining towers.
			-- also repair them!
			for sNameAlly,tCreepSpawnerAlly in pairs ( self.tCreepSpawners ) do
				local hAllyBuilding = tCreepSpawnerAlly[ "building" ]
				if hAllyBuilding ~= hOldTower and hAllyBuilding ~= nil and hAllyBuilding:IsNull() == false and hAllyBuilding:IsAlive() and hAllyBuilding:GetTeamNumber() == hOldTower:GetTeamNumber() then
					hAllyBuilding.nTowerAllyLevel = hAllyBuilding.nTowerAllyLevel + 1
					local tUpgrades = _G.NEMESTICE_TOWER_AUTO_UPGRADES_ON_DESTROY[ hAllyBuilding.nTowerAllyLevel ]
					if tUpgrades then
						for _,szUpgradeName in pairs( tUpgrades ) do
							self:UpgradeTower( hAllyBuilding, szUpgradeName )
						end
					end

					local kv =
					{
						heal_percent = _G.NEMESTICE_TOWER_DESTRUCTION_HEAL_PERCENT,
						duration = _G.NEMESTICE_TOWER_DESTRUCTION_HEAL_DURATION,
						armor_bonus = _G.NEMESTICE_TOWER_DESTRUCTION_ARMOR_BONUS,
					}
					hAllyBuilding:AddNewModifier( hAllyBuilding, nil, "modifier_repair_kit", kv )
				end
			end
			
			self.m_bMapStateUpdated = true
			return hTower
		end
	end
	return nil
end

--------------------------------------------------------------------------------
function CNemestice:CreateTowerAt( vPos, sTowerKey, nNewTeam )
	local pszTowerName = "npc_dota_nemestice_tower_dire"
	if nNewTeam == DOTA_TEAM_GOODGUYS then
		pszTowerName = "npc_dota_nemestice_tower_radiant"
	--elseif nNewTeam == DOTA_TEAM_BADGUYS then
	--	pszTowerName = "npc_dota_nemestice_tower_dire"
	end
	local hTower = CreateUnitByName( pszTowerName, vPos, true, nil, nil, nNewTeam )
	if hTower then
		hTower.bIsTower = true
		hTower.sKeyName = sTowerKey
		hTower:SetAbsOrigin( vPos )
		if self:IsGameInProgress() then
			hTower:RemoveModifierByName( "modifier_invulnerable" )
		end
		self:BuffTower( hTower )
		return hTower
	else
		print( "Failed to create tower at position %f,%f for team %d!", vPos.x, vPos.y, nNewTeam )
	end
	return nil
end

--------------------------------------------------------------------------------
function CNemestice:BuffTower( hBarracks )
	local nRound = math.max( 1, self:GetRoundNumber() )
	local kv = 
	{
		building_hp_buff_pct = _G.NEMESTICE_BUILDING_HEALTH_BUFF_PCT[ nRound ],
		building_dmg_buff_pct = _G.NEMESTICE_TOWER_DMG_BUFF_PCT[ nRound ],
		building_armor_bonus = _G.NEMESTICE_TOWER_ARMOR_BONUS[ nRound ],
	}
	hBarracks:RemoveModifierByName( "modifier_barracks_buff" )
	hBarracks:AddNewModifier( hBarracks, nil, "modifier_barracks_buff", kv )

	local kv2 =
	{
		bonus_armor = _G.NEMESTICE_TOWER_PROTECTION_ARMOR[ nRound ],
		hp_regen = _G.NEMESTICE_TOWER_PROTECTION_REGEN[ nRound ],
	}
	hBarracks:RemoveModifierByName( "modifier_tower_aura" )
	hBarracks:AddNewModifier( hBarracks, nil, "modifier_tower_aura", kv2 )
	
	--hBarracks:AddNewModifier( hBarracks, nil, "modifier_tower_upgrade_tracker", {} )
end

--------------------------------------------------------------------------------
function CNemestice:UpdateTowerBuffs()
	local bGameInProgress = self:IsGameInProgress()
	for sName,tSpawnerInfo in pairs( self.tCreepSpawners ) do
		local hBuilding = tSpawnerInfo[ "building" ]
		if hBuilding ~= nil and hBuilding:IsNull() == false then
			if bGameInProgress then
				hBuilding:RemoveModifierByName( "modifier_invulnerable" )
			else
				hBuilding:AddNewModifier( hBuilding, nil, "modifier_invulnerable", {} )
			end
			self:BuffTower( hBuilding )

			
			if self:GetRoundNumber() > 1 then
				hBuilding.nTowerLevel = hBuilding.nTowerLevel + 1
				local tUpgrades = _G.NEMESTICE_TOWER_AUTO_UPGRADES[ hBuilding.nTowerLevel ]
				if tUpgrades then
					for _,szUpgradeName in pairs( tUpgrades ) do
						self:UpgradeTower( hBuilding, szUpgradeName )
					end
				end
			else
				if bGameInProgress then
					self:UpgradeTower( hBuilding, "tower_upgrade_tower_shrine" )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:ResetAbilityBuildingCooldowns()
	local hAbilityBuildings = FindUnitsInRadius( DOTA_TEAM_CUSTOM_1, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _,hBuilding in pairs(hAbilityBuildings) do
		local hBuff = hBuilding:FindModifierByName( "modifier_ability_building" )
		if hBuff ~= nil and hBuff:IsNull() == false then
			hBuff:GetAbility():StartCooldown( -1 )
		end
	end
end

--------------------------------------------------------------------------------

function CNemestice:CreateBaseEntranceFX()
	-- Creates the particles for each base entrance
	print("Creating Base FX")
	local cpRadiantEntStart1 = Entities:FindByName( nil, "radiant_base_exit_a_start" )
	local cpRadiantEntEnd1 = Entities:FindByName( nil, "radiant_base_exit_a_end" )
	local cpRadiantEntStart2 = Entities:FindByName( nil, "radiant_base_exit_b_start" )
	local cpRadiantEntEnd2 = Entities:FindByName( nil, "radiant_base_exit_b_end" )
	local cpDireEntStart1 = Entities:FindByName( nil, "dire_base_exit_a_start" )
	local cpDireEntEnd1 = Entities:FindByName( nil, "dire_base_exit_a_end" )
	local cpDireEntStart2 = Entities:FindByName( nil, "dire_base_exit_b_start" )
	local cpDireEntEnd2 = Entities:FindByName( nil, "dire_base_exit_b_end" )

	--local nRadiantParticle1 = ParticleManager:CreateParticle( "particles/gameplay/base_entrance/base_entrance.vpcf", PATTACH_CUSTOMORIGIN, nil )
	local nRadiantParticle1 = ParticleManager:CreateParticleForTeam( "particles/gameplay/base_entrance/base_entrance.vpcf", PATTACH_CUSTOMORIGIN, nil, DOTA_TEAM_BADGUYS )
	ParticleManager:SetParticleControl( nRadiantParticle1, 0, cpRadiantEntStart1:GetAbsOrigin() )
	ParticleManager:SetParticleControl( nRadiantParticle1, 1, cpRadiantEntEnd1:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nRadiantParticle1 )

	local nRadiantParticle2 = ParticleManager:CreateParticleForTeam( "particles/gameplay/base_entrance/base_entrance.vpcf", PATTACH_CUSTOMORIGIN, nil, DOTA_TEAM_BADGUYS )
	ParticleManager:SetParticleControl( nRadiantParticle2, 0, cpRadiantEntStart2:GetAbsOrigin() )
	ParticleManager:SetParticleControl( nRadiantParticle2, 1, cpRadiantEntEnd2:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nRadiantParticle2 )

	local nDireParticle1 = ParticleManager:CreateParticleForTeam( "particles/gameplay/base_entrance/base_entrance.vpcf", PATTACH_CUSTOMORIGIN, nil, DOTA_TEAM_GOODGUYS )
	ParticleManager:SetParticleControl( nDireParticle1, 0, cpDireEntStart1:GetAbsOrigin() )
	ParticleManager:SetParticleControl( nDireParticle1, 1, cpDireEntEnd1:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nDireParticle1 )

	local nDireParticle2 = ParticleManager:CreateParticleForTeam( "particles/gameplay/base_entrance/base_entrance.vpcf", PATTACH_CUSTOMORIGIN, nil, DOTA_TEAM_GOODGUYS )
	ParticleManager:SetParticleControl( nDireParticle2, 0, cpDireEntStart2:GetAbsOrigin() )
	ParticleManager:SetParticleControl( nDireParticle2, 1, cpDireEntEnd2:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( nDireParticle2 )
end

--------------------------------------------------------------------------------
function CNemestice:RefreshPlayers()
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

		 			CenterCameraOnUnit( nPlayerID, hHero )

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

					self:ChangeMeteorEnergy( hHero:GetPlayerOwnerID(), -self:GetMeteorEnergy( hHero:GetPlayerOwnerID() ), "round_end" )
				end
			end
		end
	end
	GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept( false )
end

--------------------------------------------------------------------------------
function CNemestice:RegisterConCommands()
	local eCommandFlags = FCVAR_CHEAT
	
	Convars:RegisterCommand( "nemestice_test_disconnect", function( commandName, szPlayerID )
		local nPlayerID = tonumber( szPlayerID ) 
		self:OnPlayerDisconnect( { PlayerID = nPlayerID } )
	end, "Pretend a player disconnected", eCommandFlags )

	Convars:RegisterCommand( "nemestice_print_resource_stats", function( ... )
		PrintTable( self.tGoldStats )
		PrintTable( self.tMeteorStats )
		self:PrintRoundBasedResourceStatus( "Gold", self.tGoldStats )
		self:PrintRoundBasedResourceStatus( "Meteor", self.tMeteorStats )
	end, "Print current stats for collected Meteor Energy", eCommandFlags )

	Convars:RegisterCommand( "nemestice_place_upgrade", function( ... )
		local args = { ... }
		if #args < 3 then
			return
		end

		local szTowerName = TableFind( _G.NEMESTICE_TOWER_NICKNAMES, function( _, rgNicknames ) return TableContainsValue( rgNicknames, args[2] ) end )
		local tSpawner = self.tCreepSpawners[szTowerName]
		if szTowerName == nil or tSpawner == nil then
			print( "Bad tower name " .. tostring( args[2] ) )
			return
		end

		local szUpgradeName = TableFindFirst( NEMESTICE_TOWER_UPGRADE_SET, function( name ) return string.match( name, args[3] ) end )
		if szUpgradeName == nil then
			print( "Bad upgrade name " .. tostring( args[3] ) )
			return
		end

		local nNewUpgradeLevel = 0
		local szCount = args[4] ~= nil and tonumber( args[4] ) or 1
		for i=1,szCount do
			nNewUpgradeLevel = self:UpgradeTower( tSpawner.building, szUpgradeName )
			if nNewUpgradeLevel == nil then
				print( "ERROR, tower did not upgrade" )
				return
			end
		end
		
		local hPlayer = PlayerResource:GetPlayer( 0 )
		if hPlayer == nil then
			return
		end
		local hHero = hPlayer:GetAssignedHero()
		if hHero == nil then
			return
		end
		EmitSoundOnClient( "General.Buy", hPlayer )

	end, "Place a named upgrade `nemestice_place_upgrade $tower $upgrade $count`", eCommandFlags )

	Convars:RegisterCommand( "nemestice_print_tower_text_map", function( ... )
		self:PrintTowerTextMap()
	end, "Prints a textual representation of the game map", eCommandFlags )

	Convars:RegisterCommand( "nemestice_print_tower_health", function( ... )
		self:PrintTowerHealth()
	end, "Print each team's current stats for percent health of tower (200% means a team has 2 towers full health)", eCommandFlags )
	
	Convars:RegisterCommand( "nemestice_print_tower_health_history", function( ... )
		self:PrintTowerHealthHistory()
	end, "Print history of tower health since game start", eCommandFlags )

	Convars:RegisterCommand( "nemestice_print_tower_ownership_history", function( ... )
		self:PrintTowerOwnershipHistory()
	end, "Print history of tower ownership since game start", eCommandFlags )

	Convars:RegisterCommand( "nemestice_print_tower_creep_damage_history", function( ... )
		self:PrintTowerCreepDamageHistory()
	end, "Print history of creep damage received by towers since game start", eCommandFlags )

	Convars:RegisterCommand( "nemestice_give_embers", function( commandName, szPlayerID, nAmount )
		local nPlayerID = tonumber( szPlayerID ) 
		self:ChangeMeteorEnergy( nPlayerID, nAmount, "cheat" )
	end, "Give a player moon juice `nemestice_give_embers $playerID $amount`", eCommandFlags )

	Convars:RegisterCommand( "nemestice_create_embers", function( commandName, szAmount )
		local nAmount = tonumber( szAmount )
		local rgHeroes = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
		for _,hHero in pairs( rgHeroes ) do
			self:CreateMeteorShard( "cheat", hHero:GetAbsOrigin(), nAmount, 60 )
		end
	end, "Place embers at the player's feet `nemestice_create_embers $playerID $amount`", eCommandFlags )

	Convars:RegisterCommand( "nemestice_change_tower_team", function( ... )
		local args = { ... }
		if #args < 2 then
			return
		end

		local szTowerName = TableFind( _G.NEMESTICE_TOWER_NICKNAMES, function( _, rgNicknames ) return TableContainsValue( rgNicknames, args[2] ) end )
		local tSpawner = self.tCreepSpawners[szTowerName]
		if szTowerName == nil or tSpawner == nil then
			print( "Bad tower name " .. tostring( args[2] ) )
			return
		end

		local bValidTeam = false
		local nTeamNumber = nil
		if args[3] ~= nil then
			local nTeamNumber = tonumber( args[3] )
			if nTeamNumber == DOTA_TEAM_GOODGUYS or nTeamNumber == DOTA_TEAM_BADGUYS then
				bValidTeam = true
			end
		end
		if not bValidTeam then
			printf( "Invalid team number, must be %d or %d", DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS )
			return
		end
		if tSpawner.building:GetTeamNumber() ~= nTeamNumber then
			self.bPassThroughKillEvent = true
			tSpawner.building:ForceKill( false )
			self.bPassThroughKillEvent = nil
		end
	end, "Set a tower to a given team `nemestice_change_tower_team $tower  $teamNumber (" .. DOTA_TEAM_GOODGUYS .. "=Radiant, " .. DOTA_TEAM_BADGUYS .."=Dire)`", eCommandFlags )

	Convars:RegisterCommand( "nemestice_show_tower_destroyed_message", function( commandName, szTeamNumber, nTowersRemaining )
		local nTeamNumber = tonumber( szTeamNumber ) 
		FireGameEvent( "tower_destroyed", {
			team_id = nTeamNumber,
			towers_remaining = nTowersRemaining,
		} )
	end, "Show tower destroyed message, arguments -> team number (2 radiant or 3 dire), towers remaining (3, 2, or 1)", eCommandFlags )

	Convars:RegisterCommand( "nemestice_create_meteor_drop", function( commandName )
		self:CreateLargeMeteorCrashSites()
	end, "Create a big meteor drop", eCommandFlags )

	Convars:RegisterCommand( "nemestice_play_cinematic_intro", function( commandName )
		self:StartFirstInterstitial()
	end, "Trigger the opening sequence", eCommandFlags )
end

--------------------------------------------------------------------------------
function CNemestice:GetRoundNumber()
	if self.m_nRoundNumber == nil or self.m_nRoundNumber == 0 then 
		return 0
	else
		return math.min( _G.NEMESTICE_NUM_ROUNDS, 1 + math.floor( ( self:GetPlayedTime() + _G.NEMESTICE_LARGE_METEOR_CRASH_SITE_INITIAL_DELAY ) / _G.NEMESTICE_ROUND_TIME ) )
	end
end

--------------------------------------------------------------------------------
function CNemestice:GetRoundNumberClamped()
	return math.max( 1, self:GetRoundNumber() )
end

--------------------------------------------------------------------------------
function CNemestice:GetWaveNumber()
	return self.m_nWave
end

--------------------------------------------------------------------------------
function CNemestice:StartPrepTime()
	self.m_GameState = _G.NEMESTICE_GAMESTATE_PREP_TIME
	self.m_nNumOvertimes = 0
	local flDotaTime = GameRules:GetDOTATime( false, true )
	self.m_flTimePhaseStarted = flDotaTime
	self.m_flTimePhaseEnds =  flDotaTime + _G.NEMESTICE_PREP_TIME
	self.m_bGatesOpen = false

	self:CreateBaseEntranceFX()

	-- Reset spawn times if needed
	if self.m_flNextSpawnTime < 0 then
		self.m_flNextSpawnTime = flDotaTime + _G.NEMESTICE_PREP_TIME + 0.25
		self.m_flNextSmallMeteorCrashTime = flDotaTime + _G.NEMESTICE_PREP_TIME + _G.NEMESTICE_SMALL_METEOR_CRASH_SITE_INITIAL_DELAY - _G.NEMESTICE_METEOR_WARNING_TIME
		self.m_flNextMediumMeteorCrashTime = flDotaTime + _G.NEMESTICE_PREP_TIME + _G.NEMESTICE_MEDIUM_METEOR_CRASH_SITE_INITIAL_DELAY - _G.NEMESTICE_METEOR_WARNING_TIME
		self.m_flNextLargeMeteorCrashTime = flDotaTime + _G.NEMESTICE_PREP_TIME + _G.NEMESTICE_LARGE_METEOR_CRASH_SITE_INITIAL_DELAY - _G.NEMESTICE_METEOR_WARNING_TIME
		self.m_flNextTowerHealthTickTime = flDotaTime + _G.NEMESTICE_PREP_TIME + _G.NEMESTICE_TOWER_HEALTH_TICK_RATE
	end

	self.m_vecNeutralItemDrops = {}

	local nHeroesDire = 0
	local nHeroesRadiant = 0
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			Hero:RemoveModifierByName( "modifier_hero_buy_phase" )
		end
	end

	-- delete cinematic meteor
	if self.hFakeCinematicMeteor then
		--print( '^^^Force killing fake meteor!')
		self.hFakeCinematicMeteor:ForceKill( false )
		self.hFakeCinematicMeteor = nil
	end

	-- Reapply buffs to towers to be sure they're on correct round.
	self:UpdateTowerBuffs()
	self:ResetAbilityBuildingCooldowns()

	self:SpawnMangoTrees()
end

--------------------------------------------------------------------------------
function CNemestice:GetTowersControlledBy( nTeamNumber, bIgnoreCurrentlyBuildingTowers )
	if self.tCreepSpawners == nil then
		return 0
	end

	local nScore = 0
	for sName,tSpawnerInfo in pairs( self.tCreepSpawners ) do
		if tSpawnerInfo[ "building" ] ~= nil and tSpawnerInfo[ "building" ]:IsNull() == false and tSpawnerInfo[ "building" ]:GetTeamNumber() == nTeamNumber and tSpawnerInfo[ "building" ]:IsAlive() then
			if bIgnoreCurrentlyBuildingTowers == true then
				local hBuff = tSpawnerInfo[ "building" ]:FindModifierByName( "modifier_barracks_rebuilding" )
				if hBuff == nil then
					--printf("^^^%s - team %d", tSpawnerInfo["name"], tSpawnerInfo["building"]:GetTeamNumber() )
					nScore = nScore + 1
				else
					--printf("^^^%s - team %d IS CURRENTLY BEING REBUILT!", tSpawnerInfo["name"], tSpawnerInfo["building"]:GetTeamNumber() )
				end
			else
				nScore = nScore + 1
			end
		end
	end
	return nScore
end

--------------------------------------------------------------------------------
function CNemestice:GetAllTowersCurrentPercentHealth()
	local tResult = {}

	if self.tCreepSpawners == nil then
		return tResult
	end

	for sName,tSpawnerInfo in pairs( self.tCreepSpawners ) do
		if tSpawnerInfo[ "building" ] ~= nil and tSpawnerInfo[ "building" ]:IsNull() == false and tSpawnerInfo[ "building" ]:IsAlive() then
			local hTower = tSpawnerInfo[ "building" ]
			local nCurrentHealth = hTower:GetHealth()
			local nMaxHealth = hTower:GetMaxHealth()
			local nPctHealth = 0
			if ( nMaxHealth > 0 ) then
				nPctHealth = math.floor( 100.0 * nCurrentHealth / nMaxHealth )
			end
			tResult[ hTower.sKeyName ] = nPctHealth
		end
	end
	return tResult
end

--------------------------------------------------------------------------------
function CNemestice:GetCurrentTowerHealthForTeam( nTeamNumber )
	-- returns a whole number like 2 for two towers full health.  would return 0.5 if both towers were only 25% health
	if self.tCreepSpawners == nil then
		return 0
	end

	local flTotalHealth = 0
	for sName,tSpawnerInfo in pairs( self.tCreepSpawners ) do
		if tSpawnerInfo[ "building" ] ~= nil and tSpawnerInfo[ "building" ]:IsNull() == false and tSpawnerInfo[ "building" ]:GetTeamNumber() == nTeamNumber and tSpawnerInfo[ "building" ]:IsAlive() then
			--printf("%s - team %d, health %d / %d", tSpawnerInfo["name"], tSpawnerInfo["building"]:GetTeamNumber(), tSpawnerInfo["building"]:GetHealth(), tSpawnerInfo["building"]:GetMaxHealth() )
			local nCurrentHealth = tSpawnerInfo[ "building" ]:GetHealth()
			local nMaxHealth = tSpawnerInfo[ "building" ]:GetMaxHealth()
			if nMaxHealth > 0 then
				flTotalHealth = flTotalHealth + nCurrentHealth / nMaxHealth
			end
		end
	end
	return flTotalHealth
end

--------------------------------------------------------------------------------
function CNemestice:TakeSnapshotOfTowerCreepDamage()
	local nTime = math.ceil( self:GetPlayedTime() )
	self.m_vecTowerCreepDamageHistory[ nTime ] = self.m_vecTowerCreepDamageAccumulator;
	self.m_vecTowerCreepDamageAccumulator = {}
end

--------------------------------------------------------------------------------
function CNemestice:GetCurrentUpgradesForTeam( nTeamNumber )
	if self.tCreepSpawners == nil then
		return 0
	end

	local nScore = 0
	for sName,tSpawnerInfo in pairs( self.tCreepSpawners ) do
		if tSpawnerInfo[ "building" ] ~= nil and tSpawnerInfo[ "building" ]:IsNull() == false and tSpawnerInfo[ "building" ]:GetTeamNumber() == nTeamNumber and tSpawnerInfo[ "building" ]:IsAlive() then
			--printf("%s - team %d", tSpawnerInfo["name"], tSpawnerInfo["building"]:GetTeamNumber() )
			nScore = nScore + ( tSpawnerInfo[ "building" ].nNumUpgrades or 0 )
		end
	end
	return nScore
end

--------------------------------------------------------------------------------
function CNemestice:GameTimeExpired()
	local nRadiant = self:GetTowersControlledBy( DOTA_TEAM_GOODGUYS, false )
	local nDire = self:GetTowersControlledBy( DOTA_TEAM_BADGUYS, false )

	if nRadiant == nDire then
		self.m_GameState = _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH
		self.m_nTotalNumOvertimes = self.m_nTotalNumOvertimes + 1
		EmitAnnouncerSound( "announcer_ann_custom_overtime" )
		FireGameEvent( "start_sudden_death", { } )
		return
	end

	
	local nScoringTeam = DOTA_TEAM_BADGUYS
	if nRadiant > nDire then
		nScoringTeam = DOTA_TEAM_GOODGUYS
	end

	print( 'GAME TIME EXPIRED: Radiant Score = %d. Dire Score = %d. SCORING TEAM is %d', nRadiant, nDire, nScoringTeam )

	self:WinGame( nScoringTeam )
end

--------------------------------------------------------------------------------
function CNemestice:StartFirstInterstitial()
	-- we have loaded now, so load up player data:
	printf("[NEMESTICE] EventGameDetails table:")
	if self.m_hEventGameDetails then
	    DeepPrintTable(self.m_hEventGameDetails)
	else
		printf("EventGameDetails NOT FOUND!!")
		self.m_hEventGameDetails = {}
	end

	self:InitPlayerInfo()


	self.m_nRoundNumber = 1
	if self.m_bFastPlay then
		-- fast play skips over the cinematic
		FireGameEvent( "start_intro_cinematic", { skip_cinematic = 1 } )
		self.m_flTimePhaseEnds = GameRules:GetDOTATime( false, true ) + math.min( 0.1 )
	else
		-- standard version will start the intro cinematic and create the fake meteor
		FireGameEvent( "start_intro_cinematic", { skip_cinematic = 0 } )
		self:CreateFakeCinematicMeteorCrashSite()
		self.m_flTimePhaseEnds = GameRules:GetDOTATime( false, true ) + _G.NEMESTICE_POSTLOAD_TIME
	end
	self.m_GameState = _G.NEMESTICE_GAMESTATE_POSTLOAD_PHASE

	local nHeroesDire = 0
	local nHeroesRadiant = 0
	local Heroes = HeroList:GetAllHeroes()
	for _, Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:IsNull() == false and Hero:IsRealHero() then
			Hero:AddNewModifier( Hero, nil, "modifier_hero_buy_phase", { duration = -1 } )
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

	print( "Advance to Interstitial" )
end

--------------------------------------------------------------------------------
function CNemestice:UpdateRoundNumber( bInGame, nScoringTeam )
	local nEffectiveRoundNumber = self:GetRoundNumber()
	if self.m_nLastRoundNumber < nEffectiveRoundNumber then
		local nOldRound = self.m_nLastRoundNumber
		self.m_nLastRoundNumber = nEffectiveRoundNumber
		
		self:PrintRoundBasedResourceStatus( "Gold", self.tGoldStats )
		self:PrintRoundBasedResourceStatus( "Meteor", self.tMeteorStats )

		print( "Advancing to round number " .. self:GetRoundNumber() )

		-- This sets steam rich presence round number
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			PlayerResource:SetCustomIntParam( nPlayerID, self:GetRoundNumber() )
		end

		-- Reset ward counts in shop
		for nTeamNumber = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
			--GameRules:SetItemStockCount( 2, nTeamNumber, "item_ward_observer", -1 )
			GameRules:SetItemStockCount( 5, nTeamNumber, "item_ward_sentry", -1 )
		end

		-- Update ability building abilities
		for sName,tCreepSpawner in pairs( self.tCreepSpawners ) do
			local hTower = tCreepSpawner[ "building" ]
			if hTower ~= nil and hTower:IsNull() == false and hTower:IsAlive() then
				for i = 0, DOTA_MAX_ABILITIES - 1 do
					local hAbility = hTower:GetAbilityByIndex( i )
					if hAbility and hAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY and hAbility.tUpgradeBuildings ~= nil then
						--printf( "Tower %s has ability %s to be upgraded", tCreepSpawner[ "name" ], hAbility:GetAbilityName() )
						while hAbility:GetLevel() < math.max( 1, nEffectiveRoundNumber ) do
							hAbility:UpgradeAbility( true )
						end
						for _,hBuilding in pairs( hAbility.tUpgradeBuildings ) do
							if hBuilding.hBuildingAbility ~= nil and hBuilding.hBuildingAbility:IsNull() == false then
								--printf( "Found building with ability %s", hBuilding.hBuildingAbility:GetAbilityName() )
								while hBuilding.hBuildingAbility:GetLevel() < math.max( 1, nEffectiveRoundNumber ) do
									hBuilding.hBuildingAbility:UpgradeAbility( true )
								end
							elseif hBuilding.hBuildingAbility ~= nil then
								printf(" **** ERROR **** tower %s is alive, with an ability_type upgrade, but not-nil-but-null building ability. That Tower upgrade ability null? %s", 
									sName, ( ( hAbility:IsNull() and "yes") or "no" ) )
							end
						end
					end
				end
			end
		end

		if bInGame then
			self:UpdateTowerBuffs()


			-- Announce the round change (but no UI)
			--[[if self:GetRoundNumber() < 10 then
				EmitAnnouncerSound( "announcer_ann_custom_round_0" .. self:GetRoundNumber() )
			elseif self:GetRoundNumber() == 10 then
				EmitAnnouncerSound( "announcer_ann_custom_round_10" )
			else
				EmitAnnouncerSound( "announcer_ann_custom_round_final" )
			end--]]
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:WinGame( nScoringTeam )
	
-- Clean up some stuff
	self:CleanupDroppedItems()
	self:TakeSnapshotOfTowerCreepDamage()
	
	-- record winning team
	self.nWinningTeam = nScoringTeam
	
		
	bFinalRound = 1--]]
	
	print( " ------- Final Gold Stat Block --------" )
	self:PrintRoundBasedResourceStatus( "Gold", self.tGoldStats )
	print( " ------- Final Meteor Energy Stat Block --------" )
	self:PrintRoundBasedResourceStatus( "Meteor", self.tMeteorStats )
	print( " ------- Map of Tower Locations as Text --------" )
	self:PrintTowerTextMap()
	print( " ------- Tower Ownership History Block (with an accounting of upgrades destroyed) --------" )
	self:PrintTowerOwnershipHistory()
	print( " ------- Towers Receiving Damage from Creeps --------" )
	self:PrintTowerCreepDamageHistory()
	print( " ------- Final Tower Health --------" )
	print( "[ includes an approximation of Radiant advantage (100%) vs Dire victory (-100%) ]" )
	self:PrintTowerHealthHistory()
	GameRules:MakeTeamLose( FlipTeamNumber( self.nWinningTeam ) )
	self.m_flPlayedTime = self:GetPlayedTime()
	self.m_GameState = _G.NEMESTICE_GAMESTATE_GAMEOVER
end

--------------------------------------------------------------------------------
function CNemestice:EndPrepTime()
	self.m_GameState = _G.NEMESTICE_GAMESTATE_IN_PROGRESS
	local flDotaTime = GameRules:GetDOTATime( false, true )
	self.m_flTimePhaseStarted = flDotaTime
	self.m_flTimePhaseEnds =  flDotaTime + _G.NEMESTICE_ROUND_TIME
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		GameRules:SetGlyphCooldown( nTeam, _G.NEMESTICE_GLYPH_INITIAL_COOLDOWN )
	end

	GameRules:SetGoldPerTick( _G.NEMESTICE_GOLD_PER_TICK )

	self:UpdateTowerBuffs()
end

--------------------------------------------------------------------------------
function CNemestice:GetNumNeutralItemsDroppedForTeam( nTeamNumber )
	local nCount = 0
	if self.m_vecNeutralItemDrops ~= nil then
		for _, hItem in pairs( self.m_vecNeutralItemDrops ) do
			if hItem ~= nil and hItem.nTeam == nTeamNumber then
				nCount = nCount + 1
			end
		end
	end
	return nCount
end

--------------------------------------------------------------------------------
function CNemestice:CleanupDroppedItems()
	for _, hItem in pairs( Entities:FindAllByClassname( "dota_item_drop" ) ) do
		local szItemName = hItem:GetContainedItem():GetAbilityName()
		if szItemName == "item_soulstuff" 
				or szItemName == "item_soulstuff_dire" 
				or szItemName == "item_mango" 
				or szItemName == "item_enchanted_mango" 
				or szItemName == "item_tombstone" 
				or szItemName == "item_health_potion" 
				or szItemName == "item_mana_potion"
				or szItemName == "item_meteor_shard" then
			if hItem:GetContainedItem().nViewer ~= nil and hItem:GetContainedItem().nTeamNumber ~= nil then
				RemoveFOWViewer( hItem:GetContainedItem().nTeamNumber, hItem:GetContainedItem().nViewer )
			end
			UTIL_Remove( hItem )
		end
	end
	for _, hItem in pairs( Entities:FindAllByClassname( "dota_item_rune" ) ) do
		UTIL_Remove( hItem )
	end
end

--------------------------------------------------------------------------------
-- plays a sound on all clients. Spectators get Radiant sound
function CNemestice:PlayTeamSound( szSoundA, szSoundB, nTeamA )
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
function CNemestice:ThinkShardExpiry()
	local flCutoffTime = GameRules:GetGameTime() -- Actually it should be engine's GetGameTime. Hope this is ok.
	for _,item in pairs( Entities:FindAllByClassname( "item_lua" )) do
		if item:GetAbilityName() == "item_meteor_shard" then
			if item.flDieTime ~= nil and  item.flDieTime <= flCutoffTime then
				local container = item:GetContainer()
				if container then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, container )
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
function CNemestice:DevTowerName( sTowerKeyName )
	local sSpecialName = _G.NEMESTICE_TOWER_DEVELOPER_NAME[ sTowerKeyName ]
	if sSpecialName == nil then
		return sTowerKeyName
	end
	return sSpecialName
end

--------------------------------------------------------------------------------
function CNemestice:PrintTowerTextMap()
	local nColumns = _G.NEMESTICE_TOWER_TEXT_MAP.columns
	local nRows = _G.NEMESTICE_TOWER_TEXT_MAP.rows
	-- start with a blank text map
	local sBorderTextRow = ""
	local sBlankTextRow = ""
	for nCol = 1, nColumns do
		sBorderTextRow = sBorderTextRow .. "-"
		sBlankTextRow = sBlankTextRow .. " "
	end
	local vTextMap = {}
	for nRow = 1, nRows do
		vTextMap[ nRow ] = sBlankTextRow
	end

	-- gather info about various entities
	local hTargets = Entities:FindAllByClassname( "info_target" )
	local hTowers =  Entities:FindAllByClassname( "npc_dota_tower" )
	local hRadiantFountains = Entities:FindAllByClassname( "info_player_start_goodguys" )
	local hDireFountains = Entities:FindAllByClassname( "info_player_start_badguys" )
	local vLabeledLocations = {}
	for _,hTarget in pairs( hTargets ) do
		if string.starts( hTarget:GetName(), "meteor_drop_" ) then
			table.insert( vLabeledLocations, { hTarget:GetAbsOrigin(), "m" } )
		end
	end
	for szName,hTower in pairs( hTowers ) do
		table.insert( vLabeledLocations, { hTower:GetAbsOrigin(), tostring( hTower.sKeyName ) } )
	end
	for szName,hFountain in pairs( hRadiantFountains ) do
		table.insert( vLabeledLocations, { hFountain:GetAbsOrigin(), "R" } )
	end
	for szName,hFountain in pairs( hDireFountains ) do
		table.insert( vLabeledLocations, { hFountain:GetAbsOrigin(), "D" } )
	end

	-- find the bounds of the entity locations
	local flMinX = 0
	local flMaxX = 0
	local flMinY = 0
	local flMaxY = 0
	for i = 1, #vLabeledLocations do
		local vLocation = vLabeledLocations[ i ][ 1 ]
		local flX = vLocation[ 1 ]
		local flY = vLocation[ 2 ]
		flMinX = math.min( flMinX, flX )
		flMaxX = math.max( flMaxX, flX )
		flMinY = math.min( flMinY, flY )
		flMaxY = math.max( flMaxY, flY )
	end
	-- create some padding around edge
	flMinX = flMinX - 2
	flMaxX = flMaxX + 2
	flMinY = flMinY - 1
	flMaxY = flMaxY + 1
	local flWidthX = flMaxX - flMinX
	local flWidthY = flMaxY - flMinY

	-- populate the text map
	for i = 1, #vLabeledLocations do
		local vLocation = vLabeledLocations[ i ][ 1 ]
		local flX = vLocation[ 1 ]
		local flY = vLocation[ 2 ]
		local nCol = math.min( nColumns, math.max( 1, math.floor( 0.5 + nColumns * ( flX - flMinX ) / flWidthX ) ) )
		local nRow = math.min( nRows, math.max( 1, math.floor( 0.5 + nRows * ( flMaxY - flY ) / flWidthY ) ) )
		local sDevName = self:DevTowerName( vLabeledLocations[ i ][ 2 ] )
		local nNameLen = string.len( sDevName )
		nShiftLeft = math.min( nCol - 1, math.max( math.floor( nNameLen / 2 ), math.max( nCol + nNameLen, nColumns) - nColumns ) )  -- centered unless bumping against edge
		local sRow = vTextMap[ nRow ]
		local sPre = string.sub( sRow, 1, nCol - 1 - nShiftLeft )
		local sPost = string.sub( sRow, nCol + nNameLen - nShiftLeft )
		vTextMap[ nRow ] = string.sub( sPre .. sDevName .. sPost, 1, snColumns )
	end

	-- output the text strings
	printf( "       +%s+", sBorderTextRow )
	for i = 1, nRows do
		printf( "       |%s|", vTextMap[ i ] )
	end
	printf( "       +%s+", sBorderTextRow )
end

--------------------------------------------------------------------------------
function CNemestice:PrintTowerHealth()
	local flDotaTime = GameRules:GetDOTATime( false, true )
	local nRadiantPct = math.floor(100 * self:GetCurrentTowerHealthForTeam( DOTA_TEAM_GOODGUYS ))
	local nDirePct = math.floor(100 * self:GetCurrentTowerHealthForTeam( DOTA_TEAM_BADGUYS ))
	printf("Tower health at time %f is Radiant:%d%% and Dire:%d%%",flDotaTime, nRadiantPct, nDirePct)
	local tAllTowers = self:GetAllTowersCurrentPercentHealth();
	for sTowerKey, nPctHealth in pairs( tAllTowers ) do
		printf("   tower %s has health of %d%%", sTowerKey, nPctHealth)
	end
end

--------------------------------------------------------------------------------
function CNemestice:PrintTowerHealthHistory()
	local orderedTimes = {}
	for timeKey, towerHealths in pairs(self.m_vecTowerHealthHistory) do
		table.insert( orderedTimes, timeKey )
	end
	table.sort( orderedTimes )
	printf("towerHealthHistory = { -- %d keys", #orderedTimes )
	for i = 1, #orderedTimes do
		local timeKey, towerHealths = orderedTimes[ i ], self.m_vecTowerHealthHistory[ orderedTimes[ i ] ]
		local summedHealth = towerHealths.radiant + towerHealths.dire
		local flTowerAdvantage = ( towerHealths.radiant - towerHealths.dire ) / summedHealth
		printf("\t%s = { radiant = %f, dire = %f, advantage = %5.1f%% },", ConvertToTime( timeKey ), towerHealths.radiant, towerHealths.dire, math.floor( flTowerAdvantage * 1000 ) / 10 )
	end
	printf("} -- end of %d keys of towerHealthHistory", #orderedTimes )
end

--------------------------------------------------------------------------------
function CNemestice:PrintTowerOwnershipHistory()
	local nLongestName = 0
	for nOwnerKey, sShortName in pairs( _G.NEMESTICE_TOWER_OWNER_SHORT_NAMES ) do
		nLongestName = math.max( nLongestName, string.len( sShortName ) )
	end
	nLongestName = nLongestName + 4  -- make room for number of upgrades destroyed in the format (uu) for two digits of upgrades uu
	local uniqueTimes = {}
	for towerKey, tTowerInfo in pairs( self.m_vecTowerOwnershipHistory ) do
		local tOwnerHistory = tTowerInfo[ "ownership" ]
		if tOwnerHistory ~= nil then
			for timeKey, tOwnerChange in pairs( tOwnerHistory ) do
				uniqueTimes[ timeKey ] = true
			end
		end
	end
	local orderedTimes = {}
	for timeKey, exists in pairs( uniqueTimes ) do
		table.insert( orderedTimes, timeKey )
	end
	table.sort( orderedTimes )
	local sHeader =    "time  Team Upgrades  "
	local sSeparator = "----- Radiant  Dire  "
	for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
		local sColumnSeparator = ""
		local sDevName = self:DevTowerName( _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ] )
		local nColumnWidth = math.max( string.len(sDevName), nLongestName )
		for k = 1, nColumnWidth do
			sColumnSeparator = sColumnSeparator .. "-"
		end
		sHeader = sHeader .. " " .. sDevName
		for k = string.len(sDevName) + 1, nColumnWidth do
			sHeader = sHeader .. " "
		end
		sSeparator = sSeparator .. " " .. sColumnSeparator
	end
	print( sHeader )
	print( sSeparator )
	for i = 1, #orderedTimes do
		local nTimeKey = orderedTimes[ i ]
		local tTeamUpgrades = self.m_vecTowerUpgradeHistory[ nTimeKey ]
		local sUpgrades = " "
		if tTeamUpgrades ~= nil then
			local sRadiantUpgrades = tostring( tTeamUpgrades[ DOTA_TEAM_GOODGUYS ] )
			local sDireUpgrades = tostring( tTeamUpgrades[ DOTA_TEAM_BADGUYS ] )
			if string.len( sRadiantUpgrades ) < 2 then
				sRadiantUpgrades = " " .. sRadiantUpgrades
			end
			if string.len( sDireUpgrades ) < 2 then
				sDireUpgrades = sDireUpgrades .. " "
			end
			sUpgrades = sRadiantUpgrades .. " - " .. sDireUpgrades
		end
		local nPad = 14 - string.len( sUpgrades )
		if nPad > 0 then
			sUpgrades = string.sub( "              ", 1, math.floor( nPad / 2 ) ) .. sUpgrades .. string.sub("              ", 1, math.ceil( nPad / 2) )
		end
		local sOwnerChangesRow = " " .. sUpgrades
		for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
			local sTowerKey = _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ]
			local sDevName = self:DevTowerName( sTowerKey )
			local nColumnWidth = math.max( string.len(sDevName), nLongestName )
			local tOwnerHistory = self.m_vecTowerOwnershipHistory[ sTowerKey ][ "ownership" ]
			local tOwnerChange = tOwnerHistory[ nTimeKey ]
			local sTeam = " "
			if tOwnerChange ~= nil then
				local nNewOwnerTeam = tOwnerChange[ "nTeam" ]
				local nUpgradesDestroyed = tOwnerChange[ "nUpgradesDestroyed" ]
				if nNewOwnerTeam ~= nil then
					sTeam = _G.NEMESTICE_TOWER_OWNER_SHORT_NAMES[ nNewOwnerTeam ]
					if sTeam == nil then
						sTeam = tostring(nNewOwnerTeam)
					end
				end
				if nUpgradesDestroyed > 0 then
					sTeam = sTeam .. "(" .. tostring(nUpgradesDestroyed) .. ")"
				end
			end
			sOwnerChangesRow = sOwnerChangesRow .. " " .. sTeam
			for k = string.len(sTeam) + 1, nColumnWidth do
				sOwnerChangesRow = sOwnerChangesRow .. " "  -- pad to make same width as header key
			end
		end
		printf( "%s %s", ConvertToTime( nTimeKey ), sOwnerChangesRow )
	end
end

--------------------------------------------------------------------------------
function CNemestice:PrintTowerCreepDamageHistory()
	local nLongestName = 0
	for nOwnerKey, sShortName in pairs( _G.NEMESTICE_TOWER_OWNER_SHORT_NAMES ) do
		nLongestName = math.max( nLongestName, string.len( sShortName ) )
	end
	local orderedTimes = {}
	local uniqueOwnerChangeTimes = {}
	for sTowerKey, tTowerInfo in pairs( self.m_vecTowerOwnershipHistory ) do
		local tOwnerHistory = tTowerInfo[ "ownership" ]
		if tOwnerHistory ~= nil then
			for timeKey, nTeam in pairs( tOwnerHistory ) do
				uniqueOwnerChangeTimes[ timeKey ] = true
			end
		end
	end

	for nAccumulateTime, tAccumulation in pairs( self.m_vecTowerCreepDamageHistory ) do
		table.insert( orderedTimes, tonumber( nAccumulateTime ) )
	end
	local orderedChangeTimes = {}
	for nChangeTimeKey, exists in pairs( uniqueOwnerChangeTimes ) do
		table.insert( orderedChangeTimes, tonumber( nChangeTimeKey ) )
	end
	table.sort( orderedTimes )
	table.sort( orderedChangeTimes )

	-- print the column headers and separator rows
	local sHeader = "time  "
	local sSeparator = "----  "
	for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
		local sColumnSeparator = ""
		local sDevName = self:DevTowerName( _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ] )
		local nColumnWidth = math.max( string.len(sDevName), nLongestName )
		for k = 1, nColumnWidth do
			sColumnSeparator = sColumnSeparator .. "-"
		end
		for k = string.len(sDevName) + 1, nColumnWidth do
			sDevName = " " .. sDevName
		end
		sHeader = sHeader .. " " .. sDevName
		sSeparator = sSeparator .. " " .. sColumnSeparator
	end
	print( sHeader )
	print( sSeparator )
	
	local nNextChangeIndex = 1
	-- print the data rows
	for i = 1, #orderedTimes do
		local nAccumulateTime = orderedTimes[ i ]
		if nNextChangeIndex <= #orderedChangeTimes and orderedChangeTimes[ nNextChangeIndex ] < nAccumulateTime then
			-- print ownership change
			local nOwnerChangeTime = orderedChangeTimes[ nNextChangeIndex ]
			nNextChangeIndex = nNextChangeIndex + 1
			local sOwnerChangesRow = ""
			for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
				local sTowerKey = _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ]
				local sDevName = self:DevTowerName( sTowerKey )
				local nColumnWidth = math.max( string.len(sDevName), nLongestName )
				local tOwnerHistory = self.m_vecTowerOwnershipHistory[ sTowerKey ][ "ownership" ]
				local tOwnerChange = tOwnerHistory[ nOwnerChangeTime ]
				local sTeam = " "
				if tOwnerChange ~= nil then
					local nNewOwnerTeam = tOwnerChange[ "nTeam" ]
					if nNewOwnerTeam ~= nil then
						sTeam = _G.NEMESTICE_TOWER_OWNER_SHORT_NAMES[ nNewOwnerTeam ]
						if sTeam == nil then
							sTeam = tostring(nNewOwnerTeam)
						end
					end
				end
				for k = string.len(sTeam) + 1, nColumnWidth do
					sTeam = " " .. sTeam  -- pad to make same width as header key
				end
				sOwnerChangesRow = sOwnerChangesRow .. " " .. sTeam			
			end
			printf( "%s %s", ConvertToTime(nOwnerChangeTime), sOwnerChangesRow )
		end
		-- print the creep damage
		local tAccumulation = self.m_vecTowerCreepDamageHistory[ nAccumulateTime ]
		local flTotalDamageInAccumulation = 0
		for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
			local sTowerKey = _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ]
			local flAccumulation = tAccumulation[ sTowerKey ]
			if flAccumulation ~= nil then
				flTotalDamageInAccumulation = flTotalDamageInAccumulation + flAccumulation
			end
		end
		if math.floor( flTotalDamageInAccumulation ) > 0 then  -- supress lines that have no damage reported
			local sRow = ""
			for j = 1, #_G.NEMESTICE_TOWER_DEVELOPER_ORDER do
				local sTowerKey = _G.NEMESTICE_TOWER_DEVELOPER_ORDER[ j ]
				local sDevName = self:DevTowerName( sTowerKey )
				local nColumnWidth = math.max( string.len(sDevName), nLongestName )
				local flAccumulation = tAccumulation[ sTowerKey ]
				local sCreepDamage = " "
				if flAccumulation ~= nil then
					sCreepDamage = tostring( math.floor( flAccumulation ) )
				end
				sCreepDamage = string.sub("                    ", string.len(sCreepDamage) + 1, nColumnWidth ) .. sCreepDamage
				sRow = sRow .. " " .. sCreepDamage
			end
			printf( "%s %s", ConvertToTime(nAccumulateTime), sRow )
		end
	end
end


--------------------------------------------------------------------------------
function CNemestice:GetMeteorEnergy( nPlayerID )
	return self:GetHeroMeteorEnergy( PlayerResource:GetSelectedHeroEntity( nPlayerID ) )
end

--------------------------------------------------------------------------------
function CNemestice:GetHeroMeteorEnergy( hPlayerHero )
	if hPlayerHero then
		local hShardPouch = hPlayerHero:FindAbilityByName( "hero_meteor_shard_pouch" )
		if hShardPouch ~= nil and hShardPouch:IsNull() == false then
			return hShardPouch:GetShardCount()
		end
	end
	return 0
end

--------------------------------------------------------------------------------
function CNemestice:ChangePlayerMeteorEnergyStats( nPlayerID, nChange, bIsFromMeteor )
	if nPlayerID < 0 then
		return
	end

	if self.EventMetaData == nil then
		self.EventMetaData = {}
	end
	if self.EventMetaData[ nPlayerID ] ~= nil then

		if nChange >= 0 then
			self.EventMetaData[ nPlayerID ]["meteor_energy_absorbed"] = self.EventMetaData[ nPlayerID ]["meteor_energy_absorbed"] + nChange
			if bIsFromMeteor then
				self.EventMetaData[ nPlayerID ]["meteor_energy_channeled"] = self.EventMetaData[ nPlayerID ]["meteor_energy_channeled"] + nChange
			end
		else
			self.EventMetaData[ nPlayerID ]["meteor_energy_lost"] =  self.EventMetaData[ nPlayerID ]["meteor_energy_lost"] - nChange
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:UpdateResourceStats( szTableName, nPlayerID, nAmount, szReason )
	if nAmount == 0 then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hPlayerHero == nil then
		print( "hPlayerHero == nil" )
		return
	end
	
	szReason = szReason or "???"

	if self[szTableName] == nil then
		self[szTableName] = {}
	end
	if self[szTableName][self:GetRoundNumber()] == nil then
		self[szTableName][self:GetRoundNumber()] = {}
	end
	if self[szTableName][self:GetRoundNumber()][nPlayerID] == nil then
		self[szTableName][self:GetRoundNumber()][nPlayerID] = { name = hPlayerHero:GetName() }
	end
	local tStats = self[szTableName][self:GetRoundNumber()][nPlayerID]
	tStats[szReason] = nAmount + ( tStats[szReason] or 0 )
end

--------------------------------------------------------------------------------
function CNemestice:ChangeMeteorEnergy( nPlayerID, nChange, szReason, hNPC, flDuration, nTeamNumber, bDoNotRemoveStacks, nOffsetCurrent )
	if nPlayerID < 0 then
		return
	end

	hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hNPC == nil then
		hNPC = hPlayerHero
	end
	if hNPC then
		local hShardPouch = hNPC:FindAbilityByName( "hero_meteor_shard_pouch" )
		if hShardPouch then
			local nOldValue = hShardPouch:GetShardCount() + ( nOffsetCurrent or 0 )
			local nValue = nOldValue + nChange
			local nMax = hShardPouch:GetMaxAbilityCharges( hShardPouch:GetLevel() )
			local nCapLoss = 0
			if nValue > nMax then
				nCapLoss = nValue - nMax
				nValue = nMax
			elseif nValue < 0 then
				nValue = 0
			end
			nChange = nValue - nOldValue
			printf( "Changing meteor energy by %d for %s, old value %d", nChange, hNPC:GetUnitName(), nOldValue )

			if nChange ~= 0 then
				if nChange > 0 then
					self:ChangePlayerMeteorEnergyStats( nPlayerID, nChange, string.starts( szReason, "meteor" ) )

					-- Check team number of the shard. If it is nil, it's a fresh shard. If the team number is -1, it's already been grabbed by both teams.
					-- We get credit if it's fresh, or from an enemy (and is only changing hands now)
					--if nTeamNumber ~= hNPC:GetTeamNumber() and nTeamNumber ~= -1 then
						--self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_gathered" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_gathered" ] + nChange
					--end

					-- Fresh shards have no team number.
					if nTeamNumber == nil then
						self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_channeled" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_channeled" ] + nChange
					else
						self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_gathered" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_gathered" ] + nChange
					end

					local flTrueDuration = flDuration
					if flTrueDuration == nil then
						flTrueDuration = _G.NEMESTICE_METEOR_ENERGY_DURATION
					end
					for i = 1, nChange do
						hShardPouch:AddShard( flTrueDuration, nTeamNumber )
					end
				else
					if bDoNotRemoveStacks ~= true then
						-- TODO: Do we care which one we remove?
						for i = 1, -nChange do
							hShardPouch:RemoveShard()
						end
					end
					if szReason == "death" then
						self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_lost" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "shards_lost" ] - nChange
					end
				end
			end

			self:UpdateResourceStats( "tMeteorStats", nPlayerID, nChange, szReason )
			--tStats["cap_loss"] = -nCapLoss + ( tStats["cap_loss"] or 0 )
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:GrantMeteorEnergy()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS 
			or PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_BADGUYS then
			if PlayerResource:HasSelectedHero( nPlayerID ) then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero ~= nil then
					self:ChangeMeteorEnergy( hHero:GetPlayerOwnerID(), 100, "testing" )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:PrintRoundBasedResourceStatus( szName, tStats )
	local rgAllColumns = {}
	for _,tRoundStats in ipairs( tStats ) do
		for _,tPlayerStats in pairs( tRoundStats ) do
			table.insert( rgAllColumns, TableKeys( tPlayerStats ) )
		end
	end
	local rgColumns = TableConcatenated( rgAllColumns )
	table.sort( rgColumns )
	table.insert( rgColumns, 1, "name" ) -- force name to be first column
	rgColumns = TableUnique( rgColumns )

	for nRound,tRoundStats in ipairs( tStats ) do
		local rgCells = { rgColumns }
		local tTeamSums = {
			[DOTA_TEAM_GOODGUYS] = { name = "GOODGUYS" },
			[DOTA_TEAM_BADGUYS] = { name = "BADGUYS" },
		}
		for nPlayerID,tPlayerStats in pairs( tRoundStats ) do
			local rgRow = {}
			for _,szColumn in ipairs( rgColumns ) do
				table.insert( rgRow, tostring( tPlayerStats[szColumn] or 0 ) )

				if szColumn ~= "name" then
					local team = tTeamSums[PlayerResource:GetTeam(nPlayerID)];
					team[szColumn] = ( team[szColumn] or 0 ) + ( tPlayerStats[szColumn] or 0 )
				end
			end
			table.insert( rgCells, rgRow )
		end

		-- TODO add tTeamSums to rgCells
		for _,tTeamSum in pairs( tTeamSums ) do
			local rgRow = {}
			for _,szColumn in ipairs( rgColumns ) do
				table.insert( rgRow, tostring( tTeamSum[szColumn] or 0 ) )
			end
			table.insert( rgCells, rgRow )
		end

		print( szName .. " Stats ROUND=" .. tostring(nRound) )
		PrintGrid( rgCells )
	end
end

--------------------------------------------------------------------------------

function  CNemestice:GetRandomPathablePositionWithinExclude( vPos, nRadius, nMinRadius )
-- Try to find a good position, be willing to fail and return a nil value
	local nMaxAttempts = 10
	local nAttempts = 0
	local vTryPos = nil

	if nMinRadius == nil then
		nMinRadius = nRadius
	end

	for i=1, nMaxAttempts do
		vTryPos = vPos + RandomVector( RandomFloat( nMinRadius, nRadius ) )
		if IsPositionValid( vTryPos, self.m_tExludePositions, _G.NEMESTICE_METEOR_EXCLUDE_RADIUS ) and GridNav:CanFindPath( vPos, vTryPos ) then
			return vTryPos
		end
	end

	return nil
end

--------------------------------------------------------------------------------

function CNemestice:CreateSmallMeteorCrashSites()
	local nTeamBehind = nil
	local nTeamAhead = nil
	if self:GetTowersControlledBy( DOTA_TEAM_GOODGUYS ) > self:GetTowersControlledBy( DOTA_TEAM_BADGUYS ) then
		nTeamBehind = DOTA_TEAM_BADGUYS
		nTeamAhead = DOTA_TEAM_GOODGUYS
	else
		nTeamBehind = DOTA_TEAM_GOODGUYS
		nTeamAhead = DOTA_TEAM_BADGUYS
	end


	local nMeteorsRemaining = NEMESTICE_METEOR_DROP_COUNT -- * self:GetRoundNumber()
	print( "creating " .. nMeteorsRemaining .. " meteors" )

	local nExtraMeteorForWinningTeam = nMeteorsRemaining % 2
	local nBehindTeamMeteors = math.floor( nMeteorsRemaining / 2 )
	local nAheadTeamMeteors = math.floor( nMeteorsRemaining / 2 ) + nExtraMeteorForWinningTeam

	
	local bCreateItems = true
	local nMaxItemsForGameTime = 4 * self:GetRoundNumber() * 2
	if #self.m_vecNeutralItemDrops >= nMaxItemsForGameTime then
		bCreateItems = false
	end

	local nIndexOffset = 0
	local bFarthest = false
	local flBonusDelay = 2.0
	local bItemCreated = false

	local tBehindTeamHeroes2 = FindUnitsInRadius( nTeamBehind, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false )
	local tBehindTeamHeroes = {}
	for _,hHero in ipairs( tBehindTeamHeroes2 ) do
		if IsPositionValid( hHero:GetAbsOrigin(), self.m_tExludePositions, _G.NEMESTICE_METEOR_EXCLUDE_RADIUS ) then
			table.insert( tBehindTeamHeroes, hHero )
		end
	end
	nBehindTeamMeteors = math.min( nBehindTeamMeteors, #tBehindTeamHeroes )
	while nBehindTeamMeteors > 0 and #tBehindTeamHeroes > 0 do
		local nIndexOfHero = nil
		if bFarthest then
			nIndexOfHero = 1 + nIndexOffset
		else
			nIndexOfHero = #tBehindTeamHeroes - nIndexOffset
		end

		bFarthest = not bFarthest
		nIndexOffset = nIndexOffset + 1
		if nIndexOffset >= #tBehindTeamHeroes then
			nIndexOffset = 0
		end

		local hHero = tBehindTeamHeroes[ nIndexOfHero ]
		if hHero and hHero:IsRealHero() then
			nBehindTeamMeteors = nBehindTeamMeteors - 1
			local nTeamItem = nil
			if bCreateItems and not bItemCreated then
				nTeamItem = nTeamBehind
				bItemCreated = true
			end
			local vCrashPos = self:GetRandomPathablePositionWithinExclude( hHero:GetAbsOrigin(), 0, 600 )
			if vCrashPos ~= nil then
				self:StartMeteorCrash( vCrashPos, flBonusDelay, nTeamItem, NEMESTICE_METEOR_SIZE_SMALL, false )
			end
			flBonusDelay = flBonusDelay + 2.0
		end
	end

	nIndexOffset = 0
	bFarthest = false
	flBonusDelay = 2.0
	bItemCreated = false
	local tAheadTeamHeroes2 = FindUnitsInRadius( nTeamAhead, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false )
	local tAheadTeamHeroes = {}
	for _,hHero in ipairs( tAheadTeamHeroes2 ) do
		if IsPositionValid( hHero:GetAbsOrigin(), self.m_tExludePositions, _G.NEMESTICE_METEOR_EXCLUDE_RADIUS ) then
			table.insert( tAheadTeamHeroes, hHero )
		end
	end
	nAheadTeamMeteors = math.min( nAheadTeamMeteors, #tAheadTeamHeroes )
	while nAheadTeamMeteors > 0 and #tAheadTeamHeroes > 0 do
		local nIndexOfHero = nil
		if bFarthest then
			nIndexOfHero = 1 + nIndexOffset
		else
			nIndexOfHero = #tAheadTeamHeroes - nIndexOffset
		end

		bFarthest = not bFarthest
		nIndexOffset = nIndexOffset + 1
		if nIndexOffset >= #tAheadTeamHeroes then
			nIndexOffset = 0
		end

		local hHero = tAheadTeamHeroes[ nIndexOfHero ]
		if hHero and hHero:IsRealHero() then
			nAheadTeamMeteors = nAheadTeamMeteors - 1
			local nTeamItem = nil
			if bCreateItems and not bItemCreated then
				nTeamItem = nTeamAhead
				bItemCreated = true
			end
			local vCrashPos = self:GetRandomPathablePositionWithinExclude( hHero:GetAbsOrigin(), 0, 600 )
			if vCrashPos ~= nil then
				self:StartMeteorCrash( vCrashPos, flBonusDelay, nTeamItem, NEMESTICE_METEOR_SIZE_SMALL, false )
			end
			flBonusDelay = flBonusDelay + 2.0
		end
	end

	self.m_flNextSmallMeteorCrashTime = self.m_flNextSmallMeteorCrashTime + RandomFloat( NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_MIN, NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_MAX ) * ( 1.0 - self:GetRoundNumber() * NEMESTICE_SMALL_METEOR_CRASH_SITE_INTERVAL_PER_ROUND_DECREASE )
end

--------------------------------------------------------------------------------

function CNemestice:CreateMediumMeteorCrashSites()
	if NEMESTICE_MEDIUM_METEORS_ENABLED then
		local tCrashSites = Entities:FindAllByName( "medium_meteor_spawner" )
		if tCrashSites ~= nil then
			for i = #tCrashSites,1,-1 do
				local hCrashSite = tCrashSites[ i ]
				local hMeteors = Entities:FindByClassnameWithin( nil, "npc_dota_meteor_crash_site", hCrashSite:GetAbsOrigin(), 500 )
				if hMeteors and #hMeteors > 0 then
					for _, hMeteor in pairs ( hMeteors ) do
						hMeteor:ForceKill( false )
					end
				end
			end

			for i = #tCrashSites,1,-1 do
				local hCrashSite = tCrashSites[ i ]
				self:StartMeteorCrash( hCrashSite:GetAbsOrigin(), _G.NEMESTICE_METEOR_WARNING_TIME - 2.0, nTeam, NEMESTICE_METEOR_SIZE_MEDIUM, false )
			end
		end

		self.m_flNextMediumMeteorCrashTime = self.m_flNextMediumMeteorCrashTime + NEMESTICE_MEDIUM_METEOR_CRASH_SITE_INTERVAL
	end
end

--------------------------------------------------------------------------------

function CNemestice:CreateLargeMeteorCrashSites()
	local tCrashSites = Entities:FindAllByName( "meteor_spawn_point" )
	if tCrashSites ~= nil then
		for i = #tCrashSites,1,-1 do
			local hCrashSite = tCrashSites[ i ]
			local hMeteors = Entities:FindByClassnameWithin( nil, "npc_dota_meteor_crash_site", hCrashSite:GetAbsOrigin(), 500 )
			if hMeteors and #hMeteors > 0 then
				for _, hMeteor in pairs ( hMeteors ) do
					hMeteor:ForceKill( false )
				end
			end
		end

		if #tCrashSites > 0 then
			local hCrashSite = tCrashSites[ RandomInt( 1, #tCrashSites )]
			self:StartMeteorCrash( hCrashSite:GetAbsOrigin(), _G.NEMESTICE_METEOR_WARNING_TIME - 2.0, nil, NEMESTICE_METEOR_SIZE_LARGE, false ) --vSpawnPos, flExtraDelay, nCreateItemTeam, bBigMeteor, bFakeCinematicCrash )

			FireGameEvent( "meteor_announce", { } )	


			for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero then
					local nScreenParticleFX = ParticleManager:CreateParticleForPlayer( "particles/meteor_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero, PlayerResource:GetPlayer( nPlayerID ) )
					table.insert( self.nFXMeteorScreenParticleIndices, nScreenParticleFX )
				end
			end

			self.flEndMeteorScreenTime = self.m_flNextLargeMeteorCrashTime + _G.NEMESTICE_METEOR_WARNING_TIME
		end

		self.m_flNextLargeMeteorCrashTime = self.m_flNextLargeMeteorCrashTime + NEMESTICE_LARGE_METEOR_CRASH_SITE_INTERVAL
	end
end

--------------------------------------------------------------------------------

function CNemestice:CreateFakeCinematicMeteorCrashSite()
	local tCrashSites = Entities:FindAllByName( "meteor_spawn_point" )
	if tCrashSites ~= nil then
		if #tCrashSites > 0 then
			local hCrashSite = tCrashSites[ RandomInt( 1, #tCrashSites )]
			self:StartMeteorCrash( hCrashSite:GetAbsOrigin(), _G.NEMESTICE_METEOR_WARNING_TIME_FAKE_CINEMATIC_METEOR - 2.0, nil, NEMESTICE_METEOR_SIZE_LARGE, true ) --vSpawnPos, flExtraDelay, nCreateItemTeam, bBigMeteor, bFakeCinematicCrash )

			for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hHero then
					local nScreenParticleFX = ParticleManager:CreateParticleForPlayer( "particles/meteor_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero, PlayerResource:GetPlayer( nPlayerID ) )
					table.insert( self.nFXMeteorScreenParticleIndices, nScreenParticleFX )
				end
			end

			self.flEndMeteorScreenTime = self.m_flNextLargeMeteorCrashTime + _G.NEMESTICE_METEOR_WARNING_TIME_FAKE_CINEMATIC_METEOR
		end
	end
end

--------------------------------------------------------------------------------

function CNemestice:StartMeteorCrash( vSpawnPos, flExtraDelay, nCreateItemTeam, nMeteorSize, bFakeCinemticCrash )
	if self.hDummyCaster == nil then
		self.hDummyCaster = CreateUnitByName( "npc_dota_dummy_caster", Vector( 0, 0, 0 ), true, nil, nil, DOTA_TEAM_CUSTOM_1 )
		if self.hDummyCaster == nil then
			print ( "ERROR!  Dummy caster is nil." )
			return
		end
	end

	local hMeteorCrashSiteAbility = self.hDummyCaster:FindAbilityByName( "meteor_crash_site" )
	if hMeteorCrashSiteAbility == nil then
		hMeteorCrashSiteAbility = self.hDummyCaster:AddAbility( "meteor_crash_site" )
		if hMeteorCrashSiteAbility == nil then
			print( "ERROR! Crash site ability is nil" )
			return
		end
	end

	if hMeteorCrashSiteAbility:GetLevel() < 1 then
		print( "crash site ability was not upgraded" )
		hMeteorCrashSiteAbility:UpgradeAbility( true )
	end

	hMeteorCrashSiteAbility.bFakeCinemticCrash = bFakeCinemticCrash
	hMeteorCrashSiteAbility.flExtraDelay = flExtraDelay
	hMeteorCrashSiteAbility.nCreateItemTeam = nCreateItemTeam
	hMeteorCrashSiteAbility.nMeteorSize = nMeteorSize
	--print( "trying to create meteor at pos ( " .. vSpawnPos.x .. ", " .. vSpawnPos.y .. ", " .. vSpawnPos.z .. ")" )
	--print( hMeteorCrashSiteAbility.bBigMeteor )
	self.hDummyCaster:CastAbilityOnPosition( vSpawnPos, hMeteorCrashSiteAbility, -1 )
end

--------------------------------------------------------------------------------

function CNemestice:GetDummyCasterForPlayer( nPlayerID, szAbilityName ) -- returns tuple hDummy, hAbility
	local hDummy = self.m_tDummyCasters[ nPlayerID ]
	if hDummy == nil or hDummy:IsNull() == true then
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		hDummy = CreateUnitByName( "npc_dota_dummy_caster", Vector( 0, 0, 0 ), true, hHero, hHero, PlayerResource:GetTeam( nPlayerID ) )
		hDummy:SetControllableByPlayer( nPlayerID, true )
		self.m_tDummyCasters[ nPlayerID ] = hDummy
	end

	local hAbility = hDummy:FindAbilityByName( szAbilityName )
	if hAbility == nil then
		hAbility = hDummy:AddAbility( szAbilityName )
		hAbility:UpgradeAbility( true )
	end

	return hDummy, hAbility
end

--------------------------------------------------------------------------------

function CNemestice:PlayerExecuteAbility( nPlayerID, nCasterIndex, nAbilityIndex )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "player_execute_ability", {
		ability_ent_index = nAbilityIndex,
		caster_ent_index = nCasterIndex
	} )
end

--------------------------------------------------------------------------------

function CNemestice:UpgradeTower( hTower, szUpgradeName )
	if hTower == nil or hTower:IsNull() or hTower:IsAlive() == false then
		print( "ERROR, tower invalid, send UI error" )
		return
	end

	if szUpgradeName == "tower_upgrade_add_lane_creeps" then
        -- Special case. This becomes either tower_upgrade_spawn_melee_creeps or tower_upgrade_spawn_ranged_creeps
        local hMeleeAbility = hTower:FindAbilityByName( "tower_upgrade_spawn_melee_creeps" )
        local hRangedAbility = hTower:FindAbilityByName( "tower_upgrade_spawn_ranged_creeps" )
        if math.floor( ( ( hMeleeAbility and hMeleeAbility:GetLevel() ) or 0 ) / 2 ) <= ( ( hRangedAbility and hRangedAbility:GetLevel() ) or 0 ) then
            szUpgradeName = "tower_upgrade_spawn_melee_creeps"
        else
            szUpgradeName = "tower_upgrade_spawn_ranged_creeps"
        end
    end

	local tUpgrade = NEMESTICE_METEOR_UPGRADES[szUpgradeName]
	if tUpgrade == nil then
		print( "ERROR, upgrade invalid, send UI error" )
		return
	end

	local hTowerAbility = hTower:FindAbilityByName( szUpgradeName )
	if hTowerAbility == nil then
		hTowerAbility = hTower:AddAbility( szUpgradeName )
		if hTowerAbility == nil then
			print ( "ERROR - failed to create tower ability " .. szUpgradeName )
			return
		end
		--hTowerAbility:UpgradeAbility( true )
		hTowerAbility.nType = tUpgrade[ "nType" ]
		else
			if hTowerAbility:GetLevel() >= hTowerAbility:GetMaxLevel() or hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY then
			print( "ERROR - ability is at max level" )
			return
		end
	end

	if hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY then
		while hTowerAbility:GetLevel() < math.max( 1, self:GetRoundNumber() ) do
			hTowerAbility:UpgradeAbility( true )
		end    
	else
		hTowerAbility:UpgradeAbility( true )
	end

	if hTower.nNumUpgrades == nil then
		hTower.nNumUpgrades = 1
	else
		hTower.nNumUpgrades = hTower.nNumUpgrades + 1
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/generic_hero_status/hero_levelup.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTower )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	hTower:SetModelScale( 1 + NEMESTICE_TOWER_MODEL_SCALE_PER_UPGRADE * hTower.nNumUpgrades )
	
	self.m_bMapStateUpdated = true

	if hTowerAbility.GetUpgradeBuildingName then
		if hTowerAbility.tUpgradeBuildings == nil then
			hTowerAbility.tUpgradeBuildings = {}
		else
			if hTowerAbility.nUpgradesBeforeNewBuilding == nil then
				printf( "ERROR! Tower abilty %s on tower %s has %d buildings in table but has nil nUpgradesBeforeNewBuilding", hTowerAbility:GetAbilityName(), hTower:GetName(), #hTowerAbility.tUpgradeBuildings )
			end
		end
		if hTowerAbility.nUpgradesBeforeNewBuilding == nil then
			hTowerAbility.nUpgradesBeforeNewBuilding = 0
		end

		if hTowerAbility.nUpgradesBeforeNewBuilding == 0 then
			hTowerAbility.nUpgradesBeforeNewBuilding = 99999999
			local szUpgradeBuildingName = hTowerAbility:GetUpgradeBuildingName()

			local hPlace = nil

			if szUpgradeBuildingName == "npc_dota_nemestice_ability_building" or szUpgradeBuildingName == "npc_dota_nemestice_shrine" then
				if hTowerAbility:GetBuildingType() == "mortar" then
					hPlace = hTower.mortarPosition
				elseif hTowerAbility:GetBuildingType() == "shrine" then
					hPlace = hTower.shrinePosition
				end
			else
				ScriptAssert( #hTower.freeBuildingPositions > 0, "Tower has no free building slots left!" )
				if #hTower.freeBuildingPositions > 0 then
					local nPlaceIndex = RandomInt( 1, #hTower.freeBuildingPositions )
					hPlace = hTower.freeBuildingPositions[nPlaceIndex]
					table.remove( hTower.freeBuildingPositions, nPlaceIndex )
				end
			end

			if hPlace ~= nil then
				vPos = hPlace:GetAbsOrigin()
			else
				vPos = hTower:GetAbsOrigin() + RandomVector( RandomFloat( 250, 500 ) )
			end

			local nTeamNumber = hTower:GetTeamNumber()
			if hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY then
				nTeamNumber = DOTA_TEAM_CUSTOM_1
			end

			local hBuilding = nil
			if hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER then
				local flModelScale = 1
				local flPedestalScale = 1.1
				local szModelName = nil
				if szUpgradeName == "tower_upgrade_spawn_kobolds" then
					szModelName = "models/creeps/n_creep_crystal_kobold/kobold_c/n_creep_crystal_kobold.vmdl"
					flModelScale = 1.75
				end 
				if szUpgradeName == "tower_upgrade_spawn_hellbears" then
					szModelName = "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_crystal_furbolg.vmdl"
					flModelScale = 1.6
				end 
				if szUpgradeName == "tower_upgrade_spawn_troll_priests" then
					szModelName = "models/creeps/n_creep_crystal_trolls/n_creep_crystal_troll_high_priest.vmdl"
					flModelScale = 1.5
				end

				if szModelName == nil then
					print( "error, no model?" )
				end
				hBuilding = SpawnEffigyOfUnitOrModel( szModelName, nTeamNumber, hPlace:GetAbsOrigin(), hPlace:GetAnglesAsVector(), flModelScale, flPedestalScale, 7 )
				
			else
				hBuilding = CreateUnitByName( szUpgradeBuildingName, vPos, true, hTower, hTower, hTower:GetTeamNumber() )
				if hBuilding == nil then
					print ( "ERROR - failed to create upgrade building " .. szUpgradeBuildingName )
					return
				end
			end
		
			hBuilding.buildingPosition = hPlace

			for i = 0, DOTA_MAX_ABILITIES - 1 do
				local hAbility = hBuilding:GetAbilityByIndex( i )
				if hAbility then
					hAbility:UpgradeAbility( true )
				end
			end

			local flDuration = 7
			local hTowerRebuildingBuff = hTower:FindModifierByName( "modifier_barracks_rebuilding" ) 
			if hTowerRebuildingBuff then
				flDuration = hTowerRebuildingBuff:GetRemainingTime()
			end

			hBuilding:AddNewModifier( nil, nil, "modifier_barracks_rebuilding", { duration = flDuration } )
			hBuilding:SetAbsOrigin( vPos )

			local vAngles = hBuilding:GetAnglesAsVector()
			hBuilding:SetAbsAngles( vAngles.x, RandomFloat( 0, 360 ), vAngles.z )
			ResolveNPCPositions( vPos, 250.0 )

			local entities = FindUnitsInRadius( hBuilding:GetTeamNumber(), vPos, nil, 250, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false ) 
			if #entities > 0 then
				for _,entity in pairs( entities ) do
					FindClearSpaceForUnit( entity, vPos, false )
				end
			end

			table.insert( hTowerAbility.tUpgradeBuildings, hBuilding )
			hBuilding.hTower = hTower
			hBuilding.hTowerAbility = hTowerAbility

			if hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_SPAWNER then
				hBuilding:AddNewModifier( nil, nil, "modifier_tower_upgrade_spawner_building", {} )

			elseif hTowerAbility.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY then
				local hBuildingAbility = hBuilding:AddAbility( szUpgradeName )
				hBuildingAbility:UpgradeAbility( true )
				while hBuildingAbility:GetLevel() < math.max( 1, self:GetRoundNumber() ) do
					hBuildingAbility:UpgradeAbility( true )
				end    
				hBuilding.hBuildingAbility = hBuildingAbility
				hBuilding:AddNewModifier( hBuilding, nil, "modifier_ability_building", { ability_name = szUpgradeName } )
			end
		else
			hTowerAbility.nUpgradesBeforeNewBuilding = hTowerAbility.nUpgradesBeforeNewBuilding - 1
			local hBuilding = hTowerAbility.tUpgradeBuildings[ #hTowerAbility.tUpgradeBuildings ]
			if hBuilding then
				hBuilding:AddNewModifier( nil, nil, "modifier_barracks_rebuilding", { duration=7 } )
				hBuilding:SetModelScale( hBuilding:GetModelScale() + NEMESTICE_TOWER_MODEL_SCALE_PER_UPGRADE )

				if hBuilding.hBuildingAbility ~= nil then
					while hBuilding.hBuildingAbility:GetLevel() < math.max( 1, self:GetRoundNumber() ) do
						hBuilding.hBuildingAbility:UpgradeAbility( true )
					end    
					hBuilding.hBuildingAbility:EndCooldown()
				end
			end
		end			
	end

	return hTowerAbility:GetLevel()
end

--------------------------------------------------------------------------------

function CNemestice:CreateMeteorShard( szReason, vSpawn, nShardAmount, flDieTime )
	local hMeteorShard = CreateItem( "item_meteor_shard", nil, nil )
	hMeteorShard:SetPurchaseTime( 0 )
	hMeteorShard:SetPurchaser( nil )
	hMeteorShard:SetCurrentCharges( nShardAmount )
	hMeteorShard.szReason = szReason
	if flDieTime == nil then
		flDieTime = GameRules:GetGameTime() + _G.NEMESTICE_METEOR_ENERGY_DURATION
	end
	hMeteorShard.flDieTime = flDieTime

	local hPhysicalMeteorShard = CreateItemOnPositionSync( vSpawn, hMeteorShard )
	hPhysicalMeteorShard:SetModel( GetRandomElement( NEMESTICE_METEOR_SHARD_MODELS ) )

	return hMeteorShard, hPhysicalMeteorShard
end

--------------------------------------------------------------------------------

function CNemestice:BroadcastMapState()
	local tTowers = {}
	
	for szTowerName,tSpawner in pairs( self.tCreepSpawners ) do
		local hBuilding = tSpawner.building

		if hBuilding ~= nil and hBuilding:IsNull() == false and hBuilding:IsAlive() then
			local tState =
			{
				entindex = hBuilding:entindex(),
				upgrades = {}
			}

			for i=0,DOTA_MAX_ABILITIES-1 do
				local hAbility = hBuilding:GetAbilityByIndex( i )
				if hAbility then
					local szAbilityName = hAbility:GetName()
					local tUpgrade = NEMESTICE_METEOR_UPGRADES[ szAbilityName ]
					if tUpgrade then
						if tUpgrade.nType == NEMESTICE_METEOR_UPGRADE_TYPE_ABILITY then
							tState.upgrades[ szAbilityName ] = 1
						else
							tState.upgrades[ szAbilityName ] = hAbility:GetLevel()
						end
					end
				end
			end

			tTowers[ szTowerName ] = tState
		else
			tTowers[ szTowerName ] =
			{
				entindex = tSpawner.dummyBuilding:entindex(),
				upgrades = {}
			}
		end
	end

	local tLanes = {}
	local nLane = 1
	for szTowerName,tSpawner in pairs( self.tCreepSpawners ) do
		local hBuilding = tSpawner.building
		-- Only compute for Radiant, since lanes are bidirectional
		if hBuilding ~= nil and hBuilding:IsNull() == false and hBuilding:IsAlive() and hBuilding:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			for _,szAdjancentName in pairs( self.m_tTowerGraph[szTowerName] ) do
				--local tPairing = { tower1 = hBuilding:entindex(), tower2 = self.tCreepSpawners[szAdjancentName].building:entindex() }
				local tPairing = { tower1 = szTowerName, tower2 = szAdjancentName }
				tLanes[ "lane" .. nLane ] = tPairing
				printf( "Exported tower pairing %d: %s to %s", nLane, szTowerName, szAdjancentName )
				nLane = nLane + 1
			end
		end
	end
	CustomNetTables:SetTableValue( "mapstate", "towers", tTowers )
	CustomNetTables:SetTableValue( "mapstate", "lanes", tLanes )
end

--------------------------------------------------------------------------------

function CNemestice:IsTowerUnderAttack( szSpawnerName )
	local tSpawner = self.tCreepSpawners[ szSpawnerName ]
	if tSpawner == nil then
		print ( false )
		return false
	end

	local hBuilding = tSpawner.building
	return hBuilding ~= nil and hBuilding.nLastHurtTime ~= nil and hBuilding.nLastHurtTime + 5 > GameRules:GetGameTime()
end

--------------------------------------------------------------------------------

function CNemestice:SendClientUpdate()
	local nRadiantUpgrades = self:GetCurrentUpgradesForTeam( DOTA_TEAM_GOODGUYS)
	local nDireUpgrades = self:GetCurrentUpgradesForTeam( DOTA_TEAM_BADGUYS )

	CustomNetTables:SetTableValue( "globals", "values", { 
		GameState = self.m_GameState,
		RoundNumber = self:GetRoundNumber(),
		TimePhaseStarted = self.m_flTimePhaseStarted,
		TimePhaseEnds = self.m_flTimePhaseEnds,
		TimePlayedCached = self.m_flPlayedTime,
		RadiantTowers = self:GetTowersControlledBy( DOTA_TEAM_GOODGUYS, false ),
		DireTowers = self:GetTowersControlledBy( DOTA_TEAM_BADGUYS, false ),
		RadiantUpgrades = nRadiantUpgrades,
		DireUpgrades = nDireUpgrades,
		TowersUnderAttack = TableMap( self.tCreepSpawners, function( szSpawnerName ) return self:IsTowerUnderAttack( szSpawnerName ) end ),
		NextMeteorCrashTime = self.m_flNextLargeMeteorCrashTime + NEMESTICE_METEOR_WARNING_TIME + 3.0, -- 3.0 = -2 from flExtraDelay, 4 from meteor_delay, and 1 from ???
		MeteorEntindex = self.hBigMeteor and not self.hBigMeteor:IsNull() and self.hBigMeteor:entindex(),
		MeteorState = self.m_nLargeMeteorState
	} )
	
	GameRules:GetGameModeEntity():SetCustomRadiantScore( nRadiantUpgrades )
	GameRules:GetGameModeEntity():SetCustomDireScore( nDireUpgrades )
end

--------------------------------------------------------------------------------

function CNemestice:GetEventGameDetails( nPlayerID )
	local szAccountID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )

	if not self.mm_hEventGameDetails then
		return nil
	end

	for nPlayerRecord = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		local szPlayerRecord = string.format( "Player%d", nPlayerRecord )
		if self.m_hEventGameDetails[szPlayerRecord] ~= nil then
			local szRecordAccountID = self.m_hEventGameDetails[szPlayerRecord]['account_id']
			if szRecordAccountID ~= nil and szRecordAccountID == szAccountID then
				return self.m_hEventGameDetails[szPlayerRecord]
			end
		end
	end

	return nil

end

--------------------------------------------------------------------------------

function CNemestice:GrantTeamBattlePoints( nTeamNumber, nBattlePoints, szReason, nPlayerID, nPlayerID2 )
	if nBattlePoints < 1 then
		return
	end

	printf( "Trying to grant team %d BP points for %s, value = %d", nTeamNumber, szReason, self.m_BPGrants[ nTeamNumber ][ szReason ] )

	if self.m_BPGrants[ nTeamNumber ][ szReason ] == 0 then
		self.m_BPGrants[ nTeamNumber ][ szReason ] = 1
	else
		return
	end

	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["int_value"] = nBattlePoints

	if szReason == "first_tower" then
		if nTeamNumber == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#Nemestice_BattlePointsFound_RadiantFirstTower"
		else
			gameEvent["message"] = "#Nemestice_BattlePointsFound_DireFirstTower"
		end

	elseif szReason == "shrine_teamfight" then
		gameEvent[ "player_id" ] = nPlayerID -- Shrine caster
		if nTeamNumber == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#Nemestice_BattlePointsFound_RadiantShrineTeamfight"
		else
			gameEvent["message"] = "#Nemestice_BattlePointsFound_DireShrineTeamfight"
		end

	elseif szReason == "meteor_stun" then
		--gameEvent[ "player_id" ] = nPlayerID -- stunner
		--gameEvent[ "player_id2" ] = nOtherPlayerID -- victim
		if nTeamNumber == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#Nemestice_BattlePointsFound_RadiantMeteorStun"
		else
			gameEvent["message"] = "#Nemestice_BattlePointsFound_DireMeteorStun"
		end

	elseif szReason == "neutral_steal" then
		if nTeamNumber == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#Nemestice_BattlePointsFound_RadiantNeutralSteal"
		else
			gameEvent["message"] = "#Nemestice_BattlePointsFound_DireNeutralSteal"
		end

	elseif szReason == "full_channel" then
		if nTeamNumber == DOTA_TEAM_GOODGUYS then
			gameEvent["message"] = "#Nemestice_BattlePointsFound_RadiantFullChannel"
		else
			gameEvent["message"] = "#Nemestice_BattlePointsFound_DireFullChannel"
		end
	end
	
	if gameEvent["message"] ~= nil then
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:IsValidTeamPlayerID( nPlayerID ) and PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
			self:GrantPlayerBattlePoints( nPlayerID, nBattlePoints, szReason )
		end
	end
end
	
--------------------------------------------------------------------------------

function CNemestice:GrantPlayerBattlePoints( nPlayerID, nBattlePoints, szReason, bDisplay, nOtherPlayerID )
	if nBattlePoints < 1 then
		return
	end
	
	local nOrigBattlePoints = nBattlePoints
	nBattlePoints = self:ModifyPointsCapRemaining( nPlayerID, nBattlePoints )
	print ( "Awarding player " .. nPlayerID .. " " .. nBattlePoints .. " battle points for " .. szReason )
	self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ] = self.SignOutTable[ "player_list" ][ nPlayerID ][ "battle_points" ] + nBattlePoints

	-- Message
	--[[if bDisplay == true then
		local gameEvent = {}
		gameEvent[ "teamnumber" ] = -1
		gameEvent[ "int_value" ] = nBattlePoints

		--if szReason == "whatever"
		--end
		if gameEvent["message"] ~= nil then
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end--]]

	-- FX
	local nDigits = string.len( tostring( nBattlePoints ) )
	local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if Hero then	
		local nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/msg_fx/msg_bp.vpcf", PATTACH_CUSTOMORIGIN, nil, Hero:GetPlayerOwner() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, Hero, PATTACH_OVERHEAD_FOLLOW, nil, Hero:GetOrigin() + Vector( 0, 64, 96 ), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0, nBattlePoints, -1 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, nDigits + 1, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 233, 159, 184 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nFXIndex2 = ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/battle_point_splash.vpcf", PATTACH_WORLDORIGIN, nil, Hero:GetPlayerOwner() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, Hero:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )

		Hero:EmitSoundParams( "Item.BattlePointsClaimed", 0, 0.5, 0)
	end
end

--------------------------------------------------------------------------------

function CNemestice:GetPointsCapRemaining( nPlayerID, bTotal )

	local player = self.playerInfo[ tostring( nPlayerID ) ]
	if player == nil then
		return 0
	end

	if bTotal == false then
		return player.nBPCapRemaining
	else
		return player.nBPCapTotal
	end
end

--------------------------------------------------------------------------------

function CNemestice:ModifyPointsCapRemaining( nPlayerID, nChange )

	local player = self.playerInfo[ tostring( nPlayerID ) ]
	if player == nil then
		return 0
	end

	if nChange > player.nBPCapRemaining then
		nChange = player.nBPCapRemaining
	end

	player.nBPCapRemaining = player.nBPCapRemaining - nChange

	return nChange
end

--------------------------------------------------------------------------------

function CNemestice:InitPlayerInfo()

	self.playerInfo = {}

	for nPlayerID = 0, DOTA_DEFAULT_MAX_TEAM_PLAYERS - 1 do

		local szAccountID = tostring( PlayerResource:GetSteamAccountID( nPlayerID ) )

		local hPlayerDetails = {}
		local szPlayerRecord = string.format( "Player%d", nPlayerID )
		if self.m_hEventGameDetails[szPlayerRecord] ~= nil then
			local szRecordAccountID = self.m_hEventGameDetails[szPlayerRecord]['account_id']
			if szRecordAccountID ~= nil and szRecordAccountID == szAccountID then
				hPlayerDetails = self.m_hEventGameDetails[szPlayerRecord]
			end
		end

		local info = 
		{
			nBPCapTotal = hPlayerDetails["pointcap_total"] or 0,
			nBPCapRemaining = hPlayerDetails["pointcap_remaining"] or 0,
		}

		self.playerInfo[ tostring( nPlayerID ) ] = info
	end

end

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_hero_buy_phase", "modifiers/gameplay/modifier_hero_buy_phase", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_buff", "modifiers/gameplay/modifier_creature_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barracks_buff", "modifiers/gameplay/modifier_barracks_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barracks_rebuilding", "modifiers/gameplay/modifier_barracks_rebuilding", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_upgrade_spawner_building", "modifiers/tower_upgrades/modifier_tower_upgrade_spawner_building", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hero_respawn_time", "modifiers/gameplay/modifier_hero_respawn_time", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_building", "modifiers/gameplay/modifier_ability_building", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_upgrade_tracker", "modifiers/gameplay/modifier_tower_upgrade_tracker", LUA_MODIFIER_MOTION_NONE )