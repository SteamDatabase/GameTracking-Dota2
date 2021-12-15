--[[ Mirana AI ]]

require( "ai/ai_core" )

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 0.25 )
    behaviorSystem = AICore:CreateBehaviorSystem( thisEntity, { BehaviorNone, BehaviorShootArrow, BehaviorStarfall, BehaviorRunAway } )
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

BehaviorShootArrow = {}

function BehaviorShootArrow:Evaluate()
	local desire = 0
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.arrowAbility = thisEntity:FindAbilityByName( "mirana_arrow" )
	
	self.target = nil
	local bestDistance = 0
	if not self.arrowAbility or not self.arrowAbility:IsFullyCastable() then
		return desire
	end

	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), thisEntity, self.arrowAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	if #enemies == 0 then
		return desire
	end

	for _,enemy in pairs(enemies) do
		local enemyVec = enemy:GetOrigin() - thisEntity:GetOrigin()
		local myForward = thisEntity:GetForwardVector()
		local dotProduct = enemyVec:Dot( myForward ) 
		local enemyDesire = 5
		if enemy:IsStunned() then
			enemyDesire = 3
		elseif dotProduct > 0 then
			enemyDesire = 8
		end

		local distance = enemyVec:Length2D()
		if distance > 350 then
			if ( enemyDesire == desire and bestDistance > distance ) or ( desire < enemyDesire ) then
				desire = enemyDesire
				bestDistance = distance
				self.target = enemy
				thisEntity.lastTargetPosition = enemy:GetAbsOrigin()
			end
		end
	end

	return desire
end

function BehaviorShootArrow:Begin()

	if self.target and self.target:IsAlive() then
		local targetPoint = self.target:GetOrigin() + RandomVector( 100 )
		if self.arrowAbility and self.arrowAbility:IsFullyCastable() then
			return
			{
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self.arrowAbility:entindex(),
				Position = targetPoint
			}
		end
	end

	return nil

end

BehaviorShootArrow.Continue = BehaviorShootArrow.Begin

--------------------------------------------------------------------------------------------------------

BehaviorStarfall = {}

function BehaviorStarfall:Evaluate()
	--print( "BehaviorStarfall:Evaluate()" )
	local desire = 0

	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.starFallAbility = thisEntity:FindAbilityByName( "mirana_starfall" )
	if self.starFallAbility and self.starFallAbility:IsFullyCastable() then
		local nRange = self.starFallAbility:GetSpecialValueFor( "starfall_radius" )
		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, nRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if ( #enemies >= 0 )  then
			desire = #enemies + 1
		end
	end
	
	return desire
end

function BehaviorStarfall:Begin()
	--print( "BehaviorStarfall:Begin()" )

	if self.starFallAbility and self.starFallAbility:IsFullyCastable() then
		--print( "Casting Star Fall" )
		local order =
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.starFallAbility:entindex()
		}
		return order
	end

	return nil
end

BehaviorStarfall.Continue = BehaviorStarfall.Begin

--------------------------------------------------------------------------------------------------------

BehaviorRunAway = {}

function BehaviorRunAway:Evaluate()
	local desire = 0
	local retreatPoints = thisEntity.Encounter:GetRetreatPoints()
	if retreatPoints == nil then
		print( "*** WARNING: This AI requires info_targets named retreat_point in the map " .. thisEntity.Encounter:GetRoom():GetName() )
		return 0
	end

	-- let's not choose this twice in a row, or even too close to another escape
	if behaviorSystem.currentBehavior == self or 
		( self.startEscapeTime ~= nil and ( ( GameRules:GetGameTime() - self.startEscapeTime ) < 6 ) ) then
		return desire
	end

	local happyPlaceIndex =  RandomInt( 1, #retreatPoints )
	self.escapePoint = retreatPoints[ happyPlaceIndex ]:GetAbsOrigin()

	self.leapAbility = thisEntity:FindAbilityByName( "mirana_leap" )
	
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	local friendlies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )
	--print( string.format( "found %d enemies and %d friendlies near us", #enemies, #friendlies ) )

	-- Remember that mirana herself will be in the friendlies list, so it's one too big
	if ( #enemies >= 2 ) and ( #friendlies <= 1 ) then
		desire = #enemies + 1
	end
	
	return desire
end


function BehaviorRunAway:Begin()
	--print( "BehaviorRunAway:Begin()" )
	self.startEscapeTime = GameRules:GetGameTime()
	self.bHasLeaped = false

	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = thisEntity:GetItemInSlot( i )
		if item and item:GetAbilityName() == "item_phase_boots" then
			self.phaseAbility = item
		end
	end

	-- phase right away
	if self.phaseAbility and self.phaseAbility:IsFullyCastable() then
		return
		{
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.phaseAbility:entindex()
		}
	end

	-- move towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

function BehaviorRunAway:IsDone( )
	return ( GameRules:GetGameTime() > ( self.startEscapeTime + 6 ) ) or
		( ( thisEntity:GetAbsOrigin() - self.escapePoint ):Length2D() < 200 )
end

function BehaviorRunAway:Think( )

	-- give ourselves time to turn towards escape point before leaping
	if GameRules:GetGameTime() >= self.startEscapeTime + 0.6 and self.bHasLeaped == false then
		if self.leapAbility and self.leapAbility:IsFullyCastable() then
			-- Make sure we're not going to leap out of the room or into 
			-- somewhere not navigable
			local vMyForward = thisEntity:GetForwardVector()
			local vTargetPos = thisEntity:GetOrigin() + vMyForward * self.leapAbility:GetSpecialValueFor( "leap_distance" )
			if thisEntity.Encounter:GetRoom():IsValidSpawnPoint( vTargetPos ) and
				GridNav:CanFindPath( thisEntity:GetOrigin(), vTargetPos ) then
				self.bHasLeaped = true
				return
				{
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = self.leapAbility:entindex()
				}
			end
		end
	end

	-- keep moving towards our escape point
	return
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.escapePoint
	}

end

BehaviorRunAway.Continue = BehaviorRunAway.Begin

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorShootArrow, BehaviorRunAway }
