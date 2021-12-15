
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_ToxicTerrace == nil then
	CMapEncounter_ToxicTerrace = class( {}, {}, CMapEncounter )
end

function CMapEncounter_ToxicTerrace:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	-- Dynamic Spawns
	self.vWaveSchedule =
	{
		{
			Time = 7,
			Count = 1,
		},
		{
			Time = 25,
			Count = 1,
		},
	}

	--DeepPrintTable( self.vWaveSchedule )

	self.szDynamicPortal = "dynamic_portal"
	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szDynamicPortal, self.szDynamicPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_alchemist",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szDynamicPortal, self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_ToxicTerrace:GetPreviewUnit()
	return "npc_dota_creature_alchemist"
end

--------------------------------------------------------------------------------

function CMapEncounter_ToxicTerrace:InitializeObjectives()
	self:AddEncounterObjective( "defeat_the_alchemists", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_ToxicTerrace:Start()
	CMapEncounter.Start( self )

	self:StartSpawnerSchedule( self.szDynamicPortal, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_ToxicTerrace:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_alchemist" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_the_alchemists" )
		self:UpdateEncounterObjective( "defeat_the_alchemists", nCurrentValue + 1, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_ToxicTerrace:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		self:SetInitialGoalEntityToNearestHero( hSpawnedUnit )
	end

end

--------------------------------------------------------------------------------

return CMapEncounter_ToxicTerrace
