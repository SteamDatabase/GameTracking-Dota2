
--------------------------------------------------------------------------------

function OnTrigger( trigger )
	local hCreatures = Entities:FindAllByClassnameWithin( "npc_dota_creature", thisEntity:GetAbsOrigin(), 1000 )
	local szBristleDad = "npc_dota_friendly_bristleback"
	local hBristleDad = nil
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature:GetUnitName() == szBristleDad ) then
			hBristleDad = hCreature
		end
	end

	if hBristleDad == nil then
		print( string.format( "desert_expanse_bristleback.lua - ERROR: \"%s\" not found", szBristleDad ) )
		return
	end

	hBristleDad:RemoveModifierByName( "modifier_rooted" )
	hBristleDad:RemoveModifierByName( "modifier_stack_count_animation_controller" )

	local szWaypoint = "desert_expanse_bristleback_dad_path_1"
	local hWaypoint = Entities:FindByName( nil, szWaypoint )
	if hWaypoint == nil then
		print( string.format( "desert_expanse_bristleback.lua - ERROR: Waypoint \"%s\" not found.", szWaypoint ) )
		return
	end

	print( string.format( "Setting initial goal entity \"%s\" for unit \"%s\"", szWaypoint, hBristleDad ) )
	hBristleDad:SetInitialGoalEntity( hWaypoint )

	thisEntity:Destroy()
end

--------------------------------------------------------------------------------

