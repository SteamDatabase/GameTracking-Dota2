
require( "event_queue" )

--------------------------------------------------------------------------------

function CJungleSpirits:OnThink()

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		local hAllHeroes = HeroList:GetAllHeroes()
		for _, hHero in ipairs( hAllHeroes ) do
			if hHero ~= nil then
				if hHero:IsRealHero() and hHero:IsOwnedByAnyPlayer() and hHero:IsClone() == false and hHero:IsTempestDouble() == false then
					if hHero.bNetworkDataInit == nil then
						local netTable = {}
						netTable["gems_count"] = 0
						netTable["last_damage_time"] = hHero:GetLastDamageTime()
						netTable["spirit_active"] = false
						CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( hHero:entindex() ), netTable )
						hHero.bNetworkDataInit = true
					end	
				end
			end
		end

		if self.bDataSent == nil then
			CustomNetTables:SetTableValue( "jungle_spirits_branch_globals", tostring( 0 ), SPIRIT_GLOBAL_ABILITIES )	
			CustomNetTables:SetTableValue( "jungle_spirits_gem_constants", tostring( 0 ), NETTABLE_SEND_GEM_CONSTANTS )
			CustomNetTables:SetTableValue( "jungle_spirits_branch_abilities", tostring( 0 ), SPIRIT_ABILITIES_BY_TIER )

			local statusTable = {}
			statusTable["radiant_ent_index"] = self._hRadiantSpirit:entindex()
			statusTable["dire_ent_index"] = self._hDireSpirit:entindex()

			CustomNetTables:SetTableValue( "jungle_spirits_status", tostring( 0 ), statusTable )

			local branchTable = {}
			branchTable["radiant"] = self._hRadiantSpirit.BranchData
			branchTable["dire"] = self._hDireSpirit.BranchData
			CustomNetTables:SetTableValue( "jungle_spirits_branch_data", tostring( 0 ), branchTable )
			self.bDataSent = true
		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		self:_ThinkLootExpiry()

		if self._fNextRoundTime ~= nil and GameRules:GetGameTime() >= self._fNextRoundTime then
			self:NewSpiritRound()

			if self._nMarchesStarted % 2 == 0 then
				self._fNextRoundTime = GameRules:GetGameTime() + TIME_AFTER_MARCH_PAIR
				self.szLaneToMarchOn = LANE_SPECIFIER_STRING[ RandomInt( 1, #LANE_SPECIFIER_STRING ) ]
				self.szMarchPath = "lane_" .. self.szLaneToMarchOn .. "_pathcorner_"
			else
				self._fNextRoundTime = GameRules:GetGameTime() + TIME_BETWEEN_TEAM_MARCHES
			end

			print( "OnThink():" )
			print( "  next round time - " .. ConvertToTime( self._fNextRoundTime ) )
		end

		local statusTable = {}
		statusTable["radiant_ent_index"] = self._hRadiantSpirit:entindex()
		statusTable["dire_ent_index"] = self._hDireSpirit:entindex()
		statusTable["dire_active"] = self._hDireSpirit.bIsActive;
		statusTable["radiant_active"] = self._hRadiantSpirit.bIsActive;
		statusTable["dire_duration"] = self._hDireSpirit.start_time;
		statusTable["radiant_duration"] = self._hRadiantSpirit.start_time;

		if self._fNextRoundTime then
			statusTable["march_lane"] = self.szLaneToMarchOn
			statusTable["next_march_team"] = self:GetMarchingSpiritTeam()
			statusTable["time_until_march"] = self._fNextRoundTime - GameRules:GetGameTime();
		end
		CustomNetTables:SetTableValue( "jungle_spirits_status", "0", statusTable )
		
		if self._fNextGemTime ~= nil and ( GameRules:GetGameTime() >= ( self._fNextGemTime - GEM_SPAWN_WARNING_TIME ) ) then
			--print( "Evaluating gem for NextGemTime: ", ConvertToTime( self._fNextGemTime ) )
			if not self._hasWarnedGemSpawn then
				--print( "Launching warning for NextGemTime: ", ConvertToTime( self._fNextGemTime ) )
				self:WarnGemSpawn()
			end
		end

		for _, hHero in ipairs( HeroList:GetAllHeroes() ) do
			if hHero ~= nil and hHero:IsRealHero() and hHero:IsClone() == false and hHero:IsTempestDouble() == false  then
				local netTable = {}
				netTable["gems_count"] = 0

				local hGemsBuff = hHero:FindModifierByName( "modifier_spirit_gem" )
				if hGemsBuff ~= nil then
					netTable["gems_count"] = hGemsBuff:GetStackCount()
					netTable["last_damage_time"] = hHero:GetLastDamageTime()
					netTable["spirit_active"] = self:IsSpiritActive( self:GetSpiritForTeam( hHero:GetTeamNumber() ) )
				end
				CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( hHero:entindex() ), netTable )
			end
		end

	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end

	return 1
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnHeroFinishSpawn( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero ~= nil and hPlayerHero:IsRealHero() then
		if hPlayerHero.bFirstSpawnComplete == nil then
			hPlayerHero.bFirstSpawnComplete = true

			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			self.EventMetaData[nPlayerID] = {}
			self.EventMetaData[nPlayerID]["kills"] = 0
			self.EventMetaData[nPlayerID]["essence_gathered"] = 0
			self.EventMetaData[nPlayerID]["team_id"] = hPlayerHero:GetTeamNumber()
			self.EventMetaData[nPlayerID]["level"] = 1
			self.EventMetaData[nPlayerID]["net_worth"] = 0
			self.EventMetaData[nPlayerID]["points_from_treasure"] = 0
			self.EventMetaData[nPlayerID]["points_from_win"] = 0

			local netTable = {}
			netTable["earned_points"] = 0
			CustomNetTables:SetTableValue( "bp_tracker", string.format( "%d", nPlayerID ), netTable )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()

		if self._bDevMode and self._szDevHero ~= nil then
			self:ForceAssignHeroes()
		end

	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes() -- @test this to make sure it works
	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		self:SpawnOrRespawnBothSpirits()
		self:SetNextMarchingSpiritTeam()

		EmitGlobalSound( "JungleSpirits.EnterGame" )

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( 20.0,
			function()
				self:FireAnnouncerPregame()
			end
		)

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self._fNextRoundTime = GameRules:GetGameTime() + TIME_BEFORE_FIRST_MARCH
		print( "[MOROKAI] InitGameMode(): Next round time - " .. ConvertToTime( self._fNextRoundTime ) )

		self.szLaneToMarchOn = LANE_SPECIFIER_STRING[ RandomInt( 1, #LANE_SPECIFIER_STRING ) ]
		self.szMarchPath = "lane_" .. self.szLaneToMarchOn .. "_pathcorner_"

		self._fNextGemTime = GameRules:GetGameTime() + TIME_PER_GEM_SPAWN
		print( "[MOROKAI] InitGameMode(): Next gem time - " .. ConvertToTime( self._fNextGemTime ) )

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( 15.0, 
			function()
				self:FireAnnouncerGameStart()
			end
		)
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		-- 
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnGameFinished( event )

	printf("[MOROKAI] OnGameFinished: winningteam=%d", event["winningteam"])

	printf("[MOROKAI] EventGameDetails table:")
	if self._hEventGameDetails then
	    DeepPrintTable(self._hEventGameDetails)
	else
		printf("NOT FOUND!!")
	end
	
	self:AddResultToSignOut( event )
	print( "[MOROKAI] Metadata Table:" )
	PrintTable( self.EventMetaData, " " )
	print( "[MOROKAI] Signout Table:" )
	PrintTable( self.SignOutTable, " " )
	GameRules:SetEventMetadataCustomTable( self.EventMetaData )
	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
end

--------------------------------------------------------------------------------

function CJungleSpirits:AddResultToSignOut( event )
	self.SignOutTable["game_time"] = GameRules:GetGameTime()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local PlayerEventMetaData = self.EventMetaData[nPlayerID] or {}
			local EventGameDetails = self:GetEventGameDetails( nPlayerID ) or {}
			local unPointCapTotal = EventGameDetails["pointcap_total"] or 0
			local unPointCapRemaining = EventGameDetails["pointcap_remaining"] or 0
			local unDailyBonusesRemaining = EventGameDetails["daily_bonuses_remaining"] or 0

			local PlayerStats = {}
			PlayerStats["player_id"] = nPlayerID
			PlayerStats["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			PlayerStats["kills"] = PlayerEventMetaData["kills"] or 0
			PlayerStats["essence_gathered"] = PlayerEventMetaData["essence_gathered"] or 0
			PlayerStats["team_id"] = PlayerEventMetaData["team_id"]
			PlayerStats["level"] = PlayerResource:GetLevel( nPlayerID )
			PlayerStats["net_worth"] = PlayerResource:GetNetWorth( nPlayerID )
			PlayerStats["pointcap_remaining_pregame"] = unPointCapRemaining
			PlayerStats["points_from_treasure"] = PlayerEventMetaData["points_from_treasure"] or 0
			PlayerStats["capped_points_from_treasure"] = math.min( unPointCapRemaining,  PlayerStats["points_from_treasure"] )
			unPointCapRemaining = unPointCapRemaining - PlayerStats["capped_points_from_treasure"] 
			PlayerStats["points_from_win"] = 0
			PlayerStats["points_from_loss"] = 0
			if event["winningteam"] == PlayerResource:GetTeam( nPlayerID ) then
				local unPointsFromWin = 300
				if unDailyBonusesRemaining > 0 then
					unPointsFromWin = 1000
				end
				PlayerStats["points_from_win"] = unPointsFromWin
				PlayerStats["capped_points_from_win"] = math.min( unPointCapRemaining, unPointsFromWin )
				unPointCapRemaining = unPointCapRemaining - PlayerStats["points_from_win"] 
			else
				local unPointsFromLoss = 100
				PlayerStats["points_from_loss"] = unPointsFromLoss
				PlayerStats["capped_points_from_loss"] = math.min( unPointCapRemaining, unPointsFromLoss )
				unPointCapRemaining = unPointCapRemaining - PlayerStats["points_from_loss"] 
			end

			PlayerStats["pointcap_remaining"] = unPointCapRemaining
			PlayerStats["pointcap_total"] = unPointCapTotal

			-- duplicate this in event metadata for post game screen
			PlayerEventMetaData["points_from_treasure"] = PlayerStats["points_from_treasure"]
			PlayerEventMetaData["capped_points_from_treasure"] = PlayerStats["capped_points_from_treasure"]
		
			PlayerEventMetaData["points_from_win"] = PlayerStats["points_from_win"]
			PlayerEventMetaData["capped_points_from_win"] = PlayerStats["capped_points_from_win"]

			PlayerEventMetaData["points_from_loss"] = PlayerStats["points_from_loss"]
			PlayerEventMetaData["capped_points_from_loss"] = PlayerStats["capped_points_from_loss"]

			PlayerEventMetaData["pointcap_remaining_pregame"] = PlayerStats["pointcap_remaining_pregame"]
			PlayerEventMetaData["pointcap_remaining"] = PlayerStats["pointcap_remaining"]
			PlayerEventMetaData["pointcap_total"] = PlayerStats["pointcap_total"]

			table.insert( self.SignOutTable["stats"], PlayerStats )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnNPCSpawned( event )
	local hUnit = EntIndexToHScript( event.entindex )
	if not hUnit then
		return
	end

	if hUnit:IsRealHero() and hUnit:IsTempestDouble() == false and hUnit:IsClone() == false then
		self:OnPlayerHeroSpawned( event )
	end

	if self:IsSpecialUnit( hUnit ) == false and ( hUnit:IsNeutralUnitType() or hUnit:GetName() == "npc_dota_creep_lane" ) then
		if RandomFloat( 0, 1 ) <= CREATURE_GEM_DROP_MODIFIER_CHANCE / 100 then
			hUnit:AddNewModifier( hUnit, nil, "modifier_spirit_gem", { duration = -1 } )

			self.EventQueue = CEventQueue()
			self.EventQueue:AddEvent( 1.0, 
				function()
					self:AddGemsToUnit( hUnit, CREATURE_GEM_DROP_MODIFIER_STACK )
				end
			)
		end
	end

	if hUnit:GetUnitName() == "npc_dota_roshan" then
		hUnit:AddNewModifier( hUnit, nil, "modifier_spirit_gem", { duration = -1 } )

		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( 1.0, 
			function()
				self:AddGemsToUnit( hUnit, ROSHAN_GEMS_COUNT )
			end
		)
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnPlayerHeroSpawned( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnEntityKilled( event )
	local hKiller = EntIndexToHScript( event.entindex_attacker or -1 )
	local hVictim = EntIndexToHScript( event.entindex_killed )

	if hVictim == nil or hVictim:IsNull() or hKiller == nil or hKiller:IsNull() then
		return
	end

	local hSpiritGemModifier = hVictim:FindModifierByName( "modifier_spirit_gem" )
	if hSpiritGemModifier ~= nil then
		local nGemsToDrop = hSpiritGemModifier:GetStackCount()

		if hVictim:IsRealHero() then
			local nDisadvantage = self:GetMySpiritLevelDisadvantage( hVictim )
			local nAdvLow = 0
			local nAdvHigh = HIGHEST_BEAST_DISADVANTAGE
			-- Remap a value in the range [A,B] to [C,D].
			local fMultiplier = RemapVal( nDisadvantage, nAdvLow, nAdvHigh, GEMS_PCT_LOST_ON_DEATH_MAXIMUM, GEMS_PCT_LOST_ON_DEATH_MINIMUM )
			--printf( "hero victim - nDisadvantage: %d, nAdvLow: %d, nAdvHigh: %d, fMultiplier: %.2f", nDisadvantage, nAdvLow, nAdvHigh, fMultiplier )
			nGemsToDrop = math.floor( nGemsToDrop * fMultiplier )
		end

		local nVictimGems = math.floor( nGemsToDrop )
		self:DropGemStackFromUnit( hVictim, nVictimGems, hKiller )
	elseif hSpiritGemModifier == nil and hVictim:IsBuilding() and hVictim:IsFort() == false then
		local nBuildingGems = self:ScaleGemAmountWithGameTime( BUILDING_GEM_DROP_AMOUNT )
		self:DropGemStackFromUnit( hVictim, nBuildingGems, hKiller )
	end

	if hKiller.GetUnitName and hKiller:GetUnitName() == "npc_dota_creature_jungle_spirit" then
		if hVictim:IsRealHero() then
			local gameEvent = {}
			gameEvent["teamnumber"] = -1
			if hKiller:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				gameEvent["message"] = "#Morokai_Killed_Player"
			else
				gameEvent["message"] = "#Morokai_Killed_Player_Dire"
			end
			gameEvent["locstring_value"] = "#DOTA_GoodGuysShort"

			if hKiller:GetTeamNumber() == DOTA_TEAM_BADGUYS then
				gameEvent["locstring_value"] = "#DOTA_BadGuysShort"
			end
			gameEvent["player_id"] = hVictim:GetPlayerID()
			FireGameEvent( "dota_combat_event_message", gameEvent )

			self.EventQueue = CEventQueue()
			self.EventQueue:AddEvent( ANNOUNCER_DELAY,
				function()
					self:FireAnnouncerMorokaiPositive_PerTeam( hKiller:GetTeamNumber() )
				end
			)
		else
			self:DropGoldBag( hVictim:GetAbsOrigin(), hVictim:GetGoldBounty() )
		end
	end

	if hKiller.IsRealHero and hKiller:IsRealHero() then
		self:OnHeroKilledEntity( hKiller, hVictim )
	end

	if hVictim:GetUnitName() == "npc_dota_creature_jungle_spirit" then
		self:OnJungleSpiritKilled( event )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnHeroKilledEntity( hKiller, hVictim )
	-- empty
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnJungleSpiritKilled( event )
	-- Respawn the spirit in a few seconds
	self.EventQueue = CEventQueue()

	self.EventQueue:AddEvent( SPIRIT_DEATH_TIMER, 
		function()
			self:SpawnOrRespawnBothSpirits()
		end
	)

	local hKiller = EntIndexToHScript( event.entindex_attacker or -1 )
	local hVictim = EntIndexToHScript( event.entindex_killed )
	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["locstring_value"] = "DOTA_GoodGuysShort"
	if hVictim:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		gameEvent["locstring_value"] = "#DOTA_BadGuysShort"
	end

	if hKiller and hKiller:IsRealHero() then
		if hVictim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			gameEvent[ "message" ] = "#Player_Killed_Morokai"
		else
			gameEvent[ "message" ] = "#Player_Killed_Morokai_Dire"
		end
		gameEvent["player_id"] = hKiller:GetPlayerID()
	else
		if hVictim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			gameEvent[ "message" ] = "#Morokai_Killed_NoPlayer"
		else
			gameEvent[ "message" ] = "#Morokai_Killed_NoPlayer_Dire"
		end
	end

	FireGameEvent( "dota_combat_event_message", gameEvent )

	self.EventQueue = CEventQueue()
	self.EventQueue:AddEvent( ANNOUNCER_DELAY,
		function()
			self:FireAnnouncerMorokaiDeath_PerTeam( hVictim:GetTeamNumber() )
		end
	)
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnEntityKilled_PlayerHero( event )
	local hVictim = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker )
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnItemPickedUp( event )
	if event.itemname == "item_throw_snowball" or event.itemname == "item_summon_snowman" or event.itemname == "item_decorate_tree" or event.itemname == "item_festive_firework" then
		local nAssociatedConsumable = GIFT_ASSOCIATED_CONSUMABLES[ event.itemname ]
		local hHeroWhoLooted = EntIndexToHScript( event.HeroEntityIndex )
		--print( string.format( "\"%s\" picked up item named \"%s\"", hHeroWhoLooted:GetUnitName(), event.itemname ) )
		--print( string.format( "   item has associated consumable #: %d", nAssociatedConsumable ) )

		if hHeroWhoLooted then
			local gameEvent = {}
			gameEvent["player_id"] = hHeroWhoLooted:GetPlayerID()
			gameEvent["teamnumber"] = -1
			gameEvent["locstring_value"] = event.itemname
			gameEvent["message"] = "#Frosthaven_PickedUpGift"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnCreatureGainedLevel( event )
	local hCreature = EntIndexToHScript( event.entindex )
	local nLevel = event.level
	self:CreateSpiritGainedLevelMessage( hCreature:GetTeamNumber(), nLevel )
end

--------------------------------------------------------------------------------

function CJungleSpirits:_ThinkLootExpiry()
	if self._flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetGameTime() - self._flItemExpireTime
	local bExpire = true

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop")) do
		local containedItem = item:GetContainedItem()
		if ( containedItem ~= nil and containedItem:IsNull() == false and self:IsGemItem( containedItem ) ) and bExpire then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
		if ( containedItem ~= nil and containedItem:IsNull() == false and ( containedItem:GetAbilityName() == "item_bag_of_gold_caster_only") ) and bExpire then
			self:_ProcessItemForLootExpiry( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:IsGemItem( hItem )
	if string.match( hItem:GetAbilityName(), "item_spirit_gem" ) then
		return true
	elseif string.match( hItem:GetAbilityName(), "item_spirit_gem_medium" ) then
		return true
	elseif string.match( hItem:GetAbilityName(), "item_spirit_gem_big" ) then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

function CJungleSpirits:_ProcessItemForLootExpiry( item, flCutoffTime )
	if item:IsNull() then
		return false
	end

	local containedItem = item:GetContainedItem()

	if item:GetCreationTime() >= flCutoffTime then
		local flWiggleTime = 4
		if (item:GetCreationTime()-flWiggleTime) < flCutoffTime and item.hWiggleBuff == nil then 
			local kvWiggle = { duration = flWiggleTime + 1, start_amplitude=0.5, end_amplitude=5, start_frequency=0.1, end_frequency=0.01 } 
			item.hWiggleBuff = CreateModifierThinker( item, containedItem, "modifier_itemwiggle_thinker", kvWiggle, item:GetAbsOrigin(), DOTA_TEAM_NEUTRALS, false )
		end
		return true
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end

--------------------------------------------------------------------------------

function CJungleSpirits:GlobalAbilityButtonPressed( eventSourceIndex, data, ability )
	print( "Ability button pressed: ", ability )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data[ "PlayerID" ] )
	local spirit = self._hRadiantSpirit
	if hPlayerHero:GetTeamNumber() == self._hDireSpirit:GetTeamNumber() then
		spirit = self._hDireSpirit
	end

	spirit.Ability = spirit:FindAbilityByName( ability )
	if spirit.Ability == nil then
		print ("Ability not found")
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = spirit:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = spirit.Ability:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CJungleSpirits:IsSpecialUnit( hUnit )
	for _, szSpecialUnitName in pairs( SPECIAL_UNITS ) do
		if hUnit:GetUnitName() == szSpecialUnitName then
			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnBranchButtonClicked( eventSourceIndex, data )
	local nPlayerID = data["PlayerID"]
	local nBranchID = data["BranchID"]
	local bLearnMode = data["LearnMode"] == 1

	--print ( "OnBranchButtonClicked" )

	if nPlayerID ~= nil and nBranchID ~= nil and bLearnMode ~= nil then
		local nPlayerGemCount = 0
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero ~= nil then
			local hGemsBuff = hPlayerHero:FindModifierByName( "modifier_spirit_gem" )
			if hGemsBuff ~= nil then
				nPlayerGemCount = hGemsBuff:GetStackCount()
			end

			local hSpirit = self:GetSpiritForTeam( hPlayerHero:GetTeamNumber() )
			local bResult = self:CanSpendGems( nPlayerGemCount, hSpirit, nBranchID, bLearnMode )
			if bResult == false then
				print( "Player does not have enough gems; " .. nPlayerGemCount )
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "branch_button_clicked_fail_not_enough_gems", {} )
				return
			end

			if bLearnMode then
				self:OnPlayerUpgradeSpiritBranch( hPlayerHero, hSpirit, nBranchID )
			else
				self:OnPlayerCastBranchAbility( hPlayerHero, hSpirit, nBranchID )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnPlayerUpgradeSpiritBranch( hHero, hSpirit, nBranchID )
	--print( "OnPlayerUpgradeSpiritBranch" )
	if hSpirit == nil then
		return
	end

	if nBranchID < SPIRIT_BRANCH_JUNGLE and nBranchID > SPIRIT_BRANCH_VOLCANO then
		print( "Accessing invalid branch " .. nBranchID )
		return 
	end

	if hHero and hHero:GetLastDamageTime() + GEM_DAMAGE_COOLDOWN > GameRules:GetGameTime() then
		print( "Cannot spend gems, took damage too recently" )
		return
	end

	local hGemsBuff = hHero:FindModifierByName( "modifier_spirit_gem" )
	if hGemsBuff == nil then
		return
	end

	local szSendString = "goodguys"
	if hSpirit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		szSendString = "badguys"
	end

	local nGemsToSpend = self:GetGemCost( nBranchID, hSpirit:GetLevel() - 1, true )
	if nGemsToSpend >= self:GetGemsTillNextTier( hSpirit, nBranchID ) then
		hGemsBuff:SetStackCount( hGemsBuff:GetStackCount() - nGemsToSpend )

		local netTable = {}
		netTable["gems_count"] = hGemsBuff:GetStackCount()
		CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( hHero:entindex() ), netTable )

		hSpirit.BranchData[nBranchID].nCurrentXP = hSpirit.BranchData[nBranchID].nCurrentXP + nGemsToSpend
		hSpirit.BranchData[nBranchID].nCurrentTier = hSpirit.BranchData[nBranchID].nCurrentTier + 1
		hSpirit.BranchData[nBranchID].nCurrentXP = hSpirit.BranchData[nBranchID].nCurrentXP - CUPCAKES_REQUIRED_PER_BRANCH_LEVEL[ hSpirit:GetLevel() ]

		if hSpirit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			table.insert( self.EventMetaData["dire_upgrade_order"], nBranchID )
		else
			table.insert( self.EventMetaData["radiant_upgrade_order"], nBranchID )
		end
		-- if the creature was a hero we could just do this, but since it's not we consume them in its OnThink
		--hSpirit:AddExperience( nGemsToSpend*10, DOTA_ModifyXP_Unspecified, false, true )
		
		local hSpiritGemModifier = hSpirit:FindModifierByName( "modifier_spirit_gem" )
		if hSpiritGemModifier == nil then
			hSpirit:AddNewModifier( hSpirit, nil, "modifier_spirit_gem", { } )
			hSpiritGemModifier = hSpirit:FindModifierByName( "modifier_spirit_gem" )
		end

		if hSpiritGemModifier ~= nil then
			printf("[MOROKAI] adding %d gems", nGemsToSpend)
			hSpiritGemModifier:SetStackCount( hSpiritGemModifier:GetStackCount() + nGemsToSpend )
		end

		local hNewAbility = hSpirit:AddAbility( SPIRIT_ABILITIES_BY_TIER[nBranchID][hSpirit.BranchData[nBranchID].nCurrentTier] )
		if hNewAbility then
			hNewAbility:UpgradeAbility( false )

			local abilityTable = {}
			abilityTable["ability_name"] = hNewAbility:GetAbilityName()
			abilityTable["branch_id"] = nBranchID
			abilityTable["hero_name"] = hHero:GetUnitName()
			CustomGameEventManager:Send_ServerToTeam( hSpirit:GetTeamNumber(), "morokai_ability_learned", abilityTable )
		end

		--[[
		local hBranchGlobalAbility = hSpirit:FindAbilityByName( SPIRIT_GLOBAL_ABILITIES[nBranchID] )
		if hBranchGlobalAbility then
			hBranchGlobalAbility:UpgradeAbility( false )
		end
		]]

		local branchTable = {}
		branchTable["radiant"] = self._hRadiantSpirit.BranchData
		branchTable["dire"] = self._hDireSpirit.BranchData
		CustomNetTables:SetTableValue( "jungle_spirits_branch_data", tostring( 0 ), branchTable )

		if hSpirit:GetLevel() < MOROKAI_MAX_LEVEL then
			hSpirit:CreatureLevelUp( 1 )
		end

		local nTier = hSpirit.BranchData[ nBranchID ].nCurrentTier
		local nTotalTiersInBranch = TableLength( SPIRIT_ABILITIES_BY_TIER[ nBranchID ] )
		local bIsMaxTier = nTier == nTotalTiersInBranch
		local nTeam = hSpirit:GetTeamNumber()

		if nTier == 1 then
			self.EventQueue = CEventQueue()
			self.EventQueue:AddEvent( ANNOUNCER_DELAY,
				function()
					self:FireAnnouncerBranchStart( nTeam )
				end
			)
		elseif bIsMaxTier then
			self.EventQueue = CEventQueue()
			self.EventQueue:AddEvent( ANNOUNCER_DELAY,
				function()
					self:FireAnnouncerBranchFull( nTeam )
				end
			)
		else
			self.EventQueue = CEventQueue()
			self.EventQueue:AddEvent( ANNOUNCER_DELAY,
				function()
					self:FireAnnouncerBranchStep( nTeam )
				end
			)
		end
	else
		print( szSendString .. " needs " .. self:GetGemsTillNextTier( hSpirit, nBranchID ) .. " more gems" )
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnPlayerCastBranchAbility( hHero, hSpirit, nBranchID )
	print( "OnPlayerCastBranchAbility" )
	if hSpirit == nil then
		return
	end

	if nBranchID < SPIRIT_BRANCH_JUNGLE and nBranchID > SPIRIT_BRANCH_VOLCANO then
		print( "Accessing invalid branch " .. nBranchID )
		return 
	end

	local hGemsBuff = hHero:FindModifierByName( "modifier_spirit_gem" )
	if hGemsBuff == nil then
		return
	end

	local hGlobalAbility = hSpirit:FindAbilityByName( SPIRIT_GLOBAL_ABILITIES[nBranchID] )
	if hGlobalAbility == nil then
		print ("Ability not found")
		return
	end

	if hGlobalAbility:IsCooldownReady() == false then
		print( "Ability on cooldown" )
		return
	end

	print ( "[MOROKAI] Casting global ability " .. hGlobalAbility:GetAbilityName() )

	hGemsBuff:SetStackCount( hGemsBuff:GetStackCount() - self:GetGemCost( nBranchID, hSpirit.BranchData[nBranchID].nCurrentTier, false ) )
	
	local netTable = {}
	netTable["gems_count"] = hGemsBuff:GetStackCount()
	CustomNetTables:SetTableValue( "jungle_spirits_gems_info", tostring( hHero:entindex() ), netTable )

	ExecuteOrderFromTable({
		UnitIndex = hSpirit:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hGlobalAbility:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CJungleSpirits:DropGoldBag( vLocation, nGoldToDrop )
	if IsServer() then
		local newItem = CreateItem( "item_bag_of_gold_caster_only", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( nGoldToDrop )

		local hPhysicalItem = CreateItemOnPositionSync( vLocation, newItem )
		hPhysicalItem:SetModelScale( GOLD_BAG_MODELSCALE )
		
		local dropTarget = vLocation + RandomVector( RandomFloat( 50, 150 ) )
		newItem:LaunchLoot( true, 300, 0.75, dropTarget )

	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:OnBattlePointsEarned( hLootingHero, nTeamBattlePoints, szReason )
	local nTeamNumber = hLootingHero:GetTeamNumber()

	print( "[MOROKAI] OnBattlePointsEarned() - Team: " .. nTeamNumber .. " | Points: " .. nTeamBattlePoints .. " | Reason: " .. szReason )

	local hLooterTeamHeroes = { }

	-- Populate a table of this team's non-abandoned heroes
	local hAllHeroes = HeroList:GetAllHeroes()
	for _, hHero in ipairs( hAllHeroes ) do
		if hHero ~= nil and hHero:GetTeamNumber() == nTeamNumber and hHero:HasOwnerAbandoned() == false then
			if hHero:IsRealHero() and hHero:IsTempestDouble() == false and hHero:IsClone() == false then
				table.insert( hLooterTeamHeroes, hHero )
				--printf( "Inserted hero named %s to looter team heroes table", hHero:GetUnitName() )
			end
		end
	end

	--printf( "TableLength( hLooterTeamHeroes ) == %d", TableLength( hLooterTeamHeroes ) )

	for _, hHero in pairs( hLooterTeamHeroes ) do
		local nPlayerID = hHero:GetPlayerOwnerID()

		local nPlayerBattlePoints = nTeamBattlePoints / TableLength( hLooterTeamHeroes )

		--printf( "nTeamBattlePoints: %d, nPlayerBattlePoints: %d", nTeamBattlePoints, nPlayerBattlePoints )

		local nDigits = string.len( tostring( nPlayerBattlePoints ) )

		local nFXIndex2 = ParticleManager:CreateParticleForPlayer( "particles/generic_gameplay/battle_point_splash_ti9.vpcf", PATTACH_WORLDORIGIN, nil, hHero:GetPlayerOwner() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, hHero:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 )

		EmitSoundOnClient( "Plus.shards_tick", hHero:GetPlayerOwner() )

		self.EventMetaData[nPlayerID]["points_from_treasure"] = self.EventMetaData[nPlayerID]["points_from_treasure"] + nPlayerBattlePoints

		if self.EventMetaData[nPlayerID][szReason] == nil then
			self.EventMetaData[nPlayerID][szReason] = 0
		end

		self.EventMetaData[nPlayerID][szReason] = self.EventMetaData[nPlayerID][szReason] + 1

		local netTable = {}
		netTable["earned_points"] = self.EventMetaData[nPlayerID]["points_from_treasure"]
		CustomNetTables:SetTableValue( "bp_tracker", string.format( "%d", nPlayerID ), netTable )

		if szReason ~= nil then
			print( "-- Player " .. nPlayerID .. " just earned " .. nPlayerBattlePoints .. " battle points for " .. szReason )
		end
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:GetRandomBattlePointsRewardTier()
	if IsServer() then
		--print( "GetRandomBattlePointsReward" )

		-- Tier thresholds we're rolling against
		local fTierOne = 1 - 0.45 -- need to roll above 0.55
		local fTierTwo = fTierOne - 0.36 -- need to roll above 0.19
		local fTierThree = fTierTwo - 0.15 -- need to roll above 0.04
		local fTierFour = fTierThree - 0.03 -- need to roll above 0.01
		local fTierFive = fTierFour - 0.01 -- need to roll above 0

		--printf( "  fTierOne: %.2f, fTierTwo: %.2f, fTierThree: %.2f, fTierFour: %.2f, fTierFive: %.2f", fTierOne, fTierTwo, fTierThree, fTierFour, fTierFive )

		local nTierAwarded = 0
		local fRoll = RandomFloat( 0, 1 )

		if fRoll >= fTierOne then
			nTierAwarded = 1
		elseif fRoll >= fTierTwo then
			nTierAwarded = 2
		elseif fRoll >= fTierThree then
			nTierAwarded = 3
		elseif fRoll >= fTierFour then
			nTierAwarded = 4
		elseif fRoll >= fTierFive then
			nTierAwarded = 5
		end

		return nTierAwarded
	end
end

--------------------------------------------------------------------------------
