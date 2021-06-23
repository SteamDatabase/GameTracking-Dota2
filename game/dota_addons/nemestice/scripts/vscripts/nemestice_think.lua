print( "nemestice_think.lua loaded." )



--------------------------------------------------------------------------------
function CNemestice:OnThink()
	local oldGameState = self.m_GameState
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME and self.m_GameState == _G.NEMESTICE_GAMESTATE_PREGAME then
		self:OnThink_Pregame()
	elseif self.m_GameState == _G.NEMESTICE_GAMESTATE_POSTLOAD_PHASE then
		self:OnThink_PostLoad()
	elseif self.m_GameState == _G.NEMESTICE_GAMESTATE_PREP_TIME then
		self:OnThink_PrepTime()
	elseif self.m_GameState == _G.NEMESTICE_GAMESTATE_IN_PROGRESS or self.m_GameState == _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH then
		self:OnThink_InProgress()
	elseif self.m_GameState == _G.NEMESTICE_GAMESTATE_GAMEOVER then
		-- We're done thinking.
		return
	end

	self:SendClientUpdate()

	self:ThinkShardExpiry()
	
	if self.m_bMapStateUpdated then
		self:BroadcastMapState()
		self.m_bMapStateUpdated = false
	end
	
	-- If we've advanced the game state, think once again
	if oldGameState ~= self.m_GameState then
		return self:OnThink()
	else
		return NEMESTICE_THINK_INTERVAL
	end
end

--------------------------------------------------------------------------------
function CNemestice:OnThink_Pregame()
	if not self.m_bHaveHeroesLoaded then
		local bAllHaveLoaded = true
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:IsValidTeamPlayerID( nPlayerID ) and PlayerResource:HasSelectedHero( nPlayerID ) then
				if PlayerResource:GetSelectedHeroEntity( nPlayerID ) == nil then
					bAllHaveLoaded = false
				end
			end
		end
		
		-- Once everyone has loaded in, move to round in progress.
		if ( bAllHaveLoaded ) then
			self:StartFirstInterstitial()
			return
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:OnThink_PostLoad()
	local flTime = GameRules:GetDOTATime( false, true )
	if flTime > self.m_flTimePhaseEnds then
		self:StartPrepTime()
		return
	end
end

--------------------------------------------------------------------------------
function CNemestice:UpdateMeteors()
	local flDotaTime = GameRules:GetDOTATime( false, true )

	if flDotaTime >= self.m_flNextSmallMeteorCrashTime then
		self:CreateSmallMeteorCrashSites()
	end

	if flDotaTime >= self.m_flNextMediumMeteorCrashTime then
		self:CreateMediumMeteorCrashSites()
	end	

	if flDotaTime >= self.m_flNextLargeMeteorCrashTime then
		self:CreateLargeMeteorCrashSites()
	end

	if flDotaTime >= self.flEndMeteorScreenTime then
		if self.nFXMeteorScreenParticleIndices then
			for _,nFXIndex in pairs ( self.nFXMeteorScreenParticleIndices ) do
				ParticleManager:DestroyParticle( nFXIndex, true )
			end
			self.nFXMeteorScreenParticleIndices = {}
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:OnThink_PrepTime()
	local flTime = GameRules:GetDOTATime( false, true )
	
	if self.m_nLastRoundStartShown < self:GetRoundNumber() and flTime > self.m_flTimePhaseEnds - 2.0 then
		self:ShowGameStart()
		self.m_nLastRoundStartShown = self:GetRoundNumber()
	end
	

	if flTime > self.m_flTimePhaseEnds - 5 and self.m_nLastRoundHorn ~= self:GetRoundNumber() then
		EmitGlobalSound( "Spring2021.GameStart" )
		self.m_nLastRoundHorn = self:GetRoundNumber()
	end

	self:UpdateMeteors()
	
	self:ApplySpawnWarningFX()

	if flTime > self.m_flTimePhaseEnds then
		self:EndPrepTime()
		return
	end
end

--------------------------------------------------------------------------------
function CNemestice:ShowGameStart()
	FireGameEvent( "game_start", {} )
end

--------------------------------------------------------------------------------
function CNemestice:OnThink_InProgress()
	if self._bDevMode and self._bDevNoRounds then
		return 1
	end

	-- Score-based round ends
	local nRadiant = self:GetTowersControlledBy( DOTA_TEAM_GOODGUYS, true )
	local nDire = self:GetTowersControlledBy( DOTA_TEAM_BADGUYS, true )

	if nDire == 0 then
		self:WinGame( DOTA_TEAM_GOODGUYS )
		return
	end
	if nRadiant == 0 then
		self:WinGame( DOTA_TEAM_BADGUYS )
		return
	end

	-- Sudden death
	if self.m_GameState == _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH then
		if nRadiant > nDire then
			self:WinGame( DOTA_TEAM_GOODGUYS )
			return
		elseif nDire > nRadiant then
			self:WinGame( DOTA_TEAM_BADGUYS )
			return
		end
	end

	local flDotaTime = GameRules:GetDOTATime( false, true )
	local flTimeRemaining = self.m_flTimePhaseEnds - flDotaTime
	local flRoundTimeElapsed = GameRules:GetDOTATime( false, true ) - self.m_flTimePhaseStarted

	if self:GetPlayedTime() > _G.NEMESTICE_END_TIME and self.m_GameState ~= _G.NEMESTICE_GAMESTATE_SUDDEN_DEATH then
		self:GameTimeExpired()
		-- Don't return, because we might go into overtime.
	end

	-- instead, check here.
	if self:IsGameInProgress() == false then
		return
	end

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		local hPlayer = PlayerResource:GetPlayer( nPlayerID )
		if hPlayer ~= nil then
			local hPlayerHero = hPlayer:GetAssignedHero()
			if hPlayerHero ~= nil and hPlayerHero:IsNull() == false and hPlayerHero:GetBuybackCooldownTime() - GameRules:GetGameTime() > _G.NEMESTICE_BUYBACK_COOLDOWN then
				hPlayerHero:SetBuybackCooldownTime( _G.NEMESTICE_BUYBACK_COOLDOWN )
			end
		end
	end

	if flDotaTime >= self.m_flNextTowerHealthTickTime then
		self.m_flNextTowerHealthTickTime = self.m_flNextTowerHealthTickTime + _G.NEMESTICE_TOWER_HEALTH_TICK_RATE
		local nLogTime = math.ceil( self:GetPlayedTime() )
		local tTowersHealth = self:GetAllTowersCurrentPercentHealth()
		for sTowerKey, nPctHealth in pairs( tTowersHealth ) do
			if ( self.m_vecAllTowersPercentHealthHistory[ sTowerKey ] == nil ) then
				self.m_vecAllTowersPercentHealthHistory[ sTowerKey ] = {}
			end
			self.m_vecAllTowersPercentHealthHistory[ sTowerKey ][ nLogTime ] = nPctHealth
		end
		local flRadiant = self:GetCurrentTowerHealthForTeam( DOTA_TEAM_GOODGUYS )
		local flDire = self:GetCurrentTowerHealthForTeam( DOTA_TEAM_BADGUYS )
		local tCurrentHealth = { radiant = flRadiant, dire = flDire } 
		self.m_vecTowerHealthHistory[ nLogTime ] = tCurrentHealth
		self:TakeSnapshotOfTowerCreepDamage()
	end

	self:UpdateMeteors()

	self:UpdateRoundNumber( true, 0 )
	self.nActiveLanes[ DOTA_TEAM_GOODGUYS ] = 0
	self.nActiveLanes[ DOTA_TEAM_BADGUYS ] = 0
	for sName,tCreepSpawner in pairs( self.tCreepSpawners ) do
		tCreepSpawner.tWaves = {}
	end
	for sName,tCreepSpawner in pairs( self.tCreepSpawners ) do
		--printf("checking adjacency for spawner %s", sName )
		local hSpawner = tCreepSpawner["building"]
		if hSpawner ~= nil and hSpawner:IsNull() == false and hSpawner:IsAlive() then
			local tAdjacentSpawnerNames = self.m_tTowerGraph[ sName ]
			local bSurroundedByAlliedSpawners = true
			local nLanes = 0
			for sNameAdj,sAdjacentSpawnerName in pairs( tAdjacentSpawnerNames ) do
				local hAdjacentSpawner = self.tCreepSpawners[ sAdjacentSpawnerName ][ "building" ]
				if hAdjacentSpawner ~= nil and hAdjacentSpawner:IsNull() == false and hAdjacentSpawner:IsAlive() and hAdjacentSpawner:GetTeamNumber() ~= hSpawner:GetTeamNumber() then
					bSurroundedByAlliedSpawners = false
					nLanes = nLanes + 1
					table.insert( tCreepSpawner.tWaves, sAdjacentSpawnerName )
				end
			end
			self.nActiveLanes[ hSpawner:GetTeamNumber() ] = self.nActiveLanes[ hSpawner:GetTeamNumber() ] + nLanes

			--[[if bSurroundedByAlliedSpawners then 
				kv = {}
				hSpawner:AddNewModifier( nil, nil, "modifier_invulnerable", kv )
			else
				hSpawner:RemoveModifierByName( "modifier_invulnerable" )
			end--]]
			hSpawner.bSurroundedByAlliedSpawners = bSurroundedByAlliedSpawners
		end
	end

	self:ApplySpawnWarningFX()

	if flDotaTime >= self.m_flNextSpawnTime then
		self.m_nWave = self.m_nWave + 1
		print ( "spawning creep wave " .. self.m_nWave .. " at " .. flDotaTime )
		self.m_flNextSpawnTime = self.m_flNextSpawnTime + _G.NEMESTICE_SPAWN_DELAY

		-- Calculate rewards
		local flMinutes = math.max( 0, self:GetPlayedTime() / 60.0 )
		local flGoldMinuteAdd = 1
		for i=1,_G.NEMESTICE_WAVE_REWARD_GOLD_POW do
			flGoldMinuteAdd = flGoldMinuteAdd * flMinutes
		end
		if _G.NEMESTICE_WAVE_REWARD_GOLD_SQRT > 0 then
			for i=1,_G.NEMESTICE_WAVE_REWARD_GOLD_SQRT do
				flGoldMinuteAdd = math.sqrt( flGoldMinuteAdd )
			end
		end
		local flGoldMinuteAdd2 = 0
		if flMinutes > _G.NEMESTICE_WAVE_REWARD_GOLD_POW2_START then
			flGoldMinuteAdd2 = 1
			local flPostMinutesGold = flMinutes - _G.NEMESTICE_WAVE_REWARD_GOLD_POW2_START
			for i=1,_G.NEMESTICE_WAVE_REWARD_GOLD_POW2 do
				flGoldMinuteAdd2 = flGoldMinuteAdd2 * flPostMinutesGold
			end
		end
		self.nGoldPerWave = math.ceil( _G.NEMESTICE_WAVE_REWARD_GOLD_BASE + math.max( _G.NEMESTICE_WAVE_REWARD_GOLD_MIN_ADD, flGoldMinuteAdd * _G.NEMESTICE_WAVE_REWARD_GOLD_COEFF + flGoldMinuteAdd2 * _G.NEMESTICE_WAVE_REWARD_GOLD_COEFF2 ) )

		local flXPMinuteAdd1 = 1
		for i=1,_G.NEMESTICE_WAVE_REWARD_XP_POW do
			flXPMinuteAdd1 = flXPMinuteAdd1 * flMinutes
		end
		if _G.NEMESTICE_WAVE_REWARD_XP_SQRT > 0 then
			for i=1,_G.NEMESTICE_WAVE_REWARD_XP_SQRT do
				flXPMinuteAdd1 = math.sqrt( flXPMinuteAdd1 )
			end
		end
		local flXPMinuteAdd2 = 0
		if flMinutes > _G.NEMESTICE_WAVE_REWARD_XP_POW2_START then
			flXPMinuteAdd2 = 1
			local flPostMinutes = flMinutes - _G.NEMESTICE_WAVE_REWARD_XP_POW2_START
			for i=1,_G.NEMESTICE_WAVE_REWARD_XP_POW2 do
				flXPMinuteAdd2 = flXPMinuteAdd2 * flPostMinutes
			end
			if _G.NEMESTICE_WAVE_REWARD_XP_SQRT2 > 0 then
				for i=1,_G.NEMESTICE_WAVE_REWARD_XP_SQRT2 do
					flXPMinuteAdd2 = math.sqrt( flXPMinuteAdd2 )
				end
			end
		end
		self.nXPPerWave = math.ceil( _G.NEMESTICE_WAVE_REWARD_XP_BASE + flXPMinuteAdd1 * _G.NEMESTICE_WAVE_REWARD_XP_COEFF + flXPMinuteAdd2 * _G.NEMESTICE_WAVE_REWARD_XP_COEFF2 )

		printf( "++++For wave at minute %f, gold = %d, XP = %d", flMinutes, self.nGoldPerWave, self.nXPPerWave )

		for _,tCreepSpawner in pairs( self.tCreepSpawners ) do
			self:SpawnCreepWaves( tCreepSpawner )
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:ApplySpawnWarningFX()
	if self.m_flNextSpawnTime > 0 and GameRules:GetDOTATime( false, true ) >= self.m_flNextSpawnTime - _G.NEMESTICE_WAVE_WARNING_TIME then
		for _,tCreepSpawner in pairs( self.tCreepSpawners ) do
			local hBuilding = tCreepSpawner[ "building" ]
			if hBuilding ~= nil and hBuilding:IsNull() == false and hBuilding:IsAlive() then
				if tCreepSpawner.nWarningFX == nil then
					tCreepSpawner.nWarningFX = ParticleManager:CreateParticle( "particles/units/heroes/heroes_underlord/abyssal_underlord_darkrift_target.vpcf", PATTACH_OVERHEAD_FOLLOW, hBuilding )
					ParticleManager:SetParticleControlEnt( tCreepSpawner.nWarningFX, 1, hBuilding, PATTACH_POINT_FOLLOW, "attach_hitloc", hBuilding:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt( tCreepSpawner.nWarningFX, 6, hBuilding, PATTACH_ABSORIGIN_FOLLOW, nil, hBuilding:GetAbsOrigin(), true )
					ParticleManager:SetParticleControl( tCreepSpawner.nWarningFX, 10, Vector( _G.NEMESTICE_WAVE_WARNING_TIME, _G.NEMESTICE_WAVE_WARNING_TIME, _G.NEMESTICE_WAVE_WARNING_TIME ) );
				end
			else
				if tCreepSpawner.nWarningFX ~= nil then
					ParticleManager:DestroyParticle( tCreepSpawner.nWarningFX, false )
					tCreepSpawner.nWarningFX = nil
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:SpawnCreepWaves( tCreepSpawner )
	if tCreepSpawner == nil then
		return
	end

	local hCreepSpawnerBuilding = tCreepSpawner[ "building" ]
	if hCreepSpawnerBuilding == nil or hCreepSpawnerBuilding:IsNull() or hCreepSpawnerBuilding:IsAlive() == false then
		return
	end

	if hCreepSpawnerBuilding:FindModifierByName( "modifier_barracks_rebuilding" ) then
		return
	end

	local nWavesSpawned = 0
	--printf( "Tower %s spawning waves", tCreepSpawner[ "name" ] )
	for _,sTargetSpawnerName in pairs( tCreepSpawner.tWaves ) do
		local hTargetBuilding = self.tCreepSpawners[ sTargetSpawnerName ][ "building" ]
		if hTargetBuilding ~= nil and hTargetBuilding:IsNull() == false and hTargetBuilding:IsAlive() and hTargetBuilding:GetTeamNumber() ~= hCreepSpawnerBuilding:GetTeamNumber() and hTargetBuilding:FindModifierByName( "modifier_barracks_rebuilding" ) == nil then
			local hGoal = Entities:FindByName( nil, tCreepSpawner[ "name" ] .. "_to_" .. sTargetSpawnerName  )
			printf( "Spawning to %s", sTargetSpawnerName )
			self:SpawnWave( tCreepSpawner, hCreepSpawnerBuilding, sTargetSpawnerName, hTargetBuilding, hGoal )
			nWavesSpawned = nWavesSpawned + 1
		end
	end
	--printf( " Total waves spawned %d", nWavesSpawned )
	
	
	for _,hModifier in pairs( hCreepSpawnerBuilding:FindAllModifiers() ) do
		if hModifier.IsSingleSpawnModifier ~= nil and hModifier:IsSingleSpawnModifier() then
			hModifier:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
function CNemestice:SpawnWave( tCreepSpawner, hCreepSpawnerBuilding, sAdjacentSpawnerName, hTargetBuilding, hGoal )
	do
		local tCreepQueue = {}
		local nEnergyTotal = 0
		local vEnemyPos = hCreepSpawnerBuilding:GetAbsOrigin()
		if hTargetBuilding ~= nil then
			vEnemyPos = hTargetBuilding:GetAbsOrigin()
		else
			local hEnemyBuildings = FindUnitsInRadius( hCreepSpawnerBuilding:GetTeamNumber(), hCreepSpawnerBuilding:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			if #hEnemyBuildings > 0 then
				vEnemyPos = hEnemyBuildings[1]:GetAbsOrigin()
			else
				vEnemyPos = Vector(0, 1, 0)
			end
		end
		local vSpawnPos = OffsetXY( hCreepSpawnerBuilding:GetAbsOrigin(), vEnemyPos, 200 )
				
		for _,hModifier in pairs( hCreepSpawnerBuilding:FindAllModifiers() ) do
			if hModifier.GetAdditionalCreeps ~= nil then
				local tAdditionalCreeps = hModifier:GetAdditionalCreeps()
				for _,tNewCreep in pairs( tAdditionalCreeps ) do 
					table.insert( tCreepQueue, tNewCreep )
					nEnergyTotal = nEnergyTotal + tNewCreep.nMeteorEnergy
				end
			end
		end
				
		TableSortBy( tCreepQueue, function ( tCreep ) return tCreep.nPosition or 0 end )
				
		local nGoldTotal = math.ceil( self.nGoldPerWave / self.nActiveLanes[ hCreepSpawnerBuilding:GetTeamNumber() ] )
		local nXPTotal = math.ceil( self.nXPPerWave / self.nActiveLanes[ hCreepSpawnerBuilding:GetTeamNumber() ] )
		local nGoldLeft = nGoldTotal
		local nXPLeft = nXPTotal
		local nCreepsLeft = #tCreepQueue
		-- TODO: Sort so we apply to least-energy creeps first. Probably don't need it, but it would be good to do.
		for _,tCreep in pairs( tCreepQueue ) do
			nCreepsLeft = nCreepsLeft - 1
					
			local nGold = math.ceil( nGoldTotal * tCreep.nMeteorEnergy / nEnergyTotal )
			nGold = math.max( 0, math.min( nGoldLeft - nCreepsLeft, nGold ) )
			tCreep.nBountyGold = nGold
			nGoldLeft = nGoldLeft - nGold

			local nXP = math.ceil( nXPTotal * tCreep.nMeteorEnergy / nEnergyTotal )
			nXP = math.max( 0, math.min( nXPLeft - nCreepsLeft, nXP ) )
			tCreep.nBountyXP = nXP
			nXPLeft = nXPLeft - nXP
		end

		hCreepSpawnerBuilding:SetContextThink( sAdjacentSpawnerName or "default_wave", function()
			if #tCreepQueue == 0 then
				if tCreepSpawner.nWarningFX ~= nil then
					ParticleManager:DestroyParticle( tCreepSpawner.nWarningFX, false )
					tCreepSpawner.nWarningFX = nil
				end
				return
			end

			local tNext = tCreepQueue[ 1 ]
			local hNewCreep = self:SpawnCreep( tNext.szCreepName, vSpawnPos, hCreepSpawnerBuilding:GetTeam() )
			if hNewCreep then
				hNewCreep.nMeteorEnergy = tNext.nMeteorEnergy or 2
				hNewCreep.nBountyGold = tNext.nBountyGold
				hNewCreep.nBountyXP = tNext.nBountyXP
				hNewCreep:SetDeathXP( 0 )
				hNewCreep:SetMaximumGoldBounty( 0 )
				hNewCreep:SetMinimumGoldBounty( 0 )
				if hGoal ~= nil and hGoal:IsNull() == false then
					hNewCreep:SetInitialGoalEntity( hGoal )
					hNewCreep:SetMustReachEachGoalEntity( true )
					hNewCreep.bIsPathing = true
				else
					hNewCreep.bIsPathing = false
				end
				ApplyBuildingTargetAI( hNewCreep, hTargetBuilding )

				if tNext.hCallback ~= nil and tNext.hModifierSource ~= nil then
					tNext.hCallback( tNext.hModifierSource, hNewCreep )
				end
				if tNext.vecColor ~= nil then
					hNewCreep:SetRenderColor( tNext.vecColor.x, tNext.vecColor.y, tNext.vecColor.z )
				end
			end

			table.remove( tCreepQueue, 1 )
			return 0.2
		end, 0 )
	end
end
--------------------------------------------------------------------------------
function CNemestice:SpawnCreep( szCreepName, vSpawnPos, nTeamNumber )
	local hNewCreep = CreateUnitByName( szCreepName, vSpawnPos, true, nil, nil, nTeamNumber )
	hNewCreep.bSpringCreep = true
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/cm_arcana_pup_lvlup_godray.vpcf", PATTACH_ABSORIGIN, hNewCreep )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	return hNewCreep
end

--------------------------------------------------------------------------------
function ApplyBuildingTargetAI( hCreep, hTargetBuilding )
	if hCreep.customAI == true then
		return
	end

	hCreep.hTarget = hTargetBuilding

	hCreep:SetContextThink( "TargetAI", function()
		if hCreep:IsOwnedByAnyPlayer() then
			return 3
		end

		if hCreep.OverrideCreepAI == true then
			--print( '***Core Creep AI being overridden for ' .. hCreep:GetUnitName() )
			return 3
		end

		if hCreep.bIsPathing == true then
			--if hCreep.hTarget == nil or hCreep.hTarget:IsNull() == true or hCreep.hTarget:IsAlive() == false then
				--hCreep.bIsPathing = false
			--else
				return 3
			--end
		end

		-- Done as separate function so it can be called instantly
		-- when a creep finishes its path
		GameRules.Nemestice:ValidateCreepTargeting( hCreep )
		return 3
	end, 0)
end

--------------------------------------------------------------------------------
function CNemestice:ValidateCreepTargeting( hCreep )
	local fnIsValidTarget = Bind( IsValidTarget, hCreep )
	if not fnIsValidTarget( hCreep.hTarget ) then
		local hEnemyBuildings = FindUnitsInRadius( hCreep:GetTeamNumber(), hCreep:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		hCreep.hTarget = TableFindFirst( hEnemyBuildings, fnIsValidTarget )
	end

	if fnIsValidTarget( hCreep.hTarget ) and hCreep:GetCurrentActiveAbility() == nil and hCreep.bIsBusy ~= true then
		hCreep:MoveToPositionAggressive( hCreep.hTarget:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------------------
function IsValidTarget( hCreep, hTarget )
	if hTarget ~= nil and hTarget:IsNull() == false 
		and ( 
			( hTarget:IsAlive() == true
				and hTarget:GetTeamNumber() ~= hCreep:GetTeamNumber() ) 
				-- Pathing to dead tower now taken care of by map paths
			--[[or ( hCreep:GetAbsOrigin() - hTarget:GetAbsOrigin() ):Length2D() > 500]] ) then

		if hTarget:IsInvulnerable() == false then
			return true
		end

		hBuildBuff = hTarget:FindModifierByName( "modifier_barracks_rebuilding" )
		hInvBuff = hTarget:FindModifierByName( "modifier_invulnerable" )
		if hBuildBuff ~= nil and ( hInvBuff == nil or hInvBuff:IsNull() == true ) then
			return true
		end
			
		return false
	end
	return false
end

--------------------------------------------------------------------------------
function OffsetXY( vOrigin, vTarget, nOffset )
	local diff = vTarget - vOrigin
	diff.z = 0
	return vOrigin + diff:Normalized() * nOffset
end
