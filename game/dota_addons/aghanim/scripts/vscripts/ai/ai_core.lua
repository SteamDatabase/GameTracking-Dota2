--[[
Tower Defense AI

These are the valid orders, in case you want to use them (easier here than to find them in the C code):

DOTA_UNIT_ORDER_NONE
DOTA_UNIT_ORDER_MOVE_TO_POSITION 
DOTA_UNIT_ORDER_MOVE_TO_TARGET 
DOTA_UNIT_ORDER_ATTACK_MOVE
DOTA_UNIT_ORDER_ATTACK_TARGET
DOTA_UNIT_ORDER_CAST_POSITION
DOTA_UNIT_ORDER_CAST_TARGET
DOTA_UNIT_ORDER_CAST_TARGET_TREE
DOTA_UNIT_ORDER_CAST_NO_TARGET
DOTA_UNIT_ORDER_CAST_TOGGLE
DOTA_UNIT_ORDER_HOLD_POSITION
DOTA_UNIT_ORDER_TRAIN_ABILITY
DOTA_UNIT_ORDER_DROP_ITEM
DOTA_UNIT_ORDER_GIVE_ITEM
DOTA_UNIT_ORDER_PICKUP_ITEM
DOTA_UNIT_ORDER_PICKUP_RUNE
DOTA_UNIT_ORDER_PURCHASE_ITEM
DOTA_UNIT_ORDER_SELL_ITEM
DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
DOTA_UNIT_ORDER_MOVE_ITEM
DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
DOTA_UNIT_ORDER_STOP
DOTA_UNIT_ORDER_TAUNT
DOTA_UNIT_ORDER_BUYBACK
DOTA_UNIT_ORDER_GLYPH
DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
DOTA_UNIT_ORDER_CAST_RUNE
]]

AICore = {}

behaviorSystem = {} -- create the global so we can assign to it

function AICore:RandomEnemyHeroInRange( entity, range, bAllowInvis, bAllowMagicImmune )
	local nFlags = 0
	if bAllowInvis ~= true then
		nFlags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
	end
	if bAllowMagicImmune == true then
		nFlags = nFlags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, 0, false )
	if #enemies > 0 then
		local index = RandomInt( 1, #enemies )
		return enemies[index]
	else
		return nil
	end
end

function AICore:ClosestEnemyHeroInRange( entity, range, bAllowInvis, bAllowMagicImmune )
	local nFlags = 0
	if bAllowInvis ~= true then
		nFlags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
	end
	if bAllowMagicImmune == true then
		nFlags = nFlags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, FIND_CLOSEST, false )
	if #enemies > 0 then
		return enemies[1]
	else
		return nil
	end
end

function AICore:WeakestEnemyHeroInRange( entity, range, bAllowInvis, bAllowMagicImmune )
	local nFlags = 0
	if bAllowInvis ~= true then
		nFlags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
	end
	if bAllowMagicImmune == true then
		nFlags = nFlags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), entity, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, nFlags, 0, false )

	local minHP = nil
	local target = nil

	for _,enemy in pairs(enemies) do
		local distanceToEnemy = (entity:GetOrigin() - enemy:GetOrigin()):Length()
		local HP = enemy:GetHealth()
		if enemy:IsAlive() and (minHP == nil or HP < minHP) and distanceToEnemy < range then
			minHP = HP
			target = enemy
		end
	end

	return target
end

function AICore:CreateBehaviorSystem( hEntity, behaviors )

	local BehaviorSystem = {}

	BehaviorSystem.hEntity = hEntity
	BehaviorSystem.possibleBehaviors = behaviors
	BehaviorSystem.thinkDuration = 0.3

	BehaviorSystem.currentBehavior =
	{
	}
	BehaviorSystem.currentOrder = { OrderType = DOTA_UNIT_ORDER_NONE }

	function BehaviorSystem:Think( )
		-- Don't do anything if we're in the middle of casting something
		if self.hEntity:GetCurrentActiveAbility() ~= nil or GameRules:IsGamePaused() then
			return 0.1
		end

		local bIsDone = self.currentBehavior.IsDone == nil or self.currentBehavior:IsDone() 
		local newOrder = nil
		if bIsDone then
			local newBehavior = self:ChooseNextBehavior()
			if newBehavior == nil then 
				-- Do nothing here... this covers possible problems with ChooseNextBehavior
			elseif newBehavior == self.currentBehavior then
				newOrder = self.currentBehavior:Continue()
			else
				if self.currentBehavior.End then 
					self.currentBehavior:End() 
				end
				self.currentBehavior = newBehavior
				newOrder = self.currentBehavior:Begin()
			end
		else
			if self.currentBehavior.Think then 
				newOrder = self.currentBehavior:Think() 
			end
		end

		if newOrder ~= nil and newOrder.OrderType ~= DOTA_UNIT_ORDER_NONE then
			if  self.currentOrder.OrderType ~= newOrder.OrderType or
				self.currentOrder.TargetIndex ~= newOrder.TargetIndex or
				self.currentOrder.AbilityIndex ~= newOrder.AbilityIndex or
				self.currentOrder.Position ~= newOrder.Position then

				--print( "Executing Order " .. tostring(newOrder.OrderType) .. "->" .. tostring(newOrder.TargetIndex).. "->" .. tostring(newOrder.AbilityIndex) .. "->" .. tostring( newOrder.Position ) )
				ExecuteOrderFromTable( newOrder )
				self.currentOrder = newOrder
			end
		end

		return self.thinkDuration
	end

	function BehaviorSystem:ChooseNextBehavior()
		local result = nil
		local bestDesire = nil
		for _,behavior in pairs( self.possibleBehaviors ) do
			local thisDesire = behavior:Evaluate()
			if bestDesire == nil or thisDesire > bestDesire then
				result = behavior
				bestDesire = thisDesire
			end
		end

		return result
	end

	function BehaviorSystem:Deactivate()
		if self.currentBehavior.End then 
			self.currentBehavior:End() 
		end
	end

	function BehaviorSystem:Destroy()
		for _,behavior in pairs( self.possibleBehaviors ) do
			if behavior.Destroy then 
				behavior:Destroy() 
			end
		end

		return result
	end

	return BehaviorSystem
end