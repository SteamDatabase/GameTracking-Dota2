
--[[ pendulum_button_trigger.lua ]]
local triggerActiveRad = true
local triggerActiveDire = true

function OnStartTouch(trigger)

	print( "pendulum TRIGGER" )

  
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	local index = 0
	local pend_button = ""
	local buttonFx = "button_indicator_pend_dire"
	if triggerName == "trigger_pendulum_radiant" then
		if not triggerActiveRad then
			print( "pendulum SKIP" )
			return
		end
		triggerActiveRad = false
		thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModelRad() end, 17 )
		index = 1
		pend_button = "trigger_pendulum_radiant_button"
		buttonFx = "button_indicator_pend_rad"
	elseif triggerName == "trigger_pendulum_dire" then
		if not triggerActiveDire then
			print( "pendulum SKIP" )
			return
		end
		triggerActiveDire = false
		thisEntity:SetContextThink( "ResetTrapModel", function() ResetTrapModelDire() end, 17 )
		index = 2
		pend_button = "trigger_pendulum_dire_button"
	end
	--print("Trap Button Trigger Entered")
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnPendulumStartTouch( index, team, heroHandle )
	DoEntFire( pend_button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( pend_button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	DoEntFire( pend_button, "SetAnimation", "ancient_trigger001_up", 17, self, self )
	DoEntFire( pend_button, "SetAnimation", "ancient_trigger001_idle", 17.5, self, self )
	DoEntFire( buttonFx, "Start", "", 0, self, self )
	DoEntFire( buttonFx, "Stop", "", 2, self, self )
	
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	if triggerName == "trigger_pendulum_radiant" then
		index = 1
	elseif triggerName == "trigger_pendulum_dire" then
		index = 2
	end
	--print("Trap Button Trigger Exited")
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnPendulumEndTouch( index, team, heroHandle )
end

function ResetTrapModelRad()
	print( "pendulum RESET" )
	triggerActiveRad = true
end

function ResetTrapModelDire()
	print( "pendulum RESET" )
	triggerActiveDire = true
end