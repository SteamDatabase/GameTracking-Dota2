--[[
	Underscore prefix such as "_function()" denotes a local function and is used to improve readability
	
	Variable Prefix Examples
		"fl"	Float
		"n"		Int
		"v"		Table
		"b"		Boolean
]]

--[[ CustomUI reference
	CustomUI:DynamicHud_Create - Create a new custom hud element for the specified player(s). ( int PlayerID /*-1 means everyone*/, string ElementID /* should be unique */, string LayoutFileName, table DialogVariables /* can be nil */ )
	CustomUI:DynamicHud_SetVisible - Toggle the visibility of an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, bool Visible )
	CustomUI:DynamicHud_SetDialogVariables - Add or modify dialog variables for an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, table DialogVariables )
	CustomUI:DynamicHud_Destroy - Destroy a custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID )
]]

ON_INITIALIZED = 0
ON_SKIP_STATE = 1
ON_HERO_SPAWNED = 2
ON_THINK = 3
ON_TIP_DISMISSED = 4
ON_TASK_ADVANCED = 5
ON_PLAYER_GAINED_LEVEL = 6
ON_ABILITY_LEARNED = 7
ON_PLAYER_USED_ABILITY = 8
ON_ITEM_PURCHASED = 9
ON_ITEM_USED = 10
ON_LAST_HIT = 11
ON_SHOP_OPENED = 12
ON_SHOP_CLOSED = 13
ON_TOWER_KILL_GOOD = 14
ON_TOWER_KILL_BAD = 15
ON_PLAYER_TOOK_TOWER_DAMAGE = 16
ON_LEVEL_ABILITY_TOGGLED_ON = 17
ON_LEVEL_ABILITY_TOGGLED_OFF = 18

DEATH_TIP_NEVER_SHOWN = 0
DEATH_TIP_FIRST_VISIBLE = 1
DEATH_TIP_FIRST_WAITING_FOR_SPAWN = 2
DEATH_TIP_FIRST_CLOSED = 3
DEATH_TIP_SECOND_VISIBLE = 4
DEATH_TIP_SECOND_WAITING_FOR_SPAWN = 5
DEATH_TIP_FINISHED = 6


TIP_NEVER_SHOWN = 0
TIP_VISIBLE = 1
TIP_DISMISSED = 2

ABILITY_ID_TANGO = 44

--ON_TIP_CONTINUE_PRESSED = 5

if CTutorialBasics == nil then
	CTutorialBasics = class({})
end

-- Precache resources
function Precache( context )
	PrecacheResource( "particle", "particles/ui_mouseactions/unit_highlight.vpcf", context )
end

-- Actually make the game mode when we activate
function Activate()  
	GameRules.tutorialBasics = CTutorialBasics()
	GameRules.tutorialBasics:InitGameMode()
end


function CTutorialBasics:InitGameMode()
	self._flLastThinkGameTime = nil
	self._entAncient = Entities:FindByName( nil, "dota_goodguys_fort" )
	if not self._entAncient then
		print( "Ancient entity not found!" )
	end

	self._entTargetTower = Entities:FindByName( nil, "dota_badguys_tower1_mid" )
	if not self._entTargetTower then
		print( "Target Tower not found!" )
	end

	self._hPlayerHero = nil
	self._bShowedSalveTip = nil
	self._bShowedTangoTip = nil
	self._bShowedClarityTip = nil
	self._bShowedDeathTip = nil
	self._bPreventTowerDamage = true
	self._nDeathTipState = DEATH_TIP_NEVER_SHOWN

	self._nTangoTipState = TIP_NEVER_SHOWN
	self._nClarityTipState = TIP_NEVER_SHOWN
	self._nSalveTipState = TIP_NEVER_SHOWN
	self._nTowerDamageTipState = TIP_NEVER_SHOWN

	PrecacheUnitByNameAsync( "npc_dota_hero_luna",				function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_razor",				function(unit) end )

	Tutorial:StartTutorialMode()

	self._flDelay = 0
	self._nTowerHits = 0
	self._flTowerLastHitTime = 0
	self._flAlertDelay = 0
	self._bInitialized = false
	self._CurrentState = "setup"
	self._vTransitionTable = {}

	self._vTransitionTable["setup"] =					{ fnOnEnter = nil,							nAdvanceEvent = ON_INITIALIZED,		strNext = "wait_for_spawn" }
	self._vTransitionTable["wait_for_spawn"] =			{ fnOnEnter = self._BasicsSetup,			nAdvanceEvent = ON_HERO_SPAWNED,	strNext = "skill_attributes" }
	self._vTransitionTable["skill_attributes"] =		{ fnOnEnter = self._BasicsTakeAttributes,	nAdvanceEvent = ON_THINK,			strNext = "introduce_hero" }
	self._vTransitionTable["introduce_hero"] =			{ fnOnEnter = self._HeroIntroTip,			nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "introduce_fountain" }
	self._vTransitionTable["introduce_fountain"] =		{ fnOnEnter = self._FountainTip,			nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "move_hero_tip" }
	self._vTransitionTable["move_hero_tip"] =			{ fnOnEnter = self._HeroMoveTip,			nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "move_to_ancient_quest" }
	self._vTransitionTable["move_to_ancient_quest"] =	{ fnOnEnter = self._MoveToAncientQuest,		nAdvanceEvent = ON_TASK_ADVANCED,	strNext = "introduce_ancient" }

	self._vTransitionTable["introduce_ancient"] =		{ fnOnEnter = self._CompleteAncientQuest,	nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "introduce_purchasing", fnOnEnterDelayed = self._AncientTip,	flEnterDelay = 1 } 
	self._vTransitionTable["introduce_map"] =			{ fnOnEnter = self._MapTip,					nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "introduce_purchasing", } 

	self._vTransitionTable["introduce_purchasing"] =	{ fnOnEnter = self._PurchasingTip,			nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "back_to_base_quest" }
	self._vTransitionTable["back_to_base_quest"] =		{ fnOnEnter = self._BackToBaseQuest,		nAdvanceEvent = ON_TASK_ADVANCED,	strNext = "open_shop_quest" }

	self._vTransitionTable["open_shop_quest"] =			{ fnOnEnter = self._CompleteBackToBaseQuest,nAdvanceEvent = ON_SHOP_OPENED,		strNext = "introduce_the_shop", fnOnEnterDelayed = self._OpenShopQuest,	flEnterDelay = 1  }
	self._vTransitionTable["introduce_the_shop"] =		{ fnOnEnter = self._CompleteOpenShopQuest,	nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "buy_items_quest", fnOnEnterDelayed = self._ShopTip,	flEnterDelay = 1 }

	self._vTransitionTable["buy_items_quest"] =			{ fnOnEnter = self._BuyTangoesQuest,		nAdvanceEvent = ON_ITEM_PURCHASED,	strNext = "buy_items_quest2" }
	self._vTransitionTable["buy_items_quest2"] =		{ fnOnEnter = self._BuySalveQuest,			nAdvanceEvent = ON_ITEM_PURCHASED,	strNext = "buy_items_quest3" }
	self._vTransitionTable["buy_items_quest3"] =		{ fnOnEnter = self._BuyClarityQuest,		nAdvanceEvent = ON_ITEM_PURCHASED,	strNext = "buy_items_quest4" }
	self._vTransitionTable["buy_items_quest4"] =		{ fnOnEnter = self._BuyCirclet,				nAdvanceEvent = ON_ITEM_PURCHASED,	strNext = "buy_items_quest5" }
	self._vTransitionTable["buy_items_quest5"] =		{ fnOnEnter = self._BuySlippers,			nAdvanceEvent = ON_ITEM_PURCHASED,	strNext = "explain_items" }

	self._vTransitionTable["explain_items"] =			{ fnOnEnter = self._CompleteShopQuest,		nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "introduce_lanes", fnOnEnterDelayed = self._ExplainItemsTip,	flEnterDelay = 1 }
	self._vTransitionTable["introduce_lanes"] =			{ fnOnEnter = self._LanesTip,				nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "move_to_mid_quest" }
	self._vTransitionTable["move_to_mid_quest"] =		{ fnOnEnter = self._MoveToMidQuest,			nAdvanceEvent = ON_TASK_ADVANCED,	strNext = "introduce_creeps" }

	self._vTransitionTable["introduce_creeps"] =		{ fnOnEnter = self._CompleteMoveToMidQuest,	nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "introduce_laning", fnOnEnterDelayed = self._CreepsTip,	flEnterDelay = 1 }
	self._vTransitionTable["introduce_laning"] =		{ fnOnEnter = self._LaningTip,				nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "move_to_lane_quest" }
	self._vTransitionTable["move_to_lane_quest"] =		{ fnOnEnter = self._MoveToLaneQuest,		nAdvanceEvent = ON_TASK_ADVANCED,	strNext = "introduce_combat" }

	self._vTransitionTable["introduce_combat"] =		{ fnOnEnter = self._CompleteToLaneQuest,		nAdvanceEvent = ON_THINK,			strNext = "introduce_xp"  }
	self._vTransitionTable["introduce_xp"] =			{ fnOnEnter = self._XPTip,						nAdvanceEvent = ON_TIP_DISMISSED,		strNext = "gain_level_quest" }
	self._vTransitionTable["gain_level_quest"] =		{ fnOnEnter = self._GainLevelQuest,				nAdvanceEvent = ON_TIP_DISMISSED,		strNext = "wait_for_level", fnOnEnterDelayed = self._AttackingTip,	flEnterDelay = 1 }
	self._vTransitionTable["wait_for_level"] =			{ fnOnEnter = self._GainLevelQuest, 			nAdvanceEvent = ON_PLAYER_GAINED_LEVEL, 	strNext = "introduce_ability_levels" }
	self._vTransitionTable["introduce_ability_levels"] = { fnOnEnter = self._LevelAbilityTip, 			nAdvanceEvent = ON_TIP_DISMISSED,           strNext = "buy_ability_quest" }
	self._vTransitionTable["buy_ability_quest"] =		{ fnOnEnter = self._LevelAbilityQuest,			nAdvanceEvent = ON_ABILITY_LEARNED,			strNext = "introduce_casting" }

	self._vTransitionTable["introduce_casting"] =		{ fnOnEnter = self._CompleteLevelAbilityQuest,	nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "cast_ability_quest", fnOnEnterDelayed = self._CastingTip, flEnterDelay = 1 }
	self._vTransitionTable["cast_ability_quest"] =		{ fnOnEnter = self._CastQuest,					nAdvanceEvent = ON_PLAYER_USED_ABILITY,		strNext = "introduce_towers" }

	self._vTransitionTable["introduce_towers"] =		{ fnOnEnter = self._CompleteCastQuest,		nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "kill_tower_quest", 	fnOnEnterDelayed = self._TowersTip, flEnterDelay = 1 }
	self._vTransitionTable["kill_tower_quest"] =		{ fnOnEnter = self._KillTowerQuest,			nAdvanceEvent = ON_TOWER_KILL_GOOD,	strNext = "end" }
	self._vTransitionTable["end"] =						{ fnOnEnter = self._EndTutorial,			nAdvanceEvent = ON_TIP_DISMISSED,	strNext = "exit", fnOnEnterDelayed = self._VictoryTip,	flEnterDelay = 5 }
	self._vTransitionTable["exit"] =					{ fnOnEnter = self._ExitMatch,				nAdvanceEvent = nil,				strNext = nil }

	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetPreGameTime( 60.0 )
	GameRules:SetPostGameTime( 15.0 )
	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetGoldTickTime( 60.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetCustomGameSetupTimeout( 0 )

	GameRules:GetGameModeEntity():SetBotsInLateGame( false )
	GameRules:GetGameModeEntity():SetBotThinkingEnabled( true )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )

	GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_luna" )

	self._nFXIndex = -1
	self._flFXClearTime = -1

	-- Custom console commands
	Convars:RegisterCommand( "tutorial_advance", function(...) return self:_TestAdvanceTutorial( ... ) end, "Advance the tutorial to the next state.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_test_ui", function(...) return self:_TestTutorialUI( ... ) end, "Test tutorial UI state.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_set_hud_visibility", function(...) return self:_SetHudVisiblity( ... ) end, "Set visibility on a piece of UI.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_test_victory", function(...) return self:_TestTutorialVictory( ... ) end, "Advance the tutorial to the next state.", FCVAR_CHEAT )

	GameRules:GetGameModeEntity():SetTrackingProjectileFilter( Dynamic_Wrap( CTutorialBasics, "FilterTrackingProjectile" ), self )

	CustomGameEventManager:RegisterListener( "AbilityStartUse", function(...) return self:OnAbilityStartUse( ... ) end )
	CustomGameEventManager:RegisterListener( "AbilityLearnModeToggled", function(...) return self:OnAbilityLearnModeToggled( ... ) end )
	CustomGameEventManager:RegisterListener( "ButtonPressed", function(...) return self:OnDialogButtonPressed( ... ) end )

	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned",							Dynamic_Wrap( CTutorialBasics, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_tutorial_task_advance",			Dynamic_Wrap( CTutorialBasics, "OnTaskAdvance" ), self )
	ListenToGameEvent( "dota_player_gained_level",				Dynamic_Wrap( CTutorialBasics, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_player_spawned",					Dynamic_Wrap( CTutorialBasics, "OnPlayerSpawned" ), self )
	ListenToGameEvent( "dota_player_learned_ability",			Dynamic_Wrap( CTutorialBasics, "OnPlayerLearnedAbility" ), self )
	ListenToGameEvent( "dota_player_used_ability",				Dynamic_Wrap( CTutorialBasics, "OnPlayerUsedAbility" ), self )
	ListenToGameEvent( "dota_player_take_tower_damage",			Dynamic_Wrap( CTutorialBasics, "OnPlayerTookTowerDamage" ), self )
	ListenToGameEvent( "dota_item_purchased",					Dynamic_Wrap( CTutorialBasics, "OnItemPurchased" ), self )
	ListenToGameEvent( "dota_item_used",						Dynamic_Wrap( CTutorialBasics, "OnItemUsed" ), self )
	ListenToGameEvent( "last_hit",								Dynamic_Wrap( CTutorialBasics, "OnLastHit" ), self )
	ListenToGameEvent( "dota_tower_kill",						Dynamic_Wrap( CTutorialBasics, "OnTowerKill" ), self )
	ListenToGameEvent( "dota_tutorial_shop_toggled",			Dynamic_Wrap( CTutorialBasics, "OnShopToggled" ), self )
--	ListenToGameEvent( "dota_tutorial_level_ability_toggled",	Dynamic_Wrap( CTutorialBasics, "OnLevelAbilityToggled" ), self )
--	ListenToGameEvent( "dota_tutorial_ability_start_use",		Dynamic_Wrap( CTutorialBasics, "OnAbilityStartUse" ), self )
	ListenToGameEvent( "entity_killed", 						Dynamic_Wrap( CTutorialBasics, 'OnEntityKilled' ), self )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 ) 

end

-----------------------------------------------------------------------------------------
-- Debug Functions
-----------------------------------------------------------------------------------------

function CTutorialBasics:_TestAdvanceTutorial( cmdName )
	print ("Want to advance tutorial round" )
	self:_FireEvent( ON_SKIP_STATE )
end

function CTutorialBasics:_TestTutorialVictory( cmdName )
	self:_SetState( "end" )
--	self:_EndTutorial()
end

function CTutorialBasics:_TestTutorialUI( cmdName, nUiState )
	Tutorial:SetTutorialUI( tonumber( nUiState ) )
end

function CTutorialBasics:_SetHudVisiblity( cmdName, nUiPanel, bVisible )
	print( nUiPanel )
	print( bVisible )
	local bSetVisilble = false
	if( bVisible == "true" ) then
		bSetVisilble = true
	end
	GameRules:GetGameModeEntity():SetHUDVisible( tonumber( nUiPanel ), bSetVisilble )
end

-----------------------------------------------------------------------------------------
-- Filters
-----------------------------------------------------------------------------------------

function CTutorialBasics:FilterTrackingProjectile( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("TP: " .. k .. " " .. tostring(v) )
--	end

	local hVictim = EntIndexToHScript( filterTable["entindex_target_const"] )
	local hAttacker = EntIndexToHScript( filterTable["entindex_source_const"] )

	if ( hVictim == nil or hAttacker == nil ) then
		return true
	end

	local bDoAttack = true

	if ( hVictim:IsHero() and hAttacker:IsTower() and hVictim:GetPlayerID() == 0 ) then
		if ( self._nFXIndex ~= -1 ) then
			ParticleManager:DestroyParticle( self._nFXIndex, true )
		end

		self._nFXIndex = ParticleManager:CreateParticle( "particles/ui_mouseactions/unit_highlight.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker )
		ParticleManager:SetParticleControl( self._nFXIndex, 1, Vector( 255, 125, 0 ) )
		ParticleManager:SetParticleControl( self._nFXIndex, 2, Vector( 820, 32, 820 ) )
		self._flFXClearTime = 1.0
	end
	return bDoAttack
end

-----------------------------------------------------------------------------------------
-- Events
-----------------------------------------------------------------------------------------

function CTutorialBasics:OnDialogButtonPressed( eventSourceIndex, args )
	self:_FireEvent( ON_TIP_DISMISSED )
--	print( "ButtonPressed: ( " .. eventSourceIndex .. ", " .. args['str'] .. " )" )
end

function CTutorialBasics:OnTaskAdvance()
	print("I'm done with my task!")
	self:_FireEvent( ON_TASK_ADVANCED )
end

function CTutorialBasics:OnPlayerSpawned()
	if ( self._bInitialized == false ) then
		self._bInitialized = true
		self:_FireEvent( ON_INITIALIZED )
	end
end

function CTutorialBasics:OnPlayerGainedLevel()
	print("Level Gained")
	self:_FireEvent( ON_PLAYER_GAINED_LEVEL )
end

function CTutorialBasics:OnPlayerLearnedAbility( event )
	-- Shortcut if we skip a state.
	if ( self._CurrentState == "introduce_leveling" or self._CurrentState == "level_up_quest" or self._CurrentState == "buy_ability_quest" ) then
		self:_SetState( "introduce_casting" )
	end

	self:_FireEvent( ON_ABILITY_LEARNED )
end

function CTutorialBasics:OnPlayerUsedAbility()
	print("Ability Used")
	self:_FireEvent( ON_PLAYER_USED_ABILITY )
end

function CTutorialBasics:OnPlayerTookTowerDamage( event )
	if ( event.PlayerID == 0 ) then
		print("Player tower damage")

		self._nTowerHits = self._nTowerHits + 1
		self:_CheckForTowerTip()
		self._flTowerLastHitTime = GameRules:GetGameTime()
	end
end

function CTutorialBasics:OnItemPurchased()
	print("Item purchased")
	self:_FireEvent( ON_ITEM_PURCHASED )
end

function CTutorialBasics:OnItemUsed()
	print("Item used")
	self:_FireEvent( ON_ITEM_USED )
end

function CTutorialBasics:OnLastHit( event )
	if ( event.TowerKill == 0 and event.HeroKill == 0 ) then
		self:_FireEvent( ON_LAST_HIT )
	end
end

function CTutorialBasics:OnTowerKill( event )
	if ( event.teamnumber == 2 ) then
		self:_FireEvent( ON_TOWER_KILL_GOOD )
	else
		self:_FireEvent( ON_TOWER_KILL_BAD )
	end		
end

function CTutorialBasics:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if killedUnit:IsRealHero() and killedUnit:GetPlayerID() == 0 then
		print("Hero was killed")
		self:_CheckForDeathTip()
	end
end

function CTutorialBasics:OnAbilityLearnModeToggled( eventSourceIndex, args )
	if ( args.enabled ) then
		print("Ability Toggle on")
		self:_FireEvent( ON_LEVEL_ABILITY_TOGGLED_ON )
	else
		print("Ability Toggle off")
		self:_FireEvent( ON_LEVEL_ABILITY_TOGGLED_OFF )
	end
end

--function CTutorialBasics:OnAbilityStartUse( event )
--	print( "ability is being targeted " .. tostring( event.ability_id ) )
--
--	if( ABILITY_ID_TANGO == event.ability_id ) then
--		self:OnTangoUsed()
--	end
--end

function CTutorialBasics:OnAbilityStartUse( eventSourceIndex, args )
	print( "Ability is being targeted " .. tostring( args.ability_id ) )

	if( ABILITY_ID_TANGO == args.ability_id ) then
		self:OnTangoUsed()
	end
end

function CTutorialBasics:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsRealHero() then
		print("Hero is spawned!!!")
		if( self:_IsDeathTipVisible() ) then
			self:_ClearRespawnTip()
			return
		end
		self:_FireEvent( ON_HERO_SPAWNED )
	end
end

function CTutorialBasics:OnShopToggled( event )
	print( "Shop opened? " .. event.shop_opened )
	if ( event.shop_opened == 1 ) then
		self:_FireEvent( ON_SHOP_OPENED )
	else
		self:_FireEvent( ON_SHOP_CLOSED )
	end
end

function CTutorialBasics:OnTangoUsed()
	if ( self._nTangoTipState == TIP_NEVER_SHOWN ) then
		Tutorial:SetTimeFrozen( true )
		self:_SetScriptTipsVisible( false )
		self._nTangoTipState = TIP_VISIBLE

		self:_CreateAlertDialog( "", { TitleTextVar = "basics_alert_TangoUsageTitle", BodyTextVar = "basics_alert_TangoUsageBody" } )

--		CustomUI:DynamicHud_Create( -1, "tutorial_health_alert", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "#basics_alert_TangoUsageTitle", BodyTextVar = "#basics_alert_TangoUsageBody" } )
	end
end

-----------------------------------------------------------------------------------------
-- State Management
-----------------------------------------------------------------------------------------

-- Evaluate the state of the game
function CTutorialBasics:OnThink()
	if ( self._bPreventTowerDamage == true ) then
		self._entTargetTower:ModifyHealth( 500, nil, false, 0 )
	end

	if ( self._flFXClearTime > 0 and self._nFXIndex ~= -1 ) then
		self._flFXClearTime = self._flFXClearTime - 0.25
		if ( self._flFXClearTime <= 0 ) then
			ParticleManager:DestroyParticle( self._nFXIndex, true )
			self._nFXIndex = -1
		end
	end

	if ( self._nTowerDamageTipState == TIP_VISIBLE ) then
		print("Tower Damage tip visible!")
		if ( self._flTowerLastHitTime + 5 < GameRules:GetGameTime() ) then
			self:_ClearTowerDamageTip()
		end
	end

	-- Don't continue thinking if we are displaying a death tip
	if ( self:_IsDeathTipVisible() ) then
		print("Death tip visible!")
		return 0.25
	end

	self:_FireEvent( ON_THINK )

	vCurrentState = self:_GetState()
	if ( vCurrentState ~= nil ) then
		if ( self._flDelay > 0 ) then
			self._flDelay = self._flDelay - 0.25

			if ( self._flDelay <= 0 ) then
				if ( vCurrentState.fnOnEnterDelayed ~= nil ) then
					vCurrentState.fnOnEnterDelayed( self )
				end
			end
		end
	end

	-- disable side alerts for now.
	-- self:_CheckForAlerts()

	if ( self._flAlertDelay > 0 ) then
		self._flAlertDelay = self._flAlertDelay - 0.25
		if ( self._flAlertDelay <= 0 ) then
			CustomUI:DynamicHud_Destroy( -1, "tutorial_alert" )
		end
	end

	return 0.25
end

function CTutorialBasics:_GetState()
	if ( self._CurrentState == nil ) then
		return nil
	end
	return self._vTransitionTable[ self._CurrentState ]
end

function CTutorialBasics:_SetState( strNewState )
	self._CurrentState = strNewState

	vCurrentState = self:_GetState()
	if ( vCurrentState == nil ) then
		print("State is nil")
	else
		if ( vCurrentState.fnOnEnter ~= nil ) then
			vCurrentState.fnOnEnter( self )
		end

		if ( vCurrentState.fnOnEnterDelayed ~= nil ) then
			self._flDelay = vCurrentState.flEnterDelay
		end
	end
end

function CTutorialBasics:_FireEvent( nEvent )
	vCurrentState = self:_GetState()
	if ( vCurrentState == nil ) then
		return
	end

	if ( nEvent == ON_TIP_DISMISSED ) then

		if ( ( self._nDeathTipState == DEATH_TIP_FIRST_VISIBLE ) or ( self._nDeathTipState == DEATH_TIP_SECOND_VISIBLE ) ) then		
			print("Clearing Death Tip")
			self:_ClearDeathTip()
			return
		end

		if ( self:_IsHealingTipVisible() ) then
			self:_ClearHealingTip()
			return
		end
	end

	if ( ( nEvent == ON_SKIP_STATE ) or ( nEvent == vCurrentState.nAdvanceEvent ) ) then
		print("Advance even hit")
		self:_SetState( vCurrentState.strNext )
	end
end

-----------------------------------------------------------------------------------------
-- Dynamic tips
-----------------------------------------------------------------------------------------

function CTutorialBasics:_SetTipImage( imageClassName )
	local event_data =
	{
	    image_class = imageClassName,
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_image", event_data )
end

function CTutorialBasics:_SetAlertImage( imageClassName )
	local event_data =
	{
	    image_class = imageClassName,
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_alert_image", event_data )
end

function CTutorialBasics:_CheckForAlerts()
	if ( self._hPlayerHero == nil ) then
		self._hPlayerHero = PlayerResource:GetSelectedHeroEntity( 0 )
		return
	end

	local healthPct = 100*self._hPlayerHero:GetHealth() / self._hPlayerHero:GetMaxHealth()
	local manaPct = 100*self._hPlayerHero:GetMana() / self._hPlayerHero:GetMaxMana()

	if ( self._flAlertDelay <= 0 ) then
		if ( self._bShowedSalveTip == nil ) and ( healthPct < 50 ) then
			self:_CreateSideAlertDialog( "SalveImage", { TitleTextVar = "basics_alert_UseSalveTitle", BodyTextVar = "basics_alert_UseSalveBody" } )
--			CustomUI:DynamicHud_Create( -1, "tutorial_alert", "file://{resources}/layout/custom_game/tutorial_alert_salve.xml", { TitleTextVar = "#basics_alert_UseSalveTitle", BodyTextVar = "#basics_alert_UseSalveBody" } )
			self._flAlertDelay = 5.0
			self._bShowedSalveTip = true
		elseif ( self._bShowedTangoTip == nil ) and ( healthPct < 80 ) then
			self:_CreateSideAlertDialog( "TangoImage", { TitleTextVar = "basics_alert_UseTangoTitle", BodyTextVar = "basics_alert_UseTangoBody" } )
--			CustomUI:DynamicHud_Create( -1, "tutorial_alert", "file://{resources}/layout/custom_game/tutorial_alert_tango.xml", { TitleTextVar = "#basics_alert_UseTangoTitle", BodyTextVar = "#basics_alert_UseTangoBody" } )
			self._flAlertDelay = 5.0
			self._bShowedTangoTip = true
		elseif ( self._bShowedClarityTip == nil ) and ( manaPct < 50 ) then
			self:_CreateSideAlertDialog( "ClarityImage", { TitleTextVar = "basics_alert_UseClarityTitle", BodyTextVar = "basics_alert_UseClarityBody" } )
--			CustomUI:DynamicHud_Create( -1, "tutorial_alert", "file://{resources}/layout/custom_game/tutorial_alert_clarity.xml", { TitleTextVar = "#basics_alert_UseClarityTitle", BodyTextVar = "#basics_alert_UseClarityBody" } )
			self._flAlertDelay = 5.0
			self._bShowedClarityTip = true
		end
	end
end

function CTutorialBasics:_IsInterruptingTipVisible()
	if ( self._IsDeathTipVisible() or 
		 self._IsHealingTipVisible() ) then
		return true
	end
	return false
end

function CTutorialBasics:_IsHealingTipVisible()
	if ( ( self._nTangoTipState == TIP_VISIBLE ) or 
		 ( self._nClarityTipState == TIP_VISIBLE ) or 
		 ( self._nSalveTipState == TIP_VISIBLE ) ) then
		return true
	end
	return false
end

function CTutorialBasics:_IsDeathTipVisible()
	if ( ( self._nDeathTipState == DEATH_TIP_FIRST_VISIBLE ) or 
		 ( self._nDeathTipState == DEATH_TIP_FIRST_WAITING_FOR_SPAWN ) or 
		 ( self._nDeathTipState == DEATH_TIP_SECOND_VISIBLE ) or 
		 ( self._nDeathTipState == DEATH_TIP_SECOND_WAITING_FOR_SPAWN ) ) then
		return true
	end
	return false
end

function CTutorialBasics:_SetScriptTipsVisible( bVisible )
	CustomUI:DynamicHud_SetVisible( -1, "tutorial_alert", bVisible )
	CustomUI:DynamicHud_SetVisible( -1, "tutorial_tip", bVisible )
	CustomUI:DynamicHud_SetVisible( -1, "tutorial_objective", bVisible )
	CustomUI:DynamicHud_SetVisible( -1, "tutorial_objective_completed", bVisible )
end

function CTutorialBasics:_CheckForDeathTip()
	local bDisplayedTip = false

	if ( self._nDeathTipState == DEATH_TIP_NEVER_SHOWN ) then
		self:_CreateAlertDialog( "HeroImage", { TitleTextVar = "#basics_alert_FirstDeathTitle", BodyTextVar = "#basics_alert_FirstDeathBody" } )
--		CustomUI:DynamicHud_Create( -1, "tutorial_death_alert", "file://{resources}/layout/custom_game/tutorial_dialog_death.xml", { TitleTextVar = "#basics_alert_FirstDeathTitle", BodyTextVar = "#basics_alert_FirstDeathBody" } )
		self._nDeathTipState = DEATH_TIP_FIRST_VISIBLE
		bDisplayedTip = true
	elseif ( self._nDeathTipState == DEATH_TIP_FIRST_CLOSED ) then
		self:_CreateAlertDialog( "HeroImage", { TitleTextVar = "#basics_alert_SecondDeathTitle", BodyTextVar = "#basics_alert_SecondDeathBody" } )
--		CustomUI:DynamicHud_Create( -1, "tutorial_death_alert", "file://{resources}/layout/custom_game/tutorial_dialog_death.xml", { TitleTextVar = "#basics_alert_SecondDeathTitle", BodyTextVar = "#basics_alert_SecondDeathBody" } )
		self._nDeathTipState = DEATH_TIP_SECOND_VISIBLE
		bDisplayedTip = true
	end

	if ( bDisplayedTip ) then
		self:_SetScriptTipsVisible( false )
	end
end

function CTutorialBasics:_ClearTowerDamageTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_alert" )
	self._nTowerDamageTipState = TIP_DISMISSED
end

function CTutorialBasics:_ClearHealingTip()

	CustomUI:DynamicHud_Destroy( -1, "tutorial_alert_centered" )
	self:_SetScriptTipsVisible( true )

	if ( self._nTangoTipState == TIP_VISIBLE ) then
		self._nTangoTipState = TIP_DISMISSED
	elseif ( self._nClarityTipState == TIP_VISIBLE ) then
		self._nClarityTipState = TIP_DISMISSED
	elseif ( self._nSalveTipState == TIP_VISIBLE ) then
		self._nSalveTipState = TIP_DISMISSED
	end
end

function CTutorialBasics:_ClearDeathTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_alert_centered" )
	self:_CreateLockedAlertDialog( "HeroImage", { TitleTextVar = "#basics_alert_RespawnTitle", BodyTextVar = "#basics_alert_RespawnBody" } )

--	CustomUI:DynamicHud_Create( -1, "tutorial_respawn_alert", "file://{resources}/layout/custom_game/tutorial_dialog_respawn.xml", { TitleTextVar = "#basics_alert_RespawnTitle", BodyTextVar = "#basics_alert_RespawnBody" } )
	self._nDeathTipState = self._nDeathTipState + 1
end

function CTutorialBasics:_ClearRespawnTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_alert_no_button" )
	self._nDeathTipState = self._nDeathTipState + 1
	self:_SetScriptTipsVisible( true )
end

function CTutorialBasics:_CheckForTowerTip()

	print( "current time " .. tostring( GameRules:GetGameTime() ) .. " last time " .. tostring( self._flTowerLastHitTime ) )

	if ( self._flTowerLastHitTime > 0 and ( self._flTowerLastHitTime + 5 ) < GameRules:GetGameTime() ) then
		print("clearing tower hits.")
		self._nTowerHits = 1
	end

	if ( self._nTowerHits >= 4 and self._nTowerDamageTipState ~= TIP_VISIBLE ) then
		self._nTowerDamageTipState = TIP_VISIBLE
		self:_CreateSideAlertDialog( "AlertTowerImage", { TitleTextVar = "basics_alert_TowerDamageTitle", BodyTextVar = "basics_alert_TowerDamageBody" } )
	end
end

-----------------------------------------------------------------------------------------
-- State Actions
-----------------------------------------------------------------------------------------

function CTutorialBasics:_BasicsSetup()
	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-2" )

	Tutorial:SetTutorialConvar( "dota_disable_top_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_disable_mid_lane", "0" )
	Tutorial:SetTutorialConvar( "dota_disable_bot_lane", "1" )
	Tutorial:SetTutorialConvar( "dota_tutorial_prevent_start", "1" )

	Tutorial:SetTutorialConvar( "dota_bot_mode", "1" )
	Tutorial:SetTutorialConvar( "dota_bot_disable", "0" )
	Tutorial:SetTutorialConvar( "dota_bot_tutorial_boss", "0" )
	Tutorial:SetTutorialConvar( "dota_tutorial_prevent_exp_gain", "1" )
	Tutorial:SetTutorialConvar( "dota_tutorial_percent_damage_decrease", "30" )
	Tutorial:SetTutorialConvar( "dota_tutorial_percent_bot_exp_decrease", "100" )

	SendToServerConsole( "bind space +dota_camera_follow" )
	SendToServerConsole( "host_writeconfig" )

--	Tutorial:SelectHero( "npc_dota_hero_luna" )

	Tutorial:SelectPlayerTeam( "good" )

	Tutorial:SetWhiteListEnabled( true )

	CustomUI:DynamicHud_Create( -1, "tutorial_code", "file://{resources}/layout/custom_game/tutorial_client_code.xml", {} )

	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_COURIER, false )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_PROTECT, false )
end

function CTutorialBasics:_CreateInfoDialog( imageName, dialogVars )
	CustomUI:DynamicHud_Create( -1, "tutorial_tip", "file://{resources}/layout/custom_game/tutorial_info_dialog.xml", dialogVars )
	self:_SetTipImage( imageName )
end

function CTutorialBasics:_CreateSideAlertDialog( imageName, dialogVars )
	CustomUI:DynamicHud_Create( -1, "tutorial_alert", "file://{resources}/layout/custom_game/tutorial_alert_small.xml", dialogVars )
	self:_SetAlertImage( imageName )	
end

function CTutorialBasics:_CreateAlertDialog( imageName, dialogVars )
	CustomUI:DynamicHud_Create( -1, "tutorial_alert_centered", "file://{resources}/layout/custom_game/tutorial_alert_dialog.xml", dialogVars )
	self:_SetTipImage( imageName )	
end

function CTutorialBasics:_CreateLockedAlertDialog( imageName, dialogVars )
	CustomUI:DynamicHud_Create( -1, "tutorial_alert_no_button", "file://{resources}/layout/custom_game/tutorial_alert_no_button.xml", dialogVars )
	self:_SetTipImage( imageName )
end

function CTutorialBasics:_BasicsTakeAttributes()
	Tutorial:SetTutorialConvar( "dota_camera_hold_select_to_follow", "1" )
	Tutorial:EnablePlayerOffscreenTip( true )
	Tutorial:EnableCreepAggroViz( true )
--	Tutorial:EnableTowerAggroViz( true )
end

function CTutorialBasics:_HeroIntroTip()
	Tutorial:UpgradePlayerAbility( "luna_lunar_blessing" ) -- To get rid of the level up buttons.
	self:_CreateInfoDialog( "HeroImage", { TitleTextVar = "basics_HeroIntroTitle", BodyTextVar = "basics_HeroIntroBody" } )
end	

function CTutorialBasics:_FountainTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "FountainImage", { TitleTextVar = "basics_FountainIntroTitle", BodyTextVar = "basics_FountainIntroBody" } )
end	

function CTutorialBasics:_HeroMoveTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "RightClickImage", { TitleTextVar = "basics_MovingYourHeroTitle", BodyTextVar = "" } )
	CustomGameEventManager:Send_ServerToAllClients( "set_custom_info_string", {customBody="#basics_MovingYourHeroBody", keyname="%dota_camera_follow%" } )
end	

 function CTutorialBasics:_MoveToAncientQuest()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	Tutorial:CreateLocationTask( Vector(-6083, -5618, 261 ) )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_MoveToAncientTitle", BodyTextVar = "basics_objective_MoveToAncientBody" } )
end

function CTutorialBasics:_CompleteAncientQuest()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_MoveToAncientTitle", BodyTextVar = "basics_objective_MoveToAncientBody" } )
--	CustomGameEventManager:Send_ServerToAllClients( "set_custom_dialog_string", {customBody="#basics_objective_MoveToAncientBody", keyname="%dota_courier_deliver%" } )
end	

function CTutorialBasics:_AncientTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "AncientImage", { TitleTextVar = "basics_AncientIntroTitle", BodyTextVar = "basics_AncientIntroBody" } )
end	

function CTutorialBasics:_MapTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "MinimapBuildingsImage", { TitleTextVar = "basics_MapIntroTitle", BodyTextVar = "basics_MapIntroBody" } )
end	

function CTutorialBasics:_PurchasingTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "GoldImage", { TitleTextVar = "basics_SpendGoldTitle", BodyTextVar = "basics_SpendGoldBody" } )
end

function CTutorialBasics:_BackToBaseQuest()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	Tutorial:CreateLocationTask( Vector( -6853, -6399, 640 ) )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_MoveToShopTitle", BodyTextVar = "basics_objective_MoveToShopBody" } )
end

function CTutorialBasics:_CompleteBackToBaseQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_MoveToShopTitle", BodyTextVar = "basics_objective_MoveToShopBody" } )
	EmitGlobalSound( "Tutorial.TaskProgress" )
	Tutorial:SetItemGuide("luna_tutorial_item_build")
end

function CTutorialBasics:_OpenShopQuest()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_OpenShopTitle", BodyTextVar = "basics_objective_OpenShopBody" } )
end

function CTutorialBasics:_CompleteOpenShopQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_OpenShopTitle", BodyTextVar = "basics_objective_OpenShopBody" } )
	EmitGlobalSound( "Tutorial.TaskProgress" )
end

function CTutorialBasics:_ShopTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "ShopImage", { TitleTextVar = "basics_BuyFromShopTitle", BodyTextVar = "basics_BuyFromShopBody" } )
end

function CTutorialBasics:_ShopTip2()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "ShopImage", { TitleTextVar = "basics_BuyFromShop2Title", BodyTextVar = "basics_BuyFromShop2Body" } )
end

function CTutorialBasics:_BuyTangoesQuest()
	EmitGlobalSound("ui.npe_objective_given")
	Tutorial:SetOrModifyPlayerGold( 625, true )
	GameRules:GetGameModeEntity():SetHUDVisible( DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY, true )
	Tutorial:AddShopWhitelistItem( "item_tango" )
	Tutorial:SetQuickBuy( "tango" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuyTangoesTitle", BodyTextVar = "basics_objective_BuyTangoesBody" } )
end

function CTutorialBasics:_BuySalveQuest()
	Tutorial:RemoveShopWhitelistItem( "item_tango" )
	Tutorial:AddShopWhitelistItem( "item_flask" )
	Tutorial:SetQuickBuy( "flask" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuySalveTitle", BodyTextVar = "basics_objective_BuySalveBody" } )
end

function CTutorialBasics:_BuyClarityQuest()
	Tutorial:RemoveShopWhitelistItem( "item_flask" )
	Tutorial:AddShopWhitelistItem( "item_clarity" )
	Tutorial:SetQuickBuy( "clarity" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuyClarityTitle", BodyTextVar = "basics_objective_BuyClarityBody" } )
end

function CTutorialBasics:_BuyCirclet()
	Tutorial:RemoveShopWhitelistItem( "item_clarity" )
	Tutorial:AddShopWhitelistItem( "item_circlet" )
	Tutorial:SetQuickBuy( "circlet" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuyCircletTitle", BodyTextVar = "basics_objective_BuyCircletBody" } )
end

function CTutorialBasics:_BuyBranchQuest2()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuyBranchTitle", BodyTextVar = "basics_objective_BuyBranchBody" } )
end

function CTutorialBasics:_BuySlippers()
	Tutorial:RemoveShopWhitelistItem( "item_circlet" )
	Tutorial:AddShopWhitelistItem( "item_slippers" )
	Tutorial:SetQuickBuy( "slippers" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuySlippersTitle", BodyTextVar = "basics_objective_BuySlippersBody" } )
end

function CTutorialBasics:_CloseShopQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_CloseShopTitle", BodyTextVar = "basics_objective_CloseShopBody" } )
end

function CTutorialBasics:_CompleteShopQuest()
	EmitGlobalSound("Tutorial.TaskProgress")
end

function CTutorialBasics:_ExplainItemsTip()
	Tutorial:SetShopOpen( false )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	self:_CreateInfoDialog( "ShopImage", { TitleTextVar = "basics_BoughtStartingTitle", BodyTextVar = "basics_BoughtStartingBody" } )
end	

function CTutorialBasics:_LanesTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "LanesImage", { TitleTextVar = "basics_LaneIntroTitle", BodyTextVar = "basics_LaneIntroBody" } )
end	

function CTutorialBasics:_MoveToMidQuest()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	Tutorial:CreateLocationTask( Vector(-5029, -4522, 261 ) )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_MoveToMidLaneTitle", BodyTextVar = "basics_objective_MoveToMidLaneBody" } )
end

function CTutorialBasics:_CompleteMoveToMidQuest()
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_MoveToMidLaneTitle", BodyTextVar = "basics_objective_MoveToMidLaneBody" } )
end

function CTutorialBasics:_CreepsTip()	
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "CreepsImage", { TitleTextVar = "basics_CreepsIntroTitle", BodyTextVar = "basics_CreepsIntroBody" } )
end

function CTutorialBasics:_LaningTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "BattleImage", { TitleTextVar = "basics_LaningIntroTitle", BodyTextVar = "basics_LaningIntroBody" } )
end

function CTutorialBasics:_MoveToLaneQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	Tutorial:CreateLocationTask( Vector(-1718, -1196, 384 ) )
	Tutorial:ForceGameStart()
	EmitGlobalSound( "GameStart.RadiantAncient" )

	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_FollowCreepsTitle", BodyTextVar = "basics_objective_FollowCreepsBody" } )
end

function CTutorialBasics:_CompleteToLaneQuest()
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_FollowCreepsTitle", BodyTextVar = "basics_objective_FollowCreepsBody" } )
end

function CTutorialBasics:_AttackingTip()
	print("Attacking tip")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "AttackingImage", { TitleTextVar = "basics_AttackingIntroTitle", BodyTextVar = "basics_AttackingIntroBody" } )
end

function CTutorialBasics:_BountiesTip()
	print("Bounties tip")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	self:_CreateInfoDialog( "BountyImage", { TitleTextVar = "basics_BountiesIntroTitle", BodyTextVar = "basics_BountiesIntroBody" } )
end

function CTutorialBasics:_LastHitQuest()
	print("Last hit quest")
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_LastHitCreepsTitle", BodyTextVar = "basics_objective_LastHitCreepsBody" } )
end

function CTutorialBasics:_CompleteLastHitQuest()
	print("Complete last hit quest")
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_LastHitCreepsTitle", BodyTextVar = "basics_objective_LastHitCreepsBody" } )
end

function CTutorialBasics:_XPTip()
	print("XP tip")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "ExperienceImage", { TitleTextVar = "basics_ExpIntroTitle", BodyTextVar = "basics_ExpIntroBody" } )
end

function CTutorialBasics:_GainLevelQuest()
	EmitGlobalSound("ui.npe_objective_given")
	Tutorial:SetTutorialConvar( "dota_tutorial_prevent_exp_gain", "0" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_GetALevelTitle", BodyTextVar = "basics_objective_GetALevelBody" } )
end

function CTutorialBasics:_CompleteGainLevelQuest()
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_GetALevelTitle", BodyTextVar = "basics_objective_GetALevelBody" } )
	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "0" )
end

function CTutorialBasics:_LevelAbilityTip()
	self:_CreateInfoDialog( "AbilitiesImage", { TitleTextVar = "basics_AbilityIntroTitle", BodyTextVar = "basics_AbilityIntroBody" } )
end


function CTutorialBasics:_LevelAbilityQuest()
	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "0" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_BuyAbilityTitle", BodyTextVar = "basics_objective_BuyAbilityBody" } )
end

function CTutorialBasics:_CompleteLevelAbilityQuest()
	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-1" )
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_BuyAbilityTitle", BodyTextVar = "basics_objective_BuyAbilityBody" } )
end

function CTutorialBasics:_CastingTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
--	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-1" )
	self:_CreateInfoDialog( "UsingAbilityImage", { TitleTextVar = "basics_CastIntroTitle", BodyTextVar = "basics_CastIntroBody" } )
end

function CTutorialBasics:_CastQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_CastSpellTitle", BodyTextVar = "" } )
	CustomGameEventManager:Send_ServerToAllClients( "set_custom_objective_string", {customBody="#basics_objective_CastSpellBody", keyname="%dota_ability_execute 0%" } )
end

function CTutorialBasics:_CompleteCastQuest()
	self._bPreventTowerDamage = false
	EmitGlobalSound( "Tutorial.TaskProgress" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "basics_objective_CastSpellTitle", BodyTextVar = "" } )
	CustomGameEventManager:Send_ServerToAllClients( "set_custom_objective_string", {customBody="#basics_objective_CastSpellBody", keyname="%dota_ability_execute 0%" } )
end

function CTutorialBasics:_TowersTip()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	self:_CreateInfoDialog( "TowerImage", { TitleTextVar = "basics_AttackTowerTitle", BodyTextVar = "basics_AttackTowerBody" } )
end

function CTutorialBasics:_KillTowerQuest()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "basics_objective_KillTowerTitle", BodyTextVar = "basics_objective_KillTowerBody" } )
end

function CTutorialBasics:_EnemyTip()
	Tutorial:AddBot( "npc_dota_hero_razor", "mid", "easy", false );
	self:_CreateInfoDialog( "OpponentImage", { TitleTextVar = "basics_RazorIntroTitle", BodyTextVar = "basics_RazorIntroBody" } )
end

function CTutorialBasics:_End()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_tip" )
end

function CTutorialBasics:_EndTutorial()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	Tutorial:EnablePlayerOffscreenTip( false )
	Tutorial:FinishTutorial()
end

function CTutorialBasics:_VictoryTip()
	CustomUI:DynamicHud_Create( -1, "tutorial_tip", "file://{resources}/layout/custom_game/tutorial_dialog_endgame.xml", { TitleTextVar = "basics_WinningIntroTitle", BodyTextVar = "basics_WinningIntroBody" } )
	self:_SetTipImage("HeroImage")
end
