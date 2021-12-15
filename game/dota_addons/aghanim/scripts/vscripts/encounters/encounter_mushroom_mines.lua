
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_MushroomMines == nil then
	CMapEncounter_MushroomMines = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.nNumShroomGiantSpawners = 3

	self.fShamanSpawnTimer = -1.0
	self.fShamanRespawnTimeMin = 4.0
	self.fShamanRespawnTimeMax = 8.0

	self:SetCalculateRewardsFromUnitCount( true )

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

	-- DON'T SET SCHEDULES FOR THESE
	--self:SetSpawnerSchedule( "spawner_captain", nil )
	--self:SetSpawnerSchedule( "spawner_peon", nil )
	--self:SetSpawnerSchedule( "shaman_portal", nil )

	self.bShroomGiantsKilled = false
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:InitializeObjectives()
	self.nTotalGiants = self.nNumShroomGiantSpawners
	self:AddEncounterObjective( "kill_shroom_giants", 0, self.nTotalGiants )
end


--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:OnThink()
	CMapEncounter.OnThink( self )

	if self.fShamanSpawnTimer > 0 and self.fShamanSpawnTimer < GameRules:GetGameTime() then
		print( 'Shaman ready to spawn!' )
		if self.bShroomGiantsKilled == false then
			local hShamanPortal = self:GetPortalSpawnerV2( "shaman_portal" )
			hShamanPortal:SpawnUnitsFromRandomSpawners( 1 )
		end
		self.fShamanSpawnTimer = -1.0	-- this will be reset when the shaman is killed
	end
end

--------------------------------------------------------------------------------

--[[
function CMapEncounter_MushroomMines:MustKillForEncounterCompletion( hEnemyCreature )
    if hEnemyCreature:GetUnitName() == "npc_dota_creature_shadow_shaman" then
    	return false
    end

    return true
end
--]]

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:OnRequiredEnemyKilled( hAttacker, hVictim )
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

function CMapEncounter_MushroomMines:SetShamanRespawnTimer()
	local fTimer = RandomFloat( self.fShamanRespawnTimeMin, self.fShamanRespawnTimeMax )
	self.fShamanSpawnTimer = GameRules:GetGameTime() + fTimer
	print( 'Shadow Shaman spawn set for GetGameTime() + ' .. fTimer )
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:WakeUpShroomlings()
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

function CMapEncounter_MushroomMines:GetPreviewUnit()
	return "npc_dota_creature_shroom_giant"
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:GetMaxSpawnedUnitCount()

	local nCount = 0

	for _,Spawner in pairs ( self.Spawners ) do
		nCount = nCount + self:ComputeUnitsSpawnedBySchedule( Spawner )
	end

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:Start()
	CMapEncounter.Start( self )

	-- spawn a set number of captains from the available spawners
	local GiantSpawner = self:GetSpawner( "spawner_captain" )
	GiantSpawner:SpawnUnitsFromRandomSpawners( self.nNumShroomGiantSpawners )

	-- spawn standing trash at half of the peon spawn locations
	local ShroomSpawner = self:GetSpawner( "spawner_peon" )
	local nSpawnPositionCount = ShroomSpawner:GetSpawnPositionCount()
	ShroomSpawner:SpawnUnitsFromRandomSpawners( nSpawnPositionCount / 2 )

	self:SetShamanRespawnTimer()
end

--------------------------------------------------------------------------------

function CMapEncounter_MushroomMines:OnSpawnerFinished( hSpawner, hSpawnedUnits )
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
			end
		end
	end
end

return CMapEncounter_MushroomMines
