--------------------------------------------------------------------------------

require( "winter2022_constants" )
require( "winter2022_triggers" )

--------------------------------------------------------------------------------

function CWinter2022:RegisterGameEvents()
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CWinter2022, "ModifyGoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(CWinter2022, "ModifyExperienceFilter" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CWinter2022, "ExecuteOrderFilter" ), self )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", WINTER2022_THINK_INTERVAL )
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CWinter2022, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CWinter2022, "OnTriggerStartTouch" ), self )
 	ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( CWinter2022, "OnTriggerEndTouch" ), self )
-- 	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( CWinter2022, 'OnPlayerConnected' ), self )
 	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CWinter2022, 'OnPlayerReconnected' ), self )
-- 	ListenToGameEvent( "hero_selected", Dynamic_Wrap( CWinter2022, 'OnHeroSelected' ), self )
	ListenToGameEvent( "player_disconnect", Dynamic_Wrap( CWinter2022, 'OnPlayerDisconnect' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CWinter2022, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CWinter2022, 'OnEntityKilled' ), self )
 	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CWinter2022, "OnPlayerGainedLevel" ), self )
-- 	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CWinter2022, "OnItemPickedUp" ), self )
-- 	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CWinter2022, "OnPlayerBuyback" ), self )
-- 	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CWinter2022, "OnItemSpawned" ), self )
-- 	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CWinter2022, "OnItemPurchased" ), self )
-- 	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CWinter2022, "OnNonPlayerUsedAbility" ), self ) 	
-- 	ListenToGameEvent( "dota_hero_entered_shop", Dynamic_Wrap( CWinter2022, "OnHeroEnteredShop" ), self )
-- 	ListenToGameEvent( "dota_player_team_changed", Dynamic_Wrap( CWinter2022, "OnPlayerTeamChanged" ), self )
	ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CWinter2022, 'OnEntityHurt' ), self )
	ListenToGameEvent( "player_chat", Dynamic_Wrap( CWinter2022, 'OnPlayerChat' ), self )
	ListenToGameEvent( "dota_glyph_used", Dynamic_Wrap( CWinter2022, 'OnGlyphUsed' ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( CWinter2022, "OnGameFinished" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CWinter2022, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CWinter2022, "OnPlayerHeroInitialSpawnComplete" ), self )
	
	CustomGameEventManager:RegisterListener( "mount_choice", function(...) return self:OnMountChoice( ... ) end )
end

--------------------------------------------------------------------------------
-- Gold Filter
-- > player_id_const - int
-- > gold - int
-- > reliable - bool
-- > reason_const - int
--------------------------------------------------------------------------------

function CWinter2022:ModifyGoldFilter( filterTable )
	-- bypass check if our override is set (this is because we want to use Unspecified for giving gold
	-- as reward, but there are other things that use it that we don't want to let through.
	if self.bLetGoldThrough == true 
		and ( filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified
			or filterTable[ "reason_const" ] == DOTA_ModifyGold_NeutralKill ) then
		return true
	end

	-- if the reason is Unspecified BUT the source is a dead unit
	-- it's a kill bounty and we let it through (fixes veno wards, serpent wards, etc)
	if filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified then
		local hCreep = EntIndexToHScript( filterTable[ "source_entindex_const" ] )
		if hCreep ~= nil and hCreep:IsNull() == false and hCreep:IsAlive() == false then
			return true
		end
	end

	-- No gold on creep kills, ward kills, etc.
	if filterTable[ "reason_const" ] == DOTA_ModifyGold_RoshanKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_WardKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified -- this handles a bunch of things. Hope it doesn't break anything!
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_CreepKill
	then
		filterTable["gold"] = 0 -- no gold unless we give it to you; for now.
		return false
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyGold_NeutralKill then
		local hCreep = EntIndexToHScript( filterTable[ "source_entindex_const" ] )
		if hCreep ~= nil and hCreep:IsNull() == false and hCreep.bIsGolem == true then
			-- Golem has special handling
			filterTable["gold"] = 0
			return false
		else
			filterTable["gold"] = math.ceil( filterTable["gold"] * _G.WINTER2022_REWARD_NEUTRAL_MULTIPLIER_GOLD )
			return true
		end
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyGold_GameTick
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_Building
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_CreepKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_WardKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_BountyRune
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_AbilityGold
	then
		filterTable["gold"] = math.ceil( filterTable["gold"] * _G.WINTER2022_REWARD_OUT_OF_BAND_GOLD )

		if filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill then
			filterTable["gold"] = math.ceil( filterTable["gold"] * _G.WINTER2022_HERO_KILL_GOLD_MULTIPLIER )
		end
	end

	--self:UpdateResourceStats( "tGoldStats", filterTable["player_id_const"], filterTable["gold"], WINTER2022_GOLD_REASON_LABELS[filterTable["reason_const"]] )

	return true
end

--------------------------------------------------------------------------------
-- Experience Filter
-- > player_id_const - int
-- > hero_entindex_const - int
-- > experience - float
-- > reason_const - int
--------------------------------------------------------------------------------

function CWinter2022:ModifyExperienceFilter( filterTable )
	if self.bLetXPThrough == true then
		return true
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_TomeOfKnowledge then
		return true
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_CreepKill then
		local hCreep = EntIndexToHScript( filterTable[ "source_entindex_const" ] )
		if hCreep ~= nil and hCreep:IsNull() == false and hCreep:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			if hCreep.bIsGolem then
				-- Golem gets special handling
				filterTable[ "experience" ] = 0
				return false
			else
				filterTable[ "experience" ] = math.ceil( filterTable[ "experience" ] * _G.WINTER2022_REWARD_NEUTRAL_MULTIPLIER_XP )
				return true
			end
		end
		return true
	end

	filterTable["experience"] = math.ceil( filterTable["experience"] * _G.WINTER2022_REWARD_OUT_OF_BAND_XP )
	

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_HeroKill then
		local nXPSelf = math.ceil( filterTable[ "experience" ] * _G.WINTER2022_HERO_KILL_XP_MULTIPLIER_SELF )
		local nXPOthers = math.ceil( filterTable[ "experience" ] * _G.WINTER2022_HERO_KILL_XP_MULTIPLIER_OTHERS )
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
-- Order Filter
-- > issuer_player_id_const - int
-- > sequence_number_const - int
-- > order_type - int
-- > entindex_target - int
-- > entindex_ability - int
-- > shop_item_name - string
-- > queue - bool
-- > position_x - float
-- > position_y - float
-- > position_z - float
--------------------------------------------------------------------------------
function CWinter2022:ExecuteOrderFilter( filterTable )
	local orderType = filterTable["order_type"]

	-- If we are riding a mount, we can't attack. So interpret as a move to target instead
	if orderType == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local hTarget = EntIndexToHScript(filterTable["entindex_target"])
		if hTarget and hTarget:IsNull() == false then
			local hUnits = filterTable["units"]
			local nHeroEntIndex = -1

			for _, unit in pairs( hUnits ) do
				local hUnit = EntIndexToHScript(unit)
				if hUnit ~= nil and hUnit:IsNull() == false and hUnit:IsRealHero() and hUnit:HasModifier("modifier_mounted") then
					nHeroEntIndex = unit
				end
			end
			
			if nHeroEntIndex > 0 then
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_TARGET

				-- If we are simultaneously ordering other units, need to give them a new order so that they still attack normally
				for _, unit in pairs( hUnits ) do
					if unit ~= nHeroEntIndex then
						ExecuteOrderFromTable( {
							UnitIndex = unit,
							OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
							TargetIndex = filterTable["entindex_target"],
						} )
					end
				end

				filterTable["units"] = { nHeroEntIndex }
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - long
-- > damage - float
--------------------------------------------------------------------------------

function CWinter2022:OnEntityHurt( event )
	local hHurtUnit = EntIndexToHScript( event.entindex_killed )
	local hAttacker = nil
	
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end
end

--------------------------------------------------------------------------------
-- player_chat
-- > teamonly - bool
-- > userid - int
-- > playerid - int
-- > text - string
--------------------------------------------------------------------------------

function CWinter2022:OnPlayerChat( event )
	local nPlayerID = event.playerid
	if nPlayerID == -1 then
		return
	end

	local sChatMsg = event.text

	--[[
	if sChatMsg:find( '^-restart$' ) then
		self:RestartGameCheatCommand()
	elseif sChatMsg:find( '^-allrounds$' ) then
		self.bPlayAllRounds = true
		Say( nil, 'Forcing all rounds to be played.', false )
	elseif sChatMsg:find( '^-end$' ) then
		if self.m_GameState == _G.WINTER2022_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
			self:StartRound()
		end
		if self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] > self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] then
			self:EndRound( DOTA_TEAM_BADGUYS )
		else
			self:EndRound( DOTA_TEAM_GOODGUYS )
		end
	else
	]]--
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
	end
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 	PlayerID
--------------------------------------------------------------------------------
function CWinter2022:OnPlayerDisconnect( event )
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
-- 	PlayerID
--------------------------------------------------------------------------------
function CWinter2022:OnPlayerReconnected( event )
	local nPlayerID = event.PlayerID
	if nPlayerID == nil or nPlayerID == -1 then
		return
	end

	local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hHero ~= nil and hHero:IsNull() == false then
		for _,hBuffName in pairs( _G.WINTER2022_MOUNT_CHOICES ) do
			if hHero:HasModifier("modifier_mount_" .. hBuffName) then
				return
			end
		end
		
        CustomNetTables:SetTableValue( "mount_choices", tostring(nPlayerID), _G.WINTER2022_MOUNT_CHOICES )
	end
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- npc_spawned
-- * entindex
--------------------------------------------------------------------------------

function CWinter2022:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit == nil then
		return
	end

	if spawnedUnit:IsHero() then
		if spawnedUnit:IsRealHero() then
			self:OnNPCSpawned_PlayerHero( event )
			return
		else
			-- Illusions should display the main hero's candy count
			local hRealHero = PlayerResource:GetSelectedHeroEntity( spawnedUnit:GetPlayerOwnerID() ) 
			spawnedUnit:AddNewModifier(hRealHero, nil, "modifier_hero_candy_bucket", {})
		end
	end
end

--------------------------------------------------------------------------------

function GetCandyCount( hHero )
	if hHero == nil or hHero:IsNull() then
		return 0
	end
	return hHero:GetModifierStackCount( "modifier_hero_candy_bucket", nil )
end

--------------------------------------------------------------------------------

function CWinter2022:OnNPCSpawned_PlayerHero( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	if self.hRoshan ~= nil and self.hRoshan.vecLastTargets ~= nil then
		local flTime = GameRules:GetDOTATime( false, true ) + _G.WINTER2022_ROSHAN_HERO_TARGET_SPAWN_IMMUNITY_TIME
		if self.hRoshan.vecLastTargets[hPlayerHero] == nil then
			self.hRoshan.vecLastTargets[hPlayerHero] = flTime
		else
			self.hRoshan.vecLastTargets[hPlayerHero] = math.max( self.hRoshan.vecLastTargets[hPlayerHero], flTime )
		end
	end

	if hPlayerHero.bFirstSpawnComplete == nil then
		hPlayerHero.bResetBuyback = true
		local hBucketAbility = hPlayerHero:FindAbilityByName( "hero_candy_bucket" )
		if hBucketAbility then
			hBucketAbility:SetCandy( 0 )
		end
		
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_hero_respawn_time", { } )

		if hPlayerHero:GetOwnerEntity().mount_choice ~= nil then
			-- just meepo things
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_mount_" .. hPlayerHero:GetOwnerEntity().mount_choice, {} )
		end
		
		hPlayerHero.GetCandyCount = GetCandyCount

		hPlayerHero.bFirstSpawnComplete = true

		local nPlayerID = hPlayerHero:GetPlayerOwnerID()
		self.EventMetaData[nPlayerID] = {}
		--self.EventMetaData[nPlayerID]["kills"] = 0
		self.EventMetaData[nPlayerID]["candy_picked_up"] = 0
		self.EventMetaData[nPlayerID]["candy_scored"] = 0
		self.EventMetaData[nPlayerID]["candy_lost"] = 0
		self.EventMetaData[nPlayerID]["candy_fed"] = 0
		self.EventMetaData[nPlayerID]["candy_dropped"] = 0
		self.EventMetaData[nPlayerID]["team_id"] = hPlayerHero:GetTeamNumber()
		--self.EventMetaData[nPlayerID]["level"] = 1
		--self.EventMetaData[nPlayerID]["net_worth"] = 0
	else
		if not hPlayerHero:IsReincarnating() then
			self:GetTeamAnnouncer( hPlayerHero:GetTeamNumber() ):OnHeroRespawn( hPlayerHero )

			local hCandyBucket = hPlayerHero:FindAbilityByName( "hero_candy_bucket" )
			if hCandyBucket ~= nil then
				hCandyBucket:SetCandy( 0 )
			end
		end

		-- Heroes were spawning with missing health when they had died with the candy max hp debuff.
		-- Seemed to be due to timing of when their max hp changed.
		hPlayerHero:CalculateStatBonus( false )

		local flHealAmount = hPlayerHero:GetMaxHealth()
		hPlayerHero:Heal( flHealAmount, hPlayerHero )
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

function CWinter2022:OnPlayerHeroInitialSpawnComplete( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	--print( "OnPlayerHeroInitialSpawnComplete" )

	local hTPScroll = hPlayerHero:FindItemInInventory( "item_tpscroll" )
	if hTPScroll then
		hTPScroll:EndCooldown()
	end

	-- level up on initial spawn
	for i=1, WINTER2022_NUM_INITIAL_SPAWN_LEVEL_UPS do
		hPlayerHero:HeroLevelUp( false )
	end

	-- if player is a bot, assign a mount
	local nPlayerID = hPlayerHero:GetPlayerOwnerID()
	if self.m_bFillWithBots and PlayerResource:IsFakeClient( nPlayerID ) then
		if self.nBotMountIndex == nil then
			self.nBotMountIndex = 1
		end

		print("BOT PLAYERID: "..nPlayerID.." for "..hPlayerHero:GetUnitName())
		self:GrantMount(nPlayerID, hPlayerHero, _G.WINTER2022_MOUNT_CHOICES[self.nBotMountIndex])
		self.nBotMountIndex = ( self.nBotMountIndex % #(_G.WINTER2022_MOUNT_CHOICES) ) + 1
	else
		hPlayerHero:AddNewModifier( hHero, nil, "modifier_hero_selecting_mount", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - long
--------------------------------------------------------------------------------

function CWinter2022:OnEntityKilled( event )
	local hKilledUnit = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )

	if hKilledUnit ~= nil then
		printf( "CWinter2022:OnEntityKilled - unit killed %s", hKilledUnit:GetUnitName() )
	end

	-- death vo
	if hKilledUnit ~= nil and hKilledUnit:IsNull() == false then
		local hAnnouncer = self:GetTeamAnnouncer( hKilledUnit:GetTeamNumber() )
		if hAnnouncer ~= nil then	-- announcer may be nil when a neutral unit is killed!
			hAnnouncer:OnDeath( hKilledUnit, hAttacker )
		end

		if hKilledUnit:IsRealHero() then
			self:OnEntityKilled_PlayerHero( event )
			return
		end
	end

	-- kill vo
	if hAttacker ~= nil and hAttacker:IsNull() == false then
		local hAnnouncer = self:GetTeamAnnouncer( hAttacker:GetTeamNumber() )
		if hAnnouncer ~= nil then	-- announcer may be nil if a neutral unit gets a kill!
			hAnnouncer:OnKill( hAttacker, hKilledUnit )
		end
	end


	if self.m_GameState == _G.WINTER2022_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
		return
	end
	
	if self.bPassThroughKillEvent ~= true and self:IsGameInProgress() ~= true then
		return
	end

	-- XP, Gold, Lasthit sound and particle
	if hAttacker ~= nil and hAttacker:IsNull() == false and hKilledUnit ~= nil and hKilledUnit:IsNull() == false then
		local nKilledTeamNumber = hKilledUnit:GetTeamNumber()
		if hKilledUnit.Winter2022_bIsCore == true or hKilledUnit.Holdout_IsNPCSpawnedUnit == true then
			local nKillerTeam = hAttacker:GetTeamNumber()
			if ( nKillerTeam == DOTA_TEAM_GOODGUYS or nKillerTeam == DOTA_TEAM_BADGUYS ) then
				-- Candy first.
				if _G.WINTER2022_CREEPS_DROP_CANDY == true and hKilledUnit.nCandy ~= nil and hKilledUnit.nCandy > 0 then
					-- special clause here for suiciding exploders - if you kill yourself it should not be counted as a deny
					--local bDeny = hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:GetTeamNumber() == hKilledUnit:GetTeamNumber() and hAttacker:GetEntityIndex() ~= hKilledUnit:GetEntityIndex()
					local bDeny = false -- ignore deny logic for now.
					if bDeny == false then
						local nNumCandy = hKilledUnit.nCandy
						local nCandyMult = Convars:GetInt( "winter2022_candymult" ) or 1
						if nCandyMult > 1 then
							nNumCandy = nNumCandy * nCandyMult
						end

						local nNumBigBags = math.floor( nNumCandy / _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG )
						if nNumBigBags > 0 then
							nNumCandy = nNumCandy - nNumBigBags * _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG
							for i = 1, nNumBigBags do
								GameRules.Winter2022:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hKillerUnit, true, 1.0 )
							end
						end
						for i = 1, nNumCandy do
							GameRules.Winter2022:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hKillerUnit, false, 1.0 )
						end
					end

					-- Clean up, just in case
					hKilledUnit.nCandy = nil
				end
				-- Rewards
				-- Set base reward mults
				local flGoldMult = _G.WINTER2022_REWARD_BASE_GOLD
				local flXPMult = _G.WINTER2022_REWARD_BASE_XP
				local flGoldSelf = 0
				local flXPSelf = 0
				local bShowLasthit = false
				local bShowDeny = false
				local bHasNearbyGold = false

				if nKillerTeam == hKilledUnit:GetTeamNumber() then
					if hAttacker:GetPlayerOwner() ~= nil then
						flGoldMult = _G.WINTER2022_REWARD_DENY_MULTIPLIER_GOLD
						flXPMult = _G.WINTER2022_REWARD_DENY_MULTIPLIER_XP
						bShowDeny = true
						-- Using normal deny particle, see below
						--EmitSoundOnClient( "Lasthit.Dead", hAttacker:GetPlayerOwner() )
						--print("Deny")
					end
				else
					-- Is it a hero lasthit?
					if hAttacker:GetPlayerOwner() ~= nil then
						flGoldMult = _G.WINTER2022_REWARD_LASTHIT_GOLD
						flXPMult = _G.WINTER2022_REWARD_LASTHIT_XP
						flGoldSelf = _G.WINTER2022_REWARD_LASHIT_GOLD_SELF_PORTION
						flXPSelf = _G.WINTER2022_REWARD_LASHIT_XP_SELF_PORTION
						bShowLasthit = true
						bHasNearbyGold = true
						-- Using normal gold particle, see below.
						--EmitSoundOnClient( "LastHit.Creature", hAttacker:GetPlayerOwner() )
						--ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/dark_moon/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hKilledUnit, hAttacker:GetPlayerOwner() ) )
						--print("Creep killed by lasthit")
					else
						-- Otherwise, check if there's a nearby hero.
						local tNearbyHeroes = FindUnitsInRadius( nKillerTeam, hKilledUnit:GetAbsOrigin(), nil, _G.WINTER2022_REWARD_HERO_RADIUS, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
						if #tNearbyHeroes > 0 then
							flGoldMult = _G.WINTER2022_REWARD_NEAR_GOLD
							flXPMult = _G.WINTER2022_REWARD_NEAR_XP
							bHasNearbyGold = true
							--print("Creep killed, hero nearby")
						--else
							--print("Creep killed, and no one was there to see it")
						end
					end
				end
				--printf( "Creep %s killed by %s. Final mults gold=%f, XP=%f (self gold=%f, XP=%f)", hKilledUnit:GetUnitName(), hAttacker:GetUnitName(), flGoldMult, flXPMult, flGoldSelf, flXPSelf )

				local flSizeMult = 1.0 -- 1.75 - self.m_nNumHeroesPerTeam * 0.15
				flGoldMult = flGoldMult * _G.WINTER2022_REWARD_MULTIPLIER_GOLD * flSizeMult
				flXPMult = flXPMult * _G.WINTER2022_REWARD_MULTIPLIER_XP * flSizeMult

				-- Explicitly use bounties
				local nTotalGold = math.ceil( ( hKilledUnit.nBountyGold or hKilledUnit:GetGoldBounty() ) * flGoldMult )
				local nTotalXP = math.ceil( ( hKilledUnit.nBountyXP or hKilledUnit:GetDeathXP() ) * flXPMult )

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

				--printf( "  --results: Team gold=%d, XP=%d; self gold=%d, XP=%d (from gold=%d, xp=%d", nTeamGold, nTeamXP, nSelfGold, nSelfXP, nTotalGold, nTotalXP )

				self:GrantGoldAndXPToTeam( nKillerTeam, nTeamGold, nTeamXP, bHasNearbyGold and "nearcreep" or "lonecreep" )
				if nSelfGold > 0 or nSelfXP > 0 then
					--printf("Granting extra gold and XP to hero %s, gold %d, team %d / xp %d, team %d", hAttacker:GetUnitName(), nSelfGold, nTeamGold, nSelfXP, nTeamXP )
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
		elseif nKilledTeamNumber == DOTA_TEAM_NEUTRALS then
			local nKillerTeam = hAttacker:GetTeamNumber()
			if ( nKillerTeam == DOTA_TEAM_GOODGUYS or nKillerTeam == DOTA_TEAM_BADGUYS ) then
				if hKilledUnit.bIsGolem == true then
					self:OnGolemKilled( hKilledUnit, hAttacker )
				elseif _G.WINTER2022_CREEPS_DROP_CANDY == true then
					local nNumCandy = 1	-- TODO: each creep should have a different candy value?
					if hKilledUnit:IsAncient() then
						nNumCandy = 2
					end
					if hKilledUnit:IsSummoned() then
						nNumCandy = 0
					end
					
					GameRules.Winter2022.SignOutTable["stats"].CandyCounts.generated_neutral = GameRules.Winter2022.SignOutTable["stats"].CandyCounts.generated_neutral + nNumCandy

					local nNumBigBags = math.floor( nNumCandy / _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG )
					if nNumBigBags > 0 then
						nNumCandy = nNumCandy - nNumBigBags * _G.WINTER2022_CANDY_COUNT_IN_CANDY_BAG
						for i = 1, nNumBigBags do
							GameRules.Winter2022:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hKillerUnit, true, 1.0 )
						end
					end
					for i = 1, nNumCandy do
						GameRules.Winter2022:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hKillerUnit, false, 1.0 )
					end
				end
			end
		end
	end

	if hKilledUnit:IsBuilding() then

		print( 'BUILDING DESTROYED NAMED ' .. hKilledUnit:GetName() )
		local nBuildingTeamNumber = hKilledUnit:GetTeamNumber()

		local nCandy = 0
		if nBuildingTeamNumber == DOTA_TEAM_GOODGUYS or nBuildingTeamNumber == DOTA_TEAM_BADGUYS then
			print( 'REDUCING NUMBER OF REMAINING BUCKETS FOR ' .. nBuildingTeamNumber .. '. CURRENTLY AT ' .. self.tRemainingCandyBuckets[ nBuildingTeamNumber ] )
			self.tRemainingCandyBuckets[ nBuildingTeamNumber ] = self.tRemainingCandyBuckets[ nBuildingTeamNumber ] - 1
			print( 'NOW DOWN TO ' .. self.tRemainingCandyBuckets[ nBuildingTeamNumber ] )

			hKilledUnit:AddEffects( EF_NODRAW )
			local nFXIndex = ParticleManager:CreateParticle( "particles/destruction/candy_well_destruction.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, hKilledUnit:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitGlobalSound( "NeutralBucket.Destroyed" )

			CustomNetTables:SetTableValue( "candy_buckets", hKilledUnit:GetName(), { is_alive = false, is_invulnerable = false, total_candy = 0 } )
			self:UpdateCandyLeaderBuilding( false )
			self.m_nTeamScore[ FlipTeamNumber( nBuildingTeamNumber ) ] = self.m_nTeamScore[ FlipTeamNumber( nBuildingTeamNumber ) ] + 1

			if hAttacker and hAttacker:IsOwnedByAnyPlayer() then
				local hAttackerHero = nil
				if hAttacker:IsRealHero() then
					hAttackerHero = hAttacker
				else
					local hPlayer = hAttacker:GetPlayerOwner()
					if hPlayer then
						hAttackerHero = hPlayer:GetAssignedHero()
					end
				end

				--[[
				if hAttackerHero ~= nil then
					if self.bAwardedFirstCandyWellKill == false then
						PlayerResource:AddCandyEvent( hAttackerHero:GetPlayerID(), 6 )	-- k_ECandyReasonEventGameCandyWellDestroyed
						self.bAwardedFirstCandyWellKill = true
					end
				end
				]]--
			end

			-- Reset glyph
			if _G.WINTER2022_RESET_GLYPH_ON_WELL_DESTROY == true then
				GameRules:SetGlyphCooldown( nBuildingTeamNumber, 0.0 )
			end

			-- Deal with invulnerability
			local hBuildingToRemoveInvuln = nil
			local szMessage = ""
			local hBuildings = FindUnitsInRadius( nBuildingTeamNumber, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
			print( 'SEARCHING FOR BUILDINGS' )
			for _, building in ipairs( hBuildings ) do
				print( 'BUILDING == ' .. building:GetName() )
				if hKilledUnit:GetName() == "radiant_candy_bucket_2" then
					if building:GetName() == "radiant_candy_bucket_1" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2TopVulnerableGood_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "radiant_candy_bucket_1" then
					if building:GetName() == "radiant_candy_bucket_4" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2BotVulnerableGood_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "radiant_candy_bucket_5" then
					if building:GetName() == "radiant_candy_bucket_4" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2BotVulnerableGood_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "radiant_candy_bucket_4" then
					if building:GetName() == "radiant_candy_bucket_1" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2TopVulnerableGood_Toast"
						break
					end

				elseif hKilledUnit:GetName() == "dire_candy_bucket_2" then
					if building:GetName() == "dire_candy_bucket_1" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2TopVulnerableBad_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "dire_candy_bucket_1" then
					if building:GetName() == "dire_candy_bucket_4" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2BotVulnerableBad_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "dire_candy_bucket_5" then
					if building:GetName() == "dire_candy_bucket_4" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2BotVulnerableBad_Toast"
						break
					end
				elseif hKilledUnit:GetName() == "dire_candy_bucket_4" then
					if building:GetName() == "dire_candy_bucket_1" then
						hBuildingToRemoveInvuln = building
						szMessage = "#DOTA_HUD_CandyWellTier2TopVulnerableBad_Toast"
						break
					end
				--[[else
					if building:GetUnitName() == "home_candy_bucket" then
						hBuildingToRemoveInvuln = building
						if nBuildingTeamNumber == DOTA_TEAM_GOODGUYS then
							szMessage = "#DOTA_HUD_CandyBucketVulnerableGood_Toast"
						else
							szMessage = "#DOTA_HUD_CandyBucketVulnerableBad_Toast"
						end
						break
					end]]--
				end
			end

			if hBuildingToRemoveInvuln ~= nil then
				print( 'FOUND A BUILDING TO REMOVE INVULNERABILITY FROM - ' .. hBuildingToRemoveInvuln:GetName() )
				local hBuff = hBuildingToRemoveInvuln:FindModifierByName( "modifier_candy_bucket_invulnerable" )

				if hBuff then
					--print("-------- Found buff" )
					hBuildingToRemoveInvuln:RemoveModifierByName( "modifier_candy_bucket_invulnerable" )
					
					local gameEvent = {}
					gameEvent["teamnumber"] = -1
					gameEvent["message"] = szMessage
					FireGameEvent( "dota_combat_event_message", gameEvent )
					GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, hBuildingToRemoveInvuln:GetOrigin().x, hBuildingToRemoveInvuln:GetOrigin().y, hBuildingToRemoveInvuln, 0 )
					GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, hBuildingToRemoveInvuln:GetOrigin().x, hBuildingToRemoveInvuln:GetOrigin().y, hBuildingToRemoveInvuln, 0 )
					EmitGlobalSound( "CandyBucket.Vulnerable" )
				end
			end
			local nBucketsRemaining = self:GetRemainingCandyBuckets( nBuildingTeamNumber )
			if nBucketsRemaining >= 1 then
				self:GetTeamAnnouncer( nBuildingTeamNumber ):OnWellLost( nBucketsRemaining )
				local nFlippedTeam = FlipTeamNumber( nBuildingTeamNumber )
				self:GetTeamAnnouncer( nFlippedTeam ):OnWellLostEnemy( nBucketsRemaining )
			end

			if WINTER_2022_REFRESH_GOLEMS_AFTER_SCORING == 1 then
				for _, building in ipairs( hBuildings ) do
					print( 'REFRESHING GOLEMS FOR BUILDING ' .. building:GetName() )
					local hBuff = building:FindModifierByName( 'modifier_candy_bucket_soldiers' )
					if hBuff ~= nil then
						hBuff:RefreshSoldiers()
					end
				end
			end

			-- wipe score for scoring team
			if WINTER2022_WIPE_SCORED_CANDY_AFTER_SCORING == 1 then
				for _, building in ipairs( hBuildings ) do
					print( 'BUILDING == ' .. building:GetName() )
					local hBuildingBucket = building:FindAbilityByName( "building_candy_bucket" )
					if hBuildingBucket ~= nil then
						hBuildingBucket:SetCandy( 0 )
					end
				end
			end

			-- wipe held candy from all heroes
			if WINTER2022_WIPE_HELD_CANDY_AFTER_SCORING == 1 then
				self:ResetHeroCandy()
			end

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

function CWinter2022:OnEntityKilled_PlayerHero( event )
	local hKilledHero = EntIndexToHScript( event.entindex_killed )
	if hKilledHero == nil or hKilledHero:IsNull() == true or hKilledHero:IsRealHero() == false then
		return
	end

	local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )

	if self.m_flKillStreakAnnounceCooldown == nil or self.m_flKillStreakAnnounceCooldown <= GameRules:GetGameTime() then
		if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:GetPlayerOwner() ~= nil then
			local nPlayerID = hAttacker:GetPlayerOwner():GetPlayerID()
			if nPlayerID >= 0 then
				local nStreak = PlayerResource:GetStreak( nPlayerID )
				if nStreak > 1 then
					self.m_flKillStreakAnnounceCooldown = GameRules:GetGameTime() + _G.WINTER2022_ANNOUNCER_KILLING_SPREE_COOLDOWN
					self:GetTeamAnnouncer( hAttacker:GetTeamNumber() ):OnKillStreak( nStreak, nPlayerID, hKilledHero:GetPlayerID() )
					return
				end
			end
		end
	end

	-- kill vo
	local hAnnouncer = self:GetTeamAnnouncer( hAttacker:GetTeamNumber() )
	if hAnnouncer ~= nil then
		hAnnouncer:OnKill( hAttacker, hKilledHero )
	end
end

---------------------------------------------------------
-- game_rules_state_change
-- no parameters
---------------------------------------------------------

function CWinter2022:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	
	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self:AssignTeams()
	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		self:ForceAssignHeroes()
		if self.m_bFillWithBots == true then
			GameRules:BotPopulate()
		end
	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:OnGameStarted()
	elseif nNewState >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
end

---------------------------------------------------------
--no parameters
---------------------------------------------------------
function CWinter2022:OnGameStarted()
	self:SetTimeOfDay()

	-- Hackerino; modifier_invulnerable may be getting added by base dota code
	-- bucket 2 is in front, protecting bucket 1
	self:SetupCandyBucketByName( "radiant_candy_bucket_2", 1, false )
	self:SetupCandyBucketByName( "radiant_candy_bucket_1", 2, true )	
	
	-- bucket 3 has been removed
	--self:SetupCandyBucketByName( "radiant_candy_bucket_3", 3, false )

	-- bucket 5 is in front, protecting bucket 4
	self:SetupCandyBucketByName( "radiant_candy_bucket_5", 1, false )
	self:SetupCandyBucketByName( "radiant_candy_bucket_4", 2, true )

	-- bucket 2 is in front, protecting bucket 1
	self:SetupCandyBucketByName( "dire_candy_bucket_2", 1, false )
	self:SetupCandyBucketByName( "dire_candy_bucket_1", 2, true )
	
	-- bucket 3 has been removed
	--self:SetupCandyBucketByName( "dire_candy_bucket_3", 3, false )

	-- bucket 5 is in front, protecting bucket 4
	self:SetupCandyBucketByName( "dire_candy_bucket_5", 1, false )
	self:SetupCandyBucketByName( "dire_candy_bucket_4", 2, true )

	--[[self:SetupCandyBucketByName( "radiant_candy_bucket_top_1", 1, false )
	self:SetupCandyBucketByName( "radiant_candy_bucket_bot_1", 1, false )
	self:SetupCandyBucketByName( "radiant_candy_bucket_mid_1", 1, false )

	self:SetupCandyBucketByName( "dire_candy_bucket_top_1", 1, false )
	self:SetupCandyBucketByName( "dire_candy_bucket_bot_1", 1, false )
	self:SetupCandyBucketByName( "dire_candy_bucket_mid_1", 1, false )--]]

	self:SetupGreevilSpawnSchedule()

	self:GetGlobalAnnouncer():OnGameStarted()
end

--------------------------------------------------------------------------------
-- dota_player_gained_level
-- > player - short
-- > player_id - short
-- > level - short
-- > hero_entindex - short
-- > PlayerID - short
--------------------------------------------------------------------------------

function CWinter2022:OnPlayerGainedLevel( event )
end

--------------------------------------------------------------------------------
-- Glyph Used
-- > teamnumber - int
--------------------------------------------------------------------------------

function CWinter2022:OnGlyphUsed( event )
	local nTeam = event.teamnumber
	GameRules:SetGlyphCooldown( nTeam, _G.WINTER2022_GLYPH_COOLDOWN )

	local hUnits = FindUnitsInRadius( nTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, hUnit in ipairs( hUnits ) do
		if hUnit:GetUnitName() == "npc_dota_radiant_bucket_soldier" or hUnit:GetUnitName() == "npc_dota_dire_bucket_soldier" then
			if _G.WINTER2022_GLYPH_DURATION_GUARD > 0 then
				local kv = {
					duration = _G.WINTER2022_GLYPH_DURATION_GUARD,
				}
				hUnit:AddNewModifier( hUnit, nil, "modifier_fountain_glyph", kv )
			end
		elseif hUnit.Winter2022_bIsCore then
			if _G.WINTER2022_GLYPH_DURATION_CREEP > 0 then
				local kv = {
					duration = _G.WINTER2022_GLYPH_DURATION_CREEP,
				}
				hUnit:AddNewModifier( hUnit, nil, "modifier_fountain_glyph", kv )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- trigger_start_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short
--------------------------------------------------------------------------------

function CWinter2022:OnTriggerStartTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )	
	local szTriggerName = event.trigger_name
end

--------------------------------------------------------------------------------
-- trigger_end_touch
-- > trigger_name - string
-- > activator_entindex - short
-- > caller_entindex- short
--------------------------------------------------------------------------------

function CWinter2022:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
end


--------------------------------------------------------------------------------

function CWinter2022:OnGameFinished( event )

	printf( "[WINTER2022] OnGameFinished: winningteam=%d", event["winningteam"] )
--[[
	printf( "[WINTER2022] EventGameDetails table:" )
	if self.m_hEventGameDetails then
	    DeepPrintTable(self.m_hEventGameDetails)
	else
		printf("NOT FOUND!!")
	end
--]]	
	self:AddResultToSignOut( event )
	print( "[WINTER2022] Metadata Table:" )
	PrintTable( self.EventMetaData, " " )
	print( "[WINTER2022] Signout Table:" )
	PrintTable( self.SignOutTable, " " )
	GameRules:SetEventMetadataCustomTable( self.EventMetaData )
	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
end

--------------------------------------------------------------------------------
-- copy/paste from JungleSpirits TI9 event

function CWinter2022:AddResultToSignOut( event )
	self.SignOutTable["game_time"] = GameRules:GetDOTATime( false, true )
	self.SignOutTable[ "winning_team" ] = event[ "winningteam" ]
	self.SignOutTable["banned_heroes"] = {}

	local nBanIdx = 0
	local tBanHeroTable = GameRules:GetBannedHeroIDs()
	for _,v in ipairs( tBanHeroTable ) do
		self.SignOutTable["banned_heroes"][ ( "ban" .. nBanIdx ) ] = { hero_id = v }
		nBanIdx = nBanIdx + 1
	end

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local PlayerEventMetaData = self.EventMetaData[nPlayerID] or {}
			local PlayerStats = self.SignOutTable["stats"]["player_stats"][nPlayerID]
			PlayerStats["player_name"] = PlayerResource:GetPlayerName( nPlayerID )
			PlayerStats["hero_id"] = PlayerResource:GetSelectedHeroID( nPlayerID )
			PlayerStats["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			PlayerStats["kills"] = PlayerEventMetaData["kills"] or 0
			PlayerStats["candy_picked_up"] = PlayerEventMetaData["candy_picked_up"] or 0
			PlayerStats["candy_scored"] = PlayerEventMetaData["candy_scored"] or 0
			PlayerStats["candy_lost"] = PlayerEventMetaData["candy_lost"] or 0
			PlayerStats["candy_fed"] = PlayerEventMetaData["candy_fed"] or 0
			PlayerStats["candy_dropped"] = PlayerEventMetaData["candy_dropped"] or 0
			PlayerStats["team_id"] = PlayerEventMetaData["team_id"]
			PlayerStats["level"] = PlayerResource:GetLevel( nPlayerID )
			PlayerStats["net_worth"] = PlayerResource:GetNetWorth( nPlayerID )
		end
	end

	-- Compute state stats
	self.SignOutTable["stats"].StateSummaries = {}
	for _,v in pairs( self.SignOutTable["stats"].StateDurations ) do
		if v.duration > 0.1 then -- skip timeless states
			local tSummary = self.SignOutTable["stats"].StateSummaries[v.state]
			if tSummary == nil then
				tSummary = {}
				tSummary.name = _G.WINTER2022_STATE_NAMES[ v.state ]
				tSummary.duration = 0
				tSummary.timesRan = 0
			end
			tSummary.timesRan = tSummary.timesRan + 1
			tSummary.duration = tSummary.duration + v.duration
			self.SignOutTable["stats"].StateSummaries[v.state] = tSummary
		end
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

function CWinter2022:OnItemPickedUp( event )
	local hPickup = EntIndexToHScript( event.ItemEntityIndex )
	if hPickup ~= nil and hPickup:IsNull() == false then
		local hContainer = hPickup:GetContainer()
		if hContainer ~= nil and hContainer:IsNull() == false then
			if hContainer.bIsLootDrop == true then
				local playerID = -1
				local entIndex = event.HeroEntityIndex ~= nil and event.HeroEntityIndex or event.UnitEntityIndex
				if entIndex ~= nil then
					local hUnit = EntIndexToHScript( entIndex )
					if hUnit ~= nil and not hUnit:IsNull() and hUnit:IsOwnedByAnyPlayer() then
						playerID = hUnit:GetPlayerOwnerID()
					end
				end

				if playerID >= 0 then
					GameRules.Winter2022:GrantEventAction( playerID, "winter2022_collect_treat", 1 )
				end
			end

			if hContainer.nGolemIndex ~= nil and hContainer.nItemIndex ~= nil then
				local tItemTable = self.m_vecNeutralItemDrops[ hContainer.nGolemIndex ]
				table.remove ( tItemTable, hContainer.nItemIndex )
				-- reorder the other items
				for i = 1,#tItemTable do
					if tItemTable[i] ~= nil then
						tItemTable[i].nItemIndex = i
					end
				end
				self.m_vecNeutralItemDrops[ hContainer.nGolemIndex ] = tItemTable
			end
		end
	end
end
