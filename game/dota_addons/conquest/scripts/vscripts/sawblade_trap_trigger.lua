
--[[ sawblade_trap_trigger.lua ]]
local triggerActiveRad = true
local triggerActiveDire = true

function OnStartTouch(trigger)
	--print( "Sawblade TRIGGER" )
	
  	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local index = 0
	if triggerName == "radiant_sawblade_trap" then
		if not triggerActiveRad then
			--print( "sawblade SKIP" )
			return
		end
		triggerActiveRad = false
		thisEntity:SetContextThink( "ResetTrapModelRadiant", function() ResetTrapModelRad() end, 15 )
		index = 1
	elseif triggerName == "dire_sawblade_trap" then
		if not triggerActiveDire then
			--print( "sawblade SKIP" )
			return
		end
		triggerActiveDire = false
		thisEntity:SetContextThink( "ResetTrapModelDire", function() ResetTrapModelDire() end, 15 )
		index = 2
	end

	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnSawbladeStartTouch( index, team, heroHandle )
	local button = triggerName .. "_button"
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 15, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 15.5, self, self )
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	if triggerName == "radiant_sawblade_trap" then
		index = 1
	elseif triggerName == "dire_sawblade_trap" then
		index = 2
	end
	--print("Trap Button Trigger Exited")
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnSawbladeEndTouch( index, team, heroHandle )
end

function ResetTrapModelRad()
	--print( "Radiant Trap RESET" )
	triggerActiveRad = true
end

function ResetTrapModelDire()
	--print( "Dire Trap RESET" )
	triggerActiveDire = true
end
