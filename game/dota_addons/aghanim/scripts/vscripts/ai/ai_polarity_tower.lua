
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CPolarityTowerMiniboss == nil then
	CPolarityTowerMiniboss = class( {}, {}, CBossBase )
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

		thisEntity.AI = CPolarityTowerMiniboss( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bEnraged = false
	self.nEnragePct = 33

	--self.nShadowBladeHealthTriggerPct = 75
	self.bTriggerEscape = false

	self.polarity = 1
	if RandomInt( 0, 1 ) == 1 then
		self.polarity = -1
	end

	self.me:SetThink( "OnPolarityTowerMinibossThink", self, "OnPolarityTowerMinibossThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hSpinAttack = self.me:FindAbilityByName( "polarity_spin_attack" )
	if self.hSpinAttack == nil then
		print( 'CPolarityTowerMiniboss - Unable to find ability polarity_spin_attack')
	else
		self.hSpinAttack.Evaluate = self.EvaluateSpinAttack
		self.AbilityPriority[ self.hSpinAttack:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:OnPolarityTowerMinibossThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
	if nPct <= self.nEnragePct and self.bEnraged == false then
		self.bEnraged = true
	end

	--if nPct <= self.nShadowBladeHealthTriggerPct then
	--	print( 'Shadow Blade Health Trigger Hit at ' .. self.nShadowBladeHealthTriggerPct )
	--	self.nShadowBladeHealthTriggerPct = self.nShadowBladeHealthTriggerPct - 25
	--	self.bTriggerShadowBlade = true
	--end
end

--------------------------------------------------------------------------------

function CPolarityTowerMiniboss:EvaluateSpinAttack()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hSpinAttack:GetCastRange( self.me:GetAbsOrigin(), nil )
	printf( "EvaluateSpinAttack - nSearchRadius == %d", nSearchRadius )
	Enemies = GetEnemyHeroesInRange( thisEntity, nSearchRadius )
	--Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
		local vTargetLocation = hRandomEnemy:GetAbsOrigin()
		if vTargetLocation ~= nil then
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hSpinAttack:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = self.hSpinAttack:GetChannelTime()
			print( 'flOrderInterval = ' .. Order.flOrderInterval )

			self.hSpinAttack:SetPolarity( self.polarity )
			self.polarity = self.polarity * -1
		end
	end

	return Order
end

--------------------------------------------------------------------------------

--[[
function CPolarityTowerMiniboss:EvaluateMultishot()
	if self:IsInvisible() then	
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hMultishot:GetSpecialValueFor( "effective_range" )
	--printf( "EvaluateMultishot - nSearchRadius == %d", nSearchRadius )
	Enemies = GetEnemyHeroesInRange( thisEntity, nSearchRadius )
	--Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
		local vTargetLocation = hRandomEnemy:GetAbsOrigin()
		if vTargetLocation ~= nil then
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = vTargetLocation,
				AbilityIndex = self.hMultishot:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = self.hMultishot:GetChannelTime()
			--print( 'ORDER INTERVAL for Multishot is ' .. Order.flOrderInterval )
		end
	end

	-- need to get this entity to issue some command to select the exit portal after the cast

	return Order
end
]]--

