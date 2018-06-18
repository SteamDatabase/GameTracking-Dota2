
-- This file is a redirection to events.lua

function OnStartTouch( trigger )
	local triggerName = thisEntity:GetName()
	if trigger.activator ~= nil and trigger.caller ~= nil then
		local activator_entindex = trigger.activator:GetEntityIndex()
		local caller_entindex = trigger.caller:GetEntityIndex()
		local gamemode = GameRules.Cavern
		gamemode:OnTriggerStartTouch( triggerName, activator_entindex, caller_entindex )
	else
		printf("ERROR: OnStartTouch: trigger \"%s\" has a nil activator or caller", triggerName)
	end
end

function OnEndTouch( trigger )
	local triggerName = thisEntity:GetName()
	if trigger.activator ~= nil and trigger.caller ~= nil then
		local activator_entindex = trigger.activator:GetEntityIndex()
		local caller_entindex = trigger.caller:GetEntityIndex()
		local gamemode = GameRules.Cavern
		gamemode:OnTriggerEndTouch( triggerName, activator_entindex, caller_entindex )
	else
		printf("ERROR: OnEndTouch: trigger \"%s\" has a nil activator or caller", triggerName)
	end
end
