--[[ Monkey King AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hBoundlessStrike = thisEntity:FindAbilityByName( "monkey_king_boundless_strike" )
	thisEntity.hTreeDance = thisEntity:FindAbilityByName( "monkey_king_tree_dance" )
	thisEntity.hPrimalSpring = thisEntity:FindAbilityByName( "monkey_king_primal_spring" )
	thisEntity.hWukongsCommand = thisEntity:FindAbilityByName( "monkey_king_wukongs_command" )

	thisEntity.fSearchRadius = thisEntity:GetAcquisitionRange()
	thisEntity.bIsOnTree = false
	thisEntity.flWukongsDelayTime = GameRules:GetGameTime() + RandomFloat( 10, 16 )	-- need to live for this long before we can think about casting wukongs command
	thisEntity.flTreeDanceTime = 0
	thisEntity.bInitialized = false

	thisEntity:SetContextThink( "MonkeyKingThink", MonkeyKingThink, 1 )
end

--------------------------------------------------------------------------------

function MonkeyKingThink()
	--print( "Thinking" )
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.bInitialized == false then
		if thisEntity.hTreeDance ~= nil and thisEntity.hTreeDance:IsFullyCastable() then
			thisEntity.bInitialized = true
			return CastTreeDance()
		end
	end

	if thisEntity.hBoundlessStrike ~= nil and ( thisEntity.hBoundlessStrike:IsChanneling() or thisEntity:FindModifierByName( "modifier_aghslab_monkey_king_boundless_strike_cast" ) ) then
		return 1
	end

	if thisEntity.hPrimalSpring ~= nil and ( thisEntity.hPrimalSpring:IsChanneling() or thisEntity:FindModifierByName( "modifier_aghslab_monkey_king_primal_spring_cast" ) ) then
		return 1
	end

	if thisEntity.hTreeDance ~= nil and thisEntity.hTreeDance:IsChanneling() then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hBoundlessStrike ~= nil and thisEntity.hBoundlessStrike:IsFullyCastable() then
		return CastBoundlessStrike( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	-- Monkey King jumps into a tree if he is low health and jumps down if he is already in a tree
	if thisEntity.bIsOnTree == false then
		if ( thisEntity:GetHealthPercent() < 50 ) then
			if thisEntity.hTreeDance ~= nil and thisEntity.hTreeDance:IsFullyCastable() then
				return CastTreeDance()
			end
		end
	else
		if ( thisEntity.flTreeDanceTime + 3 ) < GameRules:GetGameTime() then
			if thisEntity.hPrimalSpring ~= nil and thisEntity.hPrimalSpring:IsFullyCastable() then
				return CastPrimalSpring( hEnemies[ RandomInt( 1, #hEnemies ) ] )
			end
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastBoundlessStrike( enemy )
	if enemy == nil then
		return
	end
	--print( "Casting Boundless Strike" )
	local kv =
		{
			vLocX = enemy:GetAbsOrigin().x,
			vLocY = enemy:GetAbsOrigin().y,
			vLocZ = enemy:GetAbsOrigin().z,
			duration = 1,
		}

	thisEntity:AddNewModifier( thisEntity, thisEntity.hBoundlessStrike, "modifier_aghslab_monkey_king_boundless_strike_cast", kv )

	return 1
end

--------------------------------------------------------------------------------

function CastTreeDance()
	local hTrees = GridNav:GetAllTreesAroundPoint( thisEntity:GetOrigin(), thisEntity.fSearchRadius, true )
	local hTree = nil
	if #hTrees > 0 then
		--print( "Found Trees" )
		hTree = hTrees[RandomInt( 1, #hTrees )]
		--print( "Casting Tree Dance" )
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
			AbilityIndex = thisEntity.hTreeDance:entindex(),
			TargetIndex = GetTreeIdForEntityIndex( hTree:entindex() ),
			Queue = false,
		})

		if thisEntity:HasModifier( "modifier_monkey_king_bounce" ) then
			--print( "Monkey King has Tree Dance modifier" )
			thisEntity.bIsOnTree = true
			thisEntity.flTreeDanceTime = GameRules:GetGameTime()
		end
	end

	return 1
end

--------------------------------------------------------------------------------

function CastPrimalSpring( enemy )
	if enemy == nil then
		return
	end
	--print( "Casting Primal Spring" )
	local kv =
		{
			vLocX = enemy:GetAbsOrigin().x,
			vLocY = enemy:GetAbsOrigin().y,
			vLocZ = enemy:GetAbsOrigin().z,
			duration = 1,
		}

	thisEntity:AddNewModifier( thisEntity, thisEntity.hPrimalSpring, "modifier_aghslab_monkey_king_primal_spring_cast", kv )
	--[[
	if thisEntity:HasModifier( "modifier_monkey_king_bounce_leap" ) == false then
		--print( "Monkey King does not have Tree Dance modifier" )
		thisEntity.bIsOnTree = false
	end
	]]
	thisEntity.bIsOnTree = false

	return 1
end

--------------------------------------------------------------------------------

function CastWukongsCommand( enemy )
	if enemy == nil then
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hWukongsCommand:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

