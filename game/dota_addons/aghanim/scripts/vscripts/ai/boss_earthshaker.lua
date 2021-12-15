
require( "ai/boss_base" )
require( "utility_functions" )

--------------------------------------------------------------------------------

if CBossEarthshaker == nil then
	CBossEarthshaker = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	--PrecacheUnitByNameSync( "npc_dota_furion_treant_4", context, -1 )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		printf( "boss_earthshaker.lua - Spawn" )
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossEarthshaker( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossEarthshaker:constructor( hUnit, flInterval )
	printf( "CBossEarthshaker:constructor" )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bMildlyEnraged = false
	self.nMildlyEnragedPct = 60

	self.bFullyEnraged = false
	self.nFullyEnragedPct = 30

	self.me:SetThink( "OnBossEarthshakerThink", self, "OnBossEarthshakerThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossEarthshaker:SetupAbilitiesAndItems()
	printf( "CBossEarthshaker:SetupAbilitiesAndItems()" )
	CBossBase.SetupAbilitiesAndItems( self )

	self.hQuakeAbility = self.me:FindAbilityByName( "boss_earthshaker_quake" )
	if self.hQuakeAbility ~= nil then
		self.hQuakeAbility.Evaluate = self.EvaluateQuake
		self.AbilityPriority[ self.hQuakeAbility:GetAbilityName() ] = 4
	end
	DoScriptAssert( self.hQuakeAbility ~= nil, "self.hQuakeAbility not found" )

	self.hFissureAbility = self.me:FindAbilityByName( "aghsfort_boss_earthshaker_fissure" )
	if self.hFissureAbility ~= nil then
		self.hFissureAbility.Evaluate = self.EvaluateFissure
		self.AbilityPriority[ self.hFissureAbility:GetAbilityName() ] = 3
	end
	DoScriptAssert( self.hFissureAbility ~= nil, "self.hFissureAbility not found" )

	self.hTotemAbility = self.me:FindAbilityByName( "aghsfort_boss_earthshaker_enchant_totem" )
	if self.hTotemAbility ~= nil then
		self.hTotemAbility.Evaluate = self.EvaluateTotem
		self.AbilityPriority[ self.hTotemAbility:GetAbilityName() ] = 2
	end
	DoScriptAssert( self.hTotemAbility ~= nil, "self.hTotemAbility not found" )

	self.hSmashAbility = self.me:FindAbilityByName( "boss_earthshaker_smash" )
	if self.hSmashAbility ~= nil then
		self.hSmashAbility.Evaluate = self.EvaluateSmash
		self.AbilityPriority[ self.hSmashAbility:GetAbilityName() ] = 1
	end
	DoScriptAssert( self.hSmashAbility ~= nil, "self.hSmashAbility not found" )
end

--------------------------------------------------------------------------------

function CBossEarthshaker:OnBossEarthshakerThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossEarthshaker:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossEarthshaker:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct <= self.nMildlyEnragedPct and self.bMildlyEnraged == false then
		self.bMildlyEnraged = true
	end

	if nPct <= self.nFullyEnragedPct and self.bFullyEnraged == false then
		self.bFullyEnraged = true
	end
end

--------------------------------------------------------------------------------

function CBossEarthshaker:EvaluateSmash()
	printf( "EvaluateSmash" )

	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hSmashAbility )
	if vTargetLocation ~= nil then
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hSmashAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hSmashAbility )
		printf( "casting Smash" )
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossEarthshaker:EvaluateFissure()
	printf( "EvaluateFissure" )

	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hFissureAbility )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetLocation,
			AbilityIndex = self.hFissureAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hFissureAbility )

		printf( "EvaluateFissure - casting Fissure on %s", vTargetLocation )
	else
		printf( "EvaluateFissure - no vTargetLocation found" )
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossEarthshaker:EvaluateQuake()
	printf( "EvaluateQuake" )

	-- First Enchant Totem to a retreat point

	if self.bMildlyEnraged == false then
		--printf( "  not even mildly enraged yet, so don't Quake" )
		return nil
	end

	local RetreatPoints = self.me.Encounter:GetRetreatPoints()

	--printf( "  found %d retreat points", #RetreatPoints )

	DoScriptAssert( RetreatPoints ~= nil, "found no ents named retreat_point" )

	ShuffleListInPlace( RetreatPoints )

	local nMinRetreatDistance = 1000
	local nTotemCastRange = self.hTotemAbility:GetLevelSpecialValueFor( "distance_scepter", GameRules.Aghanim:GetAscensionLevel() )

	local hChosenRetreatPoint = nil
	for _, hPoint in pairs ( RetreatPoints ) do
		--printf( "looping over retreat point at pos %s", hPoint:GetAbsOrigin() )
		local fDistance = ( hPoint:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
		local bIsInRoom = ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( hPoint:GetAbsOrigin() ) )
		if bIsInRoom and fDistance > nMinRetreatDistance and fDistance < nTotemCastRange then
			hChosenRetreatPoint = hPoint
			break
		end
	end

	local Order = nil

	if hChosenRetreatPoint ~= nil then
		self.hTotemAbility:EndCooldown()
		printf( "cast Enchant Totem on hChosenRetreatPoint at pos: %s", hChosenRetreatPoint:GetAbsOrigin() )

		self.me:Purge( false, true, false, true, false )

		ExecuteOrderFromTable( {
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTotemAbility:entindex(),
			Position = hChosenRetreatPoint:GetAbsOrigin(),
			Queue = false,
		} )

		printf( "casting Quake (queued)" )
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hQuakeAbility:entindex(),
			Queue = true,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hTotemAbility ) + GetSpellCastTime( self.hQuakeAbility ) + self.hQuakeAbility:GetChannelTime() + 0.1

		printf( "will return from EvaluateQuake in %.1f", Order.flOrderInterval )

		return Order
	else
		printf( "hChosenRetreatPoint is nil" )

		printf( "casting Quake (not queued)" )
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hQuakeAbility:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = self.hQuakeAbility:GetCastPoint() + self.hQuakeAbility:GetChannelTime() + 0.5

		printf( "will return from EvaluateQuake in %.1f", Order.flOrderInterval )

		return Order
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossEarthshaker:EvaluateTotem()
	printf( "EvaluateTotem" )

	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hTotemAbility:GetSpecialValueFor( "distance_scepter" ) )

	local nMinDistance = self.hTotemAbility:GetSpecialValueFor( "landing_radius" ) * 2

	local ValidEnemies = {}

	for _, enemy in pairs( Enemies ) do
		local fDistance = ( enemy:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
		if fDistance > nMinDistance then
			table.insert( ValidEnemies, enemy )
		end
	end

	if #ValidEnemies == 0 then
		printf( "EvaluateTotem - no ValidEnemies found" )
		return nil
	end

	local nRandomIndex = RandomInt( 1, #ValidEnemies )
	local hRandomEnemy = ValidEnemies[ nRandomIndex ]

	local Order = nil
	local vTargetLocation = hRandomEnemy:GetAbsOrigin()
	if vTargetLocation ~= nil then
		Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hTotemAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hTotemAbility )

		printf( "casting Totem on %s", vTargetLocation )
	end
	
	return Order
end

--------------------------------------------------------------------------------
