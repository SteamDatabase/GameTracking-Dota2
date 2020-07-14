require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossTimbersaw == nil then
	CBossTimbersaw = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheUnitByNameSync( "npc_dota_furion_treant_4", context, -1 )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossTimbersaw( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossTimbersaw:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.nTreeListener = ListenToGameEvent( "tree_cut", Dynamic_Wrap( getclass( self ), 'OnTreeCut' ), self )
	self.bEnraged = false
	self.nEnragePct = 40
	self.nNumTreantsPerTree = 1
	self.nMaxTreants = 40

	self.me:SetThink( "OnBossTimbersawThink", self, "OnBossTimbersawThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossTimbersaw:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )
	
	self.hWhirlingDeath = self.me:FindAbilityByName( "boss_timbersaw_whirling_death" )
	if self.hWhirlingDeath ~= nil then
		self.hWhirlingDeath.Evaluate = self.EvaluateWhirlingDeath
		self.AbilityPriority[ self.hWhirlingDeath:GetAbilityName() ] = 4
	end

	self.hTimberChain = self.me:FindAbilityByName( "boss_timbersaw_timber_chain" )
	if self.hTimberChain ~= nil then
		self.hTimberChain.Evaluate = self.EvaluateTimberChain
		self.AbilityPriority[ self.hTimberChain:GetAbilityName() ] = 5
	end

	self.hChakram = self.me:FindAbilityByName( "shredder_chakram" )
	if self.hChakram ~= nil then
		self.hChakram.Evaluate = self.EvaluateChakram
		self.AbilityPriority[ self.hChakram:GetAbilityName() ] = 2
	end

	self.hReturnChakram = self.me:FindAbilityByName( "shredder_return_chakram" )
	if self.hReturnChakram ~= nil then
		self.hReturnChakram.Evaluate = self.EvaluateReturnChakram
		self.AbilityPriority[ self.hReturnChakram:GetAbilityName() ] = 6
	end

	self.hChakram2 = self.me:FindAbilityByName( "shredder_chakram_2" )
	if self.hChakram2 ~= nil then
		self.hChakram2:SetActivated( true )
		self.hChakram2:SetHidden( false )
		self.hChakram2:UpgradeAbility( true )
		self.hChakram2.Evaluate = self.EvaluateChakram2
		self.AbilityPriority[ self.hChakram2:GetAbilityName() ] = 3
	end

	self.hReturnChakram2 = self.me:FindAbilityByName( "shredder_return_chakram_2" )
	if self.hReturnChakram2 ~= nil then
		self.hReturnChakram2.Evaluate = self.EvaluateReturnChakram2
		self.AbilityPriority[ self.hReturnChakram2:GetAbilityName() ] = 7
	end

	self.hChakramDance = self.me:FindAbilityByName( "boss_timbersaw_chakram_dance" )
	if self.hChakramDance then
		self.hChakramDance.Evaluate = self.EvaluateChakramDance
		self.AbilityPriority[ self.hChakramDance:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------

function CBossTimbersaw:OnTreeCut( event )

	if self.me:IsNull() or not self.me:IsAlive() then
		StopListeningToGameEvent( self.nTreeListener )
		return
	end

	if self.Encounter and self.Encounter.SpawnedSecondaryEnemies and #self.Encounter.SpawnedSecondaryEnemies > self.nMaxTreants then
		--print( "Timbersaw is not creating more treants; hit the maximum alive!" )
		return
	end

	local vLocation = Vector( event.tree_x, event.tree_y, 0 )
	for i=1,self.nNumTreantsPerTree do
		local hTreant = CreateUnitByName( "npc_dota_creature_timbersaw_treant", vLocation, true, self.me, self.me:GetOwner(), self.me:GetTeamNumber() )
		if hTreant ~= nil then
			hTreant:SetControllableByPlayer( self.me:GetPlayerOwnerID(), false )
			hTreant:SetOwner( self.me )
			hTreant.bBossMinion = true
			self.Encounter:SuppressRewardsOnDeath( hTreant )

			if #self.hPlayerHeroes > 0 then
				hTreant:SetInitialGoalEntity( self.hPlayerHeroes[ RandomInt( 1, #self.hPlayerHeroes ) ] )
			end
		end
	end
end

--------------------------------------------------------------------------------
 
function CBossTimbersaw:OnBossTimbersawThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossTimbersaw:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossTimbersaw:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
	if nPct <= self.nEnragePct and self.bEnraged == false then
		self.bEnraged = true
	end
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateWhirlingDeath()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hWhirlingDeath:GetSpecialValueFor( "whirling_radius" ) )

	local Order = nil
	if #Enemies >= 2 then
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hWhirlingDeath:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hWhirlingDeath )
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateTimberChain()
	local Order = nil
	local vTargetLocation = GetBestDirectionalPointTarget( self.hTimberChain )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetLocation,
			AbilityIndex = self.hTimberChain:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hTimberChain ) + 0.5 -- Factor in a little travel time
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateChakram()
	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hChakram )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetLocation,
			AbilityIndex = self.hChakram:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hChakram ) 
		self.hReturnChakram:StartCooldown( RandomFloat( 1.5, 7.5 ) )
	end
	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateChakram2()
	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hChakram2 )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetLocation,
			AbilityIndex = self.hChakram2:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hChakram2 )
		self.hReturnChakram2:StartCooldown( RandomFloat( 1.5, 7.5 ) )
	end
	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateReturnChakram()
	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hReturnChakram:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = 0.1
	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateReturnChakram2()
	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hReturnChakram2:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = 0.1
	return Order
end

--------------------------------------------------------------------------------

function CBossTimbersaw:EvaluateChakramDance()
	local Order = nil
	if self.bEnraged == true then
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hChakramDance:entindex(),
			Queue = false,
		}

		Order.flOrderInterval = self.hChakramDance:GetChannelTime() + 0.2
	end
	return Order
end

--------------------------------------------------------------------------------