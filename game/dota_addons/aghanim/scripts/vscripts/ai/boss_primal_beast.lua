require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossPrimalBeast == nil then
	CBossPrimalBeast = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossPrimalBeast( thisEntity, 1.0 )
	end
end


--------------------------------------------------------------------------------

function CBossPrimalBeast:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )
	self.bLeaptIntoMap = false
	self.bDefeated = false
	self.MAX_ONSLAUGHTS = 3
	self.MAX_THROWS = 3
	self.fPhasePauseTime = 0.25

	self.nCurrentThrowCount = 0
	self.nCurrentOnslaughtCount = 0
	
	self.PHASE_ONSLAUGHT = 1
	self.PHASE_THROW_ATTACK = 2	

	self.PHASE_HEAVY_STEPS = 3

	self.PHASE_PRIMAL_ROAR = 4
	self.PHASE_RAPID_VAULT = 5
	self.PHASE_PUMMEL = 6

	self.PHASE_TECTONIC_ATTACK = 7

	self.PhaseNames = 
	{
		"PHASE_ONSLAUGHT",
		"PHASE_THROW_ATTACK",
		"PHASE_HEAVY_STEPS",
		"PHASE_PRIMAL_ROAR",
		"PHASE_RAPID_VAULT",
		"PHASE_PUMMEL",
		"PHASE_TECTONIC_ATTACK",
	}
	self.nHeavyStepsPct = 80
	self.bHeavyStepsEnabled = false
	self.nRapidVaultPct = 60
	self.bRapidVaultEnabled = false


	self.nTectonicAttackPct = 40
	self.bTectonicAttackEnabled = false
	self.nLevelUpPct = 50
	self.bHasLeveledUp = false

	self.AllowedPhases = 
	{
		self.PHASE_ONSLAUGHT,
		self.PHASE_THROW_ATTACK,
	}

	self.hCurrentPummelTarget = nil
	self.flInitialAcquireRange = 5000
	self.flAggroAcquireRange = 5000
	self.nPhaseIndex = 1
	self.bReturnHome = true
	self.vLastMoveLocation = Vector( -3328, 3264, 0 )

	self.bInVictorySequence = false 
	self.flLastSpeakTime = -1000
	self.flPostSpeechTime = -1000
	self.flPostSpeechDelay = 0.5
	self.bIsSpeaking = false
	self.nCallbacksIssued = 0
	self.bShouldThrowDummyRocks = false

	self.nDeathListener = ListenToGameEvent( "entity_killed", Dynamic_Wrap( getclass( self ), 'OnEntityKilled' ), self )


	self.me:SetThink( "OnBossBeastThink", self, "OnBossBeastThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:GetCurrentPhase()
	return self.AllowedPhases[ self.nPhaseIndex ]
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:UpdateOnRemove()
	StopListeningToGameEvent( self.nDeathListener )
end


function CBossPrimalBeast:SetEncounter( hEncounter )
	CBossBase.SetEncounter( self, hEncounter )

	self.MovePositions = {}

	local MovePositions = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "move_position" )
	for _,hEnt in pairs ( MovePositions ) do
		table.insert( self.MovePositions, hEnt:GetAbsOrigin() )
	end 

	local HomePositions = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "home_position" )
	for _,hHomeEnt in pairs ( HomePositions ) do
		if hHomeEnt ~= nil then 
			self.HomePosition = hHomeEnt:GetAbsOrigin()
			break
		end
	end 

end

--------------------------------------------------------------------------------

function CBossPrimalBeast:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hOnslaughtAbility = self.me:FindAbilityByName( "aghsfort_primal_beast_boss_onslaught" )
	if self.hOnslaughtAbility ~= nil then
		self.hOnslaughtAbility.hOnslaughtAbilityPhase = 1 
		self.hOnslaughtAbility.Evaluate = self.EvaluateOnslaughtAbility
	 	self.AbilityPriority[ self.hOnslaughtAbility:GetAbilityName() ] = 1
	end


	self.hThrowAttack = self.me:FindAbilityByName( "aghsfort_primal_beast_throw_attack" )
	if self.hThrowAttack ~= nil then
		self.hThrowAttack.Evaluate = self.EvaluateThrowAttack
	 	self.AbilityPriority[ self.hThrowAttack:GetAbilityName() ] = 2
	end


	self.hHeavySteps = self.me:FindAbilityByName( "aghsfort_primal_beast_boss_heavysteps" )
	if self.hHeavySteps ~= nil then
		self.hHeavySteps.Evaluate = self.EvaluateHeavySteps
	 	self.AbilityPriority[ self.hHeavySteps:GetAbilityName() ] = 3
	end


	self.hPrimalRoarAbility = self.me:FindAbilityByName( "aghsfort_primalbeast_boss_primal_roar" )
	if self.hPrimalRoarAbility ~= nil then
		self.hPrimalRoarAbility.Evaluate = self.EvaluatePrimalRoarAbility
	 	self.AbilityPriority[ self.hPrimalRoarAbility:GetAbilityName() ] = 4
	end	


	self.hRapidVaultAbility = self.me:FindAbilityByName( "aghsfort_primal_beast_boss_rapid_vault" )
	if self.hRapidVaultAbility ~= nil then
		self.hRapidVaultAbility.Evaluate = self.EvaluateRapidVaultAbility
	 	self.AbilityPriority[ self.hRapidVaultAbility:GetAbilityName() ] = 5
	end


	self.hPummelAbility = self.me:FindAbilityByName( "aghsfort_primal_beast_boss_pummel" )
	if self.hPummelAbility ~= nil then
		self.hPummelAbility.Evaluate = self.EvaluatePummelAbility
	 	self.AbilityPriority[ self.hPummelAbility:GetAbilityName() ] = 6
	end

	self.hTectonicAttack = self.me:FindAbilityByName( "aghsfort_primal_beast_tectonic_shift" )
	if self.hTectonicAttack ~= nil then
		self.hTectonicAttack.Evaluate = self.EvaluateTectonicAttack
	 	self.AbilityPriority[ self.hTectonicAttack:GetAbilityName() ] = 7
	end
end
--------------------------------------------------------------------------------
 
function CBossPrimalBeast:OnBossBeastThink()
	if self.bDefeated then
		return -1
	end

	if thisEntity.bStarted ~= true then
		return 0.25
	end

	if self.bInVictorySequence then
		self.Encounter.bInVictorySequence = true 
		return -1
	end


	if self:IsCastingAnAbility() == false and GameRules:IsGamePaused() == false then
		self:ChangePhase()
	end


	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:ChangePhase()

	if self.nPhaseIndex > #self.AllowedPhases then
		self.nPhaseIndex = #self.AllowedPhases
	end

	print ( "BEAST is attempting to change phase! current:" .. self.PhaseNames[self:GetCurrentPhase()] )
	self.nPhase = self.AllowedPhases[ self.nPhaseIndex ]


	if self.nPhase == self.PHASE_ONSLAUGHT then
		if self.nCurrentOnslaughtCount < self.MAX_ONSLAUGHTS then
			return
		else
			self.nCurrentOnslaughtCount = 0
		end
	elseif self.nPhase == self.PHASE_THROW_ATTACK then
		if self.nCurrentThrowCount < self.MAX_THROWS then
			return
		else
			self.nCurrentThrowCount = 0
		end
	elseif self.nPhase == self.PHASE_TECTONIC_ATTACK then
		local fDistanceToHome = (self.me:GetAbsOrigin() - self.HomePosition):Length()
		if fDistanceToHome < 400 and self.bShouldChangePhaseTectonic == false then 
			return
		end
	end
	
	if self.nPhaseIndex == #self.AllowedPhases then
		self.nPhaseIndex = 1
	else
		self.nPhaseIndex = self.nPhaseIndex + 1
	end

	print ( "BEAST is changing phase! new:" .. self.PhaseNames[self:GetCurrentPhase()] )
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct < self.nHeavyStepsPct and self.bHeavyStepsEnabled == false then
		self.bHeavyStepsEnabled = true
		table.insert(self.AllowedPhases, self.PHASE_HEAVY_STEPS)

		--self.nPhaseIndex = 1

		--Reset counts for throws and onslaughts
		self.nCurrentThrowCount = self.MAX_THROWS
		self.nCurrentOnslaughtCount = self.MAX_ONSLAUGHTS
		--self:ChangePhase()
	end




	if nPct < self.nRapidVaultPct and self.bRapidVaultEnabled == false then
		--Only go down in onslaughts if there's more than 1 enemy hero
		if self:GetCurrentEnemyCount() > 1 then
			self.MAX_ONSLAUGHTS = 2
		end

		self.bRapidVaultEnabled = true
		
		table.insert(self.AllowedPhases, self.PHASE_PRIMAL_ROAR)
		table.insert(self.AllowedPhases, self.PHASE_RAPID_VAULT)
		table.insert(self.AllowedPhases, self.PHASE_PUMMEL)
		
		

		--self.nPhaseIndex = 1
		--Reset counts for throws and onslaughts
		self.nCurrentThrowCount = self.MAX_THROWS
		self.nCurrentOnslaughtCount = self.MAX_ONSLAUGHTS
		--self:ChangePhase()
	end
--
	if nPct < self.nLevelUpPct and self.bHasLeveledUp == false then
		self.bHasLeveledUp = true
		self.me:CreatureLevelUp( 1 )
	end
--	
--
	if nPct < self.nTectonicAttackPct and self.bTectonicAttackEnabled == false then

		self.bTectonicAttackEnabled = true

		table.insert(self.AllowedPhases, self.PHASE_TECTONIC_ATTACK)
		--self.nPhaseIndex = 1
		self.nCurrentThrowCount = self.MAX_THROWS
		self.nCurrentOnslaughtCount = self.MAX_ONSLAUGHTS
		--Reset counts for throws and onslaughts
		--self.nCurrentThrowCount = 0
		--self.nCurrentOnslaughtCount = 0
	end
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluateOnslaughtAbility()
	if self:GetCurrentPhase() ~= self.PHASE_ONSLAUGHT then
		return nil
	end
	--GetEnemyHeroesInRange sorts by closest
	local hEnemies = GetNoteworthyVisibleEnemiesNearby( self.me, 5000 )
	local Order = nil
	if hEnemies == nil or #hEnemies == 0 then
		return Order
	end
	if self:IsCastingAnAbility() == true then
		return Order
	end
	if #hEnemies > 0 then
		-- Select a random enemy from the furthes 1/2 of the list of enemies
		local hTargetEnemy = hEnemies[RandomInt( math.max(1,#hEnemies / 2), #hEnemies )]
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = hTargetEnemy:entindex(),
			AbilityIndex = self.hOnslaughtAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hOnslaughtAbility )
		self.nCurrentOnslaughtCount = self.nCurrentOnslaughtCount + 1
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	end
	return Order
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluateThrowAttack()
	if self:GetCurrentPhase() ~= self.PHASE_THROW_ATTACK then
		return nil
	end

	local hEnemies = GetNoteworthyVisibleEnemiesNearby( self.me, 5000 )

	local Order = nil
	if hEnemies == nil or #hEnemies == 0 then
		return Order
	end


	--find valid enemies in the range - anyone that is outside our minimum range
	local hValidEnemies = {}
	local nMinThrowAttackRange = self.hThrowAttack:GetSpecialValueFor( "min_range" )

	for _,enemy in pairs(hEnemies) do
		local distanceToEnemy = (self.me:GetOrigin() - enemy:GetOrigin()):Length()

		if self.bShouldThrowDummyRocks == true or (enemy:IsAlive() and distanceToEnemy > nMinThrowAttackRange) then
			table.insert(hValidEnemies, enemy)
		end
	end


	if hValidEnemies == nil or #hValidEnemies == 0 then
		-- we don't have any valid targets - everyone must be too close. 
		-- Pretend that we threw our final rock and Change phase
		self.nCurrentThrowCount = self.MAX_THROWS
	--	self:ChangePhase()
		return Order
	end


	if self:IsCastingAnAbility() == true then
		return Order
	end	

	if #hValidEnemies > 0 then
		local hRandomEnemy = hValidEnemies[ RandomInt( 1, #hValidEnemies )]
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = hRandomEnemy:entindex(),
			AbilityIndex = self.hThrowAttack:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hThrowAttack )

		self.nCurrentThrowCount = self.nCurrentThrowCount + 1
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	end
	return Order
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluateHeavySteps()
	if self:GetCurrentPhase() ~= self.PHASE_HEAVY_STEPS then
		return nil
	end
	local Order = nil

	local hEnemies = GetNoteworthyVisibleEnemiesNearby( self.me, 5000 )
	local Order = nil
	if hEnemies == nil or #hEnemies == 0 then
		return Order
	end
	if self:IsCastingAnAbility() == true then
		return Order
	end	

	if #hEnemies > 0 then
		local hFarthestEnemy = hEnemies[#hEnemies]
		local flDist = (self.me:GetAbsOrigin() - hFarthestEnemy:GetAbsOrigin()):Length2D()
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = hFarthestEnemy:entindex(),
			AbilityIndex = self.hHeavySteps:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hHeavySteps )
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	end
	return Order
end


--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluatePrimalRoarAbility()
	if self:GetCurrentPhase() ~= self.PHASE_PRIMAL_ROAR then
		return nil
	end

	local hEnemies = GetNoteworthyVisibleEnemiesNearby( self.me, 5000 )
	local Order = nil
	if hEnemies == nil or #hEnemies == 0 then
		return Order
	end
	if self:IsCastingAnAbility() == true then
		return Order
	end	
	
	self.hCurrentPummelTarget = nil
	--if we only have 1 enemy alive, don't pummel
--	if #hEnemies <= 1 then
--		return Order
--	end
	local hValidEnemies = {}
	for _,enemy in pairs(hEnemies) do
		if enemy:IsAlive() and not enemy:IsIllusion() then
			table.insert(hValidEnemies, enemy)
		end 
	end

	if #hValidEnemies > 0 then
		local hTargetEnemy = hValidEnemies[RandomInt( 1, #hValidEnemies  )]
		self.hCurrentPummelTarget = hTargetEnemy
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = self.hCurrentPummelTarget:entindex(),
			AbilityIndex = self.hPrimalRoarAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hPrimalRoarAbility )
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	end
	return Order
end


--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluateRapidVaultAbility()
	if self:GetCurrentPhase() ~= self.PHASE_RAPID_VAULT then
		return nil
	end
	printf('evaluatingVault')
	local Order = nil

	if self:IsCastingAnAbility() == true then
		printf('VaultIsCasting')
		return Order
	end
	if self.hCurrentPummelTarget == nil then
		printf('VaultNoTarget')--self:ChangePhase()
		return Order
	end

	local flDist = (self.me:GetAbsOrigin() - self.hCurrentPummelTarget:GetAbsOrigin()):Length2D()
	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = self.hCurrentPummelTarget:entindex(),
		AbilityIndex = self.hRapidVaultAbility:entindex(),
		Queue = false,
	}
	printf('VaultOrdered')
	Order.flOrderInterval = GetSpellCastTime( self.hRapidVaultAbility )
	GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	
	return Order
end



--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluatePummelAbility()

	if self:GetCurrentPhase() ~= self.PHASE_PUMMEL then
		return nil
	end

	local Order = nil


	if self:IsCastingAnAbility() == true then
		return Order
	end

	if self.hCurrentPummelTarget == nil then
		--self:ChangePhase()
		return Order
	end

		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = self.hCurrentPummelTarget:entindex(),
			AbilityIndex = self.hPummelAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hPummelAbility ) --+ self.hPummelAbility:GetChannelTime() + self.fPhasePauseTime
		self.hCurrentPummelTarget = nil
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	return Order
end



--------------------------------------------------------------------------------

function CBossPrimalBeast:EvaluateTectonicAttack()
	if self:GetCurrentPhase() ~= self.PHASE_TECTONIC_ATTACK then
		return nil
	end
	local hEnemies = GetNoteworthyVisibleEnemiesNearby( self.me, 5000 )
	local Order = nil
	if hEnemies == nil or #hEnemies == 0 then
		return Order
	end

	if self:IsCastingAnAbility() == true then
		return Order
	end

	--if we're too far from the middle of the map, the home position, move there first
	local fDistanceToHome = (self.me:GetAbsOrigin() - self.HomePosition):Length()

	if fDistanceToHome >= 400 then 
		self.bShouldChangePhaseTectonic = false
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = self.HomePosition,
			AbilityIndex = self.hRapidVaultAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hRapidVaultAbility ) + (fDistanceToHome / self.hRapidVaultAbility:GetSpecialValueFor( "vault_speed" )) + 0.3
		print ('flOrderInterval = '.. Order.flOrderInterval)
	elseif #hEnemies > 0 then
		local hFarthestEnemy = hEnemies[#hEnemies]
		self.bShouldChangePhaseTectonic = true
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = hFarthestEnemy:GetAbsOrigin(),
			AbilityIndex = self.hTectonicAttack:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hTectonicAttack )-- + self.hTectonicAttack:GetChannelTime() + (self.hTectonicAttack:GetSpecialValueFor( "projectile_distance" ) / self.hTectonicAttack:GetSpecialValueFor( "projectile_speed" )) 
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastPhase( self:GetCurrentPhase() )
	end	
	return Order
end

--------------------------------------------------------------------------------


function CBossPrimalBeast:IsCastingAnAbility()

	if self.me:IsChanneling() then
		return true
	end

	local szModifierList = 
	{
		"modifier_aghsfort_primal_beast_boss_heavysteps",
		"modifier_aghsfort_primal_beast_boss_pummel_self",
		"modifier_aghsfort_primal_beast_boss_onslaught_windup",
		"modifier_aghsfort_primal_beast_boss_onslaught_movement",
		"modifier_aghsfort_primal_beast_boss_rapid_vault",
		"modifier_aghsfort_primal_beast_tectonic_shift",
		"modifier_aghsfort_primal_beast_in_ability_phase_start",
	}

	for _, szModifierName in pairs (szModifierList) do
		if self.me:FindModifierByName(szModifierName) then
--			print ('Cannot cast, currently have ' .. szModifierName )
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function CBossPrimalBeast:LeapToMiddle()
	self.me:RemoveModifierByName( "modifier_boss_intro" )

	ExecuteOrderFromTable(
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = self.HomePosition,
		AbilityIndex = self.hRapidVaultAbility:entindex(),
		Queue = false,
	})
end


--------------------------------------------------------------------------------
 
function CBossPrimalBeast:Speak( flDelay, bForce, hCriteriaTable )

	--print( "CBossPrimalBeast:Speak speaking:" .. tostring( self.bIsSpeaking ) .. " ( force: " .. tostring( bForce ) .. " ) " .. hCriteriaTable.beast_event )
	--PrintTable( hCriteriaTable, " criteria --> " )

	-- Safety valve in case the callback breaks
	if ( self.bIsSpeaking == true ) and ( self.flLastSpeakTime > 0 ) and ( GameRules:GetGameTime() - self.flLastSpeakTime ) > 30 then
	--	print( "*** ERROR : CBossPrimalBeast never got the OnSpeechComplete callback!" )
		self.bIsSpeaking = false
	end

	-- Don't overlap lines unless this is a required line
	if bForce == false and self:IsCurrentlySpeaking( ) == true then
		--print( "*** CBossPrimalBeast discarding line -- " .. hCriteriaTable.beast_event .. " ( pst " .. self.flPostSpeechTime .. " cur " .. GameRules:GetGameTime() .. " ) " )
		return false
	end

	hCriteriaTable[ "always_valid_1" ] = 1
	hCriteriaTable[ "always_valid_2" ] = 1

	self.nCallbacksIssued = self.nCallbacksIssued + 1
	--print( "@@@@ Primal Beast Speak! Event " .. ( ( hCriteriaTable.beast_event ~= nil and hCriteriaTable.beast_event ) or "none" ) .. ", callback " .. self.nCallbacksIssued )
	self.flLastSpeakTime = GameRules:GetGameTime() + flDelay
	self.bIsSpeaking = true
	self.me:QueueConcept( flDelay, hCriteriaTable, Dynamic_Wrap( CBossPrimalBeast, 'OnSpeechComplete' ), self, { nCallbackIndex = self.nCallbacksIssued } )

	return true
	
end

--------------------------------------------------------------------------------
 
function CBossPrimalBeast:OnSpeechComplete( bDidActuallySpeak, hCallbackInfo )
	--print( "@@@@ CBossPrimalBeast:OnSpeechComplete " .. tostring( bDidActuallySpeak ) .. " " .. hCallbackInfo.nCallbackIndex .. " - " .. self.nCallbacksIssued )
	if hCallbackInfo.nCallbackIndex == self.nCallbacksIssued then
		self.bIsSpeaking = false
		self.flPostSpeechTime = GameRules:GetGameTime() + ( ( bDidActuallySpeak and self.flPostSpeechDelay ) or 0 )
	end
end

--------------------------------------------------------------------------------
 
function CBossPrimalBeast:IsCurrentlySpeaking( )
	return self.bIsSpeaking or ( self.flPostSpeechTime > GameRules:GetGameTime() )
end

function CBossPrimalBeast:GetCurrentEnemyCount()
	local iHeroCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero ~= nil then
			if hPlayerHero:IsRealHero() and hPlayerHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and 
			( hPlayerHero:IsAlive() or hPlayerHero:IsReincarnating() or ( hPlayerHero:GetRespawnsDisabled() == false ) ) then
				iHeroCount = iHeroCount + 1
			end
		end
	end
	return iHeroCount

end


function CBossPrimalBeast:OnEntityKilled(event)
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end
	-- if a hero died, check if there is only one non-respawning enemy remaining. 
	-- if that is the case, remove pummel, but add an extra onslaught and allow PB to throw rocks that he knows can miss to give the enemy a chance to deal damage
	if hVictim ~= nil then
		if hVictim:IsRealHero() and hVictim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then 
			local nHeroesRemaining = self:GetCurrentEnemyCount()

			-- if we have 1 enemy left, remove pummel from the allowed phases completely
			if nHeroesRemaining <= 1 then
				local vecNewAllowedPhases = {}
				for k,v in pairs( self.AllowedPhases  ) do
					if v == self.PHASE_PRIMAL_ROAR or v == self.PHASE_RAPID_VAULT or v == self.PHASE_PUMMEL then
						--printf('Removing phase ' .. self.PhaseNames[v]..' from list' )
					else
						table.insert(vecNewAllowedPhases, v)
					end
				end

				self.AllowedPhases = vecNewAllowedPhases
				self.bShouldThrowDummyRocks = true
				self.MAX_ONSLAUGHTS = 3
				self.MAX_THROWS = 2
			end

		end

	end
end

