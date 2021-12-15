
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_Aziyog_Caverns == nil then
	CMapEncounter_Aziyog_Caverns = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )




	self:SetCalculateRewardsFromUnitCount( true )

	self.vMasterWaveSchedule =
	{
		PrePlacedPeons =
		{
			SpawnerName = "spawner_preplaced_peons",
			Count = 3,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},
		PrePlacedCaptain =
		{
			SpawnerName = "spawner_preplaced_captain",
			Count = 1,
			UsePortals = false,
			AggroHeroes = false,
			TriggerData =
			{
				TimeAbsolute = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_TIME_ABSOLUTE,
					Time = 0.0,
				},
			},
		},

		Wave1_Peons =
		{
			SpawnerName = "pordlers_a_peons",
			Count = 4,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					HealthPercent = 50,
				},
			},
		},
		Wave1_Captains =
		{
			SpawnerName = "pordlers_a_captains",
			Count = 3,
			AggroHeroes = false,
			TriggerData =
			{
				TriggerKillPercent = 
				{
					TriggerType = PORTAL_TRIGGER_TYPE_HEALTH_PERCENT,
					TriggerAfterWave = "PrePlacedCaptain",
					HealthPercent = 50,
				},
			},
		},
	}

	local bInvulnerable = true

	-- Preplaced enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_peons", "preplaced_peons", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_aziyog_warrior",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_preplaced_captain", "preplaced_underlord", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_aziyog_underlord",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )

	-- Portal enemies
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_a_peons", "portal_peons", 1, 1, 1.0,
		{
			{
				EntityName = "npc_dota_creature_aziyog_warrior",
				AggroHeroes = false,
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 200.0,
			},
		}, bInvulnerable ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "pordlers_a_captains", "portal_underlord", 1, 1, 1.0,
		{
			{
				EntityName = "npc_dota_creature_aziyog_underlord",
				AggroHeroes = false,				
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable ) )


	self.PortalNames = {}

	local spawners = self:GetSpawners()
	for _, v in pairs( spawners ) do
		if v and v.UsePortals == true then
			table.insert( self.PortalNames, v:GetSpawnerName() )
			printf( "Found a portal named \"%s\" to add to self.PortalNames", v:GetSpawnerName() )
		end
	end

	printf( "self.PortalNames:" )
	PrintTable( self.PortalNames, " -- " )

	self:SetMasterSpawnSchedule( self.vMasterWaveSchedule )

	self.nUnderlordCount = 4
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:Precache( context )
	CMapEncounter.Precache( self, context )

	
	PrecacheUnitByNameSync( "npc_dota_creature_aziyog_warrior", context, -1 )
end

--------------------------------------------------------------------------------


function CMapEncounter_Aziyog_Caverns:GetPreviewUnit()
	return "npc_dota_creature_aziyog_underlord"
end


--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	local hEndPosition = self:GetRoom():FindAllEntitiesInRoomByName( "exit_target", true )
	if hEndPosition == nil then
		printf('EndPosition Nil')
	else
		printf('Endposition found')
	end
	self.vEndPos = hEndPosition[1]:GetAbsOrigin()
	self:StartAllSpawnerSchedules( 0 )

	local hHeroes = HeroList:GetAllHeroes()

	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			local hAbility = hHero:AddAbility( "aghsfort_aziyog_underlord_portal_warp" )
			if hAbility ~= nil then
				hAbility:UpgradeAbility( true )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveAbility( "aghsfort_aziyog_underlord_portal_warp" )
			hHero:RemoveModifierByName( "modifier_aghsfort_aziyog_underlord_portal_warp_channel" )
			hHero:RemoveModifierByName( "modifier_aghsfort_aziyog_underlord_portal_warp_channel_soundstop" )

			PlayerResource:SetCameraTarget( nPlayerID, nil )
			PlayerResource:SetOverrideSelectionEntity( nPlayerID, nil )

			FindClearSpaceForUnit( hHero, self.vEndPos, true )
 			CenterCameraOnUnit( nPlayerID, hHero )
		end
	end

	local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
	for _,unit in pairs( units ) do
		if unit:GetUnitName() == "npc_dota_creature_aziyog_warrior" then
			unit:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:Start()
	CMapEncounter.Start( self )

	print( '^^^CMapEncounter_Aziyog_Caverns:Start()!' )
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self.nUnderlordCount = 4
	self:AddEncounterObjective( "defeat_underlords", 0, self.nUnderlordCount )
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

		if hVictim:GetUnitName() == "npc_dota_creature_aziyog_underlord" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_underlords" )
		self:UpdateEncounterObjective( "defeat_underlords", nCurrentValue + 1, nil )
	end	
end

--------------------------------------------------------------------------------

function CMapEncounter_Aziyog_Caverns:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szLocatorName == "preplaced_underlord" then

		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
 			if hSpawnedUnit ~= nil and hSpawnedUnit:IsNull() == false and hSpawnedUnit:IsAlive() == true then

 				local hPortalAbility = hSpawnedUnit:FindAbilityByName( "aghsfort_aziyog_underlord_dark_portal" )

 				if hPortalAbility ~= nil and hPortalAbility:IsFullyCastable() then
 					hPortalAbility:StartCooldown(9999)
				end
			end
		end
	end

	--if hSpawner.szLocatorName == "portal_peons" or hSpawner.szLocatorName == "portal_captain" then
	if TableContainsValue( self.PortalNames, hSpawner.szLocatorName ) then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end
end

--------------------------------------------------------------------------------


function CMapEncounter_Aziyog_Caverns:CheckForCompletion()
	local nUnderlordProgress = self:GetEncounterObjectiveProgress( "defeat_underlords" )
	if nUnderlordProgress >= self.nUnderlordCount then 
		return true
	end

	return false
end


return CMapEncounter_Aziyog_Caverns
