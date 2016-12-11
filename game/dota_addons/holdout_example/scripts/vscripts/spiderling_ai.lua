--[[
Spiderling Spawn Logic
]]

function Spawn( entityKeyValues )
	-- Find the closest waypoint, use it as a goal entity if we can
	local waypoint = Entities:FindByNameNearest( "path_invader*", thisEntity:GetOrigin(), 0 )
	if waypoint then
		thisEntity:SetInitialGoalEntity( waypoint )
		thisEntity:MoveToPositionAggressive( waypoint:GetOrigin() )
	else
		local ancient =  Entities:FindByName( nil, "dota_goodguys_fort" )
		thisEntity:MoveToPositionAggressive( ancient:GetOrigin() )
	end
end
