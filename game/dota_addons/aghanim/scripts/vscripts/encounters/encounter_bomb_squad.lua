require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Bomb_Squad == nil then
	CMapEncounter_Bomb_Squad = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------


function CMapEncounter_Bomb_Squad:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )
	
	self:SetCalculateRewardsFromUnitCount( true )
	
	self.vPudgeSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 20,
			Count = 3,
		},
		{
			Time = 40,
			Count = 4,
		},
	}

	self.vBombSquadSchedule =
	{
		{
			Time = 0,
			Count = 1,
		},
		{
			Time = 20,
			Count = 2,
		},
		{
			Time = 40,
			Count = 2,
		},

	}

	self.szPeonSpawner = "spawner_peon"
	self.szCaptainSpawner = "spawner_captain"
	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPeonSpawner, self.szPeonSpawner, 60 * hRoom:GetDepth(), 5, 1.0,
		{
			{
				EntityName = "npc_aghsfort_creature_walrus_pudge",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szCaptainSpawner, self.szCaptainSpawner, 60 * hRoom:GetDepth(), 5, 1.0,
		{
			{
				EntityName = "npc_aghsfort_creature_bomb_squad",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( self.szPeonSpawner, self.vPudgeSchedule )
	self:SetSpawnerSchedule( self.szCaptainSpawner, self.vBombSquadSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bomb_Squad:GetPreviewUnit()
	return "npc_aghsfort_creature_bomb_squad"
end


--------------------------------------------------------------------------------

function CMapEncounter_Bomb_Squad:Start()
	CMapEncounter.Start( self )

	for _, hSpawner in pairs( self:GetSpawners() ) do
		hSpawner:SpawnUnits()
	end

	self:StartSpawnerSchedule( self.szPeonSpawner, 0 )
	self:StartSpawnerSchedule( self.szCaptainSpawner, 0 )
end


--------------------------------------------------------------------------------

function CMapEncounter_Bomb_Squad:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vPudgeSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bomb_Squad:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szSpawnerName == "spawner_peon" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
end
--------------------------------------------------------------------------------

function CMapEncounter_Bomb_Squad:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_aghsfort_creature_bomb_squad_landmine" then
    	return false
    end
    if hEnemyCreature:GetUnitName() == "npc_aghsfort_creature_bomb_squad_stasis_trap" then
    	return false
    end
    return true
end

--------------------------------------------------------------------------------

return CMapEncounter_Bomb_Squad
