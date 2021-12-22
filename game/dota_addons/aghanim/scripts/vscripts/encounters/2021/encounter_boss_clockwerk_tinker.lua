
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_boss_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BossClockwerkAndTinker == nil then
	CMapEncounter_BossClockwerkAndTinker = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self.Structures = {}

	self.szBossLocator = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossLocator, self.szBossLocator,
		{
			{
				EntityName = "npc_dota_boss_tinker",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			}
		}
	) )

	self.szStructureLocator = "spawner_tinker_structure"

	self:AddSpawner( CDotaSpawner( self.szStructureLocator, self.szStructureLocator,
		{
			{
				EntityName = "npc_dota_boss_tinker_structure",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetPreviewUnit()
	return "npc_dota_boss_tinker"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_boss_tinker", context, -1 )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tinker", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_tinker.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_creature_keen_minion", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_boss_tinker_structure", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroGesture()
	return ACT_DOTA_CAPTURE
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroCameraPitch()
	return 30
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroCameraHeight()
	return 85
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroCameraYawRotateSpeed()
	return 0.1
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroCameraInitialYaw()
	return 120
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroDuration()
	return 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:IntroduceBoss( hEncounteredBoss )
	CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )

	--EmitGlobalSound( "Boss.Intro" )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:Start()
	CMapEncounter_BossBase.Start( self )

	self:CreateStructures()
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:MustKillForEncounterCompletion( hEnemyCreature )
    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:CreateStructures()
	for _, spawner in pairs ( self:GetSpawners() ) do
		if spawner.szSpawnerName == self.szStructureLocator then
			local hStructures = spawner:SpawnUnits()
			for _, hStructure in pairs ( hStructures ) do
				--printf( "adding %s to self.Structures", hStructure:GetUnitName() )
				table.insert( self.Structures, hStructure )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:OnComplete()
	CMapEncounter.OnComplete( self )

	local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
	for _, unit in pairs( units ) do
		if unit:GetUnitName() == "npc_dota_creature_keen_minion" then
			unit:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetBossIntroVoiceLine()
	local nLine = RandomInt( 0, 3 )

	if nLine == 0 then
		return "tinker_tink_taunt_01"
	end

	if nLine == 1 then
		return "tinker_tink_taunt_02"
	end

	if nLine == 2 then
		return "tinker_tink_taunt_03"
	end

	if nLine == 3 then
		return "tinker_tink_begin_01"
	end

	return "tinker_tink_taunt_02"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetLaughLine()
	local szLines = 
	{
		"tinker_tink_laugh_01",
		"tinker_tink_laugh_04",
		"tinker_tink_laugh_06",
		"tinker_tink_laugh_07",
		"tinker_tink_laugh_09",
		"tinker_tink_laugh_10",
		"tinker_tink_laugh_11",
		"tinker_tink_laugh_12",
		"tinker_tink_laugh_13",
		"tinker_tink_laugh_14",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetKillTauntLine()
	local szLines = 
	{
		"tinker_tink_kill_01",
		"tinker_tink_kill_02",
		"tinker_tink_kill_03",
		"tinker_tink_kill_04",
		"tinker_tink_kill_05",
		"tinker_tink_kill_06",
		"tinker_tink_kill_07",
		"tinker_tink_kill_08",
		"tinker_tink_kill_09",
		"tinker_tink_kill_10",
		"tinker_tink_kill_11",
		"tinker_tink_kill_12",
		"tinker_tink_kill_13",
		"tinker_tink_kill_14",
		"tinker_tink_kill_15",
		"tinker_tink_kill_16",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossClockwerkAndTinker:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()

	--[[
	if szAbilityName == "boss_tinker_walk" then
		local szLines = 
		{
			"tinker_tink_move_11",
			"tinker_tink_haste_02",
			"tinker_tink_ability_rearm_06",
			"tinker_tink_happy_08",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	]]

	if szAbilityName == "boss_tinker_laser" then
		local szLines = 
		{
			"tinker_tink_ability_laser_02",
			"tinker_tink_ability_laser_03",
			"tinker_tink_ability_laser_04",
			"tinker_tink_doubdam_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_march" then
		local szLines = 
		{
			"tinker_tink_ability_marchofthemachines_01",
			"tinker_tink_ability_marchofthemachines_02",
			"tinker_tink_ability_marchofthemachines_03",
			"tinker_tink_ability_marchofthemachines_04",
			"tinker_tink_ability_marchofthemachines_05",
			"tinker_tink_ability_marchofthemachines_06",
			"tinker_tink_ability_marchofthemachines_07",
			"tinker_tink_ability_marchofthemachines_08",
			"tinker_tink_ability_marchofthemachines_09",
			"tinker_tink_ability_marchofthemachines_10",
			"tinker_tink_ability_marchofthemachines_11",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_missiles" then
		local szLines = 
		{
			"tinker_tink_ability_heatseekingmissile_01",
			"tinker_tink_ability_heatseekingmissile_02",
			"tinker_tink_ability_heatseekingmissile_03",
			"tinker_tink_ability_heatseekingmissile_04",
			"tinker_tink_ability_heatseekingmissile_05",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_polymorph" then
		local szLines = 
		{
			"tinker_tink_ability_rearm_11",
			"tinker_tink_cast_01",
			"tinker_tink_cast_02",
			"tinker_tink_cast_03",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_keen_teleport" then
		local szLines = 
		{
			"tinker_tink_travel_02",
			"tinker_tink_travel_03",
			"tinker_tink_travel_04",
			"tinker_tink_travel_05",
			"tinker_tink_travel_06",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_shivas" then
		local szLines = 
		{
			"tinker_tink_relic_02",
			"tinker_tink_attack_02",
			"tinker_tink_attack_03",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_tinker_mega_laser" then
		local szLines = 
		{
			"tinker_tink_ability_laser_01",
			"tinker_tink_attack_04",
			"tinker_tink_attack_10",
			"tinker_tink_levelup_03",
			"tinker_tink_levelup_04",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	return szLineToUse
end

--------------------------------------------------------------------------------

return CMapEncounter_BossClockwerkAndTinker
