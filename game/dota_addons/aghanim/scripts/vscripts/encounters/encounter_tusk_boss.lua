
require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TuskBoss == nil then
	CMapEncounter_TuskBoss = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	GameRules:SetTreeRegrowTime( 30.0 )

	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		}
	) )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:GetPreviewUnit()
	return "npc_dota_tusk_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	
	--PrecacheUnitByNameSync( "npc_dota_creature_timbersaw_treant", context, -1 )

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_tusk", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_tusk.vsndevts", context )

	--PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:GetBossIntroVoiceLine()
	local nLine = RandomInt( 0, 3 )
	if nLine == 0 then
		return "shredder_timb_levelup_04"
	end

	if nLine == 1 then
		return "shredder_timb_levelup_05"
	end

	if nLine == 2 then
		return "shredder_timb_levelup_06"
	end

	if nLine == 3 then
		return "shredder_timb_levelup_07"
	end

	return "shredder_timb_levelup_07"
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:MustKillForEncounterCompletion( hEnemyCreature )
	--[[
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_timbersaw_treant" then
    	return false
    end
    ]]

    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_TuskBoss:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )

	--[[
	local vecTreants = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_furion_treant_4", false )
	if #vecTreants > 0 then
		for _,hTreant in pairs ( vecTreants ) do
			hTreant:ForceKill( false )
		end
	end
	]]
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:GetLaughLine()

	local szLines = 
	{
		"shredder_timb_laugh_01",
		"shredder_timb_laugh_02",
		"shredder_timb_laugh_03",
		"shredder_timb_laugh_04",
		"shredder_timb_laugh_05",
		"shredder_timb_laugh_06",
		"shredder_timb_kill_15",
		"shredder_timb_kill_16",
		"shredder_timb_deny_14",
		"shredder_timb_levelup_09",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:GetKillTauntLine()
	local szLines = 
	{
		"shredder_timb_kill_02",
		"shredder_timb_kill_03",
		"shredder_timb_kill_04",
		"shredder_timb_kill_06",
		"shredder_timb_kill_07",
		"shredder_timb_kill_10",
		"shredder_timb_kill_11",
		"shredder_timb_kill_12",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskBoss:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()

	if szAbilityName == "boss_timbersaw_whirling_death" then
		local szLines = 
		{
			"shredder_timb_whirlingdeath_01",
			"shredder_timb_whirlingdeath_02",
			"shredder_timb_whirlingdeath_03",
			"shredder_timb_whirlingdeath_04",
			"shredder_timb_whirlingdeath_05",
			"shredder_timb_whirlingdeath_06",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_timbersaw_timber_chain" then
		local szLines = 
		{
			"shredder_timb_timberchain_01",
			"shredder_timb_timberchain_02",
			"shredder_timb_timberchain_05",
			"shredder_timb_timberchain_04",
			"shredder_timb_timberchain_07",
			"shredder_timb_timberchain_08",
			"shredder_timb_timberchain_09",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_timbersaw_chakram_dance" then
		local szLines = 
		{
			"shredder_timb_attack_08",
			"shredder_timb_attack_07",
			"shredder_timb_attack_05",
			"shredder_timb_attack_03",
			"shredder_timb_attack_02",
			"shredder_timb_cast_01",
			"shredder_timb_levelup_10",
			"shredder_timb_levelup_11",
			"shredder_timb_levelup_12",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "shredder_chakram" then
		local szLines = 
		{
			"shredder_timb_chakram_01",
			"shredder_timb_chakram_02",
			"shredder_timb_chakram_03",
			"shredder_timb_chakram_04",
			"shredder_timb_chakram_05",
			"shredder_timb_chakram_06",
			"shredder_timb_chakram_07",
			"shredder_timb_chakram_08",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	return szLineToUse
end


--------------------------------------------------------------------------------

return CMapEncounter_TuskBoss
