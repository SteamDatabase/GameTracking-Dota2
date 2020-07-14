
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_DragonKnight == nil then
	CMapEncounter_DragonKnight = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	local bInvulnerable = true
	
	self.vWaveSchedule =
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
		{
			Time = 60,
			Count = 2,
		},
	}

	--DeepPrintTable( self.vWaveSchedule )

	self.szPortal = "spawner_peon"

	self:AddPortalSpawnerV2( CPortalSpawnerV2( self.szPortal, self.szPortal, 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_underlord",
				Team = DOTA_TEAM_BADGUYS,
				Count = 2,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_dragon_knight",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_peon", self.vWaveSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:Precache( context )
	CMapEncounter.Precache( self, context )

	--[[
	local towerTable = 
	{ 	
		MapUnitName = "npc_dota_holdout_tower_tier2", 
		teamnumber = DOTA_TEAM_GOODGUYS,
	}
	]]
	local ogreTable =
	{
		MapUnitName = "npc_dota_creature_friendly_ogre_tank", 
		teamnumber = DOTA_TEAM_GOODGUYS,
	}

	PrecacheUnitFromTableSync( ogreTable, context )

	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:GetPreviewUnit()
	return "npc_dota_creature_dragon_knight"
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self:AddEncounterObjective( "survive_waves", 0, #self.vWaveSchedule )
	self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.szObjectiveEnts = "objective"
	self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	if #self.hObjectiveEnts == 0 then
		printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
		return
	end

	self.hOgre = CreateUnitByName( "npc_dota_creature_friendly_ogre_tank", self.hObjectiveEnts[1]:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )

	if self.hOgre ~= nil then
		self.hOgre:SetForwardVector( RandomVector( 1 ) )

		local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
		self.hOgre:CreatureLevelUp( nAscLevel )

		self.vGoalPos = self.hOgre:GetAbsOrigin()
	else
		printf( "WARNING - Failed to spawn the objective entity!" )
		return
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:ShouldAutoStartGlobalAscensionAbilities()
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	self:UpdateEncounterObjective( "defeat_all_enemies", nCurrentValue + 1, nil )
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szSpawnerName == "spawner_peon" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		if self.hOgre ~= nil and ( not self.hOgre:IsNull() ) and self.hOgre:IsAlive() then
			hSpawnedUnit:SetInitialGoalEntity( self.hOgre )
		else
			if self.hObjectiveEnts[ 1 ] ~= nil and self.hObjectiveEnts[ 1 ]:IsNull() == false then
				hSpawnedUnit:SetInitialGoalPosition( self.hObjectiveEnts[ 1 ]:GetOrigin() )
			else
				hSpawnedUnit:SetInitialGoalPosition( self.vGoalPos )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	--printf( "szTriggerName: %s, hUnit:GetUnitName(): %s, hTriggerEntity:GetName(): %s", szTriggerName, hUnit:GetUnitName(), hTriggerEntity:GetName() )

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		self:StartGlobalAscensionAbilities()
		self:StartAllSpawnerSchedules( 0 )	

		--printf( "Unit \"%s\" triggered creature spawning!", hUnit:GetUnitName() )
		EmitGlobalSound( "RoundStart" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DragonKnight:OnComplete()
	CMapEncounter.OnComplete( self )

	-- If friendly ogre is still alive, grant some rewards and do other stuff
	if self.hOgre ~= nil and ( not self.hOgre:IsNull() ) and self.hOgre:IsAlive() then
		self.hOgre:Heal( self.hOgre:GetMaxHealth(), nil )
		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hOgre )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nLives = 1
		for i = 1, nLives do
			self:DropLifeRuneFromUnit( self.hOgre, nil, true )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_DragonKnight
