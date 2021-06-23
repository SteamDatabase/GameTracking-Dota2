
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CTuskBoss == nil then
	CTuskBoss = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	--PrecacheUnitByNameSync( "npc_dota_furion_treant_4", context, -1 )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CTuskBoss( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CTuskBoss:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bEnraged = false
	self.nEnragePct = 40

	self.me:SetThink( "OnTuskBossThink", self, "OnTuskBossThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CTuskBoss:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )
	
	self.hWalrusPunch = self.me:FindAbilityByName( "aghsfort_tusk_boss_walrus_punch" )
	if self.hWalrusPunch ~= nil then
		self.hWalrusPunch.Evaluate = self.EvaluateWalrusPunch
		self.AbilityPriority[ self.hWalrusPunch:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------

function CTuskBoss:OnTuskBossThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CTuskBoss:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CTuskBoss:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
	if nPct <= self.nEnragePct and self.bEnraged == false then
		self.bEnraged = true
	end
end

--------------------------------------------------------------------------------

function CTuskBoss:EvaluateWalrusPunch()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hWalrusPunch:GetCastRange( self.me:GetOrigin(), nil ) )

	local Order = nil
	if #Enemies >= 1 then
		local hTarget = Enemies[ 1 ]
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = hTarget:entindex(),
			AbilityIndex = self.hWalrusPunch:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hWalrusPunch )
	end

	return Order
end

--------------------------------------------------------------------------------
