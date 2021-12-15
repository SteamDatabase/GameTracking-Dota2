require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_ForbiddenPalace == nil then
	CMapEncounter_ForbiddenPalace = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_brewmaster", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bInitialSpawn = true
	self.bOutpostsSpawned = false
	self.nOutposts = 2
	self.nOutpostsCaptured = 0
	self.nEnemies = 0
	self.nAdditionalEnemies = 11

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{ 
			{
				EntityName = "npc_dota_creature_year_beast",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_earth_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 100.0,
			},
		} ) )

	--Spawner schedule for Outposts
	local bInvulnerable = true

	local vCaptainSchedule1 = { { Time = 0, Count = 1 } }
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "captain_portal_1", "captain_portal_1", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_year_beast",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_earth_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 100.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( "captain_portal_1", vCaptainSchedule1 )

	local vCaptainSchedule2 = { { Time = 0, Count = 1 } }
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "captain_portal_2", "captain_portal_2", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_year_beast",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 0.0,
			},
			{
				EntityName = "npc_dota_creature_earth_spirit",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 100.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( "captain_portal_2", vCaptainSchedule2 )

end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "capture_outposts", self.nOutpostsCaptured, self.nOutposts )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:CheckForCompletion()
	local nCurrentOutpostValue = self:GetEncounterObjectiveProgress( "capture_outposts" )
	if ( nCurrentOutpostValue == self.nOutposts ) then
		return CMapEncounter.CheckForCompletion( self )
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:GetPreviewUnit()
	return "npc_dota_creature_year_beast"
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:Start()
	CMapEncounter.Start( self )

	self:CreateEnemies()
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:GetMaxSpawnedUnitCount()
	local nCount = 0
	-- Map has 4 peon spawners
	local hPeonSpawners = self:GetSpawner( "spawner_peon")
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 2
	end
	local hCaptainSpawners = self:GetSpawner( "spawner_captain")
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnPositionCount()
	end
	-- Add additional spawners after outposts are captured
	nCount = nCount + ( self.nAdditionalEnemies )

	print( "Number of spawned enemies = " .. nCount )
	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if self.bInitialSpawn == true then
		self:SpawnOutposts()
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

function CMapEncounter_ForbiddenPalace:SpawnOutposts()
	--print("Spawning outposts")
	--local outpostUnits = Entities:FindAllByName( "spawner_outpost" )
	local outpostUnitsTop = Entities:FindAllByName( "spawner_outpost_top" )
	local outpostUnitsBot = Entities:FindAllByName( "spawner_outpost_bot" )

	--local nRandom = RandomInt(1,2)
	local nRandomTop = RandomInt(1,2)
	local nRandomBot = RandomInt(1,2)
	local shuffledUnits = 
		{
			--outpostUnits[nRandom],
			outpostUnitsTop[nRandomTop],
			outpostUnitsBot[nRandomBot],
		}
	
	local sOutpostUnit = "npc_dota_watch_tower_outpost"
	local nOutpostID = 0
	for _,outpostUnit in pairs(shuffledUnits) do

		local vSpawnLoc = outpostUnit:GetAbsOrigin()
		local vAngles = VectorAngles( RandomVector( 1 ) )
		local outpostTable = 
		{ 	
			MapUnitName = sOutpostUnit, 
			origin = tostring( vSpawnLoc.x ) .. " " .. tostring( vSpawnLoc.y ) .. " " .. tostring( vSpawnLoc.z ),
			angles = tostring( vAngles.x ) .. " " .. tostring( vAngles.y ) .. " " .. tostring( vAngles.z ),
			teamnumber = DOTA_TEAM_BADGUYS,
			NeverMoveToClearSpace = false,
		}

		local hUnit = CreateUnitFromTable( outpostTable, vSpawnLoc )
		if hUnit ~= nil then
			--print("Unlocking Outpost")
			-- Outposts spawn invulnerable, and are only made capturable after early towers are knocked down.
			-- We short-circuit this by removing the modifiers.
			hUnit:RemoveModifierByName( "modifier_invulnerable" )
			hUnit:RemoveModifierByName( "modifier_watch_tower_invulnerable" )

			-- Outposts set their team based on their name. We override this after spawn.
			hUnit:ChangeTeam( DOTA_TEAM_BADGUYS )
		end
	end
	self.bOutpostsSpawned = true

end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:OnOutpostCaptured( event )
	CMapEncounter.OnOutpostCaptured( self, event )
	
	local nOutpost = event.entindex
	local hOutpost = EntIndexToHScript(nOutpost)
	local nTeam = event.team_number
	local nOldTeam = event.old_team_number
	if nTeam == DOTA_TEAM_GOODGUYS and nOldTeam == DOTA_TEAM_BADGUYS then
		print( "Outpost has been captured" )
		self.nOutpostsCaptured = self.nOutpostsCaptured + 1
		--Make the outpost invulnerable
		hOutpost:AddNewModifier( hOutpost, nil, "modifier_invulnerable", { duration = -1 } )
		hOutpost:AddNewModifier( hOutpost, nil, "modifier_watch_tower_invulnerable", { duration = -1 } )
		--Update the objectives
		self:UpdateEncounterObjective( "capture_outposts", self.nOutpostsCaptured, nil )
		self:SpawnAdditionalWave( self.nOutpostsCaptured )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_ForbiddenPalace:SpawnAdditionalWave( nWave )
	if nWave == 1 then
		self:StartSpawnerSchedule( "captain_portal_1", 0 )
	else
		self:StartSpawnerSchedule( "captain_portal_2", 0 )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_ForbiddenPalace
