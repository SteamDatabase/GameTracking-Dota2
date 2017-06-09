
function OnStartTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	if hHero and hHero:IsRealHero() then
		--print( string.format( "\"%s\" (player id %d) found the Carl in death_maze.", hHero:GetUnitName(), hHero:GetPlayerID() ) )
		GameRules.Dungeon:OnPlayerFoundInvoker( hHero:GetPlayerID(), 0 )
	end
end

function OnEndTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon
end

