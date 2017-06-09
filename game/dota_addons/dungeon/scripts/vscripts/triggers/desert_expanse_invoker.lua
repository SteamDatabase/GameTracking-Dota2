
function OnStartTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon

	if hHero and hHero:IsRealHero() then
		--print( string.format( "\"%s\" (player id %d) found the Carl in desert_expanse.", hHero:GetUnitName(), hHero:GetPlayerID() ) )
		GameRules.Dungeon:OnPlayerFoundInvoker( hHero:GetPlayerID(), 1 )
	end
end

function OnEndTouch( trigger )
	local hHero = trigger.activator
	local team = trigger.activator:GetTeam()
	local szTriggerName = thisEntity:GetName()
	local entindex = trigger.activator:GetEntityIndex()
	local gamemode = GameRules.Dungeon
end

