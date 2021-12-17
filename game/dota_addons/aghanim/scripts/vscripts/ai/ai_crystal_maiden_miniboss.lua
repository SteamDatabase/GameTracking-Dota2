
require( 'ai/boss_base' )

--------------------------------------------------------------------------------

if CCrystalMaidenMiniboss == nil then
	CCrystalMaidenMiniboss = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( 'particle_folder', 'particles/units/heroes/hero_winter_wyvern', context )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CCrystalMaidenMiniboss( thisEntity, 1.0 )

		thisEntity.nEntityHurtEvent = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnEntityHurt' ), nil )
	end
end

--------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.nEntityHurtEvent )
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.bColdEmbrace = false
	self.bRetreat = false
	self.bWaitingAtPinnacle = false
	self.bReapplyNoCCAfterColdEmbrace = false

	self.HealthPhaseTriggers =
	{
		{
			health_percent = 75,
			triggered = false,
		},
		{
			health_percent = 50,
			triggered = false,
			retreat = true,
		},
		{
			health_percent = 25,
			triggered = false,
		},
	}

	self.fOriginalAcquisitionRange = self.me:GetAcquisitionRange()

	self.me:SetThink( 'OnCrystalMaidenMinibossThink', self, 'OnCrystalMaidenMinibossThink', self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hFreezingField = self.me:FindAbilityByName( 'aghsfort_crystal_maiden_freezing_field' )
	if self.hFreezingField == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability aghsfort_crystal_maiden_freezing_field')
	else
		self.hFreezingField.Evaluate = self.EvaluateFreezingField
		self.AbilityPriority[ self.hFreezingField:GetAbilityName() ] = 1
	end

	self.hCrystalNova = self.me:FindAbilityByName( 'aghsfort_crystal_maiden_crystal_nova' )
	if self.hCrystalNova == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability aghsfort_crystal_maiden_crystal_nova' )
	else
		self.hCrystalNova.Evaluate = self.EvaluateCrystalNova
		self.AbilityPriority[ self.hCrystalNova:GetAbilityName() ] = 3
	end

	self.hFrostbite = self.me:FindAbilityByName( 'aghsfort_crystal_maiden_frostbite' )
	if self.hFrostbite == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability aghsfort_crystal_maiden_frostbite' )
	else
		self.hFrostbite.Evaluate = self.EvaluateFrostBite
		self.AbilityPriority[ self.hFrostbite:GetAbilityName() ] = 3
	end		
	
	self.hColdEmbrace = self.me:FindAbilityByName( 'aghsfort_crystal_maiden_cold_embrace' )
	if self.hColdEmbrace == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability aghsfort_crystal_maiden_cold_embrace' )
	else
		self.hColdEmbrace.Evaluate = self.EvaluateColdEmbrace
		self.AbilityPriority[ self.hColdEmbrace:GetAbilityName() ] = 5
	end		

	--[[
	self.hHurricanePike = self.me:FindItemInInventory( 'item_hurricane_pike' )
	if self.hHurricanePike == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability item_hurricane_pike')
	else
		self.hHurricanePike.Evaluate = self.EvaluateHurricanePike
		self.AbilityPriority[ self.hHurricanePike:GetAbilityName() ] = 2
	end

	self.hShadowBlade = self.me:FindItemInInventory( 'item_aghsfort_drow_ranger_invis_sword' )
	if self.hShadowBlade == nil then
		print( 'CCrystalMaidenMiniboss - Unable to find ability item_aghsfort_drow_ranger_invis_sword')
	else
		self.hShadowBlade.Evaluate = self.EvaluateShadowBlade
		self.AbilityPriority[ self.hShadowBlade:GetAbilityName() ] = 1
	end
	]]--
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:OnCrystalMaidenMinibossThink()
	if self.bWaitingAtPinnacle == true then
		--print( 'ARRIVED AT PINNACLE - will awaken on next damage!' )
		thisEntity.bAwakenOnDamage = true
		return self.flDefaultInterval
	end

	-- shutdown during the cold embrace buff
	local hColdEmbraceBuff = self.me:FindModifierByName( 'modifier_aghsfort_winter_wyvern_cold_embrace' )
	if hColdEmbraceBuff ~= nil then
		print( 'SHUTDOWN DURING COLD EMBRACE' )
		return self.flDefaultInterval
	end

	--print( 'NO COLD EMBRACE - PROCEED AS NORMAL' )

	-- once the cold embrace goes on make sure we put it back on after it falls off
	if self.bReapplyNoCCAfterColdEmbrace == true then
		print( 'ADDING NO CC BACK IN!' )
		self.bReapplyNoCCAfterColdEmbrace = false
		self.me:AddNewModifier( self.me, nil, 'modifier_absolute_no_cc', { duration = -1 } )
	end

	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	for _,v in ipairs( self.HealthPhaseTriggers ) do
		if v.triggered == false then
			if nPct < v.health_percent then
				
				self.me:Interrupt()
				self.me:InterruptChannel()

				v.triggered = true
				if v.retreat ~= nil then
					self.bColdEmbrace = false
					self.bRetreat = true
				else
					self.bColdEmbrace = true
				end				
			end
		end
	end
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:OnBossUsedAbility( szAbilityName )
	CBossBase.OnBossUsedAbility( self, szAbilityName )

	print( 'CCrystalMaidenMiniboss:OnBossUsedAbility()! - ' .. szAbilityName )

	if szAbilityName == 'aghsfort_crystal_maiden_cold_embrace' then
		print( 'REMOVING NO CC!' )
		self.bReapplyNoCCAfterColdEmbrace = true
		self.me:RemoveAbility( 'ability_absolute_no_cc' )
	  	self.me:RemoveModifierByName( 'modifier_absolute_no_cc' )
	end
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:EvaluateFreezingField()
	if self.bRetreat == true then
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	-- use the nova cast range instead - it's larger and we want to freezing field even without targets so that we can get the venges to swap in
	--local nSearchRadius = self.hFreezingField:GetSpecialValueFor( 'radius' )
	local nSearchRadius = self.hCrystalNova:GetCastRange()
	printf( 'EvaluateFreezingField - nSearchRadius == %d', nSearchRadius )
	Enemies = GetEnemyHeroesInRange( thisEntity, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		local hRandomEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
		local vTargetLocation = hRandomEnemy:GetAbsOrigin()
		if vTargetLocation ~= nil then
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.hFreezingField:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = self.hFreezingField:GetChannelTime()
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:EvaluateCrystalNova()
	if self.bRetreat == true then
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hCrystalNova:GetCastRange()
	printf( 'EvaluateCrystalNova - nSearchRadius == %d', nSearchRadius )
	Enemies = GetEnemyHeroesInRange( thisEntity, nSearchRadius )

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
				AbilityIndex = self.hCrystalNova:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hCrystalNova )
			print( 'ORDER INTERVAL for CrystalNova is ' .. Order.flOrderInterval )
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:EvaluateFrostBite()
	if self.bRetreat == true then
		return nil
	end

	local nSearchRadius = self.hFrostbite:GetCastRange()
	printf( 'EvaluateFrostBite - nSearchRadius == %d', nSearchRadius )
	Enemies = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetAbsOrigin(), nil, nSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )

	local Order = nil
	for i = 1, #Enemies do
		local enemy = Enemies[i]
		if enemy ~= nil and enemy:IsNull() == false and enemy:IsAlive() == true then
			print( 'FROST BITE ' .. enemy:GetUnitName() .. ' - at index = ' .. i )
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = enemy:entindex(),
				AbilityIndex = self.hFrostbite:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hFrostbite )
			--print( 'ORDER INTERVAL for Frostbite is ' .. Order.flOrderInterval )
			return Order
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:EvaluateColdEmbrace()
	if self.bRetreat == true then
		return nil
	end

	if self.bColdEmbrace == false then
		return nil
	end
	self.bColdEmbrace = false

	local Order = nil
	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = self.me:entindex(),
		AbilityIndex = self.hColdEmbrace:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hColdEmbrace )
	--print( 'ORDER INTERVAL for ColdEmbrace is ' .. Order.flOrderInterval )

	return Order
end

--[[
--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:EvaluateHurricanePike()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hHurricanePike:GetCastRange()
	printf( 'EvaluateHurricanePike - nSearchRadius == %d', nSearchRadius )
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

function CCrystalMaidenMiniboss:EvaluateShadowBlade()
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
]]--

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:GetNonAbilityOrder()
	if self.bRetreat == false then
		return nil
	end

	-- don't allow retreating if we're in the cold embrace
	local hColdEmbraceBuff = self.me:FindModifierByName( 'modifier_aghsfort_winter_wyvern_cold_embrace' )
	if hColdEmbraceBuff ~= nil then
		return nil
	end

	self.bRetreat = false
	self.bWaitingAtPinnacle = true

	self.me:SetAcquisitionRange( 100 )

	print( 'RETREAT! Setting new escape location' )
	local retreatPoints = nil
	if self.Encounter ~= nil then
		retreatPoints = thisEntity.Encounter:GetRetreatPoints()
		if retreatPoints == nil then
			print( "*** WARNING: CM Miniboss AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
			return nil
		end
	end

	local Order = nil
	local vEscapeLoc = retreatPoints[1]:GetAbsOrigin()
	Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vEscapeLoc,
	}
	Order.flOrderInterval = 15

	--[[
	if self.Encounter ~= nil then
		self.Encounter:OnDrowShadowBladed()
	else
		print( 'CCrystalMaidenMiniboss - ENCOUNTER IS NIL' )
	end
	]]--

	return Order
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:OnPlayerTouchedPinnacleTrigger()
	--print( 'CCrystalMaidenMiniboss:OnPlayerTouchedPinnacleTrigger()!' )
	self:WakeUp()
end

--------------------------------------------------------------------------------

function CCrystalMaidenMiniboss:WakeUp()
	self.bWaitingAtPinnacle = false
	self.me:SetAcquisitionRange( self.fOriginalAcquisitionRange )
end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------
function OnEntityHurt( event )

	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim ~= thisEntity then
		return
	end

	--print( 'CM TOOK DAMAGE' )

	if thisEntity.bAwakenOnDamage and thisEntity.bAwakenOnDamage == true then
		--print( '...AND WAS WAITING TO WAKE UP! TIME TO DIE!' )
		thisEntity.bAwakenOnDamage = false
		thisEntity.AI:WakeUp()
	end
end