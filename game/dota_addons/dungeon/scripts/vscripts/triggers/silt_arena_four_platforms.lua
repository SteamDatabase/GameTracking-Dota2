
---------------------------------------------------------------------------------

function OnStartTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon

	gamemode.nSiltArenaPlatformActivators = gamemode.nSiltArenaPlatformActivators + 1
	--print( "activators incremented, activators == " .. gamemode.nSiltArenaPlatformActivators )

	-- We only want one of these triggers to make us think
	if ( not gamemode.bSiltArenaPlatformsThinking ) then
		thisEntity:SetContextThink( "SiltArenaPlatformThink", SiltArenaPlatformThink, 0.5 )
		gamemode.bSiltArenaPlatformsThinking = true
	end
end

---------------------------------------------------------------------------------

function OnEndTouch( trigger )
	thisEntity.hActivatorHero = trigger.activator
	local gamemode = GameRules.Dungeon

	gamemode.nSiltArenaPlatformActivators = gamemode.nSiltArenaPlatformActivators - 1
	--print( "Decremented activators, activators == " .. gamemode.nSiltArenaPlatformActivators )

	if gamemode.nSiltArenaPlatformActivators < 0 then
		gamemode.nSiltArenaPlatformActivators = 0
		thisEntity:SetContextThink( "SiltArenaPlatformThink", SiltArenaPlatformThink, -1 )
		gamemode.bSiltArenaPlatformsThinking = false
	end
end

---------------------------------------------------------------------------------

function SiltArenaPlatformThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	--print( "SiltArenaPlatformThink, thisEntity.hActivatorHero is \"" .. thisEntity.hActivatorHero:GetUnitName() .. "\"" )
	local nPlayerHeroesAlive = 0
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() and hHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( hHero:IsAlive() or hHero:IsReincarnating() or hHero.nRespawnsRemaining > 0 )  then
			nPlayerHeroesAlive = nPlayerHeroesAlive + 1
		end
	end

	local gamemode = GameRules.Dungeon
	--print( string.format( "gamemode.nSiltArenaPlatformActivators: %d, nPlayerHeroesAlive: %d", gamemode.nSiltArenaPlatformActivators, nPlayerHeroesAlive ) )
	if gamemode.nSiltArenaPlatformActivators >= nPlayerHeroesAlive then
		OpenExitGate()
		CloseEntryGate()
		--print( "SiltArenaPlatformThink had enough activators to trigger stuff" )

		UTIL_RemoveImmediate( thisEntity )
		return -1
	end

	return 0.5
end

---------------------------------------------------------------------------------

function OpenExitGate()
	local szExitRelayName = "silt_arena_exit_gate_trigger_relay"
	local hExitGateRelay = Entities:FindByName( nil, szExitRelayName )
	if hExitGateRelay == nil then
		print( "ERROR: No trigger relay found" )
		return
	end
	--print( "Triggering relay named " .. szExitRelayName )
	hExitGateRelay:Trigger()

	-- Remove Silt's modifier_boss_inactive
	local hSilt = nil
	local vPos = Vector( 10271, -11657, 384 )
	local hCreatures = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, vPos, nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false )
	for _, hCreature in pairs( hCreatures ) do
		if ( hCreature ~= nil ) and ( hCreature:GetUnitName() == "npc_dota_creature_siltbreaker" ) then
			hSilt = hCreature
			--print( "found silt" )
		end
	end

	if hSilt then
		hSilt:RemoveModifierByName( "modifier_boss_inactive" )
		--print( "removed modifier_boss_inactive from " .. hSilt:GetUnitName() )
	end
end

---------------------------------------------------------------------------------

function CloseEntryGate()
	local szEntryRelayName = "silt_arena_entry_gate_trigger_relay"
	local hEntryGateRelay = Entities:FindByName( nil, szEntryRelayName )
	if hEntryGateRelay == nil then
		print( "ERROR: No trigger relay named " .. szEntryRelayName )
		return
	end
	--print( "Triggering relay named " .. szEntryRelayName )
	hEntryGateRelay:Trigger()
end

---------------------------------------------------------------------------------

