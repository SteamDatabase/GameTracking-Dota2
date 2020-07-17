
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_ShadowDemons == nil then
	CMapEncounter_ShadowDemons = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	-- urns are standing trash
	self.szUrnSpawner = "spawner_captain"
	self:AddSpawner( CDotaSpawner( self.szUrnSpawner, self.szUrnSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_upheaval_urn",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	-- waves alternate between groups of necro melee warriors and a single shadow demon
	-- one big Doom spawns in the middle of this nonsense
	local bInvulnerable = true

	self.vNecroWarriorSchedule =
	{
		{
			Time = 3,
			Count = 3,
		},
		{
			Time = 18,
			Count = 3,
		},
		{
			Time = 32,
			Count = 3,
		},
		{
			Time = 45,
			Count = 3,
		},
	}

	self.vShadowDemonSchedule =
	{
		{
			Time = 11,
			Count = 1,
		},
		{
			Time = 25,
			Count = 1,
		},
		{
			Time = 39,
			Count = 1,
		},
		{
			Time = 51,
			Count = 1,
		},
	}

	self.vDoomSchedule = 
	{
		{
			Time = 20.0,
			Count = 1
		},
	}

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_shadow_demon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_shadow_demon",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_necro_warrior", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_necro_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 250.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_doom", "spawner_doom", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_doom",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	self:SetSpawnerSchedule( self.szUrnSpawner, nil )	-- means spawn once when triggered 
	self:SetSpawnerSchedule( "spawner_shadow_demon", self.vShadowDemonSchedule )
	self:SetSpawnerSchedule( "spawner_necro_warrior", self.vNecroWarriorSchedule )
	self:SetSpawnerSchedule( "spawner_doom", self.vDoomSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:GetPreviewUnit()
	return "npc_dota_creature_doom"
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:Start()
	CMapEncounter.Start( self )

	self:StartAllSpawnerSchedules( 0 )	
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vShadowDemonSchedule + #self.vDoomSchedule + #self.vNecroWarriorSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

-- don't count urns as units that must be destroyed
function CMapEncounter_ShadowDemons:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_upheaval_urn" then
    	return false
    end

    return true
end

--------------------------------------------------------------------------------

-- only count the v2 portals for our max unit count - we don't want to count the urns since they're indestructible
function CMapEncounter_ShadowDemons:GetMaxSpawnedUnitCount()

	local nCount = 0

	for _,PortalSpawner in pairs ( self.PortalSpawnersV2 ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( PortalSpawner )
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

--[[function CMapEncounter_ShadowDemons:RemoveUrns()
	print( 'CMapEncounter_ShadowDemons:RemoveUrns called')
	local hUrns = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for i=1, #hUrns do
		print( 'Found unit named ' .. hUrns[i]:GetUnitName() )
		if hUrns[i]:GetUnitName() == "npc_dota_creature_upheaval_urn" then
			print( 'Removing urn #' .. i )
			hUrns[i]:ForceKill( false )
			UTIL_Remove( hUrns[i] )
		end
	end
end
--]]
--------------------------------------------------------------------------------

function CMapEncounter_ShadowDemons:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Pinecones:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CPortalSpawnerV2" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
		self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )

		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
		if #heroes > 0 then
			for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
					hSpawnedUnit:SetInitialGoalEntity( hero )
				end
			end
		end

		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			if hSpawnedUnit:GetUnitName() == "npc_dota_creature_doom" then
				EmitSoundOn( "encounter_shadow_demons.doom.intro", hSpawnedUnit )
				--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			end
		end

	end
end

--------------------------------------------------------------------------------

return CMapEncounter_ShadowDemons
