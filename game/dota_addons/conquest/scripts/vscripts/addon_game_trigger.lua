
-- How long the hero must be in the trigger to lock the capture point

local m_cp_name = thisEntity:GetName()

function OnStartTouch(trigger)
	local ateam = trigger.activator:GetTeam()

	--print("Capture Point " .. m_cp_name .. " Entered by Team " .. ateam)
	
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local index = gamemode.cp_index[m_cp_name]
	GameRules:GetGameModeEntity().CConquestGameMode:OnCPStartTouch( index, ateam )
end

function OnEndTouch(trigger)
	local ateam = trigger.activator:GetTeam()

	--print("Capture Point " .. m_cp_name .. " Exited by Team " .. ateam)

	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local index = gamemode.cp_index[m_cp_name]
	GameRules:GetGameModeEntity().CConquestGameMode:OnCPEndTouch( index, ateam )
end
