
--[[ triggers/desert_fortress_boss_room.lua ]]

---------------------------------------------------------------------------------

function OnStartTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon

	gamemode.nFortressExitActivators = gamemode.nFortressExitActivators + 1
	--print( "activators incremented, activators == " .. gamemode.nFortressExitActivators )

	-- We only want one of these triggers to make us think
	if ( not gamemode.bFortressExitThinking ) then
		thisEntity:SetContextThink( "FortressExitThink", FortressExitThink, 0.5 )
		gamemode.bFortressExitThinking = true
	end
end

---------------------------------------------------------------------------------

function OnEndTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon

	gamemode.nFortressExitActivators = gamemode.nFortressExitActivators - 1
	--print( "Decremented activators, activators == " .. gamemode.nFortressExitActivators )

	if gamemode.nFortressExitActivators < 0 then
		gamemode.nFortressExitActivators = 0
		thisEntity:SetContextThink( "FortressExitThink", FortressExitThink, -1 )
		gamemode.bFortressExitThinking = false
	end
end

---------------------------------------------------------------------------------

function FortressExitThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--print( "FortressExitThink, thisEntity.hActivatorHero is \"" .. thisEntity.hActivatorHero:GetUnitName() .. "\"" )
	local nPlayerHeroesAlive = 0
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() and hHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( hHero:IsAlive() or hHero:IsReincarnating() or hHero.nRespawnsRemaining > 0 )  then
			nPlayerHeroesAlive = nPlayerHeroesAlive + 1
		end
	end

	local gamemode = GameRules.Dungeon
	--print( string.format( "gamemode.nFortressExitActivators: %d, nPlayerHeroesAlive: %d", gamemode.nFortressExitActivators, nPlayerHeroesAlive ) )
	if gamemode.nFortressExitActivators >= nPlayerHeroesAlive then
		OpenExitGate()
		CloseEntryGate()
		--BroadcastMessage( "Opening exit, closing entry", 3 )
		print( "FortressExitThink had enough activators to trigger stuff" )

		return -1
	end

	return 0.5
end

---------------------------------------------------------------------------------

function OpenExitGate()
	local szExitRelayName = "df_bossroom_exit_gate_trigger_relay"
	local hExitGateRelay = Entities:FindByName( nil, szExitRelayName )
	if hExitGateRelay == nil then
		print( "ERROR: No trigger relay found" )
		return
	end
	--print( "Triggering relay named " .. szExitRelayName )
	EmitSoundOn( "Dungeon.StoneGate", hExitGateRelay )
	hExitGateRelay:Trigger()
end

---------------------------------------------------------------------------------

function CloseEntryGate()
	local szEntryRelayName = "df_bossroom_entry_gate_trigger_relay"
	local hEntryGateRelay = Entities:FindByName( nil, szEntryRelayName )
	if hEntryGateRelay == nil then
		print( "ERROR: No trigger relay named " .. szEntryRelayName )
		return
	end
	--print( "Triggering relay named " .. szEntryRelayName )
	EmitSoundOn( "Dungeon.StoneGate", hEntryGateRelay )
	hEntryGateRelay:Trigger()
end

---------------------------------------------------------------------------------

