require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Enraged_Wildwings == nil then
	CMapEncounter_Enraged_Wildwings = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"
	self.nCaptains = 6
	local bInvulnerable = true

	self.vWaveSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 24,
			Count = 3,
		},
	}

	self:AddSpawner( CDotaSpawner( "spawner_captain_trigger", "spawner_captain_trigger",
		{
			{
				EntityName = "npc_aghsfort_creature_enraged_wildwing",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 50.0,
			}
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szCaptainSpawner, self.szCaptainSpawner, 4, 5, 1.0,
		{
			{
				EntityName = "npc_aghsfort_creature_enraged_wildwing",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 100.0,
			},
			{
				EntityName = "npc_aghsfort_creature_tornado_harpy",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 100.0,
			},



		}, bInvulnerable ) )

	self:SetPortalTriggerSpawner( "spawner_captain_trigger", 0.8 )
	self:SetSpawnerSchedule( "spawner_captain_trigger", nil )	-- means spawn once when triggered 
	--self:SetSpawnerSchedule( self.szPeonSpawner, self.vPeonSchedule )
	self:SetSpawnerSchedule( self.szCaptainSpawner, self.vWaveSchedule )
	self:SetCalculateRewardsFromUnitCount( true )

end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:GetPreviewUnit()
	return "npc_aghsfort_creature_enraged_wildwing"
end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hWarriorSpawners = self:GetSpawner( self.szPeonSpawner )
	if hWarriorSpawners then
		nCount = nCount + hWarriorSpawners:GetSpawnPositionCount() * 2
	end

	local hChampionSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hChampionSpawners then
		nCount = nCount + hChampionSpawners:GetSpawnPositionCount()
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )
	self:AddEncounterObjective( "kill_wildwings", 0, self.nCaptains )
end
--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_aghsfort_creature_enraged_wildwing" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "kill_wildwings" )
		self:UpdateEncounterObjective( "kill_wildwings", nCurrentValue + 1, nil )
	end
end
--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:Start()
	CMapEncounter.Start( self )
	self:StartAllSpawnerSchedules( 0 )	

	--for _,Spawner in pairs ( self:GetSpawners() ) do
	--	if Spawner:GetSpawnerName() == "spawner_peon" then
	--		Spawner:SpawnUnitsFromRandomSpawners( Spawner:GetSpawnPositionCount() )
	--	else
	--		Spawner:SpawnUnitsFromRandomSpawners( self.nCaptains )
	--	end
	--end
end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:CreateEnemies()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Enraged_Wildwings:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_aghsfort_creature_enraged_wildwing_tornado" then
    	return false
    end
    return true
end


--------------------------------------------------------------------------------

return CMapEncounter_Enraged_Wildwings
