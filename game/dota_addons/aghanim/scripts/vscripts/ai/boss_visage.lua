require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossVisage == nil then
	CBossVisage = class( {}, {}, CBossBase )
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

		thisEntity.AI = CBossVisage( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossVisage:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )
	self.bEnraged = false
	self.nEnragePct = 50
	self.me.bStone = false

	self.me:SetThink( "OnBossVisageThink", self, "OnBossVisageThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossVisage:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )
	
	self.hRangedAttack = self.me:FindAbilityByName( "boss_visage_ranged_attack" )
	if self.hRangedAttack ~= nil then
		self.hRangedAttack.Evaluate = self.EvaluateRangedAttack
		self.AbilityPriority[ self.hRangedAttack:GetAbilityName() ] = 2
	end
	self.hGraveChill = self.me:FindAbilityByName( "boss_visage_grave_chill" )
	if self.hGraveChill ~= nil then
		self.hGraveChill.Evaluate = self.EvaluateGraveChill
		self.AbilityPriority[ self.hGraveChill:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------
 
function CBossVisage:OnBossVisageThink()
	if self.me.bStone then
		return self.flDefaultInterval
	end
	
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossVisage:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossVisage:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
	if nPct <= self.nEnragePct and self.bEnraged == false then
		self.bEnraged = true
	end
end

--------------------------------------------------------------------------------

function CBossVisage:EvaluateRangedAttack()
	local Order = nil
	local hTarget = GetBestUnitTarget( self.hRangedAttack )
	if hTarget == nil then
		return Order
	end

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetAbsOrigin(),
		AbilityIndex = self.hRangedAttack:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hRangedAttack )
		

	return Order
end

--------------------------------------------------------------------------------

function CBossVisage:EvaluateGraveChill()
	local Order = nil
	local hTarget = GetBestUnitTarget( self.hGraveChill )
	if hTarget == nil then
		return Order
	end

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hGraveChill:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hGraveChill )
	return Order
end




