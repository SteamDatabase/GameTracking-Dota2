
--[[ pendulum_button_trigger.lua ]]
local triggerActive = true
local isPendulumReady = true
local triggerCounter = 0
local triggerHeroList = {}

function OnStartTouch(trigger)
	print( "pendulum TRIGGER" )
	triggerCounter = triggerCounter + 1
  	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	table.insert( triggerHeroList, heroHandle )
	if not triggerActive then
		print( "pendulum SKIP" )
		return
	end
	triggerActive = false
	thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModel() end, 17 )

	EnablePendulum( triggerName, heroHandle )

	local button = triggerName .. "_button"
	local buttonFx = triggerName .. "_buttonFX"
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 17, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 17.5, self, self )
	--DoEntFire( buttonFx, "Start", "", 0, self, self )
	--DoEntFire( buttonFx, "Stop", "", 2, self, self )
end

function EnablePendulum( triggerName, heroHandle )
	if isPendulumReady == true then
		--print("Enabling Pendulum")
		isPendulumReady = false
		EmitGlobalSound("Conquest.Pendulum.Trigger")
		EmitGlobalSound("tutorial_rockslide")
		EmitGlobalSound("Conquest.Pendulum.Scrape")
		local pendulumTrigger = triggerName .. "_trigger"
		local pendulumModel = triggerName .. "_model"
		DoEntFire( pendulumModel, "SetAnimation", "pendulum_swing", 0, self, self )
		DoEntFire( triggerName .. "_debris", "Start", "", 0, self, self )
		DoEntFire( triggerName .. "_shake", "StartShake", "", 0, self, self )
		DoEntFire( pendulumTrigger, "Enable", "", 4, self, self )
		DoEntFire( pendulumTrigger, "Disable", "", 9, self, self )
		DoEntFire( triggerName .. "_shake", "StopShake", "", 16, self, self )
		DoEntFire( triggerName .. "_debris", "Stop", "", 16, self, self )
		local trapName = triggerName .. "_npc"
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = triggerHeroList[1]
		npc:SetContextThink( "DisableTrap", function() return DisablePendulum( triggerName, heroHandle ) end, 60 )
	end
	return -1
end

function DisablePendulum( triggerName, heroHandle )
	--print( "Disabling Pendulum" )
	isPendulumReady = true
	if triggerCounter > 0 then
		--print("Reactivate the trap")
		local trapName = triggerName .. "_npc"
		local npc = Entities:FindByName( nil, trapName )
		npc.KillerToCredit = triggerHeroList[1]
		npc:SetContextThink( "EnableTrap", function() return EnablePendulum( triggerName ) end, 0 )
		return 0
	end
end

function OnEndTouch(trigger)
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	triggerCounter = triggerCounter - 1
	for i,v in ipairs( triggerHeroList ) do
		if v == heroHandle then
			table.remove( triggerHeroList, i )
		end
	end
	--print("Trap Button Trigger Exited")
end

function ResetTrapModel()
	print( "pendulum RESET" )
	triggerActive = true
end
