require( "event_queue" )

modifier_creature_herding_penguin = class({})

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:IsHidden()
	return true;
end

--function modifier_creature_herding_penguin:RemoveOnDeath()
--	return false
--end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:OnCreated( kv )
	if IsServer() then

		if _G.FIRST_HERDING_PENGUIN_SPAWN_TIME == nil then
			_G.FIRST_HERDING_PENGUIN_SPAWN_TIME = GameRules:GetGameTime()
		end

		local hUnit = self:GetParent()
		hUnit.flAttractionRange = 250
		hUnit.hHerder = nil
		hUnit.hMoveTarget = nil
		hUnit.nPenguinIndex = -1
		hUnit.flLastRandomMovementTime = -1
		hUnit.bPositionSet = false	
		self.EventQueue = CEventQueue()

		self:StartIntervalThink( 0.5 + RandomFloat(-0.1,0.1) )

	end
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
end

function modifier_creature_herding_penguin:DropLoot()
	local hLootTable =  { 50, 50, 50, 55,  65,  75,  80,  85,  90,  95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 175 }
	local hScaleTable = {  1,  1,  1,  1, 1.2, 1.2, 1.3, 1.3, 1.3, 1.3, 1.4, 1.4, 1.5, 1.5, 1.6, 1.6, 1.7, 1.7, 1.8, 1.8, 1.8, 2.2 }
	local flNow = GameRules:GetGameTime()
	local hUnit = self:GetParent()
	if hUnit.flLootDropTime == nil then
		hUnit.flLootDropTime = flNow
		local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		local nTableIndex = math.min(#hLootTable,math.max(0, hUnit.nPenguinIndex))
		local nGoldAmount = hLootTable[ nTableIndex ]
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nGoldAmount*3 )
		
		local drop = CreateItemOnPositionSync( hUnit:GetAbsOrigin(), newItem )
		local flModelScale = hScaleTable[ nTableIndex ]
		drop:SetModelScale(flModelScale)
		newItem:LaunchLoot( true, 50, 0.3, hUnit.hHerder:GetAbsOrigin() )
		
		ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = WINTER_MAP_ENEMY_SAFE_UPPER_LEFT
		})	
		hUnit:StartGesture( ACT_DOTA_SLIDE )
		EmitSoundOn( "HerdingPenguin.DropLoot", hUnit )
	end

		--if hUnit.flLootDropTime and (flNow - hUnit.flLootDropTime) > 10 then
		--	self:Destroy()
		--end
end

function modifier_creature_herding_penguin:OnIntervalThink()
	if IsServer() then
		
		local flNow = GameRules:GetGameTime()
		local hUnit = self:GetParent()

		if not hUnit.bPositionSet then
			local vOriginalPosition = hUnit:GetAbsOrigin()
			local vGoalPosition = WINTER_MAP_CENTER_RUNE + Vector( RandomFloat(-4000, 4000), RandomFloat(-4000, 4000), 0 )	

			hUnit:SetAbsOrigin( vGoalPosition )
			FindClearSpaceForUnit( hUnit, vGoalPosition, true )
			vGoalPosition = hUnit:GetAbsOrigin()

			local vUnits = FindUnitsInRadius( hUnit:GetTeamNumber(), vGoalPosition, nil, 100, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
			if not vUnits or #vUnits < 1 then
				local bClearSpace = true
				local bSearch = 25
				bClearSpace = bClearSpace and GridNav:CanFindPath( vGoalPosition, vGoalPosition + Vector(bSearch,0) )
				bClearSpace = bClearSpace and GridNav:CanFindPath( vGoalPosition, vGoalPosition + Vector(-bSearch,0) )
				bClearSpace = bClearSpace and GridNav:CanFindPath( vGoalPosition, vGoalPosition + Vector(0,bSearch) )
				bClearSpace = bClearSpace and GridNav:CanFindPath( vGoalPosition, vGoalPosition + Vector(0,-bSearch) )

				--if not vUnits or #vUnits < 1 then
				if bClearSpace then
					hUnit.bPositionSet = true	
				end
			end

			if not hUnit.bPositionSet then
				hUnit:SetAbsOrigin(vOriginalPosition)
			end

		end

		if (flNow - _G.FIRST_HERDING_PENGUIN_SPAWN_TIME) > HERDING_PENGUIN_ROUND_DURATION then
			if not hUnit.hHerder then
				hUnit:Destroy()
			end
			return
		end

		local vGoalPosition = nil

		local flTimeSinceDisconnect = hUnit.flDisconnectTime and (flNow - hUnit.flDisconnectTime) or 10000

		--printf("penguin %s time since disconnect %s", hUnit, flTimeSinceDisconnect)

		if flTimeSinceDisconnect > 5 and (not hUnit.hHerder or not hUnit.hMoveTarget) then

			hUnit.hHerder = nil
			hUnit.hMoveTarget = nil

			local vHeroes = FindUnitsInRadius( hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, hUnit.flAttractionRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
			for index, hHero in pairs( vHeroes ) do
				local flTimeSinceLastCrash = hUnit.flLastCrashTime and (flNow - hUnit.flLastCrashTime) or 10000
				if not hUnit.hHerder and flTimeSinceLastCrash > 5 then 
					hUnit.hHerder = hHero
				end
			end

			if hUnit.hHerder then
				
				local hMovementBuff = hUnit.hHerder:FindModifierByName("modifier_penguin_herder_movement")

				if not hMovementBuff then
					hMovementBuff = hUnit.hHerder:AddNewModifier( hUnit.hHerder, nil, "modifier_penguin_herder_movement", {} )
				end

				if not hUnit.hHerder.hTrain then
					hUnit.hHerder.hTrain = {}	
				end

				local hTrain = hUnit.hHerder.hTrain

				if hUnit.nPenguinIndex == -1 then
					table.insert( hTrain, hUnit )
					hUnit.nPenguinIndex = #hTrain
					if hUnit.nPenguinIndex == 1 then
						hUnit.hMoveTarget = hUnit.hHerder
					else
						hUnit.hMoveTarget = hTrain[hUnit.nPenguinIndex-1]
					end

					hUnit.flAttachTime = flNow
					hUnit:StartGesture( ACT_DOTA_SLIDE )
					EmitSoundOn( "HerdingPenguin.Attach", hUnit )

					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					local nGoldAmount = 20
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( nGoldAmount*5 )
					local drop = CreateItemOnPositionSync( hUnit.hHerder:GetAbsOrigin(), newItem )
					newItem:LaunchLoot( true, 0, 0, hUnit.hHerder:GetAbsOrigin() )
	
					--printf("peng index %d, penguin %s, move target %s", hUnit.nPenguinIndex, hUnit, hUnit.hMoveTarget)



					--ExecuteOrderFromTable({
					--UnitIndex = hUnit:entindex(),
					--OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
					--hTargetIndex = hUnit.hMoveTarget:entindex(),
					--})

				end
			end

		end

		if hUnit.hMoveTarget ~= nil then
			if hUnit.hMoveTarget:IsNull() or not hUnit.hMoveTarget:IsAlive() then	
				self:Disconnect()
				return
			else
				hUnit:MoveToNPC( hUnit.hMoveTarget )
			end
		else	
			if (flNow - hUnit.flLastRandomMovementTime) > 3 then
				--local vGoalPosition = WINTER_MAP_CENTER_RUNE + RandomVector(4000)
				--ExecuteOrderFromTable({
				--UnitIndex = hUnit:entindex(),
				--OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				--Position = vGoalPosition
				--})
				--hUnit.flLastRandomMovementTime = flNow
			end
		end
	end
end

function modifier_creature_herding_penguin:InLine()
	local flNow = GameRules:GetGameTime()
	if flRange == nil then
		flRange = 200
	end
	local hUnit = self:GetParent()
	if not hUnit or not hUnit.hMoveTarget then
		return false
	end

	if hUnit.flAttachTime == nil or (flNow - hUnit.flAttachTime) < 2 then
		return false
	end

	local flDist = ( hUnit:GetAbsOrigin() - hUnit.hMoveTarget:GetAbsOrigin() ):Length2D()
	--printf("distance from move target %s", flDist)
	return  flDist < flRange
end

function modifier_creature_herding_penguin:Disconnect()
	local flNow = GameRules:GetGameTime()
	local hUnit = self:GetParent()
	if hUnit then
		--if hUnit.hHerder and hUnit.hHerder.hTrain then
		--	for i = hUnit.nPenguinIndex+1,#hUnit.hHerder.hTrain,1 do
		--		local hPenguin = hUnit.hHerder.hTrain[i]
		--		if hPenguin then
		--			hPenguin.hMoveTarget = nil
		--			hPenguin.hHerder = nil
		--			hPenguin.flLastRandomMovementTime = flNow + RandomFloat(2, 5)
		--		end
		--	end
		--end


		hUnit:StartGesture( ACT_DOTA_DIE )

		EmitSoundOn( "HerdingPenguin.Disconnect", hUnit )

		printf("disconnecting penguin %s", hUnit)

		hUnit.flDisconnectTime = flNow
		hUnit.flAttachTime = nil
		hUnit.hHerder = nil
		hUnit.hMoveTarget = nil
		hUnit.nPenguinIndex = -1
		--hUnit.flLastRandomMovementTime = flNow - RandomFloat(2,4)

		ExecuteOrderFromTable({
		UnitIndex = hUnit:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP
		})

		self.EventQueue:AddEvent( 0.75,
		function(hUnit)
			if not hUnit or hUnit:IsNull() then
				return
			end	
			for ii=1,5,1 do
				local vGoalPosition = hUnit:GetAbsOrigin() + Vector( RandomFloat(100, 600), RandomFloat(100, 600), 0 )
				if GridNav:CanFindPath( hUnit:GetOrigin(), vGoalPosition ) then
					ExecuteOrderFromTable({
					UnitIndex = hUnit:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = vGoalPosition
					})
					break
				end
			end
		end, hUnit )

	end
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:OnTakeDamage( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if hUnit == self:GetParent() then		
			local flDamage = params.damage
			if flDamage <= 0 then
				return
			end
			--self.flAccumDamage = self.flAccumDamage + flDamage
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		local hUnit = self:GetParent()
		if hUnit.hMoveTarget then
			return 1000
		else
			return 400
		end
	end
	return 400
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:CheckState()
	local state = {}
	if IsServer()  then
		state =
		{
			[ MODIFIER_STATE_STUNNED ] = false,
			[ MODIFIER_STATE_ROOTED ] = false,
			[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
			[ MODIFIER_STATE_INVULNERABLE ] = true,
			[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
			[ MODIFIER_STATE_UNSELECTABLE ] = true,
			[ MODIFIER_STATE_UNTARGETABLE ] = true,
			[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true,
		}
	end
	return state
end

--------------------------------------------------------------------------------

function modifier_creature_herding_penguin:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end