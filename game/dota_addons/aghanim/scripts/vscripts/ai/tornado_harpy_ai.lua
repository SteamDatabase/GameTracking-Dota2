require( "ai/ai_core" )


function Precache( context )

	PrecacheResource( "particle", "particles/neutral_fx/harpy_chain_lightning_head.vpcf", context )
   	PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context )
   	PrecacheResource( "particle", "particles/neutral_fx/harpy_chain_lightning.vpcf", context )

end




function Spawn( entityKeyValues )

	thisEntity.hSurgeAbility = thisEntity:FindAbilityByName( "tornado_harpy_intrinsic" )
    thisEntity.PreviousHealthPct = thisEntity:GetHealthPercent()
    thisEntity.PreviousHealthPctGameTime = GameRules:GetGameTime()

    thisEntity:SetContextThink( "TornadoHarpyThink", TornadoHarpyThink, 0.5 )
end

--------------------------------------------------------------------------------

function TornadoHarpyThink()
	
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--check our health pct every 4 seconds
	if GameRules:GetGameTime() > thisEntity.PreviousHealthPctGameTime + 4 then
		thisEntity.PreviousHealthPctGameTime = GameRules:GetGameTime()
		thisEntity.PreviousHealthPct = thisEntity:GetHealthPercent()		
	end
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	if #hEnemies > 0 then 
		for i = 1, #hEnemies do
			thisEntity.avoidTarget = hEnemies[i]
			if thisEntity.avoidTarget ~= nil then
				if thisEntity:GetHealthPercent() < thisEntity.PreviousHealthPct then
					return Retreat(thisEntity.avoidTarget )
				else
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = thisEntity.avoidTarget:entindex(),
						Queue = false
					})
				end
				break
			end
		end
	end

	return 0.5
end



--------------------------------------------------------------------------------

function Retreat(unit)
	
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()*4

	-- if away from enemy is an unpathable area, find a new direction to run to
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() * 4 )
		nAttempts = nAttempts + 1
	end

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	thisEntity:AddNewModifier(thisEntity, thisEntity.hSurgeAbility, "modifier_tornado_harpy_surge", {duration = 2.0})

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})

	return 2.5
end

--[[

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
	return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
--	print( "BehaviorNone:Begin()" )
	local orders = nil
	local hTarget = AICore:ClosestEnemyHeroInRange( thisEntity, thisEntity:GetDayTimeVisionRange(), false, true )
	
	if hTarget ~= nil then
		thisEntity.lastTargetPosition = hTarget:GetAbsOrigin()
		for i=1,6 do
			local vLoc = FindPathablePositionNearby(hTarget:GetAbsOrigin(), 650, 650 )
--and thisEntity:IsMoving() == false
			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then
			--orders =
			--{
			--	UnitIndex = thisEntity:entindex(),
			--	OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			--	Position = vLoc,
			--	Queue = true,
			--}
			break
			end
		end
	elseif thisEntity.lastTargetPosition ~= nil then
	for i=1,6 do
			local vLoc = FindPathablePositionNearby(thisEntity.lastTargetPosition, 650, 650 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then
			--orders =
			--{
			--	UnitIndex = thisEntity:entindex(),
			--	OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			--	Position = vLoc
			--}
			break
			end
		end
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

BehaviorAttack = {}

function BehaviorAttack:Evaluate()
	
	local desire = 6
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end

	self.chainLightningAbility = thisEntity:FindAbilityByName( "harpy_storm_chain_lightning" )
	
	if self.chainLightningAbility and self.chainLightningAbility:IsFullyCastable() then
		
		self.target = AICore:ClosestEnemyHeroInRange( thisEntity, thisEntity:GetDayTimeVisionRange(), false, false )
		if self.target ~= nil and self.target:IsAlive() then
			desire = 6
		end
	end
	
	return desire
end

function BehaviorAttack:Begin()
--	print( "BehaviorAttack:Begin()" )

	--if self.chainLightningAbility and self.chainLightningAbility:IsFullyCastable() then
		if self.target and self.target:IsAlive() then
			--print( "Casting Chain Lightning" )
			local targetPoint = self.target:GetAbsOrigin() + RandomVector( 100 )
			thisEntity.lastTargetPosition = self.target:GetAbsOrigin()
			ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
					--AbilityIndex = self.chainLightningAbility:entindex(),
					TargetIndex = self.target:entindex(),
					Queue = false
				})
		end
	--end

	return nil
end

BehaviorAttack.Continue = BehaviorAttack.Begin


--------------------------------------------------------------------------------------------------------

BehaviorAvoid = {}

function BehaviorAvoid:Evaluate()
	
	local desire = 0
	
	-- let's not choose this twice in a row
	if behaviorSystem.currentBehavior == self then 
		return desire 
	end
	--don't even think about running if you can damage!
	if self.chainLightningAbility and self.chainLightningAbility:IsFullyCastable() then
		return desire 
	end
	
	--check our health pct every 5 seconds
	if GameRules:GetGameTime() > thisEntity.PreviousHealthPctGameTime + 5 then
		printf("reseting healthpct")
		thisEntity.PreviousHealthPctGameTime = GameRules:GetGameTime()
		thisEntity.PreviousHealthPct = thisEntity:GetHealthPercent()		
	end

	self.avoidTarget = AICore:ClosestEnemyHeroInRange( thisEntity, 650, false, true )
	if self.avoidTarget ~= nil then
		desire = 4
	end

	if thisEntity:GetHealthPercent() < thisEntity.PreviousHealthPct then
		printf("I'm hurt")
		desire = 8
	end

	return desire
end

function BehaviorAvoid:Begin()
	print( "BehaviorAvoid:Begin()" )

	for i=1,6 do
		self.vEscapeLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 350, 350 )

		if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( self.vEscapeLoc ) and ( self.vEscapeLoc - self.avoidTarget:GetAbsOrigin() ):Length2D() > 650 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = self.vEscapeLoc
		})
		printf("function BehaviorAvoid: Executing order()")
		break
		end
	end
	return nil
end


function BehaviorAvoid:Think(dt)

			-- keep moving towards our escape point
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vEscapeLoc
	})
	return nil
end


BehaviorAvoid.Continue = BehaviorAvoid.Begin ]]--