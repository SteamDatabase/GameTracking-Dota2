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

	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function CHeroDemo:OnNPCSpawned( event )
	spawnedUnit = EntIndexToHScript( event.entindex )

	if spawnedUnit:GetPlayerOwnerID() == 0 and spawnedUnit:IsRealHero() and not spawnedUnit:IsClone() then
		--print( "spawnedUnit is player's hero" )
		local hPlayerHero = spawnedUnit
		hPlayerHero:SetContextThink( "self:Think_InitializePlayerHero", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end

	if spawnedUnit:GetUnitName() == "npc_dota_neutral_caster" then
		--print( "Neutral Caster spawned" )
		spawnedUnit:SetContextThink( "self:Think_InitializeNeutralCaster", function() return self:Think_InitializeNeutralCaster( spawnedUnit ) end, 0 )
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
-- ButtonEvent: OnMaxLevelButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnMaxLevelButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	hPlayerHero:AddExperience( 59900, false, false ) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = hPlayerHero:GetAbilityByIndex( i )
		if hAbility and not hAbility:IsAttributeBonus() then
			while hAbility:GetLevel() < hAbility:GetMaxLevel() and hAbility:CanAbilityBeUpgraded () == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden()  do
				hPlayerHero:UpgradeAbility( hAbility )
			end
		end
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
-- ButtonEvent: OnInvulnerabilityButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnInvulnerabilityButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	local hAllPlayerUnits = {}
	hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
	hAllPlayerUnits[ #hAllPlayerUnits + 1 ] = hPlayerHero

	if self.m_bInvulnerabilityEnabled == false then
		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:AddNewModifier( hPlayerHero, nil, "lm_take_no_damage", nil )
		end
		self.m_bInvulnerabilityEnabled = true
		self:BroadcastMsg( "#InvulnerabilityOn_Msg" )
	elseif self.m_bInvulnerabilityEnabled == true then
		for _, hUnit in pairs( hAllPlayerUnits ) do
			hUnit:RemoveModifierByName( "lm_take_no_damage" )
		end
		self.m_bInvulnerabilityEnabled = false
		self:BroadcastMsg( "#InvulnerabilityOff_Msg" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnEnemyButtonPressed( eventSourceIndex, data )
	if #self.m_tEnemiesList >= 100 then
		self:BroadcastMsg( "#MaxEnemies_Msg" )
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end

	local hPlayer = PlayerResource:GetPlayer( data.PlayerID )

	local sHeroToSpawn = Convars:GetStr( "dota_hero_demo_default_enemy" )

	DebugCreateUnit( hPlayer, sHeroToSpawn, self.m_nENEMIES_TEAM, false,
		function( hEnemy )
			table.insert( self.m_tEnemiesList, hEnemy )
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
-- ButtonEvent: SelectHeroButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSelectHeroButtonPressed( eventSourceIndex, data )
	local sHeroToSpawn = DOTAGameManager:GetHeroUnitNameByID( tonumber( data.str ) )
	Convars:SetStr( "dota_hero_demo_default_enemy", sHeroToSpawn )
	EmitGlobalSound( "UI.Button.Pressed" )
end


--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLevelUpEnemyButtonPressed( eventSourceIndex )
	for k, v in pairs( self.m_tEnemiesList ) do
		if self.m_tEnemiesList[ k ]:IsRealHero() then
			self.m_tEnemiesList[ k ]:HeroLevelUp( false )
		end
	end

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#LevelUpEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnMaxLevelEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnMaxLevelEnemyButtonPressed( eventSourceIndex )
	for k, v in pairs( self.m_tEnemiesList ) do
		if self.m_tEnemiesList[ k ]:IsRealHero() then
			self.m_tEnemiesList[ k ]:AddExperience( 56045, false, false ) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced
		end
	end

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#MaxLevelEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnDummyTargetButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnDummyTargetButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	if hPlayerHero == nil then
		return
	end
	
	table.insert( self.m_tEnemiesList, CreateUnitByName( "npc_dota_hero_target_dummy", hPlayerHero:GetAbsOrigin(), true, nil, nil, self.m_nENEMIES_TEAM ) )
	local hDummy = self.m_tEnemiesList[ #self.m_tEnemiesList ]
	hDummy:SetAbilityPoints( 0 )
	hDummy:SetControllableByPlayer( self.m_nPlayerID, false )
	hDummy:Hold()
	hDummy:SetIdleAcquire( false )
	hDummy:SetAcquisitionRange( 0 )

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#SpawnDummyTarget_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRemoveSpawnedUnitsButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnRemoveSpawnedUnitsButtonPressed( eventSourceIndex )
	for k, v in pairs( self.m_tAlliesList ) do
		self.m_tAlliesList[ k ]:Destroy()
		self.m_tAlliesList[ k ] = nil
	end
	for k, v in pairs( self.m_tEnemiesList ) do
		self.m_tEnemiesList[ k ]:Destroy()
		self.m_tEnemiesList[ k ] = nil
	end

	self.m_nEnemiesCount = 0

	EmitGlobalSound( "UI.Button.Pressed" )

	--self:BroadcastMsg( "#RemoveSpawnedUnits_Msg" )
end


--------------------------------------------------------------------------------
-- ButtonEvent: OnTowersEnabledButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnTowersEnabledButtonPressed( eventSourceIndex )

	local nTowersEnabledEnabled = Convars:GetInt("dota_hero_demo_towers_enabled") 
	
	if nTowersEnabledEnabled == 0 then	
		print("Enabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 1)
		self:SetTowersEnabled( true )
		self:BroadcastMsg( "#TowersEnabledOn_Msg" )
	elseif nTowersEnabledEnabled == 1 then
		print("Disabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 0)
		self:SetTowersEnabled( false )
		self:BroadcastMsg( "#TowersEnabledOff_Msg" )
	end

	EmitGlobalSound( "UI.Button.Pressed" )
end

function CHeroDemo:SetTowersEnabled( bEnabled )

	print("SetTowersEnabled: " .. tostring(bEnabled) )
	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius( DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false )
	for _,hUnit in pairs( units ) do
		if hUnit:IsTower() then
			print(" enabling " .. hUnit:GetUnitName() .. " " .. tostring(bEnabled) )
			if bEnabled then
				hUnit:RemoveModifierByName( "modifier_generic_hidden" )
			else
				hUnit:AddNewModifier( hUnit, nil, "modifier_generic_hidden", {} )
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
		print("Enabling Creep Spawns")
		SendToServerConsole( "dota_creeps_no_spawning 0" )
		SendToServerConsole( "dota_spawn_creeps" )
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 1)
		self:BroadcastMsg( "#SpawnCreepsOn_Msg" )
	elseif nSpawnCreepsEnabled == 1 then
		print("Disabling Creep Spawns")
		SendToServerConsole( "dota_creeps_no_spawning 1" )
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 0)
		self:BroadcastMsg( "#SpawnCreepsOff_Msg" )
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
	print( "PlayerResource:GetSelectedHeroID( data.PlayerID ) == " .. nHeroID )

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