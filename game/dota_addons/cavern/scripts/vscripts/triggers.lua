
-- This file is a redirection to events.lua

function OnStartTouch( trigger )
	local triggerName = thisEntity:GetName()
	local activator_entindex = trigger.activator:GetEntityIndex()
	local caller_entindex = trigger.caller:GetEntityIndex()
	local gamemode = GameRules.Cavern
	gamemode:OnTriggerStartTouch( triggerName, activator_entindex, caller_entindex )
end

function OnEndTouch( trigger )
	local triggerName = thisEntity:GetName()
	local activator_entindex = trigger.activator:GetEntityIndex()
	local caller_entindex = trigger.caller:GetEntityIndex()
	local gamemode = GameRules.Cavern
	gamemode:OnTriggerEndTouch( triggerName, activator_entindex, caller_entindex )
end



	


