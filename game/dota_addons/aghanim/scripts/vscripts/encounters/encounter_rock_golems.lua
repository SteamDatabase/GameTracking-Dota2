
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_RockGolems == nil then
	CMapEncounter_RockGolems = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.vWaveSchedule =
	{
		{
			Time = 3,
			Count = 1,
		},
		{
			Time = 25,
			Count = 2,
		},
		{
			Time = 50,
			Count = 2,
		},
	}

	local bInvulnerable = true
	self.szPortal = "dynamic_portal"

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPortal, self.szPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_rock_golem_a",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szPortal, self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:GetPreviewUnit()
	return "npc_dota_creature_rock_golem_a"
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:GetMaxSpawnedUnitCount()
	local nBigGolems = #self.PortalSpawnersV2
	local nMediumGolems = nBigGolems * 3
	local nSmallGolems = nMediumGolems * 4

	local nTotal = nBigGolems + nMediumGolems + nSmallGolems -- isn't working, it's 0
	printf( "GetMaxSpawnedUnitCount - nTotal: %d", nTotal )
	return nTotal
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_RockGolems:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szSpawnerName == self.szPortal then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		self:SetInitialGoalEntityToNearestHero( hSpawnedUnit )
	end
end

--------------------------------------------------------------------------------

--[[ necessary due to split-generated golems?
function CMapEncounter_RockGolems:CheckForCompletion()
	if self.nWaves == 0 and not self:HasRemainingEnemies() then
		return true
	end

	return false
end
]]

--------------------------------------------------------------------------------

return CMapEncounter_RockGolems
