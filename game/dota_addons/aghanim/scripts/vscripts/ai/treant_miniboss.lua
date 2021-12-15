
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CTreantMiniboss == nil then
	CTreantMiniboss = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CTreantMiniboss( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CTreantMiniboss:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.nPetrifiedPct = 85
	self.nPetrifiedPctDecrement = 30

	self.bTriggerEscape = false

	self.me:SetThink( "OnTreantMinibossThink", self, "OnTreantMinibossThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CTreantMiniboss:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hNaturesGraspAbility = self.me:FindAbilityByName( "treant_miniboss_natures_grasp" )
	if self.hNaturesGraspAbility == nil then
		printf( "ERROR - CTreantMiniboss: Unable to find ability \"treant_miniboss_entangle\"" )
	else
		self.hNaturesGraspAbility.Evaluate = self.EvaluateNaturesGrasp
		self.AbilityPriority[ self.hNaturesGraspAbility:GetAbilityName() ] = 1
	end

	self.hEntangleAbility = self.me:FindAbilityByName( "treant_miniboss_entangle" )
	if self.hEntangleAbility == nil then
		printf( "ERROR - CTreantMiniboss: Unable to find ability \"treant_miniboss_entangle\"" )
	else
		self.hEntangleAbility.Evaluate = self.EvaluateEntangle
		self.AbilityPriority[ self.hEntangleAbility:GetAbilityName() ] = 2
	end

	self.hPetrifiedAbility = self.me:FindAbilityByName( "treant_miniboss_petrified" )
	if self.hPetrifiedAbility == nil then
		printf( "ERROR - CTreantMiniboss: Unable to find ability \"treant_miniboss_petrified\"" )
	else
		self.hPetrifiedAbility.Evaluate = self.EvaluatePetrified
		self.AbilityPriority[ self.hPetrifiedAbility:GetAbilityName() ] = 3
	end
end

--------------------------------------------------------------------------------

function CTreantMiniboss:OnTreantMinibossThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CTreantMiniboss:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CTreantMiniboss:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct <= self.nPetrifiedPct then
		self.nPetrifiedPct = self.nPetrifiedPct - self.nPetrifiedPctDecrement
		self.bTriggerEscape = true
	end
end

--------------------------------------------------------------------------------

function CTreantMiniboss:EvaluateNaturesGrasp()
	local Order = nil

	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hNaturesGraspAbility )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hNaturesGraspAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hNaturesGraspAbility )
	end

	return Order
end

--------------------------------------------------------------------------------

function CTreantMiniboss:EvaluateEntangle()
	local Order = nil

	local nSearchRadius = self.hEntangleAbility:GetCastRange( self.me:GetOrigin(), nil ) - 150
	printf( "CTreantMiniboss:EvaluateEntangle() - nSearchRadius: %d", nSearchRadius )
	Enemies = GetEnemyHeroesInRange( self.me, nSearchRadius )

	local hRandomTarget = nil

	if #Enemies >= 1 then
		hRandomTarget = Enemies[ RandomInt( 1, #Enemies ) ]
	end

	if hRandomTarget ~= nil then
		printf( "treant_miniboss ai - Casting Entangle" )

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hEntangleAbility:entindex(),
			Position = hRandomTarget:GetOrigin(),
			Queue = false,
		}
		Order.flOrderInterval = 10.0
	end

	return Order
end

--------------------------------------------------------------------------------

function CTreantMiniboss:EvaluatePetrified()
	local Order = nil

	if self.bEscaping ~= nil and self.bEscaping == true then
		printf( "treant_miniboss ai - Casting Petrified" )

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hPetrifiedAbility:entindex(),
			Queue = false,
		}
		local fDuration = self.hPetrifiedAbility:GetSpecialValueFor( "duration" )
		Order.flOrderInterval = fDuration

		self.bEscaping = false
	end

	return Order
end

--------------------------------------------------------------------------------

function CTreantMiniboss:GetNonAbilityOrder()
	local Order = nil

	-- If we're ready to escape we should move somewhere else
	if self.bTriggerEscape == true then
		printf( "CTreantMiniboss:GetNonAbilityOrder() - Escaping! Setting new escape location" )
		self.bTriggerEscape = false

		local RetreatPoints = self.me.Encounter:GetRetreatPoints()
		DoScriptAssert( RetreatPoints ~= nil, "RetreatPoints not found" )

		-- First try to escape to an info_target-based position; these are placed more in the upper
		-- parts of the map to try to pull the action through the room
		local vEscapePos = nil
		local nMinDist = 1500
		local nMaxAttempts = #RetreatPoints
		local nAttempts = 0

		repeat
			if nAttempts > nMaxAttempts then
				vEscapePos = nil
				printf( "WARNING - CTreantMiniboss:GetNonAbilityOrder() - failed to find valid info_target position, will try FindPathablePositionNearby instead" )
				break
			end

			local nRandomRetreatIndex =  RandomInt( 1, #RetreatPoints )
			local vEscapePos = RetreatPoints[ nRandomRetreatIndex ]:GetAbsOrigin()
			local fDistToEscapePos = ( vEscapePos - self.me:GetAbsOrigin() ):Length2D()

			nAttempts = nAttempts + 1
		until ( fDistToEscapePos > nMinDist )

		-- If no info_target position found, then try this method
		if vEscapePos == nil then
			nMinDist = 2000
			local nMaxDist = 3000
			vEscapePos = FindPathablePositionNearby( self.me:GetAbsOrigin(), nMinDist, nMaxDist )
		end

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vEscapePos,
		}
		local fTimeToRun = 6
		Order.flOrderInterval = fTimeToRun

		self.bEscaping = true

		if self.Encounter ~= nil then
			self.Encounter:OnTreantMinibossEscape()
		else
			printf( "CTreantMiniboss - ENCOUNTER IS NIL" )
		end
	end

	return Order
end

--------------------------------------------------------------------------------
