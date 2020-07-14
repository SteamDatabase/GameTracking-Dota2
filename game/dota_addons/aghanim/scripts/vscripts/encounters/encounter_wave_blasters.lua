require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

LinkLuaModifier( "modifier_room_monster_sleep", "modifiers/modifier_room_monster_sleep", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

if CMapEncounter_WaveBlasters == nil then
	CMapEncounter_WaveBlasters = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle", "particles/generic_gameplay/generic_sleep.vpcf", context )
end


--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )
	
	self:SetCalculateRewardsFromUnitCount( true )
	self.nCaptains = 4
	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
			EntityName = "npc_aghsfort_creature_wave_blaster_ghost",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 400.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{ 
			{
				EntityName = "npc_dota_creature_wave_blaster",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )
end
--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self:AddEncounterObjective( "kill_waveblasters", 0, self.nCaptains )
end

--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_wave_blaster" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "kill_waveblasters" )
		self:UpdateEncounterObjective( "kill_waveblasters", nCurrentValue + 1, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:GetPreviewUnit()
	return "npc_dota_creature_wave_blaster"
end
--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:GetMaxSpawnedUnitCount()

	local nCount = 0

	for _,Spawner in pairs ( self.Spawners ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( Spawner )
	end

	-- Assume we get 4 ghosts per boss
	local hCaptainSpawners = self:GetSpawner( "spawner_captain" )
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnCountPerSpawnPosition() * 3
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:Start()
	CMapEncounter.Start( self )


	for _,Spawner in pairs ( self:GetSpawners() ) do
		if Spawner:GetSpawnerName() == "spawner_peon" then
			Spawner:SpawnUnitsFromRandomSpawners( Spawner:GetSpawnPositionCount() )
		else
			Spawner:SpawnUnitsFromRandomSpawners( self.nCaptains )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_WaveBlasters:OnSpawnerFinished( hSpawner, hSpawnedUnits)
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	for _,enemy in pairs( hSpawnedUnits ) do
		if enemy ~= nil then
			enemy:AddNewModifier( enemy, nil, "modifier_room_monster_sleep", { duration = 15 } )
		end
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_WaveBlasters
