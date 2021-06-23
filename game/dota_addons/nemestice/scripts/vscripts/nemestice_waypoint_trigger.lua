
-- Trigger to allow hero to teleport to an exit position

local m_waypoint_name = thisEntity:GetName()

function OnStartTouch(trigger)
	local team = trigger.activator:GetTeam()
	local hero = trigger.activator:GetName()
	local heroIndex = trigger.activator:GetEntityIndex()
	--print("Waypoint " .. m_waypoint_name .. " Entered by Team " .. team)
	--local gamemode = GameRules:GetGameModeEntity().CNemestice
	GameRules:GetGameModeEntity().CNemestice:OnWaypointStartTouch( hero, team, heroIndex )
end
