
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_ZealotScarabs == nil then
	CMapEncounter_ZealotScarabs = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_zealot_scarab",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 250.0,
			},
		} ) )
	
	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{
			{
				EntityName = "npc_dota_creature_scarab_priest",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 250.0,
			},
		} ) )

	self:SetSpawnerSchedule( "spawner_peon", nil )
	self:SetSpawnerSchedule( "spawner_captain", nil )

end

--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self:AddEncounterObjective( "kill_scarab_priests", 0, self:GetSpawner( "spawner_captain" ):GetSpawnPositionCount() )
end


--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_scarab_priest" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "kill_scarab_priests" )
		self:UpdateEncounterObjective( "kill_scarab_priests", nCurrentValue + 1, nil )
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:GetPreviewUnit()
	return "npc_dota_creature_zealot_scarab"
end

--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:GetMaxSpawnedUnitCount()

	local nCount = 0

	for _,Spawner in pairs ( self.Spawners ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( Spawner )
	end

	-- Assume we get 2 nyxes per boss
	local hCaptainSpawners = self:GetSpawner( "spawner_captain" )
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnCountPerSpawnPosition() * 2
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_ZealotScarabs:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

return CMapEncounter_ZealotScarabs
