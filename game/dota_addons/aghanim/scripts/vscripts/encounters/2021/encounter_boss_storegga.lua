
require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossStoregga == nil then
	CMapEncounter_BossStoregga = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.szRockSpawner_1 = "spawner_rock1"
	self.szRockSpawner_2 = "spawner_rock2"
	self.szRockSpawner_3 = "spawner_rock3"
	self.szBossSpawner = "spawner_boss"

	self.Rocks = {}

	self:AddSpawner( CDotaSpawner( self.szRockSpawner_1, self.szRockSpawner_1,
		{
			{
				EntityName = "npc_dota_storegga_rock",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szRockSpawner_2, self.szRockSpawner_2,
		{
			{
				EntityName = "npc_dota_storegga_rock2",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szRockSpawner_3, self.szRockSpawner_3,
		{
			{
				EntityName = "npc_dota_storegga_rock3",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 200.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{
			{
				EntityName = "npc_dota_creature_storegga",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	
	PrecacheUnitByNameSync( "npc_dota_creature_small_storegga", context, -1 )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tiny", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_storegga.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_tiny.vsndevts", context )
	PrecacheResource( "model", "models/heroes/tiny_01/tiny_01.vmdl", context )
end


--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetPreviewUnit()
	return "npc_dota_creature_storegga"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:Start()
	CMapEncounter_BossBase.Start( self )
	self:CreateOtherUnits()
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_small_storegga" then
    	return false
    end
    if hEnemyCreature:GetUnitName() == "npc_dota_storegga_rock" then
    	return false
    end
    if hEnemyCreature:GetUnitName() == "npc_dota_storegga_rock2" then
    	return false
    end
     if hEnemyCreature:GetUnitName() == "npc_dota_storegga_rock3" then
    	return false
    end
    return true
end


--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:CreateOtherUnits()
	for _,Spawner in pairs ( self:GetSpawners() ) do
		if Spawner.szSpawnerName ~= "spawner_boss" then
			local hRocks = Spawner:SpawnUnits()
			for _,hRock in pairs ( hRocks ) do
				table.insert( self.Rocks, hRock )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:OnComplete()
	CMapEncounter_BossBase.OnComplete( self )

	for _,hRock in pairs ( self.Rocks ) do
		UTIL_Remove( hRock )
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetBossIntroVoiceLine()
	return "tiny_tiny_pres_t3_spawn_03"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetBossIntroGesture()
	return ACT_DOTA_SPAWN
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetBossIntroCameraPitch()
	return 40
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetBossIntroCameraHeight()
	return 350
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetLaughLine()

	local szLines = 
	{
		"tiny_tiny_pres_t3_laugh_01",
		"tiny_tiny_pres_t3_laugh_02",
		"tiny_tiny_pres_t3_laugh_03",
		"tiny_tiny_pres_t3_laugh_04",
		"tiny_tiny_pres_t3_laugh_05",
		"tiny_tiny_pres_t3_laugh_06",
		"tiny_tiny_pres_t3_laugh_07",
		"tiny_tiny_pres_t3_laugh_08",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetKillTauntLine()
	local szLines = 
	{
		"tiny_tiny_pres_t3_kill_01",
		"tiny_tiny_pres_t3_kill_03",
		"tiny_tiny_pres_t3_kill_04",
		"tiny_tiny_pres_t3_kill_05",
		"tiny_tiny_pres_t3_kill_06",
		"tiny_tiny_pres_t3_kill_09",
		"tiny_tiny_pres_t3_ability_toss_11",
		"tiny_tiny_pres_t3_ability_toss_08",
		"tiny_tiny_pres_t3_ability_toss_07",
		"tiny_tiny_pres_t3_ability_toss_06",
		"tiny_tiny_pres_t3_attack_08",
		"tiny_tiny_pres_t3_attack_06",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossStoregga:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	if szAbilityName == "storegga_grab_throw" then
		local szLines = 
		{
			"tiny_tiny_pres_t3_ability_toss_13",
			"tiny_tiny_pres_t3_ability_toss_12",
			"tiny_tiny_pres_t3_ability_toss_05",
			"tiny_tiny_pres_t3_ability_toss_04",
			"tiny_tiny_pres_t3_ability_toss_03",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "storegga_arm_slam" then
		local szLines = 
		{
			"tiny_tiny_pres_t3_attack_12",
			"tiny_tiny_pres_t3_attack_11",
			"tiny_tiny_pres_t3_attack_07",
			"tiny_tiny_pres_t3_ability_toss_01",
			"tiny_tiny_pres_t3_ability_toss_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "storegga_ground_pound" then
		local szLines = 
		{
			"tiny_tiny_pres_t3_attack_04",
			"tiny_tiny_pres_t3_attack_05",
			"tiny_tiny_pres_t3_attack_03",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "storegga_avalanche" then
		local szLines = 
		{
			"tiny_tiny_pres_t3_ability_toss_15",
			"tiny_tiny_pres_t3_ability_toss_14",
			"tiny_tiny_pres_t3_ability_grow_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	

	return szLineToUse
end


--------------------------------------------------------------------------------

return CMapEncounter_BossStoregga
