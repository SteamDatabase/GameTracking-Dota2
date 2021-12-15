--[[ Kunkka AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorTorrent, BehaviorGhostShip } )
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
	return behaviorSystem:Think( )
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()

	local orders = nil
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, thisEntity:GetDayTimeVisionRange(), false, true )
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		hTarget:MakeVisibleDueToAttack( DOTA_TEAM_BADGUYS, 100 )
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = hTarget:entindex()
		}
	elseif thisEntity.lastTargetPosition ~= nil then
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = thisEntity.lastTargetPosition
		}
	else
		orders =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
	end

	return orders
end

BehaviorNone.Continue = BehaviorNone.Begin

--------------------------------------------------------------------------------------------------------

BehaviorTorrent = {}

function BehaviorTorrent:Evaluate()
	--print( "BehaviorTorrent:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.torrentAbility = thisEntity:FindAbilityByName( "kunkka_torrent_dm" )
	if self.torrentAbility and self.torrentAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end

	return desire
end

function BehaviorTorrent:Begin()
	--print( "BehaviorTorrent:Begin()" )
	if self.torrentAbility and self.torrentAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return nil
		end
		local hTarget = hEnemies[#hEnemies]
		local vTarget = hTarget:GetAbsOrigin()
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.torrentAbility:entindex(),
				Position = vTarget
			}
			return order
	end

	return nil
end

BehaviorTorrent.Continue = BehaviorTorrent.Begin

--------------------------------------------------------------------------------------------------------
--[[
BehaviorTidebringer = {}

function BehaviorTidebringer:Evaluate()
	--print( "BehaviorTorrent:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.tidebringerAbility = thisEntity:FindAbilityByName( "kunkka_tidebringer" )
	if self.tidebringerAbility and self.tidebringerAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies > 2 )  then
			desire = #enemies + 2
		end
	end

	return desire
end

function BehaviorTidebringer:Begin()
	--print( "BehaviorTorrent:Begin()" )
	if self.tidebringerAbility and self.tidebringerAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return nil
		end
		local hTarget = hEnemies[#hEnemies]
		local vTarget = hTarget:GetAbsOrigin()
		local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = hTarget:entindex(),
				AbilityIndex = self.tidebringerAbility:entindex(),
				Queue = false,
			}
			return order
	end

	return nil
end

BehaviorTidebringer.Continue = BehaviorTidebringer.Begin
]]
--------------------------------------------------------------------------------------------------------

BehaviorGhostShip = {}

function BehaviorGhostShip:Evaluate()
	--print( "BehaviorGhostShip:Evaluate()" )
	local desire = 0

	self.ghostShipAbility = thisEntity:FindAbilityByName( "kunkka_ghostship" )
	if self.ghostShipAbility and self.ghostShipAbility:IsFullyCastable() then
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies > 1 )  then
			desire = #enemies + 5
		end
	end
	
	return desire
end

function BehaviorGhostShip:Begin()
	--print( "BehaviorGhostShip:Begin()" )

	if self.ghostShipAbility and self.ghostShipAbility:IsFullyCastable() then
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hEnemies == 0 then
			return nil
		end
		local hTarget = hEnemies[#hEnemies]
		local targetPoint = hTarget:GetOrigin() + RandomVector( 100 )
		if self.ghostShipAbility and self.ghostShipAbility:IsFullyCastable() then
			--print( "Casting Ghost Ship" )
			local order =
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.ghostShipAbility:entindex(),
				Position = targetPoint
			}
			return order
		end
	end

	return nil
end

BehaviorGhostShip.Continue = BehaviorGhostShip.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorTorrent, BehaviorGhostShip }
