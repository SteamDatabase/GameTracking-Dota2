
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_NagaSiren == nil then
	CMapEncounter_NagaSiren = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )
	self.bMinesSpawned = false
	self.nMinesToDestroy = 4
	self.nMinesDestroyed = 0
	self.bInitialSpawn = false
	self.bSongUsed = false

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_slark_peon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 100.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{
			{
				EntityName = "npc_dota_creature_naga_siren_illusion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	-- Reinforcements:
	local bInvulnerable = true

	local vBossSchedule = { { Time = 0, Count = 1 } }

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_boss", "spawner_boss", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_naga_siren_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_naga_siren_illusion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 300.0,
			},
		}, bInvulnerable
	) )

	local vReinforcementsSchedule = { { Time = 0, Count = 4 } }

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "dynamic_portal", "dynamic_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_slark_peon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 100.0,
			},
			{
				EntityName = "npc_dota_creature_naga_siren_illusion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_peon", nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_captain", nil ) -- means spawn once when triggered
	self:SetSpawnerSchedule( "spawner_boss", vBossSchedule )
	self:SetSpawnerSchedule( "dynamic_portal", vReinforcementsSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:GetPreviewUnit()
	return "npc_dota_creature_naga_siren_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_siren", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_siren.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_slark", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_underwater_mine", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- 5 Peon Spawners
	local hPeonSpawners = self:GetSpawner( "spawner_peon" )
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 2
	end
	-- 4 Captain Spawners
	local hCaptainSpawners = self:GetSpawner( "spawner_captain" )
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnPositionCount()
	end
	--[[
	-- 1 Boss Spawner
	local hBossSpawners = self:GetSpawner( "spawner_boss" )
	if hBossSpawners then
		nCount = nCount + hBossSpawners:GetSpawnPositionCount() * 4
	end
	-- 4 Dynamic Portals
	local hReinforcementsSpawners = self:GetSpawner( "dynamic_portal" )
	if hBossSpawners then
		nCount = nCount + hReinforcementsSpawners:GetSpawnPositionCount() * 3
	end
	]]
	print( "Number of enemies = " .. nCount )
	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:Start()
	CMapEncounter.Start( self )

	self:CreateUnits()
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( getclass( self ), "OnAbilityUsed" ), self )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self.nEnemies = self:GetMaxSpawnedUnitCount()
	self:AddEncounterObjective( "defeat_all_enemies", 0, self.nEnemies )
	self:AddEncounterObjective( "destroy_all_mines", self.nMinesDestroyed, self.nMinesToDestroy )
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:CheckForCompletion()
	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )

	if not self.bInitialSpawn then
		return false
	end

	if nCurrentValue >= self.nEnemies and self.nMinesDestroyed == self.nMinesToDestroy then
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:CreateUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
	if not self.bMinesSpawned then
		self:SpawnMines()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	self.bInitialSpawn = true

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then	-- standing enemies in the map should not aggro to players
		return
	end

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		local hero = heroes[RandomInt(1, #heroes)]
		if hero ~= nil then
			--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
			hSpawnedUnit:SetInitialGoalEntity( hero )
		else
			print( "WARNING: Can't find a living hero and the objective entity is missing!" )
			hSpawnedUnit:MoveToPosition( self.hRoom:GetOrigin() )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:SpawnMines()
	--print("Spawning mines")
	local goalUnits = Entities:FindAllByName( "spawner_mine" )
	
	local mineUnit = "npc_dota_underwater_mine"
	for _, goalUnit in pairs(goalUnits) do
		local hUnit = CreateUnitByName( mineUnit, goalUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
		if hUnit ~= nil then
			--print("Placing a mine")
			hUnit:SetForwardVector( RandomVector( 1 ) )
		end
	end
	self.bMinesSpawned = true
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:OnEntityKilled( event )
	if not IsServer() then
		return
	end

	if self.bMinesSpawned == false then
		return
	end

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil or killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS then
		return
	end

	if killedUnit:IsCreature() == true then
		if killedUnit:GetUnitName() == "npc_dota_underwater_mine" then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "destroy_all_mines" )
			self:UpdateEncounterObjective( "destroy_all_mines", nCurrentValue + 1, nil )
			self.nMinesDestroyed = self.nMinesDestroyed + 1
			if self.nMinesDestroyed == self.nMinesToDestroy then
				self:StartSpawnerSchedule( "spawner_boss", 0 )
				self.nEnemies = self.nEnemies + 4
				local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
				self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
			end
		elseif killedUnit:GetUnitName() == "npc_dota_creature_slark_peon" or
			killedUnit:GetUnitName() == "npc_dota_creature_naga_siren_illusion" or
			killedUnit:GetUnitName() == "npc_dota_creature_naga_siren_boss" then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
			self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, self.nEnemies )
			if not self.bSongUsed then
				if killedUnit:GetUnitName() == "npc_dota_creature_naga_siren_boss" then
					-- Backup if Naga doesn't get to use Song
					self.bSongUsed = true
					self:StartSpawnerSchedule( "dynamic_portal", 0 )
					self.nEnemies = self.nEnemies + 8
					local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
					self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_NagaSiren:OnAbilityUsed( event )
	--print("Ability used")
	-- Add to the enemy counter if Naga uses Mirror Image
	if event.abilityname == "aghsfort_naga_siren_mirror_image" then
		--print("Naga Illusion Spawned")
		self.nEnemies = self.nEnemies + 1
		local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
		self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
	end
	-- Start the schedule for the Reinforcements if Naga uses Song
	if not self.bSongUsed then
		if event.abilityname == "naga_siren_song_of_the_siren" then
			--print("Naga used Song!")
			self.bSongUsed = true
			self:StartSpawnerSchedule( "dynamic_portal", 0 )
			self.nEnemies = self.nEnemies + 12
			local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
			self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue, self.nEnemies )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_NagaSiren
