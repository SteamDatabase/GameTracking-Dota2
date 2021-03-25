--------------------------------------------------------------------------------

function OnStartTouch( trigger )
	local event = {}
	event["trigger_name"] = thisEntity:GetName()
	event["activator_entindex"] = trigger.activator:GetEntityIndex()
	event["caller_entindex"] = trigger.caller:GetEntityIndex()
	FireGameEvent( "trigger_start_touch", event )
end

--------------------------------------------------------------------------------

function OnEndTouch( trigger )
	local event = {}
	event["trigger_name"] = thisEntity:GetName()
	event["activator_entindex"] = nil
	event["caller_entindex"] = nil
	if trigger.activator ~= nil then
		event["activator_entindex"] = trigger.activator:GetEntityIndex()
		event["caller_entindex"] = trigger.caller:GetEntityIndex()
	end
	FireGameEvent( "trigger_end_touch", event )
end

--------------------------------------------------------------------------------



