
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CDrowRangerMiniboss == nil then
	CDrowRangerMiniboss = class( {}, {}, CBossBase )
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

		thisEntity.AI = CDrowRangerMiniboss( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bEnraged = false
	self.nEnragePct = 33

	self.bTriggerShadowBlade = false
	self.nShadowBladeHealthTriggerPct = 75
	self.bTriggerEscape = false

	self.me:SetThink( "OnDrowRangerMinibossThink", self, "OnDrowRangerMinibossThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hGust = self.me:FindAbilityByName( "aghsfort_drow_ranger_wave_of_silence" )
	if self.hGust == nil then
		print( 'CDrowRangerMiniboss - Unable to find ability aghsfort_drow_ranger_wave_of_silence')
	else
		self.hGust.Evaluate = self.EvaluateGust
		self.AbilityPriority[ self.hGust:GetAbilityName() ] = 4
	end

	self.hMultishot = self.me:FindAbilityByName( "aghsfort_drow_ranger_multishot" )
	if self.hMultishot == nil then
		print( 'CDrowRangerMiniboss - Unable to find ability aghsfort_drow_ranger_multishot')
	else
		self.hMultishot.Evaluate = self.EvaluateMultishot
		self.AbilityPriority[ self.hMultishot:GetAbilityName() ] = 3
	end

	self.hHurricanePike = self.me:FindItemInInventory( "item_hurricane_pike" )
	if self.hHurricanePike == nil then
		print( 'CDrowRangerMiniboss - Unable to find ability item_hurricane_pike')
	else
		self.hHurricanePike.Evaluate = self.EvaluateHurricanePike
		self.AbilityPriority[ self.hHurricanePike:GetAbilityName() ] = 2
	end

	self.hShadowBlade = self.me:FindItemInInventory( "item_aghsfort_drow_ranger_invis_sword" )
	if self.hShadowBlade == nil then
		print( 'CDrowRangerMiniboss - Unable to find ability item_aghsfort_drow_ranger_invis_sword')
	else
		self.hShadowBlade.Evaluate = self.EvaluateShadowBlade
		self.AbilityPriority[ self.hShadowBlade:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:OnDrowRangerMinibossThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:IsInvisible()
	local hBuff = thisEntity:FindModifierByName( "modifier_item_invisibility_edge_windwalk" )
	return hBuff ~= nil
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )
	if nPct <= self.nEnragePct and self.bEnraged == false then
		self.bEnraged = true
	end

	if nPct <= self.nShadowBladeHealthTriggerPct then
		print( 'Shadow Blade Health Trigger Hit at ' .. self.nShadowBladeHealthTriggerPct )
		self.nShadowBladeHealthTriggerPct = self.nShadowBladeHealthTriggerPct - 25
		self.bTriggerShadowBlade = true
	end
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:EvaluateGust()
	if self:IsInvisible() then	
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hGust:GetCastRange()
	printf( "EvaluateGust - nSearchRadius == %d", nSearchRadius )
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
				AbilityIndex = self.hGust:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hGust )
		end
	end

	--[[
	local vTargetLocation = GetBestDirectionalPointTarget( self.hGust )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vTargetLocation,
			AbilityIndex = self.hGust:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hGust )
	end
	]]

	return Order
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:EvaluateMultishot()
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

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:EvaluateHurricanePike()
	if self:IsInvisible() then	
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hHurricanePike:GetCastRange()
	printf( "EvaluateHurricanePike - nSearchRadius == %d", nSearchRadius )
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
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hRandomEnemy:entindex(),
				AbilityIndex = self.hHurricanePike:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hHurricanePike )
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:EvaluateShadowBlade()
	if self:IsInvisible() then	
		return nil
	end

	local Order = nil

	if self.bTriggerShadowBlade == true then
		print( 'Triggering Shadow Blade!' )
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP,
			Queue = false,
		}
		ExecuteOrderFromTable( Order )

		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hShadowBlade:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = 1.0
		self.bTriggerShadowBlade = false
		self.bTriggerEscape = true
	end

	return Order
end

--------------------------------------------------------------------------------

function CDrowRangerMiniboss:GetNonAbilityOrder()
	local Order = nil

	-- if we've successfully shadow bladed and we're ready to escape we should move somewhere else
	if self:IsInvisible() and self.bTriggerEscape == true then
		print( 'INVIS! Setting new escape location' )
		self.bTriggerEscape = false
		local vEscapeLoc
		local flOrderInterval
		if GetMapName() == "hub" then
			vEscapeLoc = FindPathablePositionNearby( thisEntity:GetAbsOrigin(), 1500, 3000 )	-- larger run away distance for the new hub map since the map is larger
			flOrderInterval = 13
		else
			vEscapeLoc = FindPathablePositionNearby( thisEntity:GetAbsOrigin(), 1000, 2000 )
			flOrderInterval = 10
		end
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = vEscapeLoc,
		}
		Order.flOrderInterval = flOrderInterval

		if self.Encounter ~= nil then
			self.Encounter:OnDrowShadowBladed()
		else
			print( 'CDrowRangerMiniboss - ENCOUNTER IS NIL' )
		end
	end

	return Order
end
