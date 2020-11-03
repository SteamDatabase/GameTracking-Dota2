--------------------------------------------------------------------------------

require( "diretide_constants" )
require( "diretide_triggers" )

--------------------------------------------------------------------------------

function CDiretide:RegisterGameEvents()
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CDiretide, "ModifyGoldFilter" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(CDiretide, "ModifyExperienceFilter" ), self )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", DIRETIDE_THINK_INTERVAL )
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CDiretide, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( CDiretide, "OnTriggerStartTouch" ), self )
 	ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( CDiretide, "OnTriggerEndTouch" ), self )
-- 	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( CDiretide, 'OnPlayerConnected' ), self )
-- 	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CDiretide, 'OnPlayerReconnected' ), self )
-- 	ListenToGameEvent( "hero_selected", Dynamic_Wrap( CDiretide, 'OnHeroSelected' ), self )
	ListenToGameEvent( "player_disconnect", Dynamic_Wrap( CDiretide, 'OnPlayerDisconnect' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDiretide, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDiretide, 'OnEntityKilled' ), self )
 	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDiretide, "OnPlayerGainedLevel" ), self )
-- 	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDiretide, "OnItemPickedUp" ), self )
-- 	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CDiretide, "OnPlayerBuyback" ), self )
-- 	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CDiretide, "OnItemSpawned" ), self )
-- 	ListenToGameEvent( "dota_item_purchased", Dynamic_Wrap( CDiretide, "OnItemPurchased" ), self )
-- 	ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( CDiretide, "OnNonPlayerUsedAbility" ), self ) 	
-- 	ListenToGameEvent( "dota_hero_entered_shop", Dynamic_Wrap( CDiretide, "OnHeroEnteredShop" ), self )
-- 	ListenToGameEvent( "dota_player_team_changed", Dynamic_Wrap( CDiretide, "OnPlayerTeamChanged" ), self )
	ListenToGameEvent( "entity_hurt", Dynamic_Wrap( CDiretide, 'OnEntityHurt' ), self )
	ListenToGameEvent( "player_chat", Dynamic_Wrap( CDiretide, 'OnPlayerChat' ), self )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CDiretide, "OnReviveComplete" ), self )
	ListenToGameEvent( "dota_glyph_used", Dynamic_Wrap( CDiretide, 'OnGlyphUsed' ), self )
	ListenToGameEvent( "dota_match_done", Dynamic_Wrap( CDiretide, "OnGameFinished" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDiretide, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( CDiretide, "OnPlayerHeroInitialSpawnComplete" ), self )
end

--------------------------------------------------------------------------------
-- Gold Filter
-- > player_id_const - int
-- > gold - int
-- > reliable - bool
-- > reason_const - int
--------------------------------------------------------------------------------

function CDiretide:ModifyGoldFilter( filterTable )
	-- bypass check if our override is set (this is because we want to use Unspecified for giving gold
	-- as reward, but there are other things that use it that we don't want to let through.
	if self.bLetGoldThrough == true and filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified then
		return true
	end

	-- No gold on creep kills, ward kills, etc.
	if filterTable[ "reason_const" ] == DOTA_ModifyGold_CreepKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_NeutralKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_RoshanKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_CourierKill
		--or filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_WardKill
		or filterTable[ "reason_const" ] == DOTA_ModifyGold_Unspecified -- this handles a bunch of things. Hope it doesn't break anything!
	then
		filterTable["gold"] = 0 -- no gold unless we give it to you; for now.
		return false
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyGold_HeroKill then
		filterTable["gold"] = math.ceil( filterTable["gold"] * _G.DIRETIDE_HERO_KILL_GOLD_MULTIPLIER )
	end

	return true
end

--------------------------------------------------------------------------------
-- Experience Filter
-- > player_id_const - int
-- > hero_entindex_const - int
-- > experience - float
-- > reason_const - int
--------------------------------------------------------------------------------

function CDiretide:ModifyExperienceFilter( filterTable )
	if self.bLetXPThrough == true then
		return true
	end

	if filterTable[ "reason_const" ] == DOTA_ModifyXP_HeroKill then
		local nXP = math.ceil( filterTable[ "experience" ] * _G.DIRETIDE_HERO_KILL_XP_MULTIPLIER )
		local hHero = EntIndexToHScript( filterTable[ "hero_entindex_const" ] )
		if hHero then
			self:GrantGoldAndXPToTeam( hHero:GetTeamNumber(), 0, nXP )
		end
	end
	filterTable[ "experience" ] = 0
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

function CDiretide:OnEntityHurt( event )
	local hHurtUnit = EntIndexToHScript( event.entindex_killed )
	local hAttacker = nil
	
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if hHurtUnit:IsBuilding() and hAttacker ~= nil and hAttacker:IsNull() == false and ( hHurtUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS or hHurtUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
		if hAttacker:IsOwnedByAnyPlayer() then
			local fDamage = event.damage
			if hAttacker:IsHero() == false then
				fDamage = fDamage * 0.25
			end
			local nCandy = math.min( self:ShouldBuildingEmitCandy( hHurtUnit, fDamage ), self:GetTeamCandy( hHurtUnit:GetTeamNumber() ) )
			if nCandy > 0 then
				local hAttackerHero = nil
				if hAttacker:IsRealHero() then
					hAttackerHero = hAttacker
				else
					local hPlayer = hAttacker:GetPlayerOwner()
					if hPlayer then
						hAttackerHero = hPlayer:GetAssignedHero()
					end
				end

				if hAttackerHero ~= nil then
					if self.bAwardedFirstCandySteal == false then
						PlayerResource:AddCandyEvent( hAttackerHero:GetPlayerID(), 7 )	-- k_ECandyReasonEventGameFirstCandySteal
						self.bAwardedFirstCandySteal = true
					end
				end

				self:LoseCandy( hHurtUnit:GetTeamNumber(), nCandy )
				while nCandy > 0 do
					if nCandy > _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG then
						self:DropCandyAtPosition( hHurtUnit:GetAbsOrigin(), hHurtUnit, hAttacker, true, 1.0 )
						nCandy = nCandy - _G.DIRETIDE_CANDY_COUNT_IN_CANDY_BAG
					else
						self:DropCandyAtPosition( hHurtUnit:GetAbsOrigin(), hHurtUnit, hAttacker, false, 1.0 )
						nCandy = nCandy - 1
					end
				end
			end
		elseif hAttacker:GetTeamNumber() == DOTA_TEAM_GOODGUYS or hAttacker:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			-- Creeps disappear when they attack the home bucket, taking (some amount) of candy with them.
			if hHurtUnit:GetUnitName() == "home_candy_bucket" then
				-- FIXME for now just using precomputed candy amount, later we want this to be variable.
				if hAttacker.Diretide_nCandy ~= nil and hAttacker.Diretide_nCandy > 0 then
					local nCandy = math.min( hAttacker.Diretide_nCandy, self:GetTeamCandy( hHurtUnit:GetTeamNumber() ) )
					if nCandy > 0 then
						self:LoseCandy( hHurtUnit:GetTeamNumber(), nCandy )
					end
				else
					-- even creeps without the candy tag can steal candy, eventually
					local nHits = 1
					if self.m_BuildingCreepCounter[hHurtUnit] ~= nil then
						nHits = nHits + self.m_BuildingCreepCounter[hHurtUnit]
					end
					if nHits >= _G.DIRETIDE_BUILDING_CANDY_CREEP_ATTACKS_TO_LOSE then
						if self:GetTeamCandy( hHurtUnit:GetTeamNumber() ) > 0 then
							self:LoseCandy( hHurtUnit:GetTeamNumber(), 1 )
						end
						nHits = 0
					end
					self.m_BuildingCreepCounter[hHurtUnit] = nHits
				end
				-- NOTE: Losing that candy might have ended the round. If so, and if the attacker is a creep, roundend will wipe it.
				-- But we don't want to play this FX regardless if we're not in the middle of a round anymore.
				if hAttacker ~= nil and hAttacker:IsNull() == false and self:IsRoundInProgress() == true then
					local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/hw_candy_drop.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker )
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, hAttacker, PATTACH_ABSORIGIN_FOLLOW, nil, hAttacker:GetAbsOrigin(), false )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					hAttacker.Diretide_nCandy = nil
					hAttacker:ForceKill( false )
				end
			end
		end
		if hHurtUnit:GetUnitName() == "home_candy_bucket" then
			local bSpeak = false
			if hHurtUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				if self._buildingHomeHurtTimerRadiant == nil or self._buildingHomeHurtTimerRadiant < GameRules:GetGameTime() then
					GameRules:ExecuteTeamPing( hHurtUnit:GetTeamNumber(), hHurtUnit:GetOrigin().x, hHurtUnit:GetOrigin().y, hHurtUnit, 0 )
					self._buildingHomeHurtTimerRadiant = GameRules:GetGameTime() + _G.DIRETIDE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bSpeak = true
				end
			else
				if self._buildingHomeHurtTimerDire == nil or self._buildingHomeHurtTimerDire < GameRules:GetGameTime() then
					GameRules:ExecuteTeamPing( hHurtUnit:GetTeamNumber(), hHurtUnit:GetOrigin().x, hHurtUnit:GetOrigin().y, hHurtUnit, 0 )
					self._buildingHomeHurtTimerDire = GameRules:GetGameTime() + _G.DIRETIDE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bSpeak = true
				end
			end
			if bSpeak == true then
				self:GetTeamAnnouncer( hHurtUnit:GetTeamNumber() ):OnBucketAttacked()
				FireGameEvent( "candy_bucket_attacked", {
					team = hHurtUnit:GetTeamNumber(),
				 } )
			end
		else
			-- outlying building
			local bPlay = false
			if hHurtUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
				if self._buildingHurtTimerRadiant == nil or self._buildingHurtTimerRadiant < GameRules:GetGameTime() then
					self._buildingHurtTimerRadiant = GameRules:GetGameTime() + _G.DIRETIDE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bPlay = true
				end
			else
				if self._buildingHurtTimerDire == nil or self._buildingHurtTimerDire < GameRules:GetGameTime() then
					self._buildingHurtTimerDire = GameRules:GetGameTime() + _G.DIRETIDE_INTERVAL_BETWEEN_BUILDING_HIT_ANNOUNCE
					bPlay = true
				end
			end
			if bPlay == true then
				GameRules:ExecuteTeamPing( hHurtUnit:GetTeamNumber(), hHurtUnit:GetOrigin().x, hHurtUnit:GetOrigin().y, hHurtUnit, 0 )
				self:GetTeamAnnouncer( hHurtUnit:GetTeamNumber() ):OnWellAttacked()
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

function CDiretide:OnPlayerChat( event )
	--[[
	local nPlayerID = event.playerid
	if nPlayerID == -1 then
		return
	end

	local sChatMsg = event.text
	if sChatMsg:find( '^-restart$' ) then
		self:RestartGameCheatCommand()
	elseif sChatMsg:find( '^-allrounds$' ) then
		self.bPlayAllRounds = true
		Say( nil, 'Forcing all rounds to be played.', false )
	elseif sChatMsg:find( '^-end$' ) then
		if self.m_GameState == _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
			self:StartRound()
		end
		if self.m_nTeamScore[ DOTA_TEAM_GOODGUYS ] > self.m_nTeamScore[ DOTA_TEAM_BADGUYS ] then
			self:EndRound( DOTA_TEAM_BADGUYS )
		else
			self:EndRound( DOTA_TEAM_GOODGUYS )
		end
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
	end]]
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 	PlayerID
--------------------------------------------------------------------------------
function CDiretide:OnPlayerDisconnect( event )
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

function CDiretide:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if spawnedUnit == nil then
		return
	end

	if spawnedUnit:IsRealHero() then
		self:OnNPCSpawned_PlayerHero( event )
		return
	end
end

--------------------------------------------------------------------------------

function GetCandyCount( hHero )
	if hHero == nil or hHero:IsNull() then
		return 0
	end
	local hCandy = hHero:FindAbilityByName( "hero_candy_bucket" )
	if hCandy == nil then
		return 0
	end
	return hCandy:GetCandy()
end

--------------------------------------------------------------------------------

function CDiretide:OnNPCSpawned_PlayerHero( event )
	local hPlayerHero = EntIndexToHScript( event.entindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	if self.hRoshan ~= nil and self.hRoshan.vecLastTargets ~= nil then
		local flTime = GameRules:GetDOTATime( false, true ) + _G.DIRETIDE_ROSHAN_HERO_TARGET_SPAWN_IMMUNITY_TIME
		if self.hRoshan.vecLastTargets[hPlayerHero] == nil then
			self.hRoshan.vecLastTargets[hPlayerHero] = flTime
		else
			self.hRoshan.vecLastTargets[hPlayerHero] = math.max( self.hRoshan.vecLastTargets[hPlayerHero], flTime )
		end
	end

	if hPlayerHero.bFirstSpawnComplete == nil then
		local hCandy = hPlayerHero:FindAbilityByName( "hero_candy_bucket" )
		if hCandy then
			hCandy:SetCurrentAbilityCharges( 0 )
		end
		
		if _G.DIRETIDE_HERO_RESPAWN_TIMER_DEATH_PENALTY == true then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_diretide_respawn_time_penalty", { } )
		end

		if DIRETIDE_LIMITED_LIVES_PER_ROUND == true then
			hPlayerHero.nRespawnsRemaining = DIRETIDE_LIVES_PER_ROUND
			CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ), { respawns = hPlayerHero.nRespawnsRemaining } )
		end

		
		hPlayerHero.GetCandyCount = GetCandyCount

		hPlayerHero.bFirstSpawnComplete = true

		local nPlayerID = hPlayerHero:GetPlayerOwnerID()
		self.EventMetaData[nPlayerID] = {}
		--self.EventMetaData[nPlayerID]["kills"] = 0
		self.EventMetaData[nPlayerID]["candy_picked_up"] = 0
		self.EventMetaData[nPlayerID]["candy_scored"] = 0
		self.EventMetaData[nPlayerID]["candy_lost"] = 0
		self.EventMetaData[nPlayerID]["team_id"] = hPlayerHero:GetTeamNumber()
		--self.EventMetaData[nPlayerID]["level"] = 1
		--self.EventMetaData[nPlayerID]["net_worth"] = 0
	else
		if not hPlayerHero:IsReincarnating() then
			self:GetTeamAnnouncer( hPlayerHero:GetTeamNumber() ):OnHeroRespawn( hPlayerHero )

			local hCandyBucket = hPlayerHero:FindAbilityByName( "hero_candy_bucket" )
			if hCandyBucket ~= nil then
				hCandyBucket:SetCurrentAbilityCharges( 0 )
			end
		end

		-- Heroes were spawning with missing health when they had died with the candy max hp debuff.
		-- Seemed to be due to timing of when their max hp changed.
		hPlayerHero:CalculateStatBonus()

		local flHealAmount = hPlayerHero:GetMaxHealth()
		hPlayerHero:Heal( flHealAmount, hPlayerHero )
	end
end

--------------------------------------------------------------------------------
-- dota_player_pick_hero
-- > player - short
-- > heroindex - short
-- > hero - string
--------------------------------------------------------------------------------

function CDiretide:OnPlayerHeroInitialSpawnComplete( event )
	local hPlayerHero = EntIndexToHScript( event.heroindex )
	if hPlayerHero == nil or hPlayerHero:IsRealHero() == false then
		return
	end

	--print( "OnPlayerHeroInitialSpawnComplete" )

	local hTPScroll = hPlayerHero:FindItemInInventory( "item_tpscroll" )
	if hTPScroll then
		hTPScroll:EndCooldown()
	end
end

--------------------------------------------------------------------------------
-- entity_killed
-- > entindex_killed - long
-- > entindex_attacker - long
-- > entindex_inflictor - long
-- > damagebits - long
--------------------------------------------------------------------------------

function CDiretide:OnEntityKilled( event )
	local hKilledUnit = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )
--[[
	if hKilledUnit ~= nil then
		printf( "CDiretide:OnEntityKilled - unit killed %s", hKilledUnit:GetUnitName() )
	end
--]]
	if hKilledUnit:IsRealHero() then
		self:OnEntityKilled_PlayerHero( event )
		return
	end

	if self.m_GameState == _G.DIRETIDE_GAMESTATE_INTERSTITIAL_ROUND_PHASE then
		return
	end

	-- Lasthit sound and particle
	if hKilledUnit and hKilledUnit:IsCreature() then
		if hAttacker and hAttacker:IsRealHero() then
			EmitSoundOnClient( "LastHit.Creature", hAttacker:GetPlayerOwner() )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticleForPlayer( "particles/dark_moon/darkmoon_last_hit_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, hKilledUnit, hAttacker:GetPlayerOwner() ) )
		end
	end

	--[[
	if hKilledUnit:IsBuilding() and hKilledUnit:GetUnitName() == "home_candy_bucket" then
		local nScoringTeam = FlipTeamNumber( hKilledUnit:GetTeamNumber() )
		self:EndRound( nScoringTeam )
		return
	end
	--]]
	if hKilledUnit:IsBuilding() and hKilledUnit:GetUnitName() ~= "home_candy_bucket" then
		local nCandy = 0
		if hKilledUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS or hKilledUnit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
			hKilledUnit:AddEffects( EF_NODRAW )
			local nFXIndex = ParticleManager:CreateParticle( "particles/destruction/candy_well_destruction.vpcf", PATTACH_ABSORIGIN, hAttacker )
			ParticleManager:SetParticleControl( nFXIndex, 0, hKilledUnit:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

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

				if hAttackerHero ~= nil then
					if self.bAwardedFirstCandyWellKill == false then
						PlayerResource:AddCandyEvent( hAttackerHero:GetPlayerID(), 6 )	-- k_ECandyReasonEventGameCandyWellDestroyed
						self.bAwardedFirstCandyWellKill = true
					end
				end
			end

			nCandy = math.min( _G.DIRETIDE_BUILDING_DEATH_CANDY_COUNT, self:GetTeamCandy( hKilledUnit:GetTeamNumber() ) )
			self:LoseCandy( hKilledUnit:GetTeamNumber(), nCandy )
			-- Reset glyph
			if _G.DIRETIDE_RESET_GLYPH_ON_WELL_DESTROY == true then
				GameRules:SetGlyphCooldown( hKilledUnit:GetTeamNumber(), 0.0 )
			end
			-- Deal with invulnerability
			local hBuildings = FindUnitsInRadius( hKilledUnit:GetTeamNumber(), Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
			for _, building in ipairs( hBuildings ) do
				if building:GetUnitName() == "home_candy_bucket" then
					--print("++++++++++++ Found home bucket of team " .. hKilledUnit:GetTeamNumber() )
					local hBuff = building:FindModifierByName( "modifier_invulnerable" )
					if hBuff then
						--print("-------- Found buff" )
						building:RemoveModifierByName( "modifier_invulnerable" )
						local gameEvent = {}
						gameEvent["teamnumber"] = -1
						if hKilledUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							gameEvent["message"] = "#DOTA_HUD_CandyBucketVulnerableGood_Toast"
						else
							gameEvent["message"] = "#DOTA_HUD_CandyBucketVulnerableBad_Toast"
						end
						FireGameEvent( "dota_combat_event_message", gameEvent )
						GameRules:ExecuteTeamPing( DOTA_TEAM_GOODGUYS, building:GetOrigin().x, building:GetOrigin().y, building, 0 )
						GameRules:ExecuteTeamPing( DOTA_TEAM_BADGUYS, building:GetOrigin().x, building:GetOrigin().y, building, 0 )
						EmitGlobalSound( "CandyBucket.Vulnerable" )
						self:GetTeamAnnouncer( hKilledUnit:GetTeamNumber() ):OnWellLost()
					end
				end
			end
		elseif hKilledUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
			--[[ We now have Dan's death anim
			hKilledUnit:AddEffects( EF_NODRAW )
			local nFXIndex = ParticleManager:CreateParticle( "particles/destruction/candy_drop_destruction.vpcf", PATTACH_ABSORIGIN, hAttacker )
			ParticleManager:SetParticleControl( nFXIndex, 0, hKilledUnit:GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )--]]

			if hKilledUnit.nNeutralBucketIndex ~= nil then
				--self.vNeutralBucketsToSpawn[ hKilledUnit.nNeutralBucketIndex ] = true
				nCandy = _G.DIRETIDE_BUILDING_DEATH_CANDY_COUNT
			end
			if hKilledUnit.nMapCandyBucketIndex ~= nil then
				nCandy = _G.DIRETIDE_MAP_CANDY_COUNT
				self.m_vecMapCandyRespawnBuckets[ hKilledUnit.nMapCandyBucketIndex ] = true
			end

			if hAttacker and hAttacker:IsOwnedByAnyPlayer() then
				local hDropHero = nil
				if hAttacker:IsRealHero() then
					hDropHero = hAttacker
				else
					local hPlayer = hAttacker:GetPlayerOwner()
					if hPlayer then
						hDropHero = hPlayer:GetAssignedHero()
					end
				end

				if hDropHero ~= nil then
					if self.bAwardedFirstScarecrowStashKill == false then
						PlayerResource:AddCandyEvent( hDropHero:GetPlayerID(), 5 )	-- k_ECandyReasonEventGameScarecrowDestroyed
						self.bAwardedFirstScarecrowStashKill = true
					end

					local szItemDrop = GetPotentialNeutralItemDrop( self:GetRoundNumber(), hDropHero:GetTeamNumber() )
					if szItemDrop ~= nil then
						local hItem = DropNeutralItemAtPositionForHero( szItemDrop, hKilledUnit:GetAbsOrigin(), hDropHero, self:GetRoundNumber(), true )
						if hItem ~= nil then
							local nKey = hKilledUnit.nMapCandyBucketIndex
							hItem.nMapCandyBucketIndex = nKey
							hItem.nHeroPlayerID = hDropHero:GetPlayerOwnerID()
							hItem.nTeam = hDropHero:GetTeamNumber()
							self.m_vecNeutralItemDrops[nKey] = hItem
						end
					end
				end
			end
		end
		
		while nCandy > 0 do
			-- explicitly only drop single candies.
			self:DropCandyAtPosition( hKilledUnit:GetAbsOrigin(), hKilledUnit, hAttacker, false, 1.0 )
			nCandy = nCandy - 1
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

function CDiretide:OnEntityKilled_PlayerHero( event )
	local hKilledHero = EntIndexToHScript( event.entindex_killed )
	if hKilledHero == nil or hKilledHero:IsNull() == true or hKilledHero:IsRealHero() == false then
		return
	end

	local hAttacker = EntIndexToHScript( event.entindex_attacker or -1 )

	--[[if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:IsHero() then
		GameRules.Diretide:GrantGoldAndXPToTeam( hAttacker:GetTeamNumber(), hKilledHero:GetDeathXP(), math.ceil( nXP * _G.DIRETIDE_HERO_KILL_XP_MULTIPLIER ) )
	end--]]

	if self.m_flKillStreakAnnounceCooldown == nil or self.m_flKillStreakAnnounceCooldown <= GameRules:GetGameTime() then
		if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:GetPlayerOwner() ~= nil then
			local nPlayerID = hAttacker:GetPlayerOwner():GetPlayerID()
			if nPlayerID >= 0 then
				local nStreak = PlayerResource:GetStreak( nPlayerID )
				if nStreak > 1 then
					self.m_flKillStreakAnnounceCooldown = GameRules:GetGameTime() + _G.DIRETIDE_ANNOUNCER_KILLING_SPREE_COOLDOWN
					self:GetTeamAnnouncer( hAttacker:GetTeamNumber() ):OnKillStreak( nStreak, nPlayerID, hKilledHero:GetPlayerID() )
				end
			end
		end
	end

	if DIRETIDE_LIMITED_LIVES_PER_ROUND == false then
		return
	end
	
	--print( 'PLAYER ' .. hKilledHero:GetUnitName() .. ' DIED! - Current lives remaining are ' .. hKilledHero.nRespawnsRemaining )
	hKilledHero:SetRespawnsDisabled( hKilledHero.nRespawnsRemaining == 0 )
	hKilledHero.nRespawnsRemaining = math.max( 0, hKilledHero.nRespawnsRemaining - LIFE_REVIVE_COST )
	--print( 'LIVES REDUCED TO ' .. hKilledHero.nRespawnsRemaining )

	CustomGameEventManager:Send_ServerToPlayer( hKilledHero:GetPlayerOwner(), "life_lost", {} )
	CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hKilledHero:entindex() ),  { respawns = hKilledHero.nRespawnsRemaining } )
end

--------------------------------------------------------------------------------
-- dota_holdout_revive_complete
-- > caster - short
-- > target - short
-- > channel_time - float	
--------------------------------------------------------------------------------

function CDiretide:OnReviveComplete( event )
	local hPlayerHero = EntIndexToHScript( event.target )
	if hPlayerHero ~= nil then
		hPlayerHero:ModifyHealth( math.max( 1, math.ceil( hPlayerHero:GetMaxHealth() * DIRETIDE_HERO_REVIVE_HEALTH_PERCENT ) ), nil, false, 0 )
		hPlayerHero:SetMana( math.max( 1, math.ceil( hPlayerHero:GetMaxMana() * DIRETIDE_HERO_REVIVE_MANA_PERCENT ) ) )
	end
end

---------------------------------------------------------
-- game_rules_state_change
-- no parameters
---------------------------------------------------------

function CDiretide:OnGameRulesStateChange()
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
function CDiretide:OnGameStarted()
	-- Hackerino; modifier_invulnerable may be getting added by base dota code
	local hRadiantBuckets = Entities:FindAllByName( "radiant_candy_bucket" )
	for _, hBucket in pairs( hRadiantBuckets ) do
		self:AddCandyBucketModifiers( hBucket, false, true )
	end

	local hDireBuckets = Entities:FindAllByName( "dire_candy_bucket" )
	for _, hBucket in pairs( hDireBuckets ) do
		self:AddCandyBucketModifiers( hBucket, false, true )
	end

	local hRadiantHomeBuckets = Entities:FindAllByName( "radiant_home_candy_bucket" )
	for _, hBucket in pairs( hRadiantHomeBuckets ) do
		self:AddCandyBucketModifiers( hBucket, true, true )
	end

	local hDireHomeBuckets = Entities:FindAllByName( "dire_home_candy_bucket" )
	for _, hBucket in pairs( hDireHomeBuckets ) do
		self:AddCandyBucketModifiers( hBucket, true, true )
	end
	self:GetGlobalAnnouncer():OnGameStarted()

	--GameRules:SetTimeOfDay( 0.751 )
end

--------------------------------------------------------------------------------
-- dota_player_gained_level
-- > player - short
-- > player_id - short
-- > level - short
-- > hero_entindex - short
-- > PlayerID - short
--------------------------------------------------------------------------------

function CDiretide:OnPlayerGainedLevel( event )
end

--------------------------------------------------------------------------------
-- Glyph Used
-- > teamnumber - int
--------------------------------------------------------------------------------

function CDiretide:OnGlyphUsed( event )
	local nTeam = event.teamnumber
	if _G.DIRETIDE_RESET_GLYPH_PER_ROUND == true then
		GameRules:SetGlyphCooldown( nTeam, 999.0 )
	end

	local hUnits = FindUnitsInRadius( nTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _, hUnit in ipairs( hUnits ) do
		if hUnit:GetUnitName() == "npc_dota_radiant_bucket_soldier" or hUnit:GetUnitName() == "npc_dota_dire_bucket_soldier" then
			if _G.DIRETIDE_GLYPH_DURATION_GUARD > 0 then
				local kv = {
					duration = _G.DIRETIDE_GLYPH_DURATION_GUARD,
				}
				hUnit:AddNewModifier( hUnit, nil, "modifier_fountain_glyph", kv )
			end
		elseif hUnit.Diretide_bIsCore then
			if _G.DIRETIDE_GLYPH_DURATION_CREEP > 0 then
				local kv = {
					duration = _G.DIRETIDE_GLYPH_DURATION_CREEP,
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

function CDiretide:OnTriggerStartTouch( event )
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

function CDiretide:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
end


--------------------------------------------------------------------------------

function CDiretide:OnGameFinished( event )

	printf( "[DIRETIDE2020] OnGameFinished: winningteam=%d", event["winningteam"] )
--[[
	printf( "[DIRETIDE2020] EventGameDetails table:" )
	if self.m_hEventGameDetails then
	    DeepPrintTable(self.m_hEventGameDetails)
	else
		printf("NOT FOUND!!")
	end
--]]	
	self:AddResultToSignOut( event )
	print( "[DIRETIDE2020] Metadata Table:" )
	PrintTable( self.EventMetaData, " " )
	print( "[DIRETIDE2020] Signout Table:" )
	PrintTable( self.SignOutTable, " " )
	GameRules:SetEventMetadataCustomTable( self.EventMetaData )
	GameRules:SetEventSignoutCustomTable( self.SignOutTable )
end

--------------------------------------------------------------------------------
-- copy/paste from JungleSpirits TI9 event

function CDiretide:AddResultToSignOut( event )
	self.SignOutTable["game_time"] = GameRules:GetDOTATime( false, true )
	self.SignOutTable["banned_heroes"] = GameRules:GetBannedHeroes()
	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayerID( nPlayerID ) then
			local PlayerEventMetaData = self.EventMetaData[nPlayerID] or {}
			local PlayerStats = {}
			PlayerStats["player_id"] = nPlayerID
			PlayerStats["steam_id"] = PlayerResource:GetSteamID( nPlayerID )
			--PlayerStats["kills"] = PlayerEventMetaData["kills"] or 0
			PlayerStats["candy_picked_up"] = PlayerEventMetaData["candy_picked_up"] or 0
			PlayerStats["candy_scored"] = PlayerEventMetaData["candy_scored"] or 0
			PlayerStats["candy_lost"] = PlayerEventMetaData["candy_lost"] or 0
			PlayerStats["team_id"] = PlayerEventMetaData["team_id"]
			--PlayerStats["level"] = PlayerResource:GetLevel( nPlayerID )
			--PlayerStats["net_worth"] = PlayerResource:GetNetWorth( nPlayerID )

			table.insert( self.SignOutTable["stats"], PlayerStats )
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

function CDiretide:OnItemPickedUp( event )
	local hPickup = EntIndexToHScript( event.ItemEntityIndex )
	if hPickup ~= nil and hPickup:IsNull() == false then
		local hContainer = hPickup:GetContainer()
		if hContainer ~= nil and hContainer:IsNull() == false and hContainer.nMapCandyBucketIndex ~= ni then
			table.remove ( self.m_vecNeutralItemDrops, nKey )
		end
	end
end