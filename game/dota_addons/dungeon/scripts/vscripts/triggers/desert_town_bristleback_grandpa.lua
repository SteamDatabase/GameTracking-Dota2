
--------------------------------------------------------------------------------

function OnTrigger( trigger )
	local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 1000 )
	local szBristleGrandpa = "npc_dota_bristleback_grandpa"
	local hBristleGrandpa = nil
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == szBristleGrandpa ) then
			hBristleGrandpa = hCreature
		end
	end

	if hBristleGrandpa == nil then
		print( string.format( "desert_town_bristleback_grandpa.lua - ERROR: \"%s\" not found", szBristleGrandpa ) )
		return
	end

	local szWaypoint = "desert_town_bristleback_grandpa_path_1"
	local hWaypoint = Entities:FindByName( nil, szWaypoint )
	if hWaypoint == nil then
		print( string.format( "desert_town_bristleback_grandpa.lua - ERROR: Waypoint \"%s\" not found.", szWaypoint ) )
		return
	end

	hBristleGrandpa:RemoveModifierByName( "modifier_stack_count_animation_controller" )

	hBristleGrandpa:SetInitialGoalEntity( hWaypoint )

	--[[
	ExecuteOrderFromTable( {
		UnitIndex = hBristleGrandpa:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = hWaypoint:GetOrigin(),
	} )
	]]

	--hBristleGrandpa:AddNewModifier( hBristleGrandpa, nil, "modifier_followthrough", { duration = 1.0 } )

	thisEntity:Destroy()
end

--------------------------------------------------------------------------------

