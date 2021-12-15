
require( "ai/boss_base" )
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

if CBossTinker == nil then
	CBossTinker = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	--PrecacheUnitByNameSync( "npc_dota_creature_keen_minion", context, -1 )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		--printf( "boss_tinker.lua - Spawn" )
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossTinker( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossTinker:constructor( hUnit, flInterval )
	--printf( "CBossTinker:constructor" )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bMildlyEnraged = false
	self.nMildlyEnragedPct = 70

	self.bFullyEnraged = false
	self.nFullyEnragedPct = 35

	self.KeenMinions = {}
	self.nMaxKeenSpawns = 50

	self.me:SetThink( "OnBossTinkerThink", self, "OnBossTinkerThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossTinker:SetupAbilitiesAndItems()
	--printf( "CBossTinker:SetupAbilitiesAndItems()" )
	CBossBase.SetupAbilitiesAndItems( self )

	self.hMegaLaserAbility = self.me:FindAbilityByName( "boss_tinker_mega_laser" )
	if self.hMegaLaserAbility ~= nil then
		self.hMegaLaserAbility.Evaluate = self.EvaluateMegaLaser
		self.AbilityPriority[ self.hMegaLaserAbility:GetAbilityName() ] = 9
	end
	DoScriptAssert( self.hMegaLaserAbility ~= nil, "self.hMegaLaserAbility not found" )

	self.hPolymorphAbility = self.me:FindAbilityByName( "boss_tinker_polymorph" )
	if self.hPolymorphAbility ~= nil then
		self.hPolymorphAbility.Evaluate = self.EvaluatePolymorph
		self.AbilityPriority[ self.hPolymorphAbility:GetAbilityName() ] = 8
	end
	DoScriptAssert( self.hPolymorphAbility ~= nil, "self.hPolymorphAbility not found" )

	self.hKeenTeleportAbility = self.me:FindAbilityByName( "boss_tinker_keen_teleport" )
	if self.hKeenTeleportAbility ~= nil then
		self.hKeenTeleportAbility.Evaluate = self.EvaluateKeenTeleport
		self.AbilityPriority[ self.hKeenTeleportAbility:GetAbilityName() ] = 7
	end
	DoScriptAssert( self.hKeenTeleportAbility ~= nil, "self.hKeenTeleportAbility not found" )
	self.hKeenTeleportAbility:UpgradeAbility( true )

	self.hMissilesAbility = self.me:FindAbilityByName( "boss_tinker_missiles" )
	if self.hMissilesAbility ~= nil then
		self.hMissilesAbility.Evaluate = self.EvaluateMissiles
		self.AbilityPriority[ self.hMissilesAbility:GetAbilityName() ] = 6
	end
	DoScriptAssert( self.hMissilesAbility ~= nil, "self.hMissilesAbility not found" )

	self.hShivasAbility = self.me:FindAbilityByName( "boss_tinker_shivas" )
	if self.hShivasAbility ~= nil then
		self.hShivasAbility.Evaluate = self.EvaluateShivas
		self.AbilityPriority[ self.hShivasAbility:GetAbilityName() ] = 5
	end
	DoScriptAssert( self.hShivasAbility ~= nil, "self.hShivasAbility not found" )

	self.hBlink = self.me:FindItemInInventory( "item_blink" )
	if self.hBlink ~= nil then
		self.hBlink.Evaluate = self.EvaluateBlink
		self.AbilityPriority[ self.hBlink:GetAbilityName() ] = 4
	end
	DoScriptAssert( self.hBlink ~= nil, "self.hBlink not found" )

	self.hMarchAbility = self.me:FindAbilityByName( "boss_tinker_march" )
	if self.hMarchAbility ~= nil then
		self.hMarchAbility.Evaluate = self.EvaluateMarch
		self.AbilityPriority[ self.hMarchAbility:GetAbilityName() ] = 3
	end
	DoScriptAssert( self.hMarchAbility ~= nil, "self.hMarchAbility not found" )

	self.hLaserAbility = self.me:FindAbilityByName( "boss_tinker_laser" )
	if self.hLaserAbility ~= nil then
		self.hLaserAbility.Evaluate = self.EvaluateLaser
		self.AbilityPriority[ self.hLaserAbility:GetAbilityName() ] = 2
	end
	DoScriptAssert( self.hLaserAbility ~= nil, "self.hLaserAbility not found" )

	self.hWalkAbility = self.me:FindAbilityByName( "boss_tinker_walk" )
	if self.hWalkAbility ~= nil then
		self.hWalkAbility.Evaluate = self.EvaluateWalk
		self.AbilityPriority[ self.hWalkAbility:GetAbilityName() ] = 1
	end
	DoScriptAssert( self.hWalkAbility ~= nil, "self.hWalkAbility not found" )

	self.hPassiveAbility = self.me:FindAbilityByName( "boss_tinker_passive" )
end

--------------------------------------------------------------------------------

function CBossTinker:OnBossTinkerThink()
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossTinker:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossTinker:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct <= self.nMildlyEnragedPct and self.bMildlyEnraged == false then
		self.bMildlyEnraged = true
	end

	if nPct <= self.nFullyEnragedPct and self.bFullyEnraged == false then
		self.bFullyEnraged = true

		self.me:AddNewModifier( self.me, self.hPassiveAbility, "modifier_boss_tinker_enraged", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateMegaLaser()
	--printf( "EvaluateMegaLaser" )

	if self.bFullyEnraged == false then
		--printf( "  not fully enraged yet, so don't cast Mega Laser" )
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hMegaLaserAbility:GetCastRange( self.me:GetOrigin(), nil ) )

	if #Enemies < 1 then
		return nil
	end

	local Order = nil

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hMegaLaserAbility:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hMegaLaserAbility ) + self.hMegaLaserAbility:GetChannelTime()
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluatePolymorph()
	--printf( "EvaluatePolymorph" )

	if self.bFullyEnraged == false then
		--printf( "  not fully enraged yet, so don't cast Polymorph" )
		return nil
	end

	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hPolymorphAbility )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hPolymorphAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hPolymorphAbility ) + self.hPolymorphAbility:GetChannelTime()
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateKeenTeleport()
	--printf( "EvaluateKeenTeleport" )

	if self.bMildlyEnraged == false then
		--printf( "  not even mildly enraged yet, so EvaluateKeenTeleport returns early" )
		return nil
	end

	local nFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD

	local allies = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(),
		self.me, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, nFlags, 0, false
	)

	local ValidTeleportTargets = {}

	local nMinCastDistance = self.hKeenTeleportAbility:GetSpecialValueFor( "min_cast_distance" )

	for _, ally in pairs( allies ) do
		if ally ~= nil and ally:GetUnitName() == "npc_dota_boss_tinker_structure" then
			local fDistanceToTarget = ( ally:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
			if fDistanceToTarget >= nMinCastDistance then
				table.insert( ValidTeleportTargets, ally )
			end
		end
	end

	if #ValidTeleportTargets <= 0 then
		return nil
	end

	local nRandomIndex = RandomInt( 1, #ValidTeleportTargets )
	local hRandomTarget = ValidTeleportTargets[ nRandomIndex ]
	local vTargetLocation = hRandomTarget:GetAbsOrigin()

	local Order = nil

	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hKeenTeleportAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		local fCastTime = GetSpellCastTime( self.hKeenTeleportAbility )
		--local fChannelTime = self.hKeenTeleportAbility:GetChannelTime() -- this is returning 0 (?)
		local fChannelTime = self.hKeenTeleportAbility:GetSpecialValueFor( "tooltip_channel_time" )
		--printf( "fCastTime: %.1f, fChannelTime: %.1f", fCastTime, fChannelTime )
		local fInterval = fCastTime + fChannelTime

		Order.flOrderInterval = fInterval
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateShivas()
	--printf( "EvaluateShivas" )

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nMaxRange = self.hShivasAbility:GetSpecialValueFor( "blast_radius" )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, nMaxRange )

	if #Enemies < 1 then
		return nil
	end

	local Order = nil

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hShivasAbility:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hShivasAbility )

	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateBlink() 
	self.hBlink:EndCooldown() -- do this for now, maybe he should have a custom blink dagger

	local enemies = shallowcopy( self.hPlayerHeroes )
	local Order = nil
	if enemies == nil or #enemies == 0 then
		return Order
	end

	local enemy = enemies[ RandomInt( 1, #enemies ) ] 
	if #enemies >= 2 then 
		while enemy == self.hBlink.hLastTarget do 
			enemy = enemies[ RandomInt( 1, #enemies ) ] 
		end
	end

	local vTargetPos = enemy:GetAbsOrigin() + RandomVector( 400 )

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = self.hBlink:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hBlink )

	self.hBlink.hLastTarget = enemy

	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateMarch()
	--printf( "EvaluateMarch" )

	local Order = nil
	local vTargetLocation = GetBestAOEPointTarget( self.hMarchAbility )
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hMarchAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hMarchAbility ) + self.hMarchAbility:GetChannelTime()
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateLaser()
	--printf( "EvaluateLaser" )

	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hLaserAbility:GetCastRange( self.me:GetOrigin(), nil ) )

	if #Enemies < 1 then
		return nil
	end

	local ValidTargets = {}
	local nMinRange = self.hLaserAbility:GetSpecialValueFor( "minimum_range" )

	for _, enemy in pairs( Enemies ) do
		local fDistance = ( enemy:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
		if fDistance >= nMinRange then
			table.insert( ValidTargets, enemy )
		end
	end

	if #ValidTargets < 1 then
		return nil
	end

	local Order = nil

	local hRandomEnemy = ValidTargets[ RandomInt( 1, #ValidTargets ) ]
	if hRandomEnemy == nil then
		return nil
	end

	local vTargetLocation = hRandomEnemy:GetAbsOrigin()
	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hLaserAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hLaserAbility ) + self.hLaserAbility:GetChannelTime()
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateMissiles()
	--printf( "EvaluateMissiles" )

	if self.bMildlyEnraged == false and self.bFullyEnraged == false then
		--printf( "  not even mildly enraged yet, so don't cast Missiles" )
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, self.hMissilesAbility:GetCastRange( self.me:GetOrigin(), nil ) )

	if #Enemies < 1 then
		return nil
	end

	local nMinRange = self.hMissilesAbility:GetSpecialValueFor( "min_range" )
	local nValidEnemies = 0

	for _, enemy in pairs( Enemies ) do
		local fDistanceToEnemy = ( enemy:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
		if fDistanceToEnemy >= nMinRange then
			nValidEnemies = nValidEnemies + 1
		end
	end

	if nValidEnemies == 0 then
		return nil
	end

	local Order = nil

	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hMissilesAbility:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hMissilesAbility )

	return Order
end

--------------------------------------------------------------------------------

function CBossTinker:EvaluateWalk()
	printf( "EvaluateWalk" )

	local nCastRange = self.hWalkAbility:GetCastRange( self.me:GetOrigin(), nil )

	local Enemies = shallowcopy( self.hPlayerHeroes )
	Enemies = FilterEntitiesOutsideOfRange( self.me:GetAbsOrigin(), Enemies, nCastRange )

	local vTargetLocation = nil

	if #Enemies > 0 then
		local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
		local nRandomOffset = self.hWalkAbility:GetSpecialValueFor( "random_target_offset" )
		vTargetLocation = FindRandomPointInRoom( hRandomEnemy:GetAbsOrigin(), nRandomOffset, nRandomOffset )
	else
		vTargetLocation = FindRandomPointInRoom( self.me:GetAbsOrigin(), nCastRange, nCastRange )
	end

	local Order = nil

	if vTargetLocation ~= nil then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = self.hWalkAbility:entindex(),
			Position = vTargetLocation,
			Queue = false,
		}

		Order.flOrderInterval = GetSpellCastTime( self.hWalkAbility )
	end

	return Order
end

--------------------------------------------------------------------------------
