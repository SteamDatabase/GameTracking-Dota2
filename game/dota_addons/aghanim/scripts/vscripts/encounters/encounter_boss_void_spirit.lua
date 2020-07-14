
require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossVoidSpirit == nil then
	CMapEncounter_BossVoidSpirit = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

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

function CMapEncounter_BossVoidSpirit:GetPreviewUnit()
	return "npc_dota_boss_void_spirit"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_earth_spirit_statue", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:Start()
	CMapEncounter_BossBase.Start( self )

	local vEarthSpiritSpawnPos = nil
	local hEarthSpiritSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_earth_spirit", true )
	local hBossSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_boss", true )

	self.hEarthSpirits = {} -- had some issue finding these units from Void's ability, so just track them as they get made
	for _, hSpawner in pairs( hEarthSpiritSpawners ) do
		local vSpawnPos = hSpawner:GetAbsOrigin()
		local hEarthSpirit = CreateUnitByName( "npc_dota_earth_spirit_statue", vSpawnPos, true, nil, nil, DOTA_TEAM_BADGUYS )
		if hEarthSpirit ~= nil then
			if #hBossSpawners > 0 and hBossSpawners[ 1 ] ~= nil then
				-- Initially face statues towards the boss
				local vBossPos = hBossSpawners[ 1 ]:GetOrigin()
				local vDir = vBossPos - hEarthSpirit:GetOrigin()
				vDir.z = 0.0
				vDir = vDir:Normalized()
				hEarthSpirit:SetForwardVector( vDir )
			end

			--self:SuppressRewardsOnDeath( hEarthSpirit )
			table.insert( self.hEarthSpirits, hEarthSpirit )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:MustKillForEncounterCompletion( hEnemyCreature )
	return true
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
end

---------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )
end


--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:GetBossIntroVoiceLine()
	local szLines = 
	{
		"void_spirit_voidspir_battle_01_02",
		"void_spirit_voidspir_battle_03_02",
		"void_spirit_voidspir_battle_04",
		"void_spirit_voidspir_battlebegins_01",
		"void_spirit_voidspir_battlebegins_02",
		"void_spirit_voidspir_battlebegins_03",
		"void_spirit_voidspir_battlebegins_04",
		"void_spirit_voidspir_inthebag_01",
		"void_spirit_voidspir_inthebag_02",
	}


	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:GetLaughLine()

	local szLines = 
	{
		"void_spirit_voidspir_laugh_01",
		"void_spirit_voidspir_laugh_01_02",
		"void_spirit_voidspir_laugh_01_03",
		"void_spirit_voidspir_laugh_02",
		"void_spirit_voidspir_laugh_03",
		"void_spirit_voidspir_laugh_04",
		"void_spirit_voidspir_laugh_07",
		"void_spirit_voidspir_laugh_08",
		"void_spirit_voidspir_laugh_09",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:GetKillTauntLine()
	local szLines = 
	{
		"void_spirit_voidspir_kill_06",
		"void_spirit_voidspir_kill_08",
		"void_spirit_voidspir_kill_09",
		"void_spirit_voidspir_kill_10",
		"void_spirit_voidspir_kill_13",
		"void_spirit_voidspir_kill_14",
		"void_spirit_voidspir_kill_15",
		"void_spirit_voidspir_kill_16",
		"void_spirit_voidspir_kill_18",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	if szAbilityName == "aghsfort_void_spirit_boss_aether_remnant" then
		local szLines = 
		{
			"void_spirit_voidspir_ability1_13",
			"void_spirit_voidspir_ability1_12",
			"void_spirit_voidspir_ability1_11",
			"void_spirit_voidspir_ability1_10",
			"void_spirit_voidspir_ability1_09",
			"void_spirit_voidspir_ability1_08",
			"void_spirit_voidspir_ability1_06",
			"void_spirit_voidspir_ability1_05",
			"void_spirit_voidspir_ability1_03",
			"void_spirit_voidspir_ability1_01",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_void_spirit_boss_dissimilate" then
		local szLines = 
		{
			"void_spirit_voidspir_ability2_20",
			"void_spirit_voidspir_ability2_18",
			"void_spirit_voidspir_ability2_17",
			"void_spirit_voidspir_ability2_15",
			"void_spirit_voidspir_ability2_14",
			"void_spirit_voidspir_ability2_13",
			"void_spirit_voidspir_ability2_09",
			"void_spirit_voidspir_ability2_08",
			"void_spirit_voidspir_ability2_07",
			"void_spirit_voidspir_ability2_05",
			"void_spirit_voidspir_ability2_02",
			"void_spirit_voidspir_ability2_01",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_void_spirit_boss_resonant_pulse" then
		local szLines = 
		{
			"void_spirit_voidspir_ability3_15",
			"void_spirit_voidspir_ability3_14",
			"void_spirit_voidspir_ability3_10",
			"void_spirit_voidspir_ability3_09",
			"void_spirit_voidspir_ability3_08",
			"void_spirit_voidspir_ability3_06",
			"void_spirit_voidspir_ability3_04",
			"void_spirit_voidspir_ability3_03",
			"void_spirit_voidspir_ability3_01",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "void_spirit_boss_activate_earth_spirits" then
		local szLines = 
		{
			"void_spirit_voidspir_cast_03",
			"void_spirit_voidspir_cast_02",
			"void_spirit_voidspir_cast_01",
			"void_spirit_voidspir_battlebegins_05",
			"void_spirit_voidspir_levelup_11_02",
			"void_spirit_voidspir_levelup_12",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_void_spirit_boss_astral_step" then
		local szLines = 
		{
			"void_spirit_voidspir_ability4_18",
			"void_spirit_voidspir_ability4_13",
			"void_spirit_voidspir_ability4_12",
			"void_spirit_voidspir_ability4_08",
			"void_spirit_voidspir_ability4_06",
			"void_spirit_voidspir_ability4_04",
			"void_spirit_voidspir_ability4_02",
			"void_spirit_voidspir_ability4_01",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	

	return szLineToUse
end



--------------------------------------------------------------------------------

function CMapEncounter_BossVoidSpirit:GetBossIntroGesture()
	return ACT_DOTA_TELEPORT
end


--------------------------------------------------------------------------------

return CMapEncounter_BossVoidSpirit
