--[[ Events ]]

--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
function CHeroDemo:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	print( "OnGameRulesStateChange: " .. nNewState )

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		print( "OnGameRulesStateChange: Hero Selection" )

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		print( "OnGameRulesStateChange: Pre Game Selection" )
		SendToServerConsole( "dota_dev forcegamestart" )

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print( "OnGameRulesStateChange: Game In Progress" )

	end
end

--------------------------------------------------------------------------------
-- GameEvent: OnNPCSpawned
--------------------------------------------------------------------------------
function CHeroDemo:OnNPCSpawned( event )
	spawnedUnit = EntIndexToHScript( event.entindex )

	if spawnedUnit:GetPlayerOwnerID() == 0 and spawnedUnit:IsRealHero() and not spawnedUnit:IsClone() then
		print( "spawnedUnit is player's hero" )
		local hPlayerHero = spawnedUnit
		hPlayerHero:SetContextThink( "self:Think_InitializePlayerHero", function() return self:Think_InitializePlayerHero( hPlayerHero ) end, 0 )
	end

	if spawnedUnit:GetUnitName() == "npc_dota_neutral_caster" then
		print( "Neutral Caster spawned" )
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

	print( "neutralCaster:AddAbility( \"la_spawn_enemy_at_target\" )" )
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
	print( "sNewHeroName == " .. sNewHeroName ) -- we fail to get in here
	self:BroadcastMsg( "Changed hero to " .. sNewHeroName )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRefreshButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnRefreshButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_refresh" )
	self:BroadcastMsg( "#Refresh_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLevelUpButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_dev hero_level 1" )
	self:BroadcastMsg( "#LevelUp_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnMaxLevelButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnMaxLevelButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	hPlayerHero:AddExperience( 32400, false, false ) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced
	--while hPlayerHero:GetLevel() < 25 do
		--hPlayerHero:HeroLevelUp( false )
	--end

	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local hAbility = hPlayerHero:GetAbilityByIndex( i )
		if hAbility and hAbility:CanAbilityBeUpgraded () == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() then
			while hAbility:GetLevel() < hAbility:GetMaxLevel() do
				hPlayerHero:UpgradeAbility( hAbility )
			end
		end
	end

	hPlayerHero:SetAbilityPoints( 0 )
	self:BroadcastMsg( "#MaxLevel_Msg" )
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
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnInvulnerabilityButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnInvulnerabilityButtonPressed( eventSourceIndex, data )
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
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
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnSpawnEnemyButtonPressed( eventSourceIndex, data )
	if #self.m_tEnemiesList >= 100 then
		print( "#self.m_tEnemiesList == " .. #self.m_tEnemiesList )

		self:BroadcastMsg( "#MaxEnemies_Msg" )
		return
	end

	local hAbility = self._hNeutralCaster:FindAbilityByName( "la_spawn_enemy_at_target" )
	self._hNeutralCaster:CastAbilityImmediately( hAbility, -1 )

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity( data.PlayerID )
	local hAbilityTestSearch = hPlayerHero:FindAbilityByName( "la_spawn_enemy_at_target" )
	if hAbilityTestSearch then -- Testing whether AddAbility worked successfully on the lua-based ability
		print( "hPlayerHero:AddAbility( \"la_spawn_enemy_at_target\" ) was successful" )
	end

	self:BroadcastMsg( "#SpawnEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpEnemyButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLevelUpEnemyButtonPressed( eventSourceIndex )
	for k, v in pairs( self.m_tEnemiesList ) do
		self.m_tEnemiesList[ k ]:HeroLevelUp( false )
	end
	self:BroadcastMsg( "#LevelUpEnemy_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRemoveSpawnedUnitsButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnRemoveSpawnedUnitsButtonPressed( eventSourceIndex )
	print( "Entering CHeroDemo:OnRemoveSpawnedUnitsButtonPressed( eventSourceIndex )" )
	PrintTable( self.m_tAlliesList, " " )
	for k, v in pairs( self.m_tAlliesList ) do
		self.m_tAlliesList[ k ]:Destroy()
		self.m_tAlliesList[ k ] = nil
	end
	PrintTable( self.m_tEnemiesList, " " )
	for k, v in pairs( self.m_tEnemiesList ) do
		self.m_tEnemiesList[ k ]:Destroy()
		self.m_tEnemiesList[ k ] = nil
	end
	PrintTable( self.m_tDummiesList, " " )
	for k, v in pairs( self.m_tDummiesList ) do
		self.m_tDummiesList[ k ]:Destroy()
		self.m_tDummiesList[ k ] = nil
	end

	self.m_nEnemiesCount = 0
	self.m_nDummiesCount = 0

	self:BroadcastMsg( "#RemoveSpawnedUnits_Msg" )
end



--------------------------------------------------------------------------------
-- ButtonEvent: OnDayNightToggleButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnDayNightToggleButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_daynightcycle_toggle")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnHeroRenderModeButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnHeroRenderModeButtonPressed( eventSourceIndex )
	self.m_nHeroRenderMode = self.m_nHeroRenderMode + 1
	if self.m_nHeroRenderMode > 8 then
		self.m_nHeroRenderMode = 0
	end
	if self.m_nHeroRenderMode == 1 then
		self.m_nHeroRenderMode = 2 
	end

	if self.m_nHeroRenderMode == 0 then
		self:BroadcastMsg( "#HeroRender_Normal")
	elseif self.m_nHeroRenderMode == 2 then
		self:BroadcastMsg( "#HeroRender_GrayScale_full_spec_no_normals" )
	elseif self.m_nHeroRenderMode == 3 then
		self:BroadcastMsg( "#HeroRender_Grayscale_full_spec" )
	elseif self.m_nHeroRenderMode == 4 then
		self:BroadcastMsg( "#HeroRender_Grayscale_with_normals" )
	elseif self.m_nHeroRenderMode == 5 then
		self:BroadcastMsg( "#HeroRender_Desaturated" )
	elseif self.m_nHeroRenderMode == 6 then
		self:BroadcastMsg( "#HeroRender_Wireframe" )
	elseif self.m_nHeroRenderMode == 7 then
		self:BroadcastMsg( "#HeroRender_Shaded_Wireframe" )
	elseif self.m_nHeroRenderMode == 8 then
		self:BroadcastMsg( "#HeroRender_Wireframe_Overlay" )
	end

	SendToServerConsole( tostring( string.format( "r_hero_debug_render_mode %i", self.m_nHeroRenderMode ) ) )
end

--------------------------------------------------------------------------------
-- GameEvent: OnPauseButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnPauseButtonPressed( eventSourceIndex )
	SendToServerConsole( "dota_pause" )
end

--------------------------------------------------------------------------------
-- GameEvent: OnLeaveButtonPressed
--------------------------------------------------------------------------------
function CHeroDemo:OnLeaveButtonPressed( eventSourceIndex )
	SendToServerConsole( "disconnect" )
end