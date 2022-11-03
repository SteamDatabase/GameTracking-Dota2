--------------------------------------------------------------------------------

require( "winter2022_utility_functions" )

--------------------------------------------------------------------------------
function CWinter2022:CalculateWaveRewards()
	local flGameTime = self:GetPlayedTime()
	local flMinutes = math.max( 0, flGameTime / 60.0 )
	local flGoldMinuteAdd = 1
	for i=1,_G.WINTER2022_WAVE_REWARD_GOLD_POW do
		flGoldMinuteAdd = flGoldMinuteAdd * flMinutes
	end
	if _G.WINTER2022_WAVE_REWARD_GOLD_SQRT > 0 then
		for i=1,_G.WINTER2022_WAVE_REWARD_GOLD_SQRT do
			flGoldMinuteAdd = math.sqrt( flGoldMinuteAdd )
		end
	end
	local flGoldMinuteAdd2 = 0
	if flMinutes > _G.WINTER2022_WAVE_REWARD_GOLD_POW2_START then
		flGoldMinuteAdd2 = 1
		local flPostMinutesGold = flMinutes - _G.WINTER2022_WAVE_REWARD_GOLD_POW2_START
		for i=1,_G.WINTER2022_WAVE_REWARD_GOLD_POW2 do
			flGoldMinuteAdd2 = flGoldMinuteAdd2 * flPostMinutesGold
		end
	end
	self.nGoldPerWave = math.ceil( ( _G.WINTER2022_WAVE_REWARD_GOLD_BASE + math.max( _G.WINTER2022_WAVE_REWARD_GOLD_MIN_ADD, flGoldMinuteAdd * _G.WINTER2022_WAVE_REWARD_GOLD_COEFF + flGoldMinuteAdd2 * _G.WINTER2022_WAVE_REWARD_GOLD_COEFF2 ) ) * _G.WINTER2022_WAVE_REWARD_GOLD_FINAL_MULT )

	local flXPMinuteAdd1 = 1
	for i=1,_G.WINTER2022_WAVE_REWARD_XP_POW do
		flXPMinuteAdd1 = flXPMinuteAdd1 * flMinutes
	end
	if _G.WINTER2022_WAVE_REWARD_XP_SQRT > 0 then
		for i=1,_G.WINTER2022_WAVE_REWARD_XP_SQRT do
			flXPMinuteAdd1 = math.sqrt( flXPMinuteAdd1 )
		end
	end
	local flXPMinuteAdd2 = 0
	if flMinutes > _G.WINTER2022_WAVE_REWARD_XP_POW2_START then
		flXPMinuteAdd2 = 1
		local flPostMinutes = flMinutes - _G.WINTER2022_WAVE_REWARD_XP_POW2_START
		for i=1,_G.WINTER2022_WAVE_REWARD_XP_POW2 do
			flXPMinuteAdd2 = flXPMinuteAdd2 * flPostMinutes
		end
		if _G.WINTER2022_WAVE_REWARD_XP_SQRT2 > 0 then
			for i=1,_G.WINTER2022_WAVE_REWARD_XP_SQRT2 do
				flXPMinuteAdd2 = math.sqrt( flXPMinuteAdd2 )
			end
		end
	end
	self.nXPPerWave = math.ceil( (_G.WINTER2022_WAVE_REWARD_XP_BASE + flXPMinuteAdd1 * _G.WINTER2022_WAVE_REWARD_XP_COEFF + flXPMinuteAdd2 * _G.WINTER2022_WAVE_REWARD_XP_COEFF2) * _G.WINTER2022_WAVE_REWARD_XP_FINAL_MULT )

	printf( "++++For wave %d (round wave %d) at minute %f, gold = %d, XP = %d", self.m_nWave, self.m_nRoundWave, flMinutes, self.nGoldPerWave, self.nXPPerWave )
end

--------------------------------------------------------------------------------
function CWinter2022:SpawnAllWaves()
	for nTeam = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		for _,spawnInfo in pairs( _G.WINTER2022_SPAWNERS[ nTeam ] ) do
			local vSpawnLocation = nil

			local spawnerName = spawnInfo.SpawnerName
			local entSpawner = Entities:FindByName( nil, spawnerName )
			if not entSpawner then
				print( string.format( "Failed to find spawner named %d", spawnerName ) )
				return
			end

			local waypointName = spawnInfo.Waypoint
			local entWaypoint = Entities:FindByName( nil, waypointName )
			if not entWaypoint then
				print( string.format( "Failed to find a waypoint named %s", waypointName ) )
				return
			end

			self:SpawnWave( entSpawner, entWaypoint, nTeam )
		end
	end
end

--------------------------------------------------------------------------------
function CWinter2022:SpawnWave( hSpawner, hGoal, nTeamNumber )
	local nRound = self:GetRoundNumber()
	local tWaveData = _G.WINTER2022_WAVES[ nRound ]

	local tCreepQueue = {}
	--local vSpawnPos = OffsetXY( hSpawner:GetAbsOrigin(), hGoal:GetAbsOrigin(), 200 )
	local vSpawnPos = hSpawner:GetAbsOrigin()

	local nWeightTotal = 0
	for _,tCreepData in pairs( tWaveData.Units ) do
		local mod = tCreepData.everyNRounds or 1
		if self.m_nRoundWave % mod == 0 then
			--printf( "Adding creep %s to wave", tCreepData.name )
			local nCandyRemaining = tCreepData.candyTotal

			for i=1,tCreepData.count do
				local nUnitsRemaining = tCreepData.count - i + 1
			
				local tNewCreep = {}
			
				-- Unit selection
				tNewCreep.szCreepName = tCreepData.name
				if tCreepData.nameDire ~= nil and nTeamNumber == DOTA_TEAM_BADGUYS then
					tNewCreep.szCreepName = tCreepData.nameDire
				end

				-- Candy logic
				-- if this is the last unit, it gets remaining candy
				if nUnitsRemaining == 1 then
					tNewCreep.nCandy = nCandyRemaining
				else
					-- Otherwise if candy < units, we have a chance to drop,
					-- and if candy >= units, we drop >=1 candy.
					local flCurrentDropChance = nCandyRemaining / nUnitsRemaining
					if RandomFloat( 0, 1 ) <= flCurrentDropChance then
						tNewCreep.nCandy = math.min( nCandyRemaining, math.max( 1, math.floor( nCandyRemaining / nUnitsRemaining ) ) )
					else
						tNewCreep.nCandy = 0
					end
				end
				nCandyRemaining = nCandyRemaining - tNewCreep.nCandy

				-- Weight logic
				tNewCreep.nWeight = tCreepData.weightPer
				nWeightTotal = nWeightTotal + tNewCreep.nWeight

				table.insert( tCreepQueue, tNewCreep )
			end
		--else
			--printf( "Skipping creep %s", tCreepData.name )
		end
	end
	
	local nSpawners = 0
	for _,v in pairs(_G.WINTER2022_SPAWNERS[ nTeamNumber ]) do
		nSpawners = nSpawners + 1
	end
	local nGoldTotal = math.ceil( self.nGoldPerWave / nSpawners )
	local nXPTotal = math.ceil( self.nXPPerWave / nSpawners )
	--printf( "Spawning on %s. Wave gold = %f, XP = %f (%d spawners total in wave, total numbers %d,%d)", hSpawner:GetName(), nGoldTotal, nXPTotal, nSpawners, self.nGoldPerWave, self.nXPPerWave )
	local nGoldLeft = nGoldTotal
	local nXPLeft = nXPTotal
	local nCreepsLeft = #tCreepQueue
	for _,tCreep in pairs( tCreepQueue ) do
		nCreepsLeft = nCreepsLeft - 1
					
		local nGold = math.ceil( nGoldTotal * tCreep.nWeight / nWeightTotal )
		nGold = math.max( 0, math.min( nGoldLeft - nCreepsLeft, nGold ) )
		tCreep.nBountyGold = nGold
		nGoldLeft = nGoldLeft - nGold

		local nXP = math.ceil( nXPTotal * tCreep.nWeight / nWeightTotal )
		nXP = math.max( 0, math.min( nXPLeft - nCreepsLeft, nXP ) )
		tCreep.nBountyXP = nXP
		nXPLeft = nXPLeft - nXP
	end

	hSpawner:SetContextThink( "wave_spawn", function()
		if #tCreepQueue == 0 then
			--[[if tCreepSpawner.nWarningFX ~= nil then
				ParticleManager:DestroyParticle( tCreepSpawner.nWarningFX, false )
				tCreepSpawner.nWarningFX = nil
			end--]]
			return
		end

		local tNext = tCreepQueue[ 1 ]
		local hNewCreep = self:SpawnCreep( tNext.szCreepName, vSpawnPos, nTeamNumber )
		if hNewCreep then
			hNewCreep.nCandy = tNext.nCandy
			hNewCreep.nBountyGold = tNext.nBountyGold
			hNewCreep.nBountyXP = tNext.nBountyXP
			hNewCreep:SetDeathXP( 0 )
			hNewCreep:SetMaximumGoldBounty( 0 )
			hNewCreep:SetMinimumGoldBounty( 0 )
			hNewCreep:SetInitialGoalEntity( hGoal )
			hNewCreep:SetMustReachEachGoalEntity( true )
			--printf( "Spawner %s spawned creep %s with %d candy, %d gold, %d XP", hSpawner:GetName(), tNext.szCreepName, hNewCreep.nCandy, hNewCreep.nBountyGold, hNewCreep.nBountyXP )
		end

		table.remove( tCreepQueue, 1 )
		return 0.2
	end, 0 )
end

--------------------------------------------------------------------------------
function CWinter2022:SpawnCreep( szCreepName, vSpawnPos, nTeamNumber )
	local hNewCreep = CreateUnitByName( szCreepName, vSpawnPos, true, nil, nil, nTeamNumber )
	hNewCreep.Winter2022_bIsCore = true
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf", PATTACH_ABSORIGIN, hNewCreep )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	return hNewCreep
end
