require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_TrollWarlord == nil then
	CMapEncounter_TrollWarlord = class( {}, {}, CMapEncounter )
end


--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_troll_warlord", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_beastmaster", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_creature_sheep_hostage", context )
	PrecacheModel( "npc_dota_creature_sheep_hostage", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/league_teleport_2014/teleport_start_league.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bInitialSpawn = true
	self.bCagesSpawned = false
	self.nSheepToRescue = 4
	self.nSheepRescued = 0
	--Hack to get objectives to work
	self.nEnemies = 0

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_beastmaster_boar",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_beastmaster_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	--Spawner schedule for Troll Warlord
	local bInvulnerable = true
	local vCaptainSchedule = { { Time = 0, Count = 1 } }

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_1", "spawner_captain_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_troll_warlord_ranged",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_captain_2", "spawner_captain_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_troll_warlord_melee",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( "spawner_peon", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_captain_1", vCaptainSchedule )
	self:SetSpawnerSchedule( "spawner_captain_2", vCaptainSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:SpawnCages()
	print("Spawning cages")
	local captureUnits = Entities:FindAllByName( "spawner_cage" )
	--Shuffling the table
	local shuffledUnits = self:ShuffleCages(captureUnits)
	
	local cageUnit = "npc_dota_cage"
	local nCageID = 0
	for _, captureUnit in pairs(shuffledUnits) do

		local vSpawnLoc = captureUnit:GetAbsOrigin()
		local vAngles = VectorAngles( RandomVector( 1 ) )
		local cageTable = 
		{ 	
			MapUnitName = cageUnit, 
			origin = tostring( vSpawnLoc.x ) .. " " .. tostring( vSpawnLoc.y ) .. " " .. tostring( vSpawnLoc.z ),
			angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
			teamnumber = DOTA_TEAM_BADGUYS,
			NeverMoveToClearSpace = false,
		}

		local hUnit = CreateUnitFromTable( cageTable, vSpawnLoc )
		if hUnit ~= nil then
			--print("Placing a cage")
			nCageID = nCageID + 1
			hUnit:Attribute_SetIntValue( "cageID", nCageID )
			--Don't double count the cages
			self.nEnemies = self.nEnemies + 1
		end
	end
	self.bCagesSpawned = true

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies)

end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:StartExitPortal()
	local szPortalFX = "particles/portals/portal_ground_spawn_endpoint.vpcf"
	local PortalPoints = self:GetRoom():FindAllEntitiesInRoomByName( "dynamic_portal" )
	if PortalPoints == nil then
		--print("No Portal Points Found!")
		return
	end
	for _, hPortal in pairs ( PortalPoints ) do
		--print("Spawning Portal FX")
		local effects = ParticleManager:CreateParticle( szPortalFX, PATTACH_WORLDORIGIN, hPortal )
		ParticleManager:SetParticleControl( effects, 0, hPortal:GetAbsOrigin() )
		EmitGlobalSound("Aghsfort_DarkPortal.Created")
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	--Hack to get objectives to work
	self.nEnemies = self:GetMaxSpawnedUnitCount()
	self:AddEncounterObjective( "defeat_all_enemies", 0, self.nEnemies )
	self:AddEncounterObjective( "rescue_sheep", self.nSheepRescued, self.nSheepToRescue )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- Map has 7 peon spawners
	local hPeonSpawners = self:GetSpawner( "spawner_peon")
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 4
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:CheckForCompletion()
	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	if nCurrentValue >= self.nEnemies and self.nSheepRescued == 4 then
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:GetPreviewUnit()
	return "npc_dota_creature_troll_warlord_ranged"
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:Start()
	CMapEncounter.Start( self )
	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	if self.bInitialSpawn == true then
		self:SpawnCages()
		self.bInitialSpawn = false
	end
	
	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	if #heroes > 0 then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:OnEntityKilled( event )
	if not IsServer() then
		return
	end

	if self.bCagesSpawned == false then
		return
	end

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if killedUnit:GetUnitName() =="npc_dota_creature_beastmaster_boss" or
		killedUnit:GetUnitName() == "npc_dota_creature_beastmaster_boar" or
		killedUnit:GetUnitName() == "npc_dota_creature_troll_warlord_melee" or
		killedUnit:GetUnitName() == "npc_dota_creature_troll_warlord_ranged" or
		killedUnit:GetUnitName() == "npc_dota_cage" then
		--print(killedUnit:GetUnitName())
		local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
		self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, self.nEnemies )
	end

	--Check to see if it's a cage
	if killedUnit:GetUnitName() == "npc_dota_cage" then
		local cageAttribute = killedUnit:Attribute_GetIntValue( "cageID", -1 )
		if cageAttribute ~= -1 then
			local szHostageUnit = "npc_dota_creature_beastmaster_boar"
			local vCagePos = killedUnit:GetOrigin()
			--print("Cage has been destroyed")
			if cageAttribute < 5 then
				--print("Cage has been released")
				--self:StartExitPortal()
				self.nSheepRescued = self.nSheepRescued + 1
				--Update the objectives
				local nCurrentValue = self:GetEncounterObjectiveProgress( "rescue_sheep" )
				self:UpdateEncounterObjective( "rescue_sheep", nCurrentValue + 1, nil )
				--Spawn sheep
				szHostageUnit = "npc_dota_creature_sheep_hostage"
				local hHostage = CreateUnitByName( szHostageUnit, vCagePos, true, nil, nil, DOTA_TEAM_GOODGUYS )
				if hHostage ~= nil then
					--print("Spawning a sheep")
					local hPortal = Entities:FindByName( nil, "portal_path_track" )
					hHostage:SetInitialGoalEntity( hPortal )
					EmitSoundOn("Creature.Sheep.Spawn", hHostage)
				end
				if self.nSheepRescued == 4 then
					self:SpawnWarlord()
				end
			else
				--Don't always spawn boars
				local nRoll = RandomInt(1,2)
				if nRoll == 1 then
					local hBoar = CreateUnitByName( szHostageUnit, vCagePos, true, nil, nil, DOTA_TEAM_BADGUYS )
					hBoar:SetForwardVector( RandomVector( 1 ) )
					--Hack to get objectives to work
					self.nEnemies = self.nEnemies + 1
					local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
					self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:SpawnWarlord()
	print("Spawning Warlord")
	self:StartSpawnerSchedule( "spawner_captain_1", 0 )
	self:StartSpawnerSchedule( "spawner_captain_2", 0 )
	self.nEnemies = self.nEnemies + 2
	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrollWarlord:ShuffleCages(orig_list)
	local list = shallowcopy( orig_list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

return CMapEncounter_TrollWarlord
