require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossWinterWyvern == nil then
	CMapEncounter_BossWinterWyvern = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:constructor( hRoom, szEncounterName )
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
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetPreviewUnit()
	return "npc_dota_creature_ice_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheResource( "particle", "particles/forest/egg_destruction.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_flying.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_winter_wyvern.vsndevts", context )

	PrecacheUnitByNameSync( "npc_dota_creature_baby_ice_dragon", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_ice_boss_egg", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetBossIntroVoiceLine()
	local nLine = RandomInt( 0, 3 )
	if nLine == 0 then
		return "winter_wyvern_winwyv_battlebegins_01"
	end

	if nLine == 1 then
		return "winter_wyvern_winwyv_rare_01"
	end

	if nLine == 2 then
		return "winter_wyvern_winwyv_spawn_02"
	end

	if nLine == 3 then
		return "winter_wyvern_winwyv_spawn_03"
	end

	return "winter_wyvern_winwyv_spawn_03"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetBossIntroCameraDistance()
	return 2000
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_baby_ice_dragon" or hEnemyCreature:GetUnitName() == "npc_dota_creature_ice_boss_egg" then
    	return false
    end
    return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )

	local vecDragons = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_creature_baby_ice_dragon", false )
	if #vecDragons > 0 then
		for _,hDragon in pairs ( vecDragons ) do
			hDragon:ForceKill( false )
		end
	end

	local vecEggs = self:GetRoom():FindAllEntitiesInRoomByName( "npc_dota_creature_ice_boss_egg", false )
	if #vecEggs > 0 then
		for _,hEgg in pairs ( vecEggs ) do
			hEgg:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetLaughLine()

	local szLines = 
	{
		"winter_wyvern_winwyv_laugh_02",
		"winter_wyvern_winwyv_laugh_03",
		"winter_wyvern_winwyv_laugh_04",
		"winter_wyvern_winwyv_laugh_06",
		"winter_wyvern_winwyv_laugh_07",
		"winter_wyvern_winwyv_laugh_08",
		"winter_wyvern_winwyv_laugh_09",
		"winter_wyvern_winwyv_laugh_10",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetKillTauntLine()
	local szLines = 
	{
		"winter_wyvern_winwyv_kill_03",
		"winter_wyvern_winwyv_kill_04",
		"winter_wyvern_winwyv_kill_05",
		"winter_wyvern_winwyv_kill_06",
		"winter_wyvern_winwyv_kill_08",
		"winter_wyvern_winwyv_kill_09",
		"winter_wyvern_winwyv_kill_10",
		"winter_wyvern_winwyv_kill_11",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossWinterWyvern:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	if szAbilityName == "ice_boss_shatter_projectile" then
		local szLines = 
		{
			"winter_wyvern_winwyv_attack_03",
			"winter_wyvern_winwyv_attack_04",
			"winter_wyvern_winwyv_attack_05",
			"winter_wyvern_winwyv_attack_09",
			"winter_wyvern_winwyv_articburn_01",
			"winter_wyvern_winwyv_articburn_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "ice_boss_flying_shatter_blast" then
		local szLines = 
		{
			"winter_wyvern_winwyv_attack_06",
			"winter_wyvern_winwyv_attack_07",
			"winter_wyvern_winwyv_attack_08",
			"winter_wyvern_winwyv_laugh_02",
			"winter_wyvern_winwyv_laugh_03",
			"winter_wyvern_winwyv_laugh_04",
			"winter_wyvern_winwyv_laugh_06",
			"winter_wyvern_winwyv_laugh_07",
			"winter_wyvern_winwyv_laugh_08",
			"winter_wyvern_winwyv_laugh_09",
			"winter_wyvern_winwyv_laugh_10",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "ice_boss_take_flight" then
		local szLines = 
		{
			"winter_wyvern_winwyv_cast_03",
			"winter_wyvern_winwyv_attack_10",
			"winter_wyvern_winwyv_laugh_02",
			"winter_wyvern_winwyv_laugh_03",
			"winter_wyvern_winwyv_laugh_04",
			"winter_wyvern_winwyv_laugh_06",
			"winter_wyvern_winwyv_laugh_07",
			"winter_wyvern_winwyv_laugh_08",
			"winter_wyvern_winwyv_laugh_09",
			"winter_wyvern_winwyv_laugh_10",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "ice_boss_land" then
		local szLines = 
		{
			"winter_wyvern_winwyv_coldembrace_02",
			"winter_wyvern_winwyv_coldembrace_03",
			"winter_wyvern_winwyv_coldembrace_04",
			"winter_wyvern_winwyv_cast_01",
			"winter_wyvern_winwyv_cast_02",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "ice_boss_projectile_curse" then
		local szLines = 
		{
			"winter_wyvern_winwyv_winterscurse_01",
			"winter_wyvern_winwyv_winterscurse_02",
			"winter_wyvern_winwyv_winterscurse_03",
			"winter_wyvern_winwyv_winterscurse_04",
			"winter_wyvern_winwyv_winterscurse_05",
			"winter_wyvern_winwyv_winterscurse_06",
			"winter_wyvern_winwyv_winterscurse_07",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	

	return szLineToUse
end


--------------------------------------------------------------------------------

return CMapEncounter_BossWinterWyvern
