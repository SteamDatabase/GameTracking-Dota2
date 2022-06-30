
--[[ trap_button_trigger.lua ]]

local triggerActiveRadiant = true
local triggerActiveDire = true

function OnStartTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	local level = trigger.activator:GetLevel()
	--print("Trap Button Trigger Entered")
	local index = 0
	local button = ""
	if triggerName == "trigger_fire_trap_cp1" then
		index = 1
		button = "npc_dota_fire_trap_cp1_button"
	elseif triggerName == "trigger_fire_trap_cp2" then
		index = 2
		button = "npc_dota_fire_trap_cp2_button"
	elseif triggerName == "trigger_fire_trap_cp3_radiant" then
		index = 3
		button = "npc_dota_fire_trap_cp3_radiant_button"
	elseif triggerName == "trigger_fire_trap_cp3_dire" then
		index = 4
		button = "npc_dota_fire_trap_cp3_dire_button"
	elseif triggerName == "trigger_fire_trap_cp4" then
		index = 5
		button = "npc_dota_fire_trap_cp4_button"
	elseif triggerName == "trigger_fire_trap_cp5" then
		index = 6
		button = "npc_dota_fire_trap_cp5_button"
	elseif triggerName == "trigger_venom_trap_radiant" then
		index = 7
		button = "npc_dota_venom_trap_radiant_button"
	elseif triggerName == "trigger_venom_trap_dire" then
		index = 8
		button = "npc_dota_venom_trap_dire_button"
	end

	print("OnStartTouch event for "..triggerName.." with activator "..trigger.activator:GetName().." on team "..team)
	if index == 0 then return end

	local triggerActivated = false
	if index < 4 then
		if triggerActiveRadiant then
			triggerActiveRadiant = false
			thisEntity:SetContextThink( "ResetButtonModel", function() ResetButtonModelRadiant() end, 2 )
			triggerActivated = true
		end
	elseif index > 3 and index < 7 then
		if triggerActiveDire then
			triggerActiveDire = false
			thisEntity:SetContextThink( "ResetButtonModel", function() ResetButtonModelDire() end, 2 )
			triggerActivated = true
		end
	elseif index == 7 then
		if triggerActiveRadiant then
			triggerActiveRadiant = false
			thisEntity:SetContextThink( "ResetButtonModel", function() ResetButtonModelRadiant() end, 4 )
			triggerActivated = true
		end
	elseif index == 8 then
		if triggerActiveDire then
			triggerActiveDire = false
			thisEntity:SetContextThink( "ResetButtonModel", function() ResetButtonModelDire() end, 4 )
			triggerActivated = true
		end
	end
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	if index < 7 then
		DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 2, self, self )
		DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 2.5, self, self )
	elseif index > 6 then
		DoEntFire( button, "SetAnimation", "ancient_trigger001_up", 4, self, self )
		DoEntFire( button, "SetAnimation", "ancient_trigger001_idle", 4.5, self, self )
	end
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnTrapStartTouch( index, team, level, heroHandle, triggerActivated )
end

function OnEndTouch(trigger)
	local triggerName = thisEntity:GetName()
	local team = trigger.activator:GetTeam()
	--print("Trap Button Trigger Exited")
	local index = 0
	if triggerName == "trigger_fire_trap_cp1" then
		index = 1
	elseif triggerName == "trigger_fire_trap_cp2" then
		index = 2
	elseif triggerName == "trigger_fire_trap_cp3_radiant" then
		index = 3
	elseif triggerName == "trigger_fire_trap_cp3_dire" then
		index = 4
	elseif triggerName == "trigger_fire_trap_cp4" then
		index = 5
	elseif triggerName == "trigger_fire_trap_cp5" then
		index = 6
	elseif triggerName == "trigger_venom_trap_radiant" then
		index = 7
	elseif triggerName == "trigger_venom_trap_dire" then
		index = 8
	end

	print("OnEndTouch event for "..triggerName.." with activator "..trigger.activator:GetName().." on team "..team)
	if index == 0 then return end
	local heroIndex = trigger.activator:GetEntityIndex()
	local heroHandle = EntIndexToHScript(heroIndex)
	GameRules:GetGameModeEntity().CConquestGameMode:OnTrapEndTouch( index, team, heroHandle )
end

function ResetButtonModelRadiant()
	print( "Trap RESET" )
	triggerActiveRadiant = true
end

function ResetButtonModelDire()
	print( "Trap RESET" )
	triggerActiveDire = true
end
