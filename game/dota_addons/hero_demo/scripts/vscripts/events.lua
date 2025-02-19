--[[ Events ]]

--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
function CHeroDemo:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	--print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--print( "OnGameRulesStateChange: Pre Game Selection" )
		SendToServerConsole( "dota_dev forcegamestart" ) 

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "OnGameRulesStateChange: Game In Progress" )
		local sLoadScenario = Convars:GetStr( "dota_sv_load_demo_mode_scenario" )
		if sLoadScenario ~= nil and #sLoadScenario then
			--print( "loading demo mode scenario: " .. sLoadScenario )
			SendToServerConsole( "dota_load_demo_mode_scenario " .. sLoadScenario )
		end

		local sCustomStartupString = GameRules:GetGameSessionConfigValue( "demo_hero_custom_start_message", "" )
		if sCustomStartupString ~= "" then
			GameRules:SendCustomMessage( sCustomStartupString, 0, -1 )
		end
	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function CHeroDemo:OnNPCSpawned( event )
	--print( "^^^CHeroDemo:OnNPCSpawned" )

	spawnedUnit = EntIndexToHScript( event.entindex )

	if spawnedUnit == nil then
		return
	end

	--DeepPrintTable( event )

	if spawnedUnit:GetUnitName() == "npc_dota_neutral_caster" then
		--print( "Neutral Caster spawned" )
		spawnedUnit:SetContextThink( "self:Think_InitializeNeutralCaster", function() return self:Think_InitializeNeutralCaster( spawnedUnit ) end, 0 )
	end

	if spawnedUnit:GetUnitName() == "npc_dota_courier" then
		spawnedUnit:SetContextThink( "self:Think_InitializeCourier", function() return self:Think_InitializeCourier( spawnedUnit ) end, 0 )
	end

	if spawnedUnit:GetPlayerOwnerID() == 0 and spawnedUnit:IsRealHero() and not spawnedUnit:IsClone() and not spawnedUnit:IsTempestDouble() then
		print( "spawnedUnit is player's hero" )

		-- clean up ui element for previous player hero if we have a different ent index
		if self.m_nPlayerEntIndex ~= -1 and self.m_nPlayerEntIndex ~= event.entindex then
			local event_data =
			{
				entindex = self.m_nPlayerEntIndex
			}
			CustomGameEventManager:Send_ServerToAllClients( "remove_hero_entry", event_data )
		end

		self.m_nPlayerEntIndex = event.entindex

		local event_data =
		{
			hero_id = spawnedUnit:GetHeroID(),
			hero_variant = spawnedUnit:GetHeroFacetID()
		}

		CustomGameEventManager:Send_ServerToAllClients( "set_player_hero_id", event_data )

		local hPlayerHero = spawnedUnit
		hPlayerHero:SetContextThink( "self:Think_InitializePlayerHero", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end

	if event.is_respawn == 0 and spawnedUnit:IsRealHero() and not spawnedUnit:IsClone() and not spawnedUnit:IsTempestDouble() then
		local event_data =
		{
			entindex = event.entindex
		}
		CustomGameEventManager:Send_ServerToAllClients( "add_new_hero_entry", event_data )
	end
end

--------------------------------------------------------------------------------
-- Think_InitializePlayerHero
--------------------------------------------------------------------------------
function CHeroDemo:Think_InitializePlayerHero( hPlayerHero )
	if not hPlayerHero then
		return 0.1
	end

	hPlayerHero:GetPlayerOwner():CheckForCourierSpawning( hPlayerHero )

	if self.m_bPlayerDataCaptured == false then
		if hPlayerHero:GetUnitName() == self.m_sHeroSelection then
			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			PlayerResource:ModifyGold( nPlayerID, 99999, true, 0 )
			self.m_bPlayerDataCaptured = true
		end
	end

	-- TODO - support this!
	if self.m_bInvulnerabilityEnabled then
		local hAllPlayerUnits = {}
		hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
		hAllPlayerUnits[ #hAllPlayerUnits + 1 ] = hPlayerHero

		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:AddNewModifier( hPlayerHero, nil, "lm_take_no_damage", nil )
		end
	end

	return
end

--------------------------------------------------------------------------------
-- Think_InitializeCourier
--------------------------------------------------------------------------------
function CHeroDemo:Think_InitializeCourier( hCourier )
	if not hCourier then
		return 0.1
	end

	-- Move any couriers spawned to their respective fountains.
	local nTeam = hCourier:GetTeamNumber();
	local invulUnits = FindUnitsInRadius( nTeam, Vector( 0, 0, 0 ), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false )
	for _,hFountain in pairs( invulUnits ) do
		if hFountain:GetUnitName() == "dota_fountain" then
			-- print( "Moving courier to fountain..." )
			FindClearSpaceForUnit( hCourier, hFountain:GetAbsOrigin(), true )
			break
		end
	end

	return
end

--------------------------------------------------------------------------------
-- Think_InitializeNeutralCaster
--------------------------------------------------------------------------------
function CHeroDemo:Think_InitializeNeutralCaster( neutralCaster )
	if not neutralCaster then
		return 0.1
	end

	--print( "neutralCaster:AddAbility( \"la_spawn_enemy_at_target\" )" )
	neutralCaster:AddAbility( "la_spawn_enemy_at_target" )
	return
end

--------------------------------------------------------------------------------
-- GameEvent: OnItemPurchased
--------------------------------------------------------------------------------
function CHeroDemo:OnItemPurchased( event )
	local hBuyer = PlayerResource:GetPlayer( event.PlayerID )
	local hBuyerHero = hBuyer:GetAssignedHero()
	hBuyerHero:ModifyGold( event.itemcost, true, 0 )
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCReplaced
--------------------------------------------------------------------------------
function CHeroDemo:OnNPCReplaced( event )
	local sNewHeroName = PlayerResource:GetSelectedHeroName( event.new_entindex )
	--print( "sNewHeroName == " .. sNewHeroName ) -- we fail to get in here
	self:BroadcastMsg( "Changed hero to " .. sNewHeroName )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnWelcomePanelDismissed
--------------------------------------------------------------------------------
function CHeroDemo:OnWelcomePanelDismissed( event )
	--print( "Entering CHeroDemo:OnWelcomePanelDismissed( event )" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRefreshButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnRefreshButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_refresh" )

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#Refresh_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLevelUpButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_level 1" )

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#LevelUp_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnUltraMaxLevelButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnUltraMaxLevelButtonPressed( eventSourceIndex, data )
	
	--print( 'ULTRA MAX!' )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	HeroMaxLevel( hPlayerHero )

	if not hPlayerHero:FindModifierByName( "modifier_item_aghanims_shard" ) then
		hPlayerHero:AddItemByName( "item_aghanims_shard" )
	end

	if not hPlayerHero:FindModifierByName( "modifier_item_ultimate_scepter_consumed" ) then
		hPlayerHero:AddItemByName( "item_ultimate_scepter_2" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#MaxLevel_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnFreeSpellsButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnFreeSpellsButtonPressed( eventSourceIndex )
	SendToServerConsole( "toggle dota_ability_debug" )
	if self.m_bFreeSpellsEnabled == false then
		self.m_bFreeSpellsEnabled = true
		SendToServerConsole( "dota_dev hero_refresh" )
		self:BroadcastMsg( "#FreeSpellsOn_Msg" )
	elseif self.m_bFreeSpellsEnabled == true then
		self.m_bFreeSpellsEnabled = false
		self:BroadcastMsg( "#FreeSpellsOff_Msg" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: CombatLogButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:CombatLogButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_toggle_combatlog" )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSetInvulnerabilityHero
--------------------------------------------------------------------------------
function CHeroDemo:OnSetInvulnerabilityHero( bInvuln, eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		--print( 'OnSetInvulnerabilityHero! - found hero with ent index = ' .. nHeroEntIndex )

		local hAllUnits = {}
		if hHero:IsRealHero() then
			hAllUnits = hHero:GetAdditionalOwnedUnits()
		end
		table.insert( hAllUnits, hHero )

		if bInvuln == nil then
			bInvuln = hHero:FindModifierByName( "lm_take_no_damage" ) == nil
		end

		if bInvuln then
			for _, hUnit in pairs( hAllUnits ) do
				--print( 'Adding INVULN modifier to entindex ' .. hUnit:GetEntityIndex() .. ' - ' .. hUnit:GetUnitName() )
				hUnit:AddNewModifier( hHero, nil, "lm_take_no_damage", nil )
			end
		else
			for _, hUnit in pairs( hAllUnits ) do
				--print( 'Removing INVULN modifier to ' .. hUnit:GetUnitName() )
				hUnit:RemoveModifierByName( "lm_take_no_damage" )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnEnemyButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	local hPlayer = PlayerResource:GetPlayer( data.PlayerID )

	local sHeroToSpawn = Convars:GetStr( "dota_hero_demo_default_enemy" )
	local nHeroVariant = Convars:GetInt( "dota_hero_demo_default_enemy_variant" );

	DebugCreateHeroWithVariant( hPlayer, sHeroToSpawn, nHeroVariant, self.m_nENEMIES_TEAM, false,
		function( hEnemy )
			hEnemy:SetControllableByPlayer( self.m_nPlayerID, false )
			hEnemy:SetRespawnPosition( hPlayerHero:GetAbsOrigin() )
			FindClearSpaceForUnit( hEnemy, hPlayerHero:GetAbsOrigin(), false )
			hEnemy:Hold()
			hEnemy:SetIdleAcquire( false )
			hEnemy:SetAcquisitionRange( 0 )
			self:BroadcastMsg( "#SpawnEnemy_Msg" )
		end )

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- RequestInitialSpawnHeroID
--------------------------------------------------------------------------------
function CHeroDemo:OnRequestInitialSpawnHeroID( eventSourceIndex, data )
	local sHeroToSpawn = Convars:GetStr( "dota_hero_demo_default_enemy" )
	local nHeroID = DOTAGameManager:GetHeroIDByName( sHeroToSpawn )
	local event_data =
	{
		hero_id = nHeroID,
		hero_name = sHeroToSpawn,
		initial_spawn = true
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_spawn_hero_id", event_data )
end

--------------------------------------------------------------------------------
-- ToggleDayNight
--------------------------------------------------------------------------------
function CHeroDemo:OnToggleDayNight( eventSourceIndex, data )
	if GameRules:IsDaytime() then
		GameRules:SetTimeOfDay( 0.751 )
	else
		GameRules:SetTimeOfDay( 0.251 )
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: SelectMainHeroButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSelectMainHeroButtonPressed( eventSourceIndex, data )

    local sep, fields = ":", {}
    local pattern = string.format("([^%s]+)", sep)
    data.str:gsub(pattern, function(c) fields[#fields+1] = c end)

	local sHero = DOTAGameManager:GetHeroUnitNameByID( tonumber( fields[1] ) )
	--EmitGlobalSound( "UI.Button.Pressed" )

	--print( 'MAIN HERO PICK!' )

	local event_data =
	{
		hero_id = tonumber( fields[1] ),
		hero_name = sHero,
		hero_variant = tonumber( fields[2] )
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_main_hero_id", event_data )
end

--------------------------------------------------------------------------------
-- ButtonEvent: SelectSpawnHeroButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSelectSpawnHeroButtonPressed( eventSourceIndex, data )

    local sep, fields = ":", {}
    local pattern = string.format("([^%s]+)", sep)
    data.str:gsub(pattern, function(c) fields[#fields+1] = c end)

	local sHeroToSpawn = DOTAGameManager:GetHeroUnitNameByID( tonumber( fields[1] ) )

	Convars:SetStr( "dota_hero_demo_default_enemy", sHeroToSpawn )
	Convars:SetInt( "dota_hero_demo_default_enemy_variant", tonumber( fields[2] ) )
	--EmitGlobalSound( "UI.Button.Pressed" )

	--print( 'SPAWN HERO PICK!' )

	local event_data =
	{
		hero_id = tonumber( fields[1] ),
		hero_name = sHeroToSpawn,
		hero_variant = tonumber( fields[2] )
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_spawn_hero_id", event_data )
end

--------------------------------------------------------------------------------
-- ButtonEvent: RemoveHeroButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnRemoveHeroButtonPressed( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	
	if ( hHero ~= nil and hHero:IsNull() == false and hHero ~= PlayerResource:GetSelectedHeroEntity( 0 ) ) then
		--print( 'OnRemoveHeroButtonPressed! - found hero with ent index = ' .. nHeroEntIndex )
		if hHero:IsHero() and hHero:GetPlayerOwner() ~= nil and hHero:GetPlayerOwnerID() ~= 0 then
			local nPlayerID = hHero:GetPlayerID()
			-- TODO - kill all clones that are attached
			GameRules:ResetPlayer( nPlayerID )
			DisconnectClient( nPlayerID, true )
		else
			hHero:Destroy()
		end

		local event_data =
		{
			entindex = nHeroEntIndex
		}
		CustomGameEventManager:Send_ServerToAllClients( "remove_hero_entry", event_data )
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: LevelUpHero
--------------------------------------------------------------------------------
function CHeroDemo:OnLevelUpHero( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		--print( 'OnLevelUpHero! - found hero with ent index = ' .. nHeroEntIndex )
		if hHero.HeroLevelUp then
			hHero:HeroLevelUp( true )
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: MaxLevelUpHero
--------------------------------------------------------------------------------
function CHeroDemo:OnMaxLevelUpHero( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		--print( 'OnMaxLevelUpHero! - found hero with ent index = ' .. nHeroEntIndex )

		if hHero.AddExperience then
			hHero:AddExperience( 64400, false, false ) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced

			for i = 0, DOTA_MAX_ABILITIES - 1 do
				local hAbility = hHero:GetAbilityByIndex( i )
				if hAbility and not hAbility:IsAttributeBonus() then
					while hAbility:GetLevel() < hAbility:GetMaxLevel() and hAbility:CanAbilityBeUpgraded () == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden()  do
						hHero:UpgradeAbility( hAbility )
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ScepterHero
--------------------------------------------------------------------------------
function CHeroDemo:OnScepterHero( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		--print( 'OnScepterHero! - found hero with ent index = ' .. nHeroEntIndex )
		
		if not hHero:FindModifierByName( "modifier_item_ultimate_scepter_consumed" ) then
			hHero:AddItemByName( "item_ultimate_scepter_2" )
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ShardHero
--------------------------------------------------------------------------------
function CHeroDemo:OnShardHero( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		--print( 'OnShardHero! - found hero with ent index = ' .. nHeroEntIndex )
		
		if not hHero:FindModifierByName( "modifier_item_aghanims_shard" ) then
			hHero:AddItemByName( "item_aghanims_shard" )
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ResetHero
--------------------------------------------------------------------------------
function CHeroDemo:OnResetHero( eventSourceIndex, data )
	local nHeroEntIndex = tonumber( data.str )
	local hHero = EntIndexToHScript( nHeroEntIndex )
	if ( hHero ~= nil and hHero:IsNull() == false ) then
		if hHero:IsHero() then
			--print( 'OnResetHero! - found hero with ent index = ' .. nHeroEntIndex )
			GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept( true )
			PlayerResource:ReplaceHeroWithNoTransfer( hHero:GetPlayerOwnerID(), hHero:GetUnitName(), -1, 0 )
			GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept( false )
		elseif hHero:IsCourier() then
			hHero:RespawnCourier()
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnAllyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnAllyButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	print( 'OnSpawnAllyPressed!')
	DeepPrintTable( data )

	local hPlayer = PlayerResource:GetPlayer( data.PlayerID )

	local sHeroToSpawn = Convars:GetStr( "dota_hero_demo_default_enemy" )
	local nHeroVariant = Convars:GetInt( "dota_hero_demo_default_enemy_variant" );

	DebugCreateHeroWithVariant( hPlayer, sHeroToSpawn, nHeroVariant, self.m_nALLIES_TEAM, false,
		function( hAlly )
			hAlly:SetControllableByPlayer( self.m_nPlayerID, false )
			hAlly:SetRespawnPosition( hPlayerHero:GetAbsOrigin() )
			FindClearSpaceForUnit( hAlly, hPlayerHero:GetAbsOrigin(), false )
			hAlly:Hold()
			hAlly:SetIdleAcquire( false )
			hAlly:SetAcquisitionRange( 0 )
			self:BroadcastMsg( "#SpawnAlly_Msg" )
		end )

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnDummyTargetButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnDummyTargetButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	local hDummy = CreateUnitByName( "npc_dota_hero_target_dummy", hPlayerHero:GetAbsOrigin(), true, nil, nil, self.m_nENEMIES_TEAM )
	hDummy:SetAbilityPoints( 0 )
	hDummy:SetControllableByPlayer( self.m_nPlayerID, false )
	hDummy:Hold()
	hDummy:SetIdleAcquire( false )
	hDummy:SetAcquisitionRange( 0 )

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#SpawnDummyTarget_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnTowersEnabledButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnTowersEnabledButtonPressed( eventSourceIndex )

	local nTowersEnabledEnabled = Convars:GetInt("dota_hero_demo_towers_enabled") 
	
	if nTowersEnabledEnabled == 0 then	
		--print("Enabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 1)
		self:SetTowersEnabled( true )
		self:BroadcastMsg( "#TowersEnabledOn_Msg" )
	elseif nTowersEnabledEnabled == 1 then
		--print("Disabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 0)
		self:SetTowersEnabled( false )
		self:BroadcastMsg( "#TowersEnabledOff_Msg" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )
end

function CHeroDemo:SetTowersEnabled( bEnabled )

	--print("SetTowersEnabled: " .. tostring(bEnabled) )
	for _,tTower in pairs( self.m_rgTowers ) do
		local hTower = tTower.hUnit

		if hTower ~= nil and not hTower:IsNull() then
			if not hTower:IsAlive() and hTower:UnitCanRespawn() then
				--print(" respawning " .. tTower.sName )
				hTower:SetOriginalModel( tTower.sOriginalModel )
				hTower:RespawnUnit()
				hTower:RemoveModifierByName( "modifier_invulnerable" )
			end

			--print(" enabling " .. tTower.sName .. " " .. tostring(bEnabled) )
			if bEnabled then
				hTower:RemoveModifierByName( "modifier_generic_hidden" )
			else
				hTower:AddNewModifier( hTower, nil, "modifier_generic_hidden", {} )
			end
		end
	end		
end

function CHeroDemo:FindTowers()
	--print( "FindTowers" )
	self.m_rgTowers = {}
	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false )
	for _,hUnit in pairs( units ) do
		if hUnit:IsTower() then
			local tTower = {
				hUnit = hUnit,
				sName = hUnit:GetUnitName(),
				sOriginalModel = hUnit:GetModelName()
			}
			if hUnit:GetUnitName() == "npc_dota_goodguys_tower1_mid" then
				hUnit:SetUnitCanRespawn( true )
				self.m_rgTowers[1] = tTower
			elseif hUnit:GetUnitName() == "npc_dota_badguys_tower1_mid" then
				hUnit:SetUnitCanRespawn( true )
				self.m_rgTowers[2] = tTower
			end
		end
	end
end


--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnCreepsButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnCreepsButtonPressed( eventSourceIndex )

	local nSpawnCreepsEnabled = Convars:GetInt("dota_hero_demo_spawn_creeps_enabled") 
	
	if nSpawnCreepsEnabled == 0 then	
		--print("Enabling Creep Spawns")
		SendToServerConsole( "dota_creeps_no_spawning 0" )
		SendToServerConsole( "dota_spawn_creeps" )
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 1)
		self:BroadcastMsg( "#SpawnCreepsOn_Msg" )
	elseif nSpawnCreepsEnabled == 1 then
		--print("Disabling Creep Spawns")
		self:RemoveCreeps()
		SendToServerConsole( "dota_creeps_no_spawning 1" )
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 0)
		self:BroadcastMsg( "#SpawnCreepsOff_Msg" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnSingleCreepWaveButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnSingleCreepWaveButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_spawn_creeps" )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------

function CHeroDemo:RemoveCreeps()

	--print( "Removing Creeps" )
	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false )
	for _,hUnit in pairs( units ) do
		if hUnit:IsCreep() and not hUnit:IsControllableByAnyPlayer() then
			hUnit:Destroy()
		end
	end		

end

--------------------------------------------------------------------------------
-- SpawnRuneInFrontOfUnit - Helper method for rune spawning
--------------------------------------------------------------------------------
function CHeroDemo:SpawnRuneInFrontOfUnit( hUnit, runeType )
	if hUnit == nil then
		return
	end

	local fDistance = 200.0
	local fMinSeparation = 50.0
	local fRingOffset = fMinSeparation + 20.0
	local vDir = hUnit:GetForwardVector()
	local vInitialTarget = hUnit:GetAbsOrigin() + vDir * fDistance
	vInitialTarget.z = GetGroundHeight( vInitialTarget, nil )
	local vTarget = vInitialTarget
	local nRemainingAttempts = 100
	local fAngle = 2 * math.pi
	local fOffset = 0.0
	local bDone = false

	local vecRunes = Entities:FindAllByClassname( "dota_item_rune" )
	while ( not bDone and nRemainingAttempts > 0 ) do
		bDone = true
		-- Too close to other runes?
		for i=1, #vecRunes do
			if ( vecRunes[i]:GetAbsOrigin() - vTarget ):Length() < fMinSeparation then
				bDone = false
				break
			end
		end
		if not GridNav:CanFindPath( hUnit:GetAbsOrigin(), vTarget ) then
			bDone = false
		end 
		if not bDone then
			fAngle = fAngle + 2 * math.pi / 8
			if fAngle >= 2 * math.pi then
				fOffset = fOffset + fRingOffset
				fAngle = 0
			end
			vTarget = vInitialTarget + fOffset * Vector( math.cos( fAngle ), math.sin( fAngle), 0.0 )
			vTarget.z = GetGroundHeight( vTarget, nil )
		end
		nRemainingAttempts = nRemainingAttempts - 1
	end

	CreateRune( vTarget, runeType )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneDoubleDamagePressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneDoubleDamagePressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_DOUBLEDAMAGE )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneHastePressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneHastePressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_HASTE )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneIllusionPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneIllusionPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_ILLUSION )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneInvisibilityPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneInvisibilityPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_INVISIBILITY )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------

function CHeroDemo:GetRuneSpawnLocation()

end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneRegenerationPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneRegenerationPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_REGENERATION )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneArcanePressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneArcanePressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_ARCANE )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneShieldPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnRuneShieldPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	self:SpawnRuneInFrontOfUnit( hPlayerHero, DOTA_RUNE_SHIELD )
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnChangeSpeedStep
--------------------------------------------------------------------------------
function CHeroDemo:OnChangeSpeedStep( eventSourceIndex, data )
	--print( 'CHeroDemo:OnChangeSpeedStep' )
	--DeepPrintTable( data )
	local nData = tonumber( data.str )
	--print( 'DATA = ' .. nData )
	
	if ( nData == 0 ) then
		SendToServerConsole( "host_timescale 1" )
	elseif ( nData == 1 ) then
		SendToServerConsole( "host_timescale_inc" )
	elseif ( nData == -1 ) then
		SendToServerConsole( "host_timescale_dec" )
	end
	
	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeCosmeticsButtonPresse
--------------------------------------------------------------------------------
function CHeroDemo:OnChangeCosmeticsButtonPressed( eventSourceIndex )
	-- currently running the command directly in XML, should run it here if possible
	-- can use GetSelectedHeroID

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeHeroButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnChangeHeroButtonPressed( eventSourceIndex, data )
	-- currently running the command directly in XML, should run it here if possible
	local nHeroID = PlayerResource:GetSelectedHeroID( data.PlayerID )
	--print( "PlayerResource:GetSelectedHeroID( data.PlayerID ) == " .. nHeroID )

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnPauseButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnPauseButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_pause" )

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnLeaveButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLeaveButtonPressed( eventSourceIndex )
	EmitGlobalSound( "UI.Button.Pressed" )

	SendToServerConsole( "disconnect" )
end

--------------------------------------------------------------------------------
-- Utility Function: Clear Game State
--------------------------------------------------------------------------------
function CHeroDemo:OnClearGameState( eventSourceIndex )

	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false )
	for _,hUnit in pairs( units ) do
		if hUnit ~= nil and not hUnit:IsNull() and hUnit:IsHero() and hUnit:IsRealHero() then
			if hUnit:GetPlayerID() == 0 then
				self:OnResetHero( eventSourceIndex, { str=tostring( hUnit:entindex() ) } )
			else
				self:OnRemoveHeroButtonPressed( eventSourceIndex, { str=tostring( hUnit:entindex() ) } )
			end
		elseif hUnit:IsCreep() then
			hUnit:Destroy()
		end
	end		
end

--------------------------------------------------------------------------------
-- ButtonEvent: SaveState
--------------------------------------------------------------------------------
function CHeroDemo:OnSaveState( eventSourceIndex )
	SendToServerConsole( "dota_save_scenario demo_mode" )
end

-- ButtonEvent: RestoreState
--------------------------------------------------------------------------------
function CHeroDemo:OnRestoreState( eventSourceIndex )
	SendToServerConsole( "dota_load_demo_mode_scenario demo_mode" )
end