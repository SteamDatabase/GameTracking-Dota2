
--[[ triggers/ut_boss_room.lua ]]

---------------------------------------------------------------------------------

function OnStartTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon
	--local team = trigger.activator:GetTeam()
	--local triggerName = thisEntity:GetName()
	--local entindex = trigger.activator:GetEntityIndex()

	gamemode.nTempleExitActivators = gamemode.nTempleExitActivators + 1
	--print( "activators incremented, activators == " .. gamemode.nTempleExitActivators )

	-- We only want one of these triggers to make us think
	if ( not gamemode.bTempleExitThinking ) then
		thisEntity:SetContextThink( "TempleExitThink", TempleExitThink, 0.5 )
		gamemode.bTempleExitThinking = true
	end
end

---------------------------------------------------------------------------------

function OnEndTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon
	--local team = trigger.activator:GetTeam()
	--local triggerName = thisEntity:GetName()
	--local entindex = trigger.activator:GetEntityIndex()

	gamemode.nTempleExitActivators = gamemode.nTempleExitActivators - 1
	--print( "Decremented activators, activators == " .. gamemode.nTempleExitActivators )

	if gamemode.nTempleExitActivators < 0 then
		gamemode.nTempleExitActivators = 0
		thisEntity:SetContextThink( "TempleExitThink", TempleExitThink, -1 )
		gamemode.bTempleExitThinking = false
	end
end

---------------------------------------------------------------------------------

function TempleExitThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--print( "TempleExitThink, thisEntity.hActivatorHero is \"" .. thisEntity.hActivatorHero:GetUnitName() .. "\"" )
	local nPlayerHeroesAlive = 0
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() and hHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( hHero:IsAlive() or hHero:IsReincarnating() or hHero.nRespawnsRemaining > 0 )  then
			nPlayerHeroesAlive = nPlayerHeroesAlive + 1
		end
	end

	local gamemode = GameRules.Dungeon
	--print( string.format( "gamemode.nTempleExitActivators: %d, nPlayerHeroesAlive: %d", gamemode.nTempleExitActivators, nPlayerHeroesAlive ) )
	if gamemode.nTempleExitActivators >= nPlayerHeroesAlive then
		OpenExitGate()
		CloseEntryGate()
		ActivateBossRelay()
		--BroadcastMessage( "Opening exit, closing entry", 3 )
		print( "TempleExitThink had enough activators to trigger stuff" )

		return -1
	end

	return 0.5
end

---------------------------------------------------------------------------------

function OpenExitGate()
	local szExitRelayName = "ut_bossroom_exit_gate_trigger_relay"
	local hExitGateRelay = Entities:FindByName( nil, szExitRelayName )
	if hExitGateRelay == nil then
		print( "ERROR: No trigger relay found" )
		return
	end
	--print( "Triggering relay named " .. szExitRelayName )
	EmitSoundOn( "Door.Open", hExitGateRelay )
	hExitGateRelay:Trigger()
end

---------------------------------------------------------------------------------

function CloseEntryGate()
	local szEntryRelayName = "ut_bossroom_entry_gate_trigger_relay"
	local hEntryGateRelay = Entities:FindByName( nil, szEntryRelayName )
	if hEntryGateRelay == nil then
		print( "ERROR: No trigger relay named " .. szEntryRelayName )
		return
	end
	--print( "Triggering relay named " .. szEntryRelayName )
	EmitSoundOn( "Door.Close", hEntryGateRelay )
	hEntryGateRelay:Trigger()
end

---------------------------------------------------------------------------------

function ActivateBossRelay()
	print( "ActivateBossRelay()" )
	-- For now just do it directly here, the boss relay trigger had some issues
	local gamemode = GameRules.Dungeon
	local Zone = gamemode:GetZoneByName( "underground_temple" )
	if Zone ~= nil then
		print( "Wake the Temple Guardians" )
		EmitSoundOn( "TempleGuardian.Awaken", thisEntity )
		Zone:WakeBosses()
	end

	--[[
	local szBossRelayName = "ut_activate_bosses_relay"
	local hBossRelay = Entities:FindByName( nil, szBossRelayName )
	if hBossRelay == nil then
		print( "ERROR: No trigger relay named " .. szBossRelayName )
		return
	end
	print( "Triggering relay named " .. szBossRelayName )
	hBossRelay:Trigger()
	]]
end

