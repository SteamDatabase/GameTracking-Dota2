local m_cp_name = string.sub(thisEntity:GetName(), 1, 3)

function OnStartTouch(trigger)
	local ateam = trigger.activator:GetTeam()

	--print("Capture Point " .. m_cp_name .. " approached by Team " .. ateam)
	
	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local index = gamemode.cp_index[m_cp_name]
	GameRules:GetGameModeEntity().CConquestGameMode:OnCPStartNear( index, ateam )
end

function OnEndTouch(trigger)
	local ateam = trigger.activator:GetTeam()

	--print("Capture Point " .. m_cp_name .. " left by Team " .. ateam)

	local gamemode = GameRules:GetGameModeEntity().CConquestGameMode
	local index = gamemode.cp_index[m_cp_name]
	GameRules:GetGameModeEntity().CConquestGameMode:OnCPEndNear( index, ateam )
end
