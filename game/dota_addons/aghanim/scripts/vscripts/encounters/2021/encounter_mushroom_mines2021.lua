
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_MushroomMines2021 == nil then
	CMapEncounter_MushroomMines2021 = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.nNumShroomGiantSpawners = 3

	self.fShamanSpawnTimer = -1.0
	self.fShamanRespawnTimeMin = 4.0
	self.fShamanRespawnTimeMax = 8.0

	

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{
			{
				EntityName = "npc_dota_creature_shroomling",
				Team = DOTA_TEAM_BADGUYS,
				Count = 3,
				PositionNoise = 500.0,
			},
		} ) )
	
	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
		{
			{
				EntityName = "npc_dota_creature_shroom_giant",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			}
		} ) )

	self:AddPortalSpawnerV2( CPortalSpawnerV2( "shaman_portal", "shaman_portal", 8, 5, 1.0,
		{
			{
				EntityName = "npc_dota_creature_shadow_shaman",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}, true
	) )

	self.bShroomGiantsKilled = false
	self.nTotalSpawnedUnits = 20 --hack
	self:SetCalculateRewardsFromUnitCount( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:InitializeObjectives()
	CMapEncounter.InitializeObjectives( self )

	self.nTotalGiants = self.nNumShroomGiantSpawners
	self:AddEncounterObjective( "kill_shroom_giants", 0, self.nTotalGiants )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:GetMaxSpawnedUnitCount()
	return self.nTotalSpawnedUnits
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:OnThink()
	CMapEncounter.OnThink( self )

	if self.fShamanSpawnTimer > 0 and self.fShamanSpawnTimer < GameRules:GetGameTime() then
		print( 'Shaman ready to spawn!' )
		local hShamanPortal = self:GetPortalSpawnerV2( "shaman_portal" )
		hShamanPortal:SpawnUnitsFromRandomSpawners( 1 )
		self.fShamanSpawnTimer = -1.0	-- this will be reset when the shaman is killed
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_shroom_giant" then
		local nCurrentValue = self:GetEncounterObjectiveProgress( "kill_shroom_giants" )
		nCurrentValue = nCurrentValue + 1
		self:UpdateEncounterObjective( "kill_shroom_giants", nCurrentValue, nil )
		--print( 'Updating kills objective to ' .. nCurrentValue )

		if nCurrentValue >= self.nTotalGiants then
			self.bShroomGiantsKilled = true
			self:AddEncounterObjective( "defeat_all_enemies", 0, 0 ) 
			self:WakeUpShroomlings()
		end

	elseif hVictim and hVictim:GetUnitName() == "npc_dota_creature_shadow_shaman" then
		print( 'Shadow Shaman killed!' )
		self:SetShamanRespawnTimer()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:SetShamanRespawnTimer()
	local fTimer = RandomFloat( self.fShamanRespawnTimeMin, self.fShamanRespawnTimeMax )
	self.fShamanSpawnTimer = GameRules:GetGameTime() + fTimer
	print( 'Shadow Shaman spawn set for GetGameTime() + ' .. fTimer )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:WakeUpShroomlings()
	local vecShroomlings = self:GetSpawnedUnitsOfType( "npc_dota_creature_shroomling" )
	print( 'Waking up ' .. #vecShroomlings .. " Shroomlings")
	if #vecShroomlings > 0 then
		for _,hUnit in pairs ( vecShroomlings ) do
			local flWakeTime = RandomFloat( 2.0, 15.0 )
			print( 'Wake up time set to ' .. flWakeTime )

			local hSleepBuff = hUnit:FindModifierByName( "modifier_shroomling_sleep" )
			if hSleepBuff ~= nil then
				hSleepBuff:SetDuration( flWakeTime, true )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:GetPreviewUnit()
	return "npc_dota_creature_shroom_giant"
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:Start()
	CMapEncounter.Start( self )
	self.nTotalSpawnedUnits = 0
	-- spawn a set number of captains from the available spawners
	local GiantSpawner = self:GetSpawner( "spawner_captain" )
	GiantSpawner:SpawnUnitsFromRandomSpawners( self.nNumShroomGiantSpawners )
	self.nTotalSpawnedUnits = self.nTotalSpawnedUnits + ( self.nNumShroomGiantSpawners * 6 ) -- 1 + 5, giant and death spawn ability

	-- spawn standing trash at half of the peon spawn locations
	local ShroomSpawner = self:GetSpawner( "spawner_peon" )
	local nSpawnPositionCount = ShroomSpawner:GetSpawnPositionCount()
	local hUnits = ShroomSpawner:SpawnUnitsFromRandomSpawners( nSpawnPositionCount / 2 )
	if #hUnits > 0 then 
		self.nTotalSpawnedUnits = self.nTotalSpawnedUnits + 1
	end

	self:SetShamanRespawnTimer()
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines2021:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
	--print( "CMapEncounter_Pinecones:OnSpawnerFinished" )

	if hSpawner:GetSpawnerType() == "CPortalSpawnerV2" then	-- only aggro the shamans that pop out of the spawners
		local heroes = FindRealLivingEnemyHeroesInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), FIND_UNITS_EVERYWHERE )
		if #heroes > 0 then
			for _,hSpawnedUnit in pairs( hSpawnedUnits ) do
				local hero = heroes[RandomInt(1, #heroes)]
				if hero ~= nil then
					--printf( "Set initial goal entity for unit \"%s\" to \"%s\"", hSpawnedUnit:GetUnitName(), hero:GetUnitName() )
					hSpawnedUnit:SetInitialGoalEntity( hero )
				end

				self.nTotalSpawnedUnits = self.nTotalSpawnedUnits + 1
			end
		end
	end
end

return CMapEncounter_MushroomMines2021
