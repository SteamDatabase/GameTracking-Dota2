--[[-------------------------------------------------------------------------
	Setup the focus on ancient think on spawn
-----------------------------------------------------------------------------]]
function Spawn( entityKeyValues )
	s_AbilityBloodlust = thisEntity:FindAbilityByName( OGRE_MAGI_BLOODLUST )
	s_EntityAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	thisEntity:SetContextThink( "BloodLustThink", BloodLustThink, 0.25 )
end

OGRE_MAGI_BLOODLUST = "custom_ogre_magi_bloodlust"

local s_InnerSensingRadius = 600.0
local s_OuterSensingRadius = 1500.0

local s_LastOrder = { OrderType = nil, UnitIndex = nil, TargetIndex = nil, AbilityIndex = nil, Position = nil, Queue = true }
local s_LastTarget = nil

--[[-------------------------------------------------------------------------
	List Filter Function
-----------------------------------------------------------------------------]]
function ListFilterWithFn( t, fn )

	if not t then
		return {}
	end

	local result = {}

    for i = 1, #t do
    	if fn( t[i] ) then
        	table.insert( result, t[i] )
        end
    end

    return result
end

--[[-------------------------------------------------------------------------
 	Create and update (execute if necessary) the order
-----------------------------------------------------------------------------]]
function CreateOrder( order, target, ability, position, queue )

	-- Locally cache the target, ability, and unit indices
	local targetIndex = nil
	if target then
		targetIndex = target:entindex()
	end

	local abilityIndex = nil
	if ability then
		abilityIndex = ability:entindex()
	end

	local unitIndex = thisEntity:entindex()

	-- Save the last order
	local newOrder = {
		UnitIndex = unitIndex,
		OrderType = order,
		TargetIndex = targetIndex,
		AbilityIndex = abilityIndex,
		Position = position,
		Queue = queue
	}

	-- Are we executing this order already?
	local isDifferent = false
	for k, v in pairs( newOrder ) do
		if v ~= s_LastOrder[k] then
			isDifferent = true
			break
		end
	end

	if not isDifferent then
		return
	end

	-- Save the last order
	s_LastOrder = newOrder

	-- Execute order
	ExecuteOrderFromTable( s_LastOrder )

	-- Save the last target
	s_LastTarget = target
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function ExistsInList( list, entity )
    for i = 1, #list do
    	if list[i] == entity then
    		return true
    	end
    end

    return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleExistingTarget( creatureList )

	-- No target
	if not s_LastTarget then
		return false
	end

	-- Were we moving toward a target?
	if s_LastOrder.orderType == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		-- Find the target and if it still exists
		local inList = ExistsInList( creatureList, s_LastTarget )
		if inList then
    		-- Is the target in casting radius now, if not keep moving (no change in order)
    		if ( thisEntity:GetOrigin() - s_LastTarget:GetOrigin() ):Length() <= s_InnerSensingRadius then
    			CreateOrder( DOTA_UNIT_ORDER_CAST_TARGET, s_LastTarget, s_AbilityBloodlust, nil, nil )
    		end

    		return true;
		end
    end

    -- Re-evaluate all other options at this point
    return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleTankInnerSensingRadius( tankList )

	-- Generate list of tanks that are close to the caster
	local tankListInner = ListFilterWithFn ( tankList, 
											 function(e) 
											    return ( thisEntity:GetOrigin() - e:GetOrigin() ):Length() <= s_InnerSensingRadius 
										     end )

	for i = 1, #tankListInner do
		local tank = tankListInner[i]

		-- Does this tank have bloodlust already?
		if not tank:HasModifier( "modifier_ogre_magi_bloodlust" ) then
			-- Can I cast bloodlust
			if s_AbilityBloodlust:IsFullyCastable() then
				CreateOrder( DOTA_UNIT_ORDER_CAST_TARGET, tank, s_AbilityBloodlust, nil, nil )
				return true
			else
				CreateOrder( DOTA_UNIT_ORDER_HOLD_POSITION, nil, nil, nil, nil )
				return true
			end
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleTankOuterSensingRadius( tankList )

	-- Generate list of tanks in the outer sensing radius
	local tankListOuter = ListFilterWithFn ( tankList, 
											 function(e) 
											 	local distance = ( thisEntity:GetOrigin() - e:GetOrigin() ):Length()
											 	if distance > s_InnerSensingRadius and distance <= s_OuterSensingRadius then
											 	    return true
											 	 else
											 	    return false
											 	 end
										     end )

	for i = 1, #tankListOuter do
		local tank = tankListOuter[i]

		-- Does this tank have bloodlust already?
		if not tank:HasModifier( "modifier_ogre_magi_bloodlust" ) then
			CreateOrder( DOTA_UNIT_ORDER_MOVE_TO_TARGET, tank, nil, nil, false )
			return true
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleMeleeInnerSensingRadius( meleeList )

	-- Generate list of tanks that are close to the caster
	local meleeListInner = ListFilterWithFn ( meleeList, 
											 function(e) 
											    return ( thisEntity:GetOrigin() - e:GetOrigin() ):Length() <= s_InnerSensingRadius 
										     end )
	for i = 1, #meleeListInner do
		local melee = meleeListInner[i]

		-- Does this tank have bloodlust already? And can I cast it
		if not tank:HasModifier( "modifier_ogre_magi_bloodlust" ) and s_AbilityBloodlust:IsFullyCastable() then
			CreateOrder( DOTA_UNIT_ORDER_CAST_TARGET, melee, s_AbilityBloodlust, nil, nil )
			return true
		end
	end

	return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleTankFarAway( tankList )

	local tankListFar = ListFilterWithFn ( tankList, 
											 function(e) 
											    return ( thisEntity:GetOrigin() - e:GetOrigin() ):Length() > s_OuterSensingRadius 
										     end )

	-- Attack/move toward a far away tank
	for i = 1, #tankListFar do
		local tank = tankListFar[i]
		thisEntity:SetInitialGoalEntity( tank )
		CreateOrder( DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, tank:GetOrigin(), nil )
		return true
	end

	return false
end

--[[-------------------------------------------------------------------------
-----------------------------------------------------------------------------]]
function HandleMeleeOuterSensingRadius( meleeList )

	-- Generate list of tanks that are close to the caster
	local meleeListOuter = ListFilterWithFn( meleeList, 
											 function(e) 
											 	local distance = ( thisEntity:GetOrigin() - e:GetOrigin() ):Length()
											 	if distance > s_InnerSensingRadius and distance <= s_OuterSensingRadius then
											 	    return true
											 	 else
											 	    return false
											 	 end
										     end )

	for i = 1, #meleeListOuter do
		local melee = meleeListOuter[i]
		thisEntity:SetInitialGoalEntity( melee )
		CreateOrder( DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, melee:GetOrigin(), nil )
		return true
	end

	return false
end

--[[-------------------------------------------------------------------------
	Focus on ancient
-----------------------------------------------------------------------------]]
function BloodLustThink()

	print( "BloodlustThink" )

	-- Find a good target to bloodlust
	local creatureList =  FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, 0, 0, false )

	-- Do we have an existing target
	if HandleExistingTarget( creatureList ) then
		return 3.0
	end

	-- Tank List
	local tankList = ListFilterWithFn( creatureList, function(e) return e:GetUnitName() == "npc_dota_creature_ogre_tank" end )

	-- Can I cast on a tank?
	if HandleTankInnerSensingRadius( tankList ) then
		return 3.0
	end

	-- Can I move toward a close tank to cast on?
	if HandleTankOuterSensingRadius( tankList ) then
		return 3.0
	end

	-- Melee List
	local meleeList = ListFilterWithFn( creatureArray, function(e) return e:GetUnitName() == "npc_dota_creature_ogre_tank" end )

	-- Can I cast on a melee?
	if HandleMeleeInnerSensingRadius( meleeList ) then
		return 3.0
	end

	-- Can I attack/move toward a tank?
	if HandleTankFarAway( tankList ) then
		return 3.0
	end

	-- Can I attack/move toward a melee?
	if HandleMeleeOuterSensingRadius( meleeList ) then
		return 3.0
	end

	-- Cast on myelf or move toward ancient
	if s_AbilityBloodlust:IsFullyCastable() then
		CreateOrder( DOTA_UNIT_ORDER_CAST_TARGET, thisEntity, s_AbilityBloodlust, nil, nil )
	else
		thisEntity:SetInitialGoalEntity( s_EntityAncient )
		CreateOrder( DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, s_EntityAncient:GetOrigin(), nil )
	end

	return 3.0
end