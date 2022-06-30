
--[[ boulder_trap_trigger.lua ]]
local triggerActiveRad = true
local triggerActiveDire = true

function OnStartTouch(trigger)
	--print( "Boulder TRIGGER" )
	
  	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local index = 0
	local triggerActivated = false
	if triggerName == "radiant_boulder_trap" then
		if triggerActiveRad then
			triggerActiveRad = false
			thisEntity:SetContextThink( "ResetTrapModelRadiant", function() ResetTrapModelRad() end, 15 )
			index = 1
			triggerActivated = true
		end
	elseif triggerName == "dire_boulder_trap" then
		if triggerActiveDire then
			triggerActiveDire = false
			thisEntity:SetContextThink( "ResetTrapModelDire", function() ResetTrapModelDire() end, 15 )
			index = 2
			triggerActivated = true
		end
	end

	print("OnStartTouch event for "..triggerName.." with activator "..trigger.activator:GetName().." on team "..team)
	if index == 0 then return end
	
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnBoulderStartTouch( index, team, heroHandle, triggerActivated )
	
	local button = triggerName .. "_button"
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 15, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 15.5, self, self )
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local index = 0
	if triggerName == "radiant_boulder_trap" then
		index = 1
	elseif triggerName == "dire_boulder_trap" then
		index = 2
	end

	print("OnEndTouch event for "..triggerName.." with activator "..trigger.activator:GetName().." on team "..team)
	if index == 0 then return end

	--print("Trap Button Trigger Exited")
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnBoulderEndTouch( index, team, heroHandle )
end

function ResetTrapModelRad()
	--print( "Radiant Trap RESET" )
	triggerActiveRad = true
end

function ResetTrapModelDire()
	--print( "Dire Trap RESET" )
	triggerActiveDire = true
end
