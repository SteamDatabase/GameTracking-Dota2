--[[ Night Stalker AI ]]

function Spawn( entityKeyValues )
end

--[[
function OnEntityKilled( event )
	local killedEntity = EntIndexToHScript( event.entindex_killed )
	if killedEntity then
		print( "killedEntity == " .. killedEntity )
	end

	--CreateUnitByName( "npc_dota_techies_land_mine", thisEntity:GetAbsOrigin(), true, nil, nil, thisEntity:GetTeamNumber() )
end
]]
