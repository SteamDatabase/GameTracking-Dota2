require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_DireSiege == nil then
	CMapEncounter_DireSiege = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:SetCalculateRewardsFromUnitCount( true )

	self.hDireCaptain = nil
	self.nDireCaptainHealthPercentTrigger = 20
	self.nNumCatapultsToKillForReinforcements = 3
	self.bTriggeredReinforcements = false

	self.szMeleeSpawner = "spawner_melee"
	self.szRangedSpawner = "spawner_ranged"
	self.szCatapultSpawner = "spawner_catapult"
	self.szCaptainSpawner = "spawner_captain"

	self:AddSpawner( CDotaSpawner( self.szMeleeSpawner, self.szMeleeSpawner,
		{ 
			{
				EntityName = "npc_dota_assault_bad_melee_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 250.0,
			},
		} ) )
	self:AddSpawner( CDotaSpawner( self.szRangedSpawner, self.szRangedSpawner,
		{ 
			{
				EntityName = "npc_dota_assault_bad_ranged_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 250.0,
			},
		} ) )
	self:AddSpawner( CDotaSpawner( self.szCatapultSpawner, self.szCatapultSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_catapult",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
	self:AddSpawner( CDotaSpawner( self.szCaptainSpawner, self.szCaptainSpawner,
		{ 
			{
				EntityName = "npc_aghsfort_creature_dire_assault_captain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	-- reinforcement wave through portals
	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_ranged", "portal_ranged", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_assault_bad_ranged_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 250.0,
			},
		}, true
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_melee", "portal_melee", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_assault_bad_melee_creep",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 250.0,
			},
		}, true
	) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "portal_captain", "portal_captain", 8, 5, 1.0,
		{
			{
				EntityName = "npc_aghsfort_creature_dire_assault_captain",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true
	) )

end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:GetPreviewUnit()
	return "npc_dota_creature_catapult"
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:GetMaxSpawnedUnitCount()
	local nCount = 0

	local hMeleeSpawners = self:GetSpawner( self.szMeleeSpawner )
	if hMeleeSpawners then
		nCount = nCount + hMeleeSpawners:GetSpawnPositionCount()
	end

	local hRangedSpawners = self:GetSpawner( self.szRangedSpawner )
	if hRangedSpawners then
		nCount = nCount + hRangedSpawners:GetSpawnPositionCount()
	end

	local hCatapultSpawners = self:GetSpawner( self.szCatapultSpawner )
	if hCatapultSpawners then
		nCount = nCount + hCatapultSpawners:GetSpawnPositionCount()
	end

	local hCaptainSpawners = self:GetSpawner( self.szCaptainSpawner )
	if hCaptainSpawners then
		nCount = nCount + hCaptainSpawners:GetSpawnPositionCount()
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:Start()
	CMapEncounter.Start( self )

	for _,Spawner in pairs ( self:GetSpawners() ) do
		Spawner:SpawnUnits()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:SpawnReinforcements()
	if self.bTriggeredReinforcements == true then
		return
	end

	self.bTriggeredReinforcements = true
	
	self.hDireCaptain = nil
	for _, hPortalSpawner in pairs( self.PortalSpawnersV2 ) do
		hPortalSpawner:SpawnUnitsFromRandomSpawners( 1 )
	end	
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:OnThink()
	CMapEncounter.OnThink( self )

	if self.bTriggeredReinforcements == true then
		return
	end

	-- original dire captain is dead or goes below the health percent trigger
	if self.hDireCaptain ~= nil and self.hDireCaptain:IsNull() == false then
		--print( 'CMapEncounter_DireSiege:OnThink() Dire Assault Captain health percent is ' .. self.hDireCaptain:GetHealthPercent() )
		if self.hDireCaptain:IsAlive() == false or self.hDireCaptain:GetHealthPercent() < self.nDireCaptainHealthPercentTrigger then
			self:SpawnReinforcements()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if self.bTriggeredReinforcements == true then
		return
	end

	-- trigger the reinforcements after killing a set number of catapults
	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_catapult" then
		self.nNumCatapultsToKillForReinforcements = self.nNumCatapultsToKillForReinforcements - 1

		if self.nNumCatapultsToKillForReinforcements <= 0 then
			self:SpawnReinforcements()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_DireSiege:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Pinecones:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CDotaSpawner" then
		for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
			if hSpawnedUnit:GetUnitName() == "npc_aghsfort_creature_dire_assault_captain" then
				print( 'CMapEncounter_DireSiege:OnSpawnerFinished() - found original Dire Assault Captain')
				self.hDireCaptain = hSpawnedUnit
			end
		end

	elseif hSpawner:GetSpawnerType() == "CPortalSpawnerV2" then
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
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_DireSiege
