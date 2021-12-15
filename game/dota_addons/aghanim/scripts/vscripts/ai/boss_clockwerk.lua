
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossClockwerk == nil then
	CBossClockwerk = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	--PrecacheUnitByNameSync( "npc_dota_furion_treant_4", context, -1 )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		printf( "boss_clockwerk.lua - Spawn" )
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossClockwerk( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossClockwerk:constructor( hUnit, flInterval )
	printf( "CBossClockwerk:constructor" )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bMildlyEnraged = false
	self.nMildlyEnragedPct = 60

	self.bFullyEnraged = false
	self.nFullyEnragedPct = 30

	self.me:SetThink( "OnBossClockwerkThink", self, "OnBossClockwerkThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossClockwerk:SetupAbilitiesAndItems()
	printf( "CBossClockwerk:SetupAbilitiesAndItems()" )
	CBossBase.SetupAbilitiesAndItems( self )

	self.hJetpackAbility = self.me:FindAbilityByName( "boss_clockwerk_jetpack" )
	if self.hJetpackAbility ~= nil then
		self.hJetpackAbility.Evaluate = self.EvaluateJetpack
		self.AbilityPriority[ self.hJetpackAbility:GetAbilityName() ] = 2
	end
	DoScriptAssert( self.hJetpackAbility ~= nil, "self.hJetpackAbility not found" )

	self.hBatteryAbility = self.me:FindAbilityByName( "boss_clockwerk_battery_assault" )
	if self.hBatteryAbility ~= nil then
		self.hBatteryAbility.Evaluate = self.EvaluateBattery
		self.AbilityPriority[ self.hBatteryAbility:GetAbilityName() ] = 1
	end
	DoScriptAssert( self.hBatteryAbility ~= nil, "self.hBatteryAbility not found" )

	self.hPassiveAbility = self.me:FindAbilityByName( "boss_clockwerk_passive" )
end

--------------------------------------------------------------------------------

function CBossClockwerk:OnBossClockwerkThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossClockwerk:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossClockwerk:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct <= self.nMildlyEnragedPct and self.bMildlyEnraged == false then
		self.bMildlyEnraged = true
	end

	if nPct <= self.nFullyEnragedPct and self.bFullyEnraged == false then
		self.bFullyEnraged = true

		self.me:AddNewModifier( self.me, self.hPassiveAbility, "modifier_boss_clockwerk_enraged", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function CBossClockwerk:OnBuddyDied()
	printf( "CBossClockwerk: OnBuddyDied" )

	self.bBuddyDied = true
	self.bFullyEnraged = true

	self.me:AddNewModifier( self.me, self.hPassiveAbility, "modifier_boss_clockwerk_enraged", { duration = -1 } )
end

--------------------------------------------------------------------------------

function CBossClockwerk:EvaluateBattery()
	printf( "EvaluateBattery" )

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRange = self.hBatteryAbility:GetSpecialValueFor( "search_radius" )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, nSearchRange )

	if #Enemies < 1 then
		return nil
	end

	local Order = nil

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hBatteryAbility:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hBatteryAbility )

	return Order
end

--------------------------------------------------------------------------------

function CBossClockwerk:EvaluateJetpack()
	printf( "EvaluateJetpack" )

	local Order = nil

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hJetpackAbility:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hJetpackAbility )

	return Order
end

--------------------------------------------------------------------------------