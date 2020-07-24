
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawnerv2" )

--------------------------------------------------------------------------------

if CMapEncounter_TuskSkeletons == nil then
	CMapEncounter_TuskSkeletons = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.vPeonSchedule =
	{
		{
			Time = 0,
			Count = 2,
		},
		{
			Time = 18,
			Count = 3,
		},
		{
			Time = 36,
			Count = 3,
		},
		{
			Time = 54,
			Count = 4,
		},
	}

	--DeepPrintTable( self.vPeonSchedule )

	local bInvulnerable = true

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "spawner_peon", "spawner_peon", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_tusk_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 6,
				PositionNoise = 200.0,
			},
			{
				EntityName = "npc_dota_creature_spectral_tusk_mage",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, bInvulnerable
	) )

	self:SetSpawnerSchedule( "spawner_peon", self.vPeonSchedule )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:Precache( context )
	CMapEncounter.Precache( self, context )

	local friendTable =
	{
		MapUnitName = "npc_dota_creature_friendly_ogre_seal", 
		teamnumber = DOTA_TEAM_GOODGUYS,
	}

	PrecacheUnitFromTableSync( friendTable, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:GetPreviewUnit()
	return "npc_dota_creature_spectral_tusk_mage"
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:InitializeObjectives()
	self:AddEncounterObjective( "survive_waves", 0, #self.vPeonSchedule )
	self:AddEncounterObjective( "save_gary", 0, 0 )

	CMapEncounter.InitializeObjectives( self )
	-- self:AddEncounterObjective( "defeat_all_enemies", 0, self:GetMaxSpawnedUnitCount() )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.szObjectiveEnts = "objective"
	self.hObjectiveEnts = self:GetRoom():FindAllEntitiesInRoomByName( self.szObjectiveEnts, true )

	if #self.hObjectiveEnts == 0 then
		printf( "WARNING - self.hObjectiveEnt is nil (looked for classname \"%s\")", self.szObjectiveEnts )
		return
	end

	self.hFriend = CreateUnitByName( "npc_dota_creature_friendly_ogre_seal", self.hObjectiveEnts[1]:GetOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS )

	if self.hFriend ~= nil then
		self.hFriend:SetForwardVector( RandomVector( 1 ) )

		local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
		self.hFriend:CreatureLevelUp( nAscLevel )

		self.vGoalPos = self.hFriend:GetAbsOrigin()

		self.hFriend.Encounter = self
		self.hFriend:AddNewModifier( self.hFriend, nil, "modifier_monster_leash", {} )

	else
		printf( "WARNING - Failed to spawn GARY!" )
		return
	end

	--[[
	local objectiveAngles = self.hObjectiveEnts[ 1 ]:GetAngles()
	self.hFriend:SetAbsAngles( objectiveAngles.x, objectiveAngles.y, objectiveAngles.z )
	]]
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:ShouldAutoStartGlobalAscensionAbilities()
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:Start()
	CMapEncounter.Start( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner.szSpawnerName == "spawner_peon" then
		if hSpawner.schedule then
			local nCurrentValue = self:GetEncounterObjectiveProgress( "survive_waves" )
			self:UpdateEncounterObjective( "survive_waves", nCurrentValue + 1, nil )
		end
	end

	local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
	--print( heroes )

	for _, hSpawnedUnit in pairs ( hSpawnedUnits ) do
		if self.hFriend ~= nil and ( not self.hFriend:IsNull() ) and self.hFriend:IsAlive() then
			hSpawnedUnit:SetInitialGoalEntity( self.hFriend )
		else
			local hero = heroes[RandomInt(1, #heroes)]
			if hero ~= nil then
				printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
				hSpawnedUnit:SetInitialGoalEntity( hero )
			elseif #self.hObjectiveEnts > 0 then
				print( "Can't find a hero to attack - setting a goal position to Objective Entity" )
				hSpawnedUnit:SetInitialGoalPosition( self.hObjectiveEnts[1]:GetOrigin() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TuskSkeletons:OnTriggerStartTouch( event )
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

function CMapEncounter_TuskSkeletons:OnComplete()
	CMapEncounter.OnComplete( self )

	-- If friendly unit is still alive, grant some rewards and do other stuff
	if self.hFriend ~= nil and ( not self.hFriend:IsNull() ) and self.hFriend:IsAlive() then
		self.hFriend:Heal( self.hFriend:GetMaxHealth(), nil )
		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hFriend )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local nLives = 1
		for i = 1, nLives do
			self:DropLifeRuneFromUnit( self.hFriend, nil, true )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_TuskSkeletons
