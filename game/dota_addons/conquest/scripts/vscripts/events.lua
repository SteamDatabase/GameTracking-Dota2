--[[ events.lua ]]

---------------------------------------------------------------------------
-- Event: Game state change handler
---------------------------------------------------------------------------
function CConquestGameMode:OnGameRulesStateChange()
	--print( "CConquestGameMode:OnGameRulesStateChange" )
	local nNewState = GameRules:State_Get()
	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		local gamemode = GameRules:GetGameModeEntity()
		gamemode:SetContextThink( "AnnouncerConquest", function() return CConquestGameMode:AnnouncerConquest() end, 7.5 )
		gamemode:SetContextThink( "AnnouncerBegin", function() return CConquestGameMode:AnnouncerBegin() end, 9.25 )
		-- Setting up particles
		--print("setting up particles for default owners")
		CConquestGameMode:ParticleUpdate( 1, DOTA_TEAM_GOODGUYS )
		CConquestGameMode:ParticleUpdate( 2, DOTA_TEAM_GOODGUYS )
		CConquestGameMode:ParticleUpdate( 4, DOTA_TEAM_BADGUYS )
		CConquestGameMode:ParticleUpdate( 5, DOTA_TEAM_BADGUYS )
	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		if self.m_bFillWithBots == true then
			GameRules:BotPopulate()
		end
		-- random for all players that haven't chosen yet
		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end	
		end
		-- disable announcer now that starting stuff is done
		GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		_G.game_in_progress = true
		if GetMapName() == "jungle_colosseum" then
			CConquestGameMode:SpawnDigSites()
		else
			CConquestGameMode:EnableWaypoint( DOTA_TEAM_GOODGUYS )
			CConquestGameMode:EnableWaypoint( DOTA_TEAM_BADGUYS )
		end
		if GetMapName() == "haunted_colosseum" then
			EmitGlobalSound("Conquest.Stinger.GameBegin")
		else
			EmitGlobalSound("Conquest.Stinger.GameBegin.Generic")
		end
		GameRules:SetTimeOfDay( 0.50 )

		-- Disable glyph
		GameRules:SetGlyphCooldown( DOTA_TEAM_GOODGUYS, 18000 )
		GameRules:SetGlyphCooldown( DOTA_TEAM_BADGUYS, 18000 )
	end
end

---------------------------------------------------------------------------
-- Event: NPC Spawned
---------------------------------------------------------------------------
function CConquestGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	--print( "CConquestGameMode:OnNPCSpawned" )
	if spawnedUnit:IsRealHero() then
		--Hero has spawned
		--[[]]
		if spawnedUnit:FindAbilityByName( "channel_ability_building" ) == nil then
			print( "added dig site channel ability" )
			local hDigSiteChannel = spawnedUnit:AddAbility( "channel_ability_building" )
			if hDigSiteChannel then
				hDigSiteChannel:UpgradeAbility( true )
				hDigSiteChannel:SetHidden( true )
			end
		end
		--]]
	end
end

---------------------------------------------------------------------------
-- Event: Entity killed
---------------------------------------------------------------------------
function CConquestGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then return end
	--print(killedUnit:GetClassname())
	-- Check to see if it's a hero
	if killedUnit:IsRealHero() then
		local attacker = EntIndexToHScript( event.entindex_attacker )
		-- Add 20 seconds for Necro ultimate
		local extraTime = 0
		if event.entindex_inflictor ~= nil then
			local inflictor_index = event.entindex_inflictor
			if inflictor_index ~= nil then
				local ability = EntIndexToHScript( event.entindex_inflictor )
				if ability ~= nil then
					if ability:GetAbilityName() ~= nil then
						if ability:GetAbilityName() == "necrolyte_reapers_scythe" then
							print("Killed by Necro Ult")
							extraTime = 20
						end
					end
				end
			end
		end
		--CConquestGameMode:CheckForLootItemDrop( killedUnit )
		--[[
		-- Add more time if the team is leading
		local team = killedUnit:GetTeam()
		local teamTime = 5

		-- Change respawn time based on points
		local difference = 0
		if team == 2 and radiantTotal > direTotal then
			difference = radiantTotal - direTotal
		elseif team == 3 and direTotal > radiantTotal then
			difference = direTotal - radiantTotal
		end
		if difference > 500 and difference <= 2000 then
			teamTime = 15
		elseif difference > 2000 and difference <= 4000 then
			teamTime = 25
		elseif difference > 4000 then
			teamTime = 35
		end

		-- Change the respawn time based on the hero's level
		local baseTime = 0
		local level = killedUnit:GetLevel()
		if level > 9 and level < 20 then
			baseTime = 10
		elseif level >= 20 then
			baseTime = 20
		end

		local respawnTime = killedUnit:GetRespawnTime()
		--]]
		local teamTime = 0
		local baseTime = 5
		if killedUnit:GetLevel() < 20 then
			baseTime = baseTime + killedUnit:GetLevel()
		else
			baseTime = baseTime + 25
		end

		-- Change the respawn time depending on if the team is leading or trailing
		if killedUnit:IsReincarnating() == true then
			print("Set Time for Wraith King respawn disabled")
			return nil
		else
			if respawnWaveTime < 5 then
				killedUnit:SetTimeUntilRespawn( math.floor(10 - respawnWaveTime) + teamTime + extraTime + baseTime )
			else
				killedUnit:SetTimeUntilRespawn( math.floor(10 + (10 - respawnWaveTime)) + teamTime + extraTime + baseTime )
			end
		end
	elseif killedUnit:GetClassname() == "npc_dota_creep_neutral" then
		--print("Golem has been killed")
		CConquestGameMode:CheckForLootItemDrop( killedUnit )
	end
end

---------------------------------------------------------------------------
-- Event: Item picked up
---------------------------------------------------------------------------
function CConquestGameMode:OnItemPickUp( event )
	if event.ItemEntityIndex == nil or event.HeroEntityIndex == nil then
		return
	end

	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )

	if item == nil or item:IsNull() or owner == nil or owner:IsNull() then
		return
	end

	local playerID = owner:GetPlayerID()
	item:SetPurchaser( owner )
	--print("Item has been picked up")
	if event.itemname == "item_bag_of_gold" then
		r = 100
		StartSoundEvent( "General.Coins", owner )
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_fountain_potion" then
		local health = owner:GetHealth()
		local maxHealth = owner:GetMaxHealth()
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_mango_juice" then
		local m = owner:GetMaxMana()
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_health_treat" then
		local health = owner:GetHealth()
		local maxHealth = owner:GetMaxHealth()
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_mana_treat" then
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_halloween_candy" then
		r = 300
		StartSoundEvent( "General.Coins", owner )
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

---------------------------------------------------------------------------
-- Event: Waypoint entered
---------------------------------------------------------------------------
function CConquestGameMode:OnWaypointStartTouch( hero, team, heroIndex )
	local teleportUnit = EntIndexToHScript( heroIndex )
	if teleportUnit:IsRealHero() ~= true then
		return
	end
	if _G.game_in_progress == true then
		--print(hero .. " is using the waypoint" )
		local heroHandle = EntIndexToHScript(heroIndex)
		local player = heroHandle:GetPlayerID()
		
		heroHandle:Stop()
		--DoEntFire( "death_".. m_team_name[team] .."_teleport", "TeleportEntity", hero, 0, self, self )
		local exit = Entities:FindByName( nil, "teleport_particle_exit_radiant" )
		if team == DOTA_TEAM_BADGUYS then
			exit = Entities:FindByName( nil, "teleport_particle_exit_dire" )
		end
		local exitPosition = exit:GetAbsOrigin()
		-- Teleport the hero
		FindClearSpaceForUnit( heroHandle, exitPosition, true );

		local tpEffects = ParticleManager:CreateParticle( "particles/waypoint/waypoint_ground_flash_holo.vpcf", PATTACH_ABSORIGIN, heroHandle )
		ParticleManager:SetParticleControlEnt( tpEffects, PATTACH_ABSORIGIN, heroHandle, PATTACH_ABSORIGIN, "attach_origin", heroHandle:GetAbsOrigin(), true )
		heroHandle:Attribute_SetIntValue( "effectsID", tpEffects )

		DoEntFire( "teleport_particle_".. m_team_name[team], "Start", "", 0, self, self )
		PlayerResource:SetCameraTarget( player, heroHandle )
		StartSoundEvent( "Portal.Hero_Appear", heroHandle )
		heroHandle:SetContextThink( "KillSetCameraTarget", function() return PlayerResource:SetCameraTarget( player, nil ) end, 0.2 )
		heroHandle:SetContextThink( "KillTPEffects", function() return ParticleManager:DestroyParticle( tpEffects, true ) end, 3 )
	end
end

---------------------------------------------------------------------------
-- Event: Point Captured
---------------------------------------------------------------------------
function CConquestGameMode:OnPointCaptured( point, newTeam, oldTeam )
	local szMessage = nil 
	local nNumberOfPoints = 0

	if newTeam == DOTA_TEAM_GOODGUYS then
		nNumberOfPoints = m_points_owned[DOTA_TEAM_GOODGUYS]
		CConquestGameMode:BroadcastControlPointsOwned( newTeam, nNumberOfPoints )
		szMessage = "#DOTA_HUD_Radiant_CaptureZone"
		if nNumberOfPoints == 3 then 
			szMessage = "#DOTA_HUD_Radiant_CaptureZone_NowScoring"
		end
	elseif newTeam == DOTA_TEAM_BADGUYS then
		nNumberOfPoints = m_points_owned[DOTA_TEAM_BADGUYS]
		CConquestGameMode:BroadcastControlPointsOwned( newTeam, nNumberOfPoints )
		szMessage = "#DOTA_HUD_Dire_CaptureZone"
		if nNumberOfPoints == 3 then 
			szMessage = "#DOTA_HUD_Dire_CaptureZone_NowScoring"
		end
	end

	if szMessage ~= nil then 
		local gameEvent = {}
		gameEvent["teamnumber"] = -1
		gameEvent["int_value"] = point
		gameEvent["message"] = szMessage
		FireGameEvent( "dota_combat_event_message", gameEvent )

		local cp_particle_name = "cp"..point.."_particle_neutral"
		local cpParticleEnt = Entities:FindByName( nil, cp_particle_name )
		if cpParticleEnt ~= nil then 
			--print( "found" )
			local hGoodGuysHero = PlayerResource:GetSelectedHeroEntity( 0 )
			local hBadGuysHero = PlayerResource:GetSelectedHeroEntity( 5 )
			MinimapEvent( DOTA_TEAM_GOODGUYS, hGoodGuysHero, cpParticleEnt:GetAbsOrigin().x, cpParticleEnt:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3.0 )
			MinimapEvent( DOTA_TEAM_BADGUYS, hBadGuysHero, cpParticleEnt:GetAbsOrigin().x, cpParticleEnt:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3.0 )
		end
	end

	if oldTeam == DOTA_TEAM_GOODGUYS then
		local number_of_points = m_points_owned[DOTA_TEAM_GOODGUYS]
		CConquestGameMode:BroadcastControlPointsOwned( oldTeam, number_of_points )
	elseif oldTeam == DOTA_TEAM_GOODGUYS then
		local number_of_points = m_points_owned[DOTA_TEAM_BADGUYS]
		CConquestGameMode:BroadcastControlPointsOwned( oldTeam, number_of_points )
	end
end

---------------------------------------------------------------------------
-- Event: Milestone Achieved
---------------------------------------------------------------------------
function CConquestGameMode:OnTeamMilestoneReached( team, pointsAchieved )
	print("Team milestone achieved")

	-- Other team gets catch-up bonuses
	if team == DOTA_TEAM_GOODGUYS then
		direMilestoneBonus = pointsAchieved
	elseif team == DOTA_TEAM_BADGUYS then
		radiantMilestoneBonus = pointsAchieved
	end
end
--[[
	local opposingTeam = 2
	if team == 2 then
		opposingTeam = 3
	end
	if GetMapName() == "haunted_colosseum" then
		EmitGlobalSound("Conquest.Stinger.HulkCreep")
	else
		EmitGlobalSound("Conquest.Stinger.HulkCreep.Generic")
	end

	local numberToSpawn = 1
	if pointsAchieved > 1 then
		numberToSpawn = pointsAchieved - 1
	end
	CConquestGameMode:SpawnCreeps( opposingTeam, numberToSpawn )
end
--]]


function CConquestGameMode:OnPlayerConnect()
	self:ControlPointUpdateParticles()
end


---------------------------------------------------------------------------
-- Event: Chat Cheats
-- > teamonly - bool
-- > userid - int
-- > playerid - int
-- > text - string
---------------------------------------------------------------------------
function CConquestGameMode:OnPlayerChat( event )
	local nPlayerID = event.playerid
	if nPlayerID == -1 then
		return
	end

	local sChatMsg = event.text
	print(sChatMsg)
	-- givepoints
	if sChatMsg:find( '^-givepoints radiant') then
		local points = ''
		_,_,points = sChatMsg:find('^-givepoints radiant (.*)$')
		self:TestGivePoints('givepoints', points, 2)
	elseif sChatMsg:find( '^-givepoints dire') then
		local points = ''
		_,_,points = sChatMsg:find('^-givepoints dire (.*)$')
		self:TestGivePoints('givepoints', points, 3)
	-- capture
	elseif sChatMsg:find( '^-capture radiant') then
		local cp = ''
		_,_,cp = sChatMsg:find('^-capture radiant (.*)$')
		self:TestCapturePoint('capture', cp, 2)
	elseif sChatMsg:find( '^-capture dire') then
		local cp = ''
		_,_,cp = sChatMsg:find('^-capture dire (.*)$')
		self:TestCapturePoint('capture', cp, 3)
	-- point multiplier
	elseif sChatMsg:find( '^-pointmultiplier') then
		local mult = ''
		_,_,mult = sChatMsg:find('^-pointmultiplier (.*)$')
		self:TestPointMultiplier('pointmultiplier', mult)
	elseif sChatMsg:find( '^-digsite') then
		dig_site_radiant:RemoveModifierByName( "modifier_dig_site_cooldown" )
		dig_site_dire:RemoveModifierByName( "modifier_dig_site_cooldown" )
	-- other
	elseif sChatMsg:find( '^-lua' ) then
		local cmd = ''
		_,_,cmd = sChatMsg:find( '^-lua (.*)$' )
		print( 'Running a lua command: ' .. cmd )
		local f = loadstring( cmd, 'chatCommand' )
		if f == nil then
			Say( nil, "Error loading command", false )
		else
			local ok, result = pcall( f )
			if ok then
				if result == nil then result = 'nil' end
				Say( nil, "Result is " .. result, false )
			else
				Say( nil, "Error: " .. result, false )
			end
		end
	end
end