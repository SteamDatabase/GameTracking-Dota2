require( "ai/shared" )
require( "ai/basic_spell_casting_ai" )

--------------------------------------------------------------------------------

if CBossBase == nil then
	CBossBase = class({})
end

--------------------------------------------------------------------------------

function CBossBase:constructor( hUnit, flInterval )
	self.me = hUnit
	self.flDefaultInterval = flInterval
	self.AbilityPriority = {}
	self.hPlayerHeroes = {}
	self.QueuedOrders = {}
	self.Encounter = nil
	self.bSeenAnyEnemy = false
	self.nLastHealthPct = 10000
	self.flInitialAcquireRange = 1800
	self.flAggroAcquireRange = 4500

	self:SetupAbilitiesAndItems()

	self.nAbilityListener = ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( getclass( self ), 'OnNonPlayerUsedAbility' ), self )
end

--------------------------------------------------------------------------------

function CBossBase:SetupAbilitiesAndItems()
	--empty
end

--------------------------------------------------------------------------------

function CBossBase:SetEncounter( Encounter )
	self.Encounter = Encounter 
end

--------------------------------------------------------------------------------

function CBossBase:ShouldAutoAttack()
	return true 
end

--------------------------------------------------------------------------------

function CBossBase:OnBaseThink()
	if self.me == nil or self.me:IsNull() or self.me:IsAlive() == false then
		--print( '^^^CBossBase:OnBaseThink() - boss is dead shutting down!')
		StopListeningToGameEvent( self.nAbilityListener )
		return -1
	end

	Order = nil

	if self.Encounter == nil then 
		--print( '^^^CBossBase:OnBaseThink() - encounter is nil!')
		return 0.01
	end

	if self.Encounter:HasStarted() == false then
		--print( '^^^CBossBase:OnBaseThink() - encounter has not started!')
		return 0.01
	end

	if GameRules:IsGamePaused() then
		return 0.01
	end

	if self.me:IsChanneling() then
		return 0.1
	end

	local flRange = self.flInitialAcquireRange
	if self.bSeenAnyEnemy == true then
		flRange = self.flAggroAcquireRange
	end
	self.hPlayerHeroes = GetVisibleEnemyHeroesInRange( self.me, flRange )
	
	if #self.hPlayerHeroes == 0 then
		goto autoattack
	elseif self.bSeenAnyEnemy == false then
		self.bSeenAnyEnemy = true
		self:OnFirstSeen()
	end

	if self.nLastHealthPct > self.me:GetHealthPercent() then
		self.nLastHealthPct = self.me:GetHealthPercent()
		self:OnHealthPercentThreshold( self.nLastHealthPct )
	end

	AbilitiesReady = self:GetReadyAbilitiesAndItems()
	if #AbilitiesReady == 0 then
		goto autoattack
	end

	if #self.QueuedOrders > 0 then
		Order = self.QueuedOrders[ 1 ]
		table.remove( self.QueuedOrders, 1 )
		goto execute_order
	else
		for _,Ability in pairs ( AbilitiesReady ) do
			if Ability ~= nil and Ability.Evaluate ~= nil then
				local TryOrder = Ability.Evaluate( self )
				if TryOrder ~= nil then
					Order = TryOrder
					break
				end
			end
		end
	end

	::autoattack::
	
	NonAbilityOrder = nil
	if Order == nil then
		NonAbilityOrder = self:GetNonAbilityOrder()
		if NonAbilityOrder ~= nil then
			--print( 'NON ABILITY ORDER' )
			Order = NonAbilityOrder
		end
	end

	if Order == nil and #self.hPlayerHeroes > 0 and self.me:IsChanneling() == false and self:ShouldAutoAttack() then
		if self.me:HasAttackCapability() then
			--print( 'autoattack for ' .. self.flDefaultInterval  )
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.hPlayerHeroes[ 1 ]:GetAbsOrigin(), 
			}
			Order.flOrderInterval = self.flDefaultInterval
		else
			--print( 'no attack capability - facing towards the best hero' )
			self.me:FaceTowards( self.hPlayerHeroes[ 1 ]:GetAbsOrigin() )
		end
	end

	::execute_order::
	if Order then
		print( 'Executing Order ' .. Order.OrderType .. ' and sleeping for ' .. Order.flOrderInterval )
		ExecuteOrderFromTable( Order )
		return Order.flOrderInterval
	end
	
	::idle::
	return self.flDefaultInterval
end

--------------------------------------------------------------------------------

function CBossBase:GetReadyAbilitiesAndItems()
	local AbilitiesReady = {}
	for n=0,self.me:GetAbilityCount() - 1 do
		local hAbility = self.me:GetAbilityByIndex( n )
		if hAbility and hAbility:IsFullyCastable() and not hAbility:IsPassive() and not hAbility:IsHidden() and hAbility:IsActivated() then
			--print( 'Adding ABILITY ' .. hAbility:GetAbilityName() )
			if self.AbilityPriority[ hAbility:GetAbilityName() ] ~= nil then
				table.insert( AbilitiesReady, hAbility )
			end
		end
	end

	for i = 0, DOTA_ITEM_MAX - 1 do
		local hItem = self.me:GetItemInSlot( i )
		if hItem and hItem:IsFullyCastable() and not hItem:IsPassive() and not hItem:IsHidden() and hItem:IsActivated() then
			--print( 'Adding ITEM ' .. hItem:GetAbilityName() )
			if self.AbilityPriority[ hItem:GetAbilityName() ] ~= nil then
				table.insert( AbilitiesReady, hItem )
			end
		end
	end

	if #AbilitiesReady > 1 then
		table.sort( AbilitiesReady, function( h1, h2 ) 
				local nAbility1Priority = self.AbilityPriority[ h1:GetAbilityName() ]
				local nAbility2Priority = self.AbilityPriority[ h2:GetAbilityName() ]
			return nAbility1Priority > nAbility2Priority 
		end
	 )
	end

	return AbilitiesReady
end

--------------------------------------------------------------------------------

function CBossBase:GetNonAbilityOrder()
	return nil
end

--------------------------------------------------------------------------------

function CBossBase:OnFirstSeen()
	-- empty
end

--------------------------------------------------------------------------------

function CBossBase:OnHealthPercentThreshold( nPct )
	-- empty
end
---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------
function CBossBase:OnNonPlayerUsedAbility( event )
	
	local hCaster = nil
	if event.caster_entindex ~= nil and event.abilityname ~= nil then
		hCaster = EntIndexToHScript( event.caster_entindex )
		if hCaster ~= nil and hCaster == self.me then
			self:OnBossUsedAbility( event.abilityname )
		end
	end
end

--------------------------------------------------------------------------------

function CBossBase:OnBossUsedAbility( szAbilityName )
	-- empty
end

--------------------------------------------------------------------------------