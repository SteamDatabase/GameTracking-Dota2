print( "nemestice_events.lua loaded." )

--------------------------------------------------------------------------------

require( "nemestice_constants" )
require( "nemestice_triggers" )

--------------------------------------------------------------------------------

function CNemestice:RegisterGameEvents()
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( self, "ModifyGoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( self, "ModifyExperienceFilter" ), self )
	--GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( self, "ModifyExecuteOrdersFilter" ), self )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", NEMESTICE_THINK_INTERVAL )
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( self, "OnTriggerStartTouch" ), self )
 	ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( self, "OnTriggerEndTouch" ), self )
-- 	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( self, 'OnPlayerConnected' ), self )
-- 	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( self, 'OnPlayerReconnected' ), self )
-- 	ListenToGameEvent( "hero_selected", Dynamic_Wrap( self, 'OnHeroSelected' ), self )
	ListenToGameEvent( "player_disconnect", Dynamic_Wrap( self, 'OnPlayerDisconnect' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( self, 'OnEntityKilled' ), self )
 	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( self, "OnPlayerGainedLevel" ), self )
 	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickedUp" ), self )
-- 	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( self, "OnPlayerBuyback" ), self )
-- 	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( self, "OnItemSpawned" ), self )
-- 	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( self, "OnItemPurchased" ), self )	
-- 	ListenToGameEvent( "dota_hero_entered_shop", Dynamic_Wrap( self, "OnHeroEnteredShop" ), self )
-- 	ListenToGameEvent( "dota_player_team_changed", Dynamic_Wrap( self, "OnPlayerTeamChanged" ), self )
	ListenToGameEvent( "entity_hurt", Dynamic_Wrap( self, 'OnEntityHurt' ), self )
	ListenToGameEvent( "player_chat", Dynamic_Wrap( self, 'OnPlayerChat' ), self )
	ListenToGameEvent( "dota_glyph_used", Dynamic_Wrap( self, 'OnGlyphUsed' ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( self, "OnGameFinished" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( self, "OnPlayerHeroInitialSpawnComplete" ), self )
	ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( self, "OnPlayerAbilityUsed" ), self )
	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( self, "OnNonPlayerUsedAbility" ), self ) 
	ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( self, "OnNpcGoalReached" ), self )

	print( "Game Events susccesfully registered" )
end

--------------------------------------------------------------------------------
-- Gold Filter
-- > player_id_const - int
-- > gold - int
-- > reliable - bool
-- > reason_const - int
--------------------------------------------------------------------------------

function CNemestice:ModifyGoldFilter( filterTable )
	-- bypass check if our override is set (this is because we want to use Unspecified for giving gold
	-- as reward, but there are other things that use it that we don't want to let through.
	if self.bLetGoldThrough == true and filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified then
		return true
	end

	-- No gold on creep kills, ward kills, etc.
	if filterTable[ "reason_const" ] == DOTA_ModifyGold_NeutralKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_RoshanKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_WardKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified -- this handles a bunch of things. Hope it doesn't break anything!
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_CreepKill
	then
		filterTable["gold"] = 0 -- no gold unless we give it to you; for now.
		return false
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyGold_GameTick
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_Building
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_CreepKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_NeutralKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_WardKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_BountyRune
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_AbilityGold
	then
		filterTable["gold"] = math.ceil( filterTable["gold"] * _G.NEMESTICE_REWARD_OUT_OF_BAND_GOLD[ self:GetRoundNumberClamped() ] )

		if filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill then
			filterTable["gold"] = math.ceil( filterTable["gold"] * _G.NEMESTICE_HERO_KILL_GOLD_MULTIPLIER )
		end
	end

	self:UpdateResourceStats( "tGoldStats", filterTable["player_id_const"], filterTable["gold"], NEMESTICE_GOLD_REASON_LABELS[filterTable["reason_const"]] )

	return true
end

--------------------------------------------------------------------------------
-- Experience Filter
-- > player_id_const - int
-- > hero_entindex_const - int
-- > experience - float
-- > reason_const - int
--------------------------------------------------------------------------------

function CNemestice:ModifyExperienceFilter( filterTable )
	if self.bLetXPThrough == true then
		return true
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_CreepKill then
		return true
	end

	filterTable["experience"] = math.ceil( filterTable["experience"] * _G.NEMESTICE_REWARD_OUT_OF_BAND_XP[ self:GetRoundNumberClamped() ] )
	

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_HeroKill then
		local nXPSelf = math.ceil( filterTable[ "experience" ] * _G.NEMESTICE_HERO_KILL_XP_MULTIPLIER_SELF )
		local nXPOthers = math.ceil( filterTable[ "experience" ] * _G.NEMESTICE_HERO_KILL_XP_MULTIPLIER_OTHERS )
		local hHero = EntIndexToHScript( filterTable[ "hero_entindex_const" ] )
		if hHero then
			local nTeamNumber = hHero:GetTeamNumber()
			for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
				if PlayerResource:GetTeam( nPlayerID ) == nTeamNumber then
					local hChangeHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if hChangeHero ~= nil then
						self:GrantGoldAndXP( hChangeHero, 0, ( hChangeHero == hHero and nXPSelf ) or nXPOthers )
					end
				end
			end
		end
	end
	filterTable[ "experience" ] = 0
	return false
end

--------------------------------------------------------------------------------
-- Execute Orders Filter
-- > issuer_player_id_const - int
-- > sequence_number_const - int
-- > units - table
-- > order_type - int
-- > entindex_target - int
-- > entindex_ability - int
-- > shop_item_name - string 
-- > queue - bool
-- > position_x - float
-- > position_y - float
-- > position_z - float
--------------------------------------------------------------------------------

function CNemestice:ModifyExecuteOrdersFilter( filterTable )
	if filterTable[ "order_type" ] ~= DOTA_UNIT_ORDER_PURCHASE_ITEM then
		return true
	end

--	print( "Filtering item purchase" )
	if filterTable[ "shop_item_name" ] == nil then
		print ( "shop item name is nil?" )
		return true
	end

--	print( "Filtering item purchase: " .. filterTable[ "shop_item_name" ] )
	local hKV = GetAbilityKeyValuesByName( filterTable[ "shop_item_name" ] )
	if hKV == nil then
		print ( "item kv is nil" )
		return true
	end

	local bItemRequiresMeteorShards = hKV[ "ItemRequiresMeteorShards" ] 
	--print ( "bItemRequiresMeteorShards" .. bItemRequiresMeteorShards )
	if bItemRequiresMeteorShards == nil then
		print ( "item doesnt require meteor shards" )
		return true
	end

	local nShardCost = hKV[ "ItemCost" ]
	if nShardCost == nil or nShardCost < 0 then
		print( "No valid meteor shard cost" )
		return true
	end

	if self:GetMeteorEnergy( filterTable[ "issuer_player_id_const" ] ) >= nShardCost then
		print( "Success; buying meteor shard item" )
		self:ChangeMeteorEnergy( filterTable[ "issuer_player_id_const" ], -nShardCost, "item_purchase" )
		return true
	end

	print( "Not enough meteor shards!")
	return false
 end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - long
-- > damage - float
--------------------------------------------------------------------------------

function CNemestice:OnEntityHurt( event )
	local hHurtUnit = EntIndexToHScript( event.entindex_killed )

	local hAttacker = nil
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if event.damage == nil or event.damage == 0 or hHurtUnit == nil or hAttacker == nil then
		return
	end

	-- accumulate creep damage to towers
	if hHurtUnit:IsNull() == false and hHurtUnit.bIsTower and hHurtUnit.sKeyName ~= nil
	  and hAttacker:IsNull() == false and hAttacker.bSpringCreep then
		local nAttackerTeam = hAttacker:GetTeamNumber()
		local sTowerKey = hHurtUnit.sKeyName
		if nAttackerTeam == nil then
			nAttackerTeam = 0
		end
		local nTowerCreepDamage = self.m_vecTowerCreepDamageAccumulator[ sTowerKey ]
		if nTowerCreepDamage == nil then
			nTowerCreepDamage = 0
		end
		nTowerCreepDamage = nTowerCreepDamage + event.damage
		self.m_vecTowerCreepDamageAccumulator[ sTowerKey ] = nTowerCreepDamage
	end

	-- track tower attack time
	if hHurtUnit.bIsTower then
		hHurtUnit.nLastHurtTime = GameRules:GetGameTime()
	end

	-- tower under attack VO
	if hHurtUnit.bIsTower and hAttacker:IsNull() == false and ( hHurtUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS or hHurtUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
		if hHurtUnit:GetUnitName() == "npc_dota_nemestice_tower_radiant" or hHurtUnit:GetUnitName() == "npc_dota_nemestice_tower_dire" then
			local bSpeak = false
			if hHurtUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				--print( '^^^RADIANT TOWER ATTACKED!' )
				if self._buildingTowerHurtTimerRadiant == nil or self._buildingTowerHurtTimerRadiant < GameRules:GetGameTime() then
					GameRules:ExecuteTeamPing( hHurtUnit:GetTeamNumber(), hHurtUnit:GetOrigin().x, hHurtUnit:GetOrigin().y, hHurtUnit, 0 )
					self._buildingTowerHurtTimerRadiant = GameRules:GetGameTime() + _G.NEMESTICE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bSpeak = true
				end
			else
				--print( '^^^DIRE TOWER ATTACKED!' )
				if self._buildingTowerHurtTimerDire == nil or self._buildingTowerHurtTimerDire < GameRules:GetGameTime() then
					GameRules:ExecuteTeamPing( hHurtUnit:GetTeamNumber(), hHurtUnit:GetOrigin().x, hHurtUnit:GetOrigin().y, hHurtUnit, 0 )
					self._buildingTowerHurtTimerDire = GameRules:GetGameTime() + _G.NEMESTICE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bSpeak = true
				end
			end
			if bSpeak == true then
				--print( '^^^SPEAKING TOWER ATTACKED VO - announcer_announcer_tower_attack_01!' )
				EmitAnnouncerSoundForTeam( "announcer_announcer_tower_attack_01", hHurtUnit:GetTeamNumber() )
			end
		end
	end	
end

--------------------------------------------------------------------------------
-- player_chat
-- > teamonly - bool
-- > userid - int
-- > playerid - int
-- > text - string
--------------------------------------------------------------------------------

function CNemestice:OnPlayerChat( event )
	--[[
	local nPlayerID = event.playerid
	if nPlayerID == -1 then
		return
	end

	local sChatMsg = event.text
	if sChatMsg:find( '^-lua' ) then
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
	end]]
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 	PlayerID
--------------------------------------------------------------------------------
function CNemestice:OnPlayerDisconnect( event )
	local nPlayerID = event.PlayerID
	if nPlayerID == nil or nPlayerID == -1 then
		return
	end
	local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hHero ~= nil then
		local nHeroTeam = PlayerResource:GetTeam( nPlayerID )
		local szFountainName = "info_player_start_goodguys"
		if nHeroTeam == DOTA_TEAM_BADGUYS then
			szFountainName = "info_player_start_badguys"
		end
		local hFountainTable = Entities:FindAllByClassname( szFountainName )
		if hFountainTable ~= nil then
			local hFountain = hFountainTable[1]
			local vecFountain = hFountain:GetAbsOrigin()
			hHero:MoveToPosition( vecFountain )
		end
	end
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- npc_spawned
-- * entindex
--------------------------------------------------------------------------------

function CNemestice:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit == nil then
		return
	end

	if string.starts( spawnedUnit:GetUnitName(), "npc_dota_lone_druid_bear" ) then
		if spawnedUnit:FindAbilityByName( "hero_meteor_shard_pouch" ) == nil then
			local hShardPouch = spawnedUnit:AddAbility( "hero_meteor_shard_pouch" )
			if hShardPouch then
				hShardPouch:UpgradeAbility( true )
				hShardPouch:SetCurrentAbilityCharges( 0 )
				hShardPouch:SetHidden( true )
			end
		end

		if spawnedUnit:FindAbilityByName( "channel_meteor" ) == nil then
			local hMeteorChannel = spawnedUnit:AddAbility( "channel_meteor" )
			if hMeteorChannel then
				hMeteorChannel:UpgradeAbility( true )
				hMeteorChannel:SetHidden( true )
			end
		end

		if spawnedUnit:FindAbilityByName( "channel_ability_building" ) == nil then
			local hAbilityBuildingChannel = spawnedUnit:AddAbility( "channel_ability_building" )
			if hAbilityBuildingChannel then
				hAbilityBuildingChannel:UpgradeAbility( true )
				hAbilityBuildingChannel:SetHidden( true )
			end
		end

		local hTP = spawnedUnit:FindItemInInventory( "item_tpscroll" )
		--printf("tp scroll %s", hTP)
		if hTP == nil then
			hTP = spawnedUnit:AddItemByName("item_tpscroll")	
		end
		hTP:SetCurrentCharges( 9999 )
		local nCharges = hTP:GetValuelessCharges()
		nCharges = math.max( 9999 - nCharges, 0 )
		hTP:ModifyNumValuelessCharges( nCharges )
	end

	if spawnedUnit:IsRealHero() then
		self:OnNPCSpawned_PlayerHero( event )
		return
	end
end

--------------------------------------------------------------------------------

function CNemestice:OnNPCSpawned_PlayerHero( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	--printf("spawning %s", hPlayerHero:GetUnitName())

	if hPlayerHero.bFirstSpawnComplete == nil then
		hPlayerHero.bFirstSpawnComplete = true
		hPlayerHero.bResetBuyback = true
		--printf("FIRST SPAWN for %s", hPlayerHero:GetUnitName())

		local hPlayer = hPlayerHero:GetPlayerOwner()
		if hPlayer then
			hPlayer:CheckForCourierSpawning( hPlayerHero )
		end

		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_hero_respawn_time", { } )
	end

	local hTP = hPlayerHero:FindItemInInventory( "item_tpscroll" )
	--printf("tp scroll %s", hTP)
	if hTP == nil then
		hTP = hPlayerHero:AddItemByName("item_tpscroll")	
	end
	hTP:SetCurrentCharges( 9999 )
	local nCharges = hTP:GetValuelessCharges()
	nCharges = math.max( 9999 - nCharges, 0 )
	hTP:ModifyNumValuelessCharges( nCharges )
end

--------------------------------------------------------------------------------
-- dota_player_pick_hero
-- > player - short
-- > heroindex - short
-- > hero - string
--------------------------------------------------------------------------------

function CNemestice:OnPlayerHeroInitialSpawnComplete( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	--print( "OnPlayerHeroInitialSpawnComplete" )

	local hTPScroll = hPlayerHero:FindItemInInventory( "item_tpscroll" )
	if hTPScroll then
		hTPScroll:EndCooldown()
	end


	local hShardPouch = hPlayerHero:AddAbility( "hero_meteor_shard_pouch" )
	if hShardPouch then
		hShardPouch:UpgradeAbility( true )
		hShardPouch:SetCurrentAbilityCharges( 0 )
		hShardPouch:SetHidden( true )
	end

	local hMeteorChannel = hPlayerHero:AddAbility( "channel_meteor" )
	if hMeteorChannel then
		print( "added meteor channel ability" )
		hMeteorChannel:UpgradeAbility( true )
		hMeteorChannel:SetHidden( true )
	end

	local hAbilityBuildingChannel = hPlayerHero:AddAbility( "channel_ability_building" )
	if hAbilityBuildingChannel then
		print( "added ability building channel ability" )
		hAbilityBuildingChannel:UpgradeAbility( true )
		hAbilityBuildingChannel:SetHidden( true )
	end
end

--------------------------------------------------------------------------------
-- dota_npc_goal_reached
-- > npc_entindex - short // Entity index of the npc which was following a path and has reached a goal entity
-- > goal_entindex - short // Entity index of the path goal entity which has been reached
-- > next_goal_entindex - short // Entity index of the next goal entity on the path (if any) which the npc will now be pathing towards
--------------------------------------------------------------------------------
function CNemestice:OnNpcGoalReached( event )
	local hUnit = EntIndexToHScript( event.npc_entindex )
	if hUnit ~= nil and hUnit:IsNull() == false then
		if hUnit.bSpringCreep then
			local hNext = EntIndexToHScript( event.next_goal_entindex )
			if hNext == nil or hNext:IsNull() == true then
				hUnit.bIsPathing = false
				self:ValidateCreepTargeting( hUnit )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - long
--------------------------------------------------------------------------------

function CNemestice:OnEntityKilled( event )
	local hKilledUnit = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )
--[[
	if hKilledUnit ~= nil then
		printf( "CNemestice:OnEntityKilled - unit killed %s", hKilledUnit:GetUnitName() )
	end
--]]
	if hKilledUnit:IsRealHero() or ( hKilledUnit:IsCreepHero() and hKilledUnit:IsOwnedByAnyPlayer() ) then
		self:OnEntityKilled_PlayerOrCreepHero( event )
		return
	end

	if self.bPassThroughKillEvent ~= true and self:IsGameInProgress() ~= true then
		return
	end

	if hAttacker ~= nil and hAttacker:IsNull() == false and hKilledUnit ~= nil and hKilledUnit:IsNull() == false then
		if hKilledUnit.bSpringCreep == true then
			local nKillerTeam = hAttacker:GetTeamNumber()
			if ( nKillerTeam == DOTA_TEAM_GOODGUYS or nKillerTeam == DOTA_TEAM_BADGUYS ) then
				-- Set base reward mults
				local flGoldMult = _G.NEMESTICE_REWARD_BASE_GOLD
				local flXPMult = _G.NEMESTICE_REWARD_BASE_XP
				local flGoldSelf = 0
				local flXPSelf = 0
				local bShowLasthit = false
				local bShowDeny = false
				local bHasNearbyGold = false

				if nKillerTeam == hKilledUnit:GetTeamNumber() then
					if hAttacker:GetPlayerOwner() ~= nil then
						flGoldMult = _G.NEMESTICE_REWARD_DENY_MULTIPLIER_GOLD
						flXPMult = _G.NEMESTICE_REWARD_DENY_MULTIPLIER_XP
						bShowDeny = true
						-- Using normal deny particle, see below
						--EmitSoundOnClient( "Lasthit.Dead", hAttacker:GetPlayerOwner() )
						--print("Deny")
					end
				else
					-- Is it a hero lasthit?
					if hAttacker:GetPlayerOwner() ~= nil then
						flGoldMult = _G.NEMESTICE_REWARD_LASTHIT_GOLD
						flXPMult = _G.NEMESTICE_REWARD_LASTHIT_XP
						flGoldSelf = _G.NEMESTICE_REWARD_LASHIT_GOLD_SELF_PORTION
						flXPSelf = _G.NEMESTICE_REWARD_LASHIT_XP_SELF_PORTION
						bShowLasthit = true
						bHasNearbyGold = true
						-- Using normal gold particle, see below.
						--EmitSoundOnClient( "LastHit.Creature", hAttacker:GetPlayerOwner() )
						--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/dark_moon/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hKilledUnit, hAttacker:GetPlayerOwner() ) )
						--print("Creep killed by lasthit")
					else
						-- Otherwise, check if there's a nearby hero.
						local tNearbyHeroes = FindUnitsInRadius( nKillerTeam, hKilledUnit:GetAbsOrigin(), nil, _G.NEMESTICE_REWARD_HERO_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false ) 
						if #tNearbyHeroes > 0 then
							flGoldMult = _G.NEMESTICE_REWARD_NEAR_GOLD
							flXPMult = _G.NEMESTICE_REWARD_NEAR_XP
							bHasNearbyGold = true
							--print("Creep killed, hero nearby")
						--else
							--print("Creep killed, and no one was there to see it")
						end
					end
				end

				local flSizeMult = 1.75 - self.m_nNumHeroesPerTeam * 0.15
				flGoldMult = flGoldMult * _G.NEMESTICE_REWARD_MULTIPLIER_GOLD * flSizeMult
				flXPMult = flXPMult * _G.NEMESTICE_REWARD_MULTIPLIER_XP * flSizeMult

				-- Explicitly use bounties
				local nTotalGold = math.ceil( ( hKilledUnit.nBountyGold or self.nGoldPerCreep ) * flGoldMult )
				local nTotalXP = math.ceil( ( hKilledUnit.nBountyXP or self.nXPPerCreep ) * flXPMult )

				local nSelfGold = 0
				local nSelfXP = 0
				local nTeamGold = nTotalGold
				local nTeamXP = nTotalXP

				if flGoldSelf > 0 then
					nSelfGold = math.floor( flGoldSelf * nTotalGold )
					nTeamGold = nTotalGold - nSelfGold
				end

				if flXPSelf > 0 then
					nSelfXP = math.floor( flXPSelf * nTotalXP )
					nTeamXP = nTotalXP - nSelfXP
				end

				--printf("Total bounties gold %d, XP %d", nTotalGold, nTotalXP )

				self:GrantGoldAndXPToTeam( nKillerTeam, nTeamGold, nTeamXP, bHasNearbyGold and "nearcreep" or "lonecreep" )
				if nSelfGold > 0 or nSelfXP > 0 then
					--printf("Granting extra gold and XP to hero %s, gold %d, team %d / xp %d, team %d", hHero:GetUnitName(), nSelfGold, nTeamGold, nSelfXP, nTeamXP )
					self:GrantGoldAndXP( hAttacker, nSelfGold, nSelfXP, "lasthit" )
				end
				if hAttacker:GetPlayerOwner() ~= nil then
					if bShowLasthit then
						SendOverheadEventMessage( hAttacker:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hKilledUnit, nTotalGold, nil )
					elseif bShowDeny then
						SendOverheadEventMessage( nil, OVERHEAD_ALERT_DENY, hKilledUnit, 0, hAttacker:GetPlayerOwner() )
					end
				end
			end
		end

		if hKilledUnit.bIsTower == true then
			local nKilledTeam = hKilledUnit:GetTeamNumber()
			-- message and ping on loss
			if nKilledTeam == DOTA_TEAM_GOODGUYS or nKilledTeam == DOTA_TEAM_BADGUYS then
				GameRules:ExecuteTeamPing( nKilledTeam, hKilledUnit:GetOrigin().x, hKilledUnit:GetOrigin().y, hKilledUnit, 0 )
				EmitAnnouncerSoundForTeam( "announcer_announcer_tower_fallen_01", nKilledTeam )
				EmitAnnouncerSoundForTeam( "announcer_announcer_tower_enemy_fallen_01", FlipTeamNumber( nKilledTeam ) )
			end

			local hDeathRing = hKilledUnit:FindAbilityByName( "nemestice_tower_death_ring" )
			if hDeathRing ~= nil then
				ExecuteOrderFromTable({
					UnitIndex = hKilledUnit:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hDeathRing:entindex(),
					Queue = false,
				})
			end

			local kv = {}
			kv[ "duration" ] = 1
			CreateModifierThinker( hKilledUnit, nil, "modifier_glyph_reset", kv, hKilledUnit:GetAbsOrigin(), hKilledUnit:GetTeamNumber(), false )

			-- FX
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_CUSTOMORIGIN, hKilledUnit )
			ParticleManager:SetParticleControl( nFXIndex, 0, hKilledUnit:GetAbsOrigin() )
			local nRadius = _G.NEMESTICE_TOWER_DESTRUCTION_DAMAGE_RADIUS
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nRadius, nRadius, nRadius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			hKilledUnit:AddEffects( EF_NODRAW )

			-- Towers are not respawned once killed
			self:TowerDestroyed( hKilledUnit, hAttacker, ( hAttacker ~= hKilledUnit and hAttacker:GetTeamNumber() ) or FlipTeamNumber( hKilledUnit:GetTeamNumber() ) )

			-- update tower buffs after we're destroyed the tower
			self:UpdateTowerBuffs()			
		end
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - short
--------------------------------------------------------------------------------

function CNemestice:OnEntityKilled_PlayerOrCreepHero( event )
	local hKilledHero = EntIndexToHScript( event.entindex_killed )
	if hKilledHero == nil or hKilledHero:IsNull() == true then
		return
	end

	local bPlayer = true
	if hKilledHero:IsRealHero() == false then
		if hKilledHero:IsCreepHero() == false then
			return
		end
		bPlayer = false
	end


	if self:IsGameInProgress() ~= true then
		return
	end

	if bPlayer then
		local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )
		if hAttacker ~= nil and hAttacker ~= hKilledHero and hAttacker:GetTeamNumber() ~= hKilledHero:GetTeamNumber() and ( hAttacker:IsRealHero() or ( hAttacker:IsOwnedByAnyPlayer() and hAttacker:IsCreepHero() ) ) then
			local nAttackerPlayerID = hAttacker:GetPlayerOwnerID()
			local nShards = self:GetHeroMeteorEnergy( hAttacker )
			if nShards > 0 and self.SignOutTable[ "player_list" ][ nAttackerPlayerID ] ~= nil then
				self.SignOutTable[ "player_list" ][ nAttackerPlayerID ][ "shard_kills" ] = self.SignOutTable[ "player_list" ][ nAttackerPlayerID ][ "shard_kills" ] + 1
			end
			printf( "Real hero %s died! Attacker was %s and had %d shards.", hKilledHero:GetUnitName(), hAttacker:GetUnitName(), nShards )
			local hHealBuff = hAttacker:FindModifierByName( "modifier_filler_heal" )
			if hHealBuff ~= nil and hHealBuff:IsNull() == false then
				--print( "   and a shrine buff!" )
				local hBuilding = hHealBuff:GetCaster()
				if hBuilding.bHasRewardedKill ~= true then
					hBuilding.bHasRewardedKill = true

					-- Rewarding is done in the shrine tracker

					-- Old code: reward for each kill.
					--[[local nPlayerID = hBuilding.nLastCastingPlayerID
					if nPlayerID ~= nil and nPlayerID >= 0 and nPlayerID ~= hAttacker:GetPlayerOwnerID() then
						--printf( "Was buffed by player %d", nPlayerID )
						hBuilding.bHasRewardedKill = true
						GameRules.Nemestice:GrantPlayerBattlePoints( nPlayerID, _G.BATTLE_POINT_DROP_SHRINE_KILL, "shrine_kill_healer", true, nAttackerPlayerID )
						GameRules.Nemestice:GrantPlayerBattlePoints( nAttackerPlayerID, _G.BATTLE_POINT_DROP_SHRINE_KILL, "shrine_kill_killer", false )
					end--]]
				end
			end
		end
	end
	
	local hTP = hKilledHero:FindItemInInventory( "item_tpscroll" )
	if hTP ~= nil then
		hTP:EndCooldown()
	end

	-- Have to explicitly find the buffs because we need the individual expiration times.
	local hBuffs = hKilledHero:FindAllModifiersByName( "modifier_hero_meteor_shard_pouch_stack" )
	printf( "Dying unit %s had %d shards, creating them.", hKilledHero:GetUnitName(), #hBuffs )
	for _,hBuff in pairs( hBuffs ) do
		local hMeteorShard = self:CreateMeteorShard( "kill_shard", hKilledHero:GetAbsOrigin(), 1, hBuff:GetDieTime() )
		-- if buff already has a team number, use that. It means either that we picked it up from a teammate, or it is -1
		-- (i.e. we picked it up from an enemy, and we need to record no more swaps)
		hMeteorShard.nTeamNumber = hBuff.nTeamNumber or hKilledHero:GetTeamNumber()

		local vDropLocation = GetRandomPathablePositionWithin( hKilledHero:GetAbsOrigin(), 350, 50 )
		if GridNav:CanFindPath( hKilledHero:GetAbsOrigin(), vDropLocation ) == false then
			vDropLocation = hKilledHero:GetAbsOrigin()
		end
		hMeteorShard:LaunchLoot( true, 300, 0.75, vDropLocation )
	end
	local nMeteorEnergyChange = - ( #hBuffs )
	self:ChangeMeteorEnergy( hKilledHero:GetPlayerOwnerID(), nMeteorEnergyChange, "death", hKilledHero )
	self:ChangePlayerMeteorEnergyStats( hKilledHero:GetPlayerOwnerID(), nMeteorEnergyChange, false )
end

---------------------------------------------------------
-- game_rules_state_change
-- no parameters
---------------------------------------------------------

function CNemestice:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:OnGameStarted()
	elseif nNewState >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
end

---------------------------------------------------------
--no parameters
---------------------------------------------------------
function CNemestice:OnGameStarted()
	GameRules:SetTimeOfDay( _G.NEMESTICE_STARTING_TIME_OF_DAY )
end

--------------------------------------------------------------------------------
-- dota_player_gained_level
-- > player - short
-- > player_id - short
-- > level - short
-- > hero_entindex - short
-- > PlayerID - short
--------------------------------------------------------------------------------

function CNemestice:OnPlayerGainedLevel( event )
end

--------------------------------------------------------------------------------
-- Glyph Used
-- > teamnumber - int
--------------------------------------------------------------------------------

function CNemestice:OnGlyphUsed( event )
	local nTeam = event.teamnumber
	if nTeam == DOTA_TEAM_GOODGUYS then
		EmitAnnouncerSound( "announcer_announcer_fort_rad" )
	elseif nTeam == DOTA_TEAM_BADGUYS then
		EmitAnnouncerSound( "announcer_announcer_fort_dire" )
	end

	self.m_tGlyphsUsed[ nTeam ] = self.m_tGlyphsUsed[ nTeam ] + 1

	local teamGlyphs = self.m_vecGlyphHistory[ tostring( nTeam ) ]
	teamGlyphs[ tostring( math.floor( self:GetPlayedTime() ) ) ] = true
	self.m_vecGlyphHistory[ tostring( nTeam ) ] = teamGlyphs
end

--------------------------------------------------------------------------------
-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short
--------------------------------------------------------------------------------

function CNemestice:OnTriggerStartTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )	
	local szTriggerName = event.trigger_name
	--print(szTriggerName)
	--Waypoint Trigger
	if self:IsPrepOrInProgress() == true then
		if szTriggerName == "waypoint_trigger_radiant" or szTriggerName == "waypoint_trigger_dire" then
			if hUnit:IsRealHero() == true then
				print("waypoint entered" )
				local player = hUnit:GetPlayerID()
				local team = hUnit:GetTeam()
				
				hUnit:Stop()
				local exit = Entities:FindByName( nil, "radiant_teleport_exit" )
				if team == DOTA_TEAM_BADGUYS then
					exit = Entities:FindByName( nil, "dire_teleport_exit" )
				end
				local exitPosition = exit:GetAbsOrigin()
				-- Teleport the hero
				FindClearSpaceForUnit( hUnit, exitPosition, true );

				local tpEffects = ParticleManager:CreateParticle( "particles/waypoint/waypoint_ground_flash_holo.vpcf", PATTACH_ABSORIGIN, hUnit )
				ParticleManager:SetParticleControlEnt( tpEffects, PATTACH_ABSORIGIN, hUnit, PATTACH_ABSORIGIN, "attach_origin", hUnit:GetAbsOrigin(), true )
				hUnit:Attribute_SetIntValue( "effectsID", tpEffects )

				PlayerResource:SetCameraTarget( player, hUnit )
				StartSoundEvent( "Waypoint.Appear", hUnit )
				hUnit:SetContextThink( "KillSetCameraTarget", function() return PlayerResource:SetCameraTarget( player, nil ) end, 0.2 )
				hUnit:SetContextThink( "KillTPEffects", function() return ParticleManager:DestroyParticle( tpEffects, true ) end, 3 )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- trigger_end_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short
--------------------------------------------------------------------------------

function CNemestice:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
	--print(szTriggerName)
end


--------------------------------------------------------------------------------

function CNemestice:OnGameFinished( event )

	printf( "[Nemestice] OnGameFinished: winningteam=%d", event["winningteam"] )

	-- Update battlepass points in both tables
	local nMinPoints = 9999999
	local nMaxPoints = 0
	local nPlayers = 0
	local nPointTotal = 0
	for nPlayerID,v in pairs( self.SignOutTable[ "player_list" ] ) do
		nPlayers = nPlayers + 1

		v.bp_remaining = self:GetPointsCapRemaining( nPlayerID, false )
		v.bp_total_cap = self:GetPointsCapRemaining( nPlayerID, true )
			
		local nBPoints = v.battle_points
		nPointTotal = nPointTotal + nBPoints
		if nBPoints > nMaxPoints then
			nMaxPoints = nBPoints
		end
		if nBPoints < nMinPoints then
			nMinPoints = nBPoints
		end

		if self.EventMetaData[nPlayerID] ~= nil then
			self.EventMetaData[nPlayerID].battle_points = nBPoints
			self.EventMetaData[nPlayerID].bp_remaining = v.bp_remaining
			self.EventMetaData[nPlayerID].bp_total_cap = v.bp_total_cap
		end
	end
	local nPointAverage = 0
	if nPlayers > 0 then
		nPointAverage = math.floor( nPointTotal / nPlayers + 0.5 )
	end
	if nMinPoints >= 9999999 then
		nMinPoints = 0
	end

	self.SignOutTable[ "points_min" ] = nMinPoints
	self.SignOutTable[ "points_max" ] = nMaxPoints
	self.SignOutTable[ "points_average" ] = nPointAverage

	self:AddResultToMetadata( event )
	self:AddResultToSignOut( event )

	print( "[Nemestice] Metadata Table:" )
	PrintTable( self.EventMetaData, " " )
	GameRules:SetEventMetadataCustomTable( self.EventMetaData )

	print( "[Nemestice] Signout Table:" )
	PrintTable( self.SignOutTable, " " )
	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
end

--------------------------------------------------------------------------------

function CNemestice:AddResultToMetadata( event )
	local orderedTimes = {}
	for timeKey, towerHealths in pairs(self.m_vecTowerHealthHistory) do
		table.insert( orderedTimes, timeKey )
	end
	table.sort( orderedTimes )
	self.EventMetaData[ "towers" ] = self.m_vecTowerOwnershipHistory
	self.EventMetaData[ "towers_health" ] = self.m_vecAllTowersPercentHealthHistory
	self.EventMetaData[ "glyphs" ] = self.m_vecGlyphHistory
end

--------------------------------------------------------------------------------

function CNemestice:AddResultToSignOut( event )
	self.SignOutTable[ "game_time" ] = self:GetPlayedTime()
	self.SignOutTable[ "winning_team" ] = event[ "winningteam" ]
	self.SignOutTable[ "winning_team_towers" ] = self:GetTowersControlledBy( event[ "winningteam" ] )
	self.SignOutTable[ "first_tower_fall_time" ] = self.m_nfirstTowerFallTime
	self.SignOutTable[ "event_window_start_time" ] = GameRules:GetGameModeEntity():GetEventWindowStartTime()
	self.SignOutTable[ "glyphs_used_radiant" ] = self.m_tGlyphsUsed[ DOTA_TEAM_GOODGUYS ]
	self.SignOutTable[ "glyphs_used_dire" ] = self.m_tGlyphsUsed[ DOTA_TEAM_BADGUYS ]
	self.SignOutTable[ "shrines_used_radiant" ] = self.m_tShrinesUsed[ DOTA_TEAM_GOODGUYS ]
	self.SignOutTable[ "shrines_used_dire" ] = self.m_tShrinesUsed[ DOTA_TEAM_BADGUYS ]

	self.SignOutTable[ "tower_deaths" ] = {}
	for sName,tCreepSpawner in pairs ( self.tCreepSpawners ) do
		local nIndex = -1
		for k,v in pairs( _G.NEMESTICE_SCOREBOARD_TOWER_ORDER ) do
			if v == sName then
				nIndex = k
				break
			end
		end
		if nIndex >= 0 then
			self.SignOutTable[ "tower_deaths" ][nIndex] = {
				index = nIndex,
				death_time = tCreepSpawner[ "death_time" ] or 0
			}
		end
	end

	self.SignOutTable["banned_heroes"] = {}
	local nBanIdx = 0
	local tBanHeroTable = GameRules:GetBannedHeroIDs()
	for _,v in ipairs( tBanHeroTable ) do
		self.SignOutTable["banned_heroes"][ ( "ban" .. nBanIdx ) ] = { hero_id = v }
		nBanIdx = nBanIdx + 1
	end

	for nPlayerID,v in pairs( self.SignOutTable[ "player_list" ] ) do
		v.kills = PlayerResource:GetKills( nPlayerID )
		v.death_count = PlayerResource:GetDeaths( nPlayerID )
		v.level = PlayerResource:GetLevel( nPlayerID )
		v.net_worth = PlayerResource:GetNetWorth( nPlayerID )
	end
end

---------------------------------------------------------
-- dota_item_picked_up
-- * PlayerID
-- * HeroEntityIndex
-- * UnitEntityIndex (only if parent is not a hero)
-- * itemname
-- * ItemEntityIndex
---------------------------------------------------------

function CNemestice:OnItemPickedUp( event )
	local hPickup = EntIndexToHScript( event.ItemEntityIndex )
	local hHero = nil
	if event.HeroEntityIndex ~= nil then
		hHero = EntIndexToHScript( event.HeroEntityIndex )
	else
		hHero = EntIndexToHScript( event.UnitEntityIndex )
	end
	if hPickup ~= nil and hPickup:IsNull() == false and hHero ~= nil and hHero:IsNull() == false then
		-- This event handler was disabled, so in reenabling it I have disabled this code.
		--[[if hPickup:GetAbilityName() == "item_meteor_shard" then
			hPickup:SetPurchaser( hHero )
		end--]]
		if hPickup.nNeutralItemTeamNumber ~= nil then
			local nHeroTeamNumber = hHero:GetTeamNumber()
			--printf( "Found nNeutralItemTeamNumber = %d, pickup hero team %d", hPickup.nNeutralItemTeamNumber, nHeroTeamNumber )
			if hPickup.nNeutralItemTeamNumber ~= nHeroTeamNumber then
				self:GrantTeamBattlePoints( nHeroTeamNumber, _G.BATTLE_POINT_DROP_NEUTRAL_STEAL, "neutral_steal" )
			end
		end
	end
end

---------------------------------------------------------
-- dota_player_used_ability
-- * PlayerID
-- * abilityname
-- * caster_entindex
---------------------------------------------------------
function CNemestice:OnPlayerAbilityUsed( event )
end

---------------------------------------------------------
-- dota_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------
function CNemestice:OnNonPlayerUsedAbility( event )
	local hCaster = EntIndexToHScript( event.caster_entindex )
	if hCaster ~= nil and hCaster:IsNull() == false and hCaster.nLastCastingPlayerID ~= nil then
		local hAbility = hCaster:FindAbilityByName( event.abilityname )
		if hAbility ~= nil and hAbility:IsNull() == false then
			hCaster:SetControllableByPlayer( -1, true )
		end
	end
end

