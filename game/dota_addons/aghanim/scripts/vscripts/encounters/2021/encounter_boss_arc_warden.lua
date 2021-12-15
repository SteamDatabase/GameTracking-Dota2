
require( "encounters/encounter_boss_base" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BossArcWarden == nil then
	CMapEncounter_BossArcWarden = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:constructor( hRoom, szEncounterName )
	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	self.TeleportPositions = {}

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

	self:AddSpawner( CDotaSpawner( "spawner_meteor", "spawner_meteor",
		{ 
			{
				EntityName = "npc_dota_aghsfort_arc_warden_boss_meteor",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:Start()
	-- spawn the meteor before the boss
	local vecMeteors = self:GetSpawner( "spawner_meteor" ):SpawnUnits()
	self.hMeteor = vecMeteors[1]

	CMapEncounter_BossBase.Start( self )

	local hBossSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_boss", true )

	--print( 'GATHERING TELEPORT POSITIONS' )
	local TeleportPositions = self:GetRoom():FindAllEntitiesInRoomByName( "teleport_position" )
	for _,hEnt in pairs ( TeleportPositions ) do
		local t =
		{
			position = hEnt:GetAbsOrigin(),
			ent = nil,
		}
		table.insert( self.TeleportPositions, t )
	end

	--print( 'TELEPORT POSITION TABLE:' )
	--DeepPrintTable( self.TeleportPositions )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetMeteor()
	if self.hMeteor == nil then
		print( 'ERROR - self.hMeteor is nil!' )
	end

	return self.hMeteor
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetOpenTeleportPositionForEnt( hEnt )
	--print( 'CMapEncounter_BossArcWarden:GetOpenTeleportPositionForEnt' )
	ShuffleListInPlace( self.TeleportPositions )

	for _,v in ipairs( self.TeleportPositions ) do
		if v.ent == nil then
			--print( 'Found a valid teleport position!' )
			self:ClearTeleportPositionForEnt( hEnt )
			v.ent = hEnt
			return v.position
		end
	end

	-- all taken
	return nil
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:ClearTeleportPositionForEnt( hEnt )
	for _,v in pairs( self.TeleportPositions ) do
		if v.ent ~= nil and v.ent == hEnt then
			v.ent = nil
			--print( 'Removing entity from its current teleport position!' )
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetPreviewUnit()
	return "npc_dota_aghsfort_arc_warden_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_aghsfort_arc_warden_boss_meteor", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghsfort_arc_warden_boss_clone", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghsfort_arc_warden_spark_wraith_missile", context, -1 )
	PrecacheResource( "soundfile", "soundevents/game_sounds_arc_warden_boss.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:OnEncounterLoaded()
	CMapEncounter_BossBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:Dev_ResetEncounter()
	CMapEncounter_BossBase.Dev_ResetEncounter( self )

	print( 'CMapEncounter_BossArcWarden:Dev_ResetEncounter()' )

	self.Bosses[1].AI:Reset()
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:OnThink()
	CMapEncounter_BossBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:MustKillForEncounterCompletion( hEnemyCreature )
	return true
end

--------------------------------------------------------------------------------

--function CMapEncounter_BossArcWarden:OnBossSpawned( hBoss )
--	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )
--
--	hBoss.AI:SetEncounter( self )
--end

---------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:OnEnemyCreatureSpawned( hEnemyCreature )
	CMapEncounter_BossBase.OnEnemyCreatureSpawned( self, hEnemyCreature )

	--print( 'CMapEncounter_BossArcWarden:OnEnemyCreatureSpawned( hEnemyCreature )')

	if hEnemyCreature:GetUnitName() == 'npc_dota_aghsfort_arc_warden_boss' then
		hEnemyCreature.AI:SetIsClone( false )
		hEnemyCreature.AI:SetEncounter( self )
	elseif hEnemyCreature:GetUnitName() == 'npc_dota_aghsfort_arc_warden_boss_clone' then
		hEnemyCreature.AI:SetIsClone( true )
		hEnemyCreature.AI:SetEncounter( self )
	end
end

---------------------------------------------------------

function CMapEncounter_BossArcWarden:OnEntityKilled( event )
	--print( 'CMapEncounter_BossArcWarden:OnEntityKilled( event )')
	CMapEncounter_BossBase.OnEntityKilled( self, event )

	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	--print( 'ENTITY KILLED! Freeing up a spot in the TELEPORT LIST')
	if hVictim ~= nil then
		self:ClearTeleportPositionForEnt( hVictim )
	end
end

---------------------------------------------------------

function CMapEncounter_BossArcWarden:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter_BossBase.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	--print( 'REQUIRED ENEMY KILLED! Freeing up a spot in the TELEPORT LIST')
	self:ClearTeleportPositionForEnt( hVictim )
end

---------------------------------------------------------

function CMapEncounter_BossArcWarden:OnSecondaryEnemyKilled( hAttacker, hVictim )
	CMapEncounter_BossBase.OnSecondaryEnemyKilled( self, hAttacker, hVictim )
	
	--print( 'SECONDARY ENEMY KILLED! Freeing up a spot in the TELEPORT LIST')
	self:ClearTeleportPositionForEnt( hVictim )
end

---------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:OnBossKilled( hBoss, hAttacker )
	CMapEncounter_BossBase.OnBossKilled( self, hBoss, hAttacker )
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetBossIntroVoiceLine()
	local szLines = 
	{
		"arc_warden_arcwar_battlebegins_01",
		"arc_warden_arcwar_battlebegins_03",
	}


	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetBossDeathVoiceLine()
	local szLines = 
	{
		"arc_warden_arcwar_death_01",
		"arc_warden_arcwar_death_03",
		"arc_warden_arcwar_death_04",
		"arc_warden_arcwar_death_07",
		"arc_warden_arcwar_death_13",
		"arc_warden_arcwar_lose_01",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetLaughLine()

	local szLines = 
	{
		"arc_warden_arcwar_kill_17",
		"arc_warden_arcwar_kill_24",
		"arc_warden_arcwar_laugh_01",
		"arc_warden_arcwar_laugh_02",
		"arc_warden_arcwar_laugh_03",
		"arc_warden_arcwar_laugh_04",
		"arc_warden_arcwar_laugh_05",
		"arc_warden_arcwar_laugh_06",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetKillTauntLine()
	local szLines = 
	{
		"arc_warden_arcwar_kill_01",
		"arc_warden_arcwar_kill_02",
		"arc_warden_arcwar_kill_04",
		"arc_warden_arcwar_kill_05",
		"arc_warden_arcwar_kill_07",
		"arc_warden_arcwar_kill_09",
		"arc_warden_arcwar_kill_15",
		"arc_warden_arcwar_kill_25",
	}

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetAbilityUseLine( szAbilityName )
	local szLineToUse = self:GetLaughLine()
	--[[
	if szAbilityName == "aghsfort_arc_warden_boss_flux" then
		local szLines = 
		{
			"arc_warden_arcwar_flux_01",
			"arc_warden_arcwar_flux_02",
			"arc_warden_arcwar_flux_04",
			"arc_warden_arcwar_flux_06",
			"arc_warden_arcwar_flux_09",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end
	]]--

	if szAbilityName == "aghsfort_arc_warden_boss_magnetic_field" then
		local szLines = 
		{
			"arc_warden_arcwar_magnetic_field_01",
			"arc_warden_arcwar_magnetic_field_02",
			"arc_warden_arcwar_magnetic_field_05",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_arc_warden_boss_spark_wraith_missile" then
		local szLines = 
		{
			"arc_warden_arcwar_spark_wraith_01",
			"arc_warden_arcwar_spark_wraith_02",
			"arc_warden_arcwar_spark_wraith_03",
			"arc_warden_arcwar_spark_wraith_05",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	if szAbilityName == "aghsfort_arc_warden_boss_tempest_double" then
		local szLines = 
		{
			"arc_warden_arcwar_tempest_double_02",
			"arc_warden_arcwar_tempest_double_03",
			"arc_warden_arcwar_tempest_double_04",
			"arc_warden_arcwar_tempest_double_06",
		}
		szLineToUse = szLines[ RandomInt( 1, #szLines ) ]
	end

	return szLineToUse
end


--------------------------------------------------------------------------------

function CMapEncounter_BossArcWarden:GetBossIntroGesture()
	--return AW_NEMESTICE_FRONTPAGE
	return ACT_DOTA_CAPTURE
end


--------------------------------------------------------------------------------

return CMapEncounter_BossArcWarden
