require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

LinkLuaModifier( "modifier_boss_dark_willow_fear_movement_speed", "modifiers/creatures/modifier_boss_dark_willow_fear_movement_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_dark_willow_shadow_realm_debuff", "modifiers/creatures/modifier_boss_dark_willow_shadow_realm_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_BossDarkWillow == nil then
	CMapEncounter_BossDarkWillow = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )
	self:AddSpawner( CDotaSpawner( "spawner_boss", "spawner_boss",
		{
			{
				EntityName = self:GetPreviewUnit(),
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
	
			},
		} ) )

	-- self:AddSpawner( CDotaSpawner( "spawner_pango", "spawner_pango",
	-- 	{
	-- 		{
	-- 			EntityName = self:GetPreviewUnit(),
	-- 			Team = DOTA_TEAM_BADGUYS,
	-- 			Count = 1,
	-- 			PositionNoise = 0.0,
	
	-- 		},
	-- 	} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetPreviewUnit()
	return "npc_dota_creature_dark_willow_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	
	PrecacheResource( "model", "models/items/furion/treant_flower_1.vmdl", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_dark_willow.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_channel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_fear_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetBossIntroVoiceLine()
	local nLine = RandomInt( 0, 4 )
	if nLine == 0 then
		return "dark_willow_sylph_spawn_01"
	end

	if nLine == 1 then
		return "dark_willow_sylph_spawn_06"
	end

	if nLine == 2 then
		return "dark_willow_sylph_spawn_07"
	end

	if nLine == 3 then
		return "dark_willow_sylph_spawn_08"
	end

	return "dark_willow_sylph_spawn_12"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetBossIntroCameraDistance()
	return 1000
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_dark_willow_flower" then
    	return false
    end
    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetLaughLine()

	local szLines = 
	{
		"dark_willow_sylph_laugh_01",
		"dark_willow_sylph_laugh_02",
		"dark_willow_sylph_laugh_03",
		"dark_willow_sylph_laugh_04",
		"dark_willow_sylph_laugh_05",
		"dark_willow_sylph_laugh_14",
		"dark_willow_sylph_laugh_13",
		"dark_willow_sylph_laugh_12",
		"dark_willow_sylph_laugh_11",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetKillTauntLine()
	local szLines = 
	{
		"dark_willow_sylph_kill_01",
		"dark_willow_sylph_kill_02",
		"dark_willow_sylph_kill_03",
		"dark_willow_sylph_kill_04",
		"dark_willow_sylph_kill_05",
		"dark_willow_sylph_kill_06",
		"dark_willow_sylph_kill_07",
		"dark_willow_sylph_deny_16",
		"dark_willow_sylph_deny_18",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossDarkWillow:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	if szAbilityName == "boss_dark_willow_bloom_toss" then
		local szLines = 
		{
			"dark_willow_sylph_ability1_01",
			"dark_willow_sylph_ability1_02",
			"dark_willow_sylph_ability1_03",
			"dark_willow_sylph_ability1_05",
			"dark_willow_sylph_ability1_06",
			"dark_willow_sylph_ability1_07",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_boss_dark_willow_shadow_realm" then
		local szLines = 
		{
			"dark_willow_sylph_ability2_01",
			"dark_willow_sylph_ability2_02",
			"dark_willow_sylph_ability2_03",
			"dark_willow_sylph_ability2_04",
			"dark_willow_sylph_ability2_05",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_boss_dark_willow_cursed_crown" then
		local szLines = 
		{
			"dark_willow_sylph_ability3_03",
			"dark_willow_sylph_ability3_04",
			"dark_willow_sylph_ability3_05",
			"dark_willow_sylph_ability3_06",
			"dark_willow_sylph_ability3_09",
			"dark_willow_sylph_ability3_10",
			"dark_willow_sylph_ability3_11",
			"dark_willow_sylph_ability3_12",
			"dark_willow_sylph_ability3_13",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "boss_dark_willow_terrorize" or "boss_dark_willow_bedlam"  then
		local szLines = 
		{
			"dark_willow_sylph_ability4_01",
			"dark_willow_sylph_ability4_02",
			"dark_willow_sylph_ability4_03",
			"dark_willow_sylph_ability4_04",
			"dark_willow_sylph_ability4_05",
			"dark_willow_sylph_ability4_06",
			"dark_willow_sylph_ability4_07",
			"dark_willow_sylph_ability4_08",
			"dark_willow_sylph_ability4_09",
			"dark_willow_sylph_ability4_10",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	return szLineToUse
end


--------------------------------------------------------------------------------

return CMapEncounter_BossDarkWillow
