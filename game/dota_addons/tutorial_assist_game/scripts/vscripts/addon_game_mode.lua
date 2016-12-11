--[[
	Underscore prefix such as "_function()" denotes a local function and is used to improve readability
	
	Variable Prefix Examples
		"fl"	Float
		"n"		Int
		"v"		Table
		"b"		Boolean
]]

--[[ CustomHudElements reference
	CustomUI:DynamicHud_Create - Create a new custom hud element for the specified player(s). ( int PlayerID /*-1 means everyone*/, string ElementID /* should be unique */, string LayoutFileName, table DialogVariables /* can be nil */ )
	CustomUI:DynamicHud_SetVisible - Toggle the visibility of an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, bool Visible )
	CustomUI:DynamicHud_SetDialogVariables - Add or modify dialog variables for an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, table DialogVariables )
	CustomUI:DynamicHud_Destroy - Destroy a custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID )
]]

TIP_NEVER_SHOWN = 0
TIP_VISIBLE = 1
TIP_DISMISSED = 2

ON_INITIALIZED = 0
ON_HERO_SPAWNED = 1
ON_THINK = 2
ON_TIP_DISMISSED = 3
ON_PLAYER_GAINED_LEVEL = 4
ON_ABILITY_LEARNED = 5
ON_ITEM_PURCHASED = 6
ON_TOWER_KILL_GOOD = 7
ON_TOWER_KILL_BAD = 8
ON_PLAYER_TOOK_TOWER_DAMAGE = 9
ON_TEN_LAST_HITS = 10
ON_EARLY_ITEMS_PURCHASED = 11
ON_SKIP_STATE = 12
ON_PUSH_T3 = 13
ON_FORT_KILLED = 14

ALERT_TOO_MANY_TOWER_HITS = 0
ALERT_TOO_MANY_CREEP_HITS = 1
ALERT_LOW_HEALTH = 2
ALERT_FORCE_PURCHASE_ITEMS = 3
ALERT_NEED_DELIVER_ITEMS = 4
ALERT_FORCE_LEVEL_UP = 5
ALERT_BEHIND_ON_TOWERS = 6
ALERT_BEHIND_ON_GOLD = 7
ALERT_BEHIND_ON_EXP = 8
ALERT_DEATH = 9
ALERT_SECRET_SHOP = 10
ALERT_SECRET_SHOP_FOUND = 11
ALERT_PICKED_UP_RUNE = 12
ALERT_ROSHAN = 13
ALERT_SIDE_SHOP = 14
ALERT_FIRST_PURCHASE = 15
ALERT_NEUTRAL_CREEP = 16
ALERT_FOUNTAIN = 17

ALERT_STYLE_CONTINUE = 1
ALERT_STYLE_FORCE = 2

if CTutorialAG == nil then
	CTutorialAG = class({})
end

-- Precache resources
function Precache( context )
	--PrecacheResource( "particle", "particles/generic_gameplay/winter_effects_hero.vpcf", context )
	--PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	
	--PrecacheResource( "particle_folder", "particles/frostivus_gameplay", context )
	--PrecacheItemByNameSync( "item_tombstone", context )
	--PrecacheItemByNameSync( "item_bag_of_gold", context )
	--PrecacheItemByNameSync( "item_slippers_of_halcyon", context )
	--PrecacheItemByNameSync( "item_greater_clarity", context )
end

-- Actually make the game mode when we activate
function Activate()  
	GameRules.tutorialAG = CTutorialAG()
	GameRules.tutorialAG:InitGameMode()
end

function Precache( context ) 
	PrecacheResource( "particle", "particles/ui_mouseactions/unit_highlight.vpcf", context )
	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
end


function CTutorialAG:InitGameMode()

	self._flLastThinkGameTime = nil
	self._entAncient = Entities:FindByName( nil, "dota_badguys_fort" )
	if not self._entAncient then
		print( "Ancient entity not found!" )
	end

	PrecacheUnitByNameAsync( "npc_dota_hero_dazzle", 			function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_crystal_maiden",	function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_nevermore",			function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_zuus",				function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_dragon_knight",		function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_phantom_assassin",	function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_witch_doctor",		function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_death_prophet",		function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_luna",				function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_lina",				function(unit) end )
	PrecacheUnitByNameAsync( "npc_dota_hero_sven",				function(unit) end )

	self._vTier1Towers = { [1] = "dota_badguys_tower1_top", [2] = "dota_badguys_tower1_mid", [3] = "dota_badguys_tower1_bot" }
	self._vTier2Towers = { [1] = "dota_badguys_tower2_top", [2] = "dota_badguys_tower2_mid", [3] = "dota_badguys_tower2_bot" }
	self._vTier3Towers = { [1] = "dota_badguys_tower3_top", [2] = "dota_badguys_tower3_mid", [3] = "dota_badguys_tower3_bot" }

	self._CurrentState = "setup"
	self._vTransitionTable = {}

	self._vTransitionTable["setup"] =					{ fnOnEnter = nil,							nAdvanceEvent = ON_INITIALIZED,				strNext = "wait_for_spawn" }
	self._vTransitionTable["wait_for_spawn"] =			{ fnOnEnter = self._Setup,					nAdvanceEvent = ON_HERO_SPAWNED,			strNext = "introduce_role" }
--	self._vTransitionTable["introduce_prep"] =			{ fnOnEnter = self._IntroducePrep,			nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "introduce_role" }
	self._vTransitionTable["introduce_role"] =			{ fnOnEnter = self._IntroduceRole,			nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "introduce_plan" }
	self._vTransitionTable["introduce_plan"] =			{ fnOnEnter = self._IntroducePlan,			nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "introduce_build" }
	self._vTransitionTable["introduce_build"] =			{ fnOnEnter = self._IntroduceBuild,			nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_choose_ability" }
	self._vTransitionTable["quest_choose_ability"] =	{ fnOnEnter = self._QuestChooseAbility,		nAdvanceEvent = ON_ABILITY_LEARNED,			strNext = "wait_for_ability_desc" }
	self._vTransitionTable["wait_for_ability_desc"] =	{ fnOnEnter = nil,							nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_buy_items" }
	self._vTransitionTable["quest_buy_items"] =			{ fnOnEnter = self._CompleteChooseAbility,	nAdvanceEvent = ON_ITEM_PURCHASED,			strNext = "quest_buy_items2", 		fnOnEnterDelayed = self._QuestBuyItems,		flEnterDelay = 1 } 
	self._vTransitionTable["quest_buy_items2"] =		{ fnOnEnter = self._QuestBuyItems2,			nAdvanceEvent = ON_ITEM_PURCHASED,			strNext = "quest_buy_items3" }
	self._vTransitionTable["quest_buy_items3"] =		{ fnOnEnter = self._QuestBuyItems2,			nAdvanceEvent = ON_ITEM_PURCHASED,			strNext = "quest_buy_items4" }
	self._vTransitionTable["quest_buy_items4"] =		{ fnOnEnter = self._QuestBuyItems2,			nAdvanceEvent = ON_ITEM_PURCHASED,			strNext = "introduce_lane_choice" }
	self._vTransitionTable["introduce_lane_choice"] =	{ fnOnEnter = self._CompleteBuyItems,		nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_move_to_lane", 	fnOnEnterDelayed = self._IntroduceLane,		flEnterDelay = 2 }
	self._vTransitionTable["quest_move_to_lane"] =		{ fnOnEnter = self._QuestMoveToLane,		nAdvanceEvent = ON_TASK_ADVANCED,			strNext = "introduce_laning" }
	self._vTransitionTable["introduce_laning"] =		{ fnOnEnter = self._CompleteMoveToLane,		nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_last_hits", 		fnOnEnterDelayed = self._IntroduceLaning,	flEnterDelay = 2 }
	self._vTransitionTable["quest_last_hits"] =			{ fnOnEnter = self._StartGame,				nAdvanceEvent = ON_TEN_LAST_HITS,			strNext = "introduce_core_items", 	fnOnEnterDelayed = self._QuestLastHits,		flEnterDelay = 10 }
	self._vTransitionTable["introduce_core_items"] =	{ fnOnEnter = self._CompleteLastHits,		nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_core_items", 		fnOnEnterDelayed = self._IntroduceCoreItems,flEnterDelay = 2 }
	self._vTransitionTable["quest_core_items"] =		{ fnOnEnter = self._QuestCoreItems,			nAdvanceEvent = ON_EARLY_ITEMS_PURCHASED,	strNext = "introduce_objectives" }
	self._vTransitionTable["introduce_objectives"] =	{ fnOnEnter = self._CompleteCoreItems,		nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_take_objectives", 	fnOnEnterDelayed = self._IntroduceObjectives,flEnterDelay = 2 }
	self._vTransitionTable["quest_take_objectives"] =	{ fnOnEnter = self._QuestTakeTowers,		nAdvanceEvent = ON_PUSH_T3,					strNext = "introduce_highground" }
	self._vTransitionTable["introduce_highground"] =	{ fnOnEnter = self._CompleteTakeTowers,		nAdvanceEvent = ON_TIP_DISMISSED,			strNext = "quest_break_base", 		fnOnEnterDelayed = self._IntroduceHighground,	flEnterDelay = 2 }
	self._vTransitionTable["quest_break_base"] =		{ fnOnEnter = self._QuestBreakBase,			nAdvanceEvent = ON_FORT_KILLED,				strNext = "end" }
	self._vTransitionTable["end"] =						{ fnOnEnter = self._EndTutorial,			nAdvanceEvent = ON_TIP_DISMISSED,			strNext = nil, 						fnOnEnterDelayed = self._VictoryTip,		flEnterDelay = 5 }

	self._difficultyCheckTime = 0
	self._nMinDifficulty = 0
	self._nCurrentDifficulty = 0
	self._nCurrentPlayerDifficulty = 0

	self._bWhiteListEnabled = false;
	self._nItemIndex = 0
	self._vItemBuild = {}

	self._nSkillIndex = -1
	self._vSkillBuild = {}
	self._vSkillBuildTxt = {}

	self._vItemDetails = {}

	self._ItemBuildName = ""
	self._vSwingHero = {}
	self._vSelectAbilityText = {}
	self._vBuildDetails = {}
	self._vDoubleBuyItems = {}

	self._bShowedSecretLocation = false
	self._bPausedForDetails = false
	self._bStayPausedForDetails = false
	self._bGameStarted = false
	self._bLateGame = false
	self._hPickupRune = nil 


	-- Most of these tick are checked every second. Tower hits are checked as they come in.
	self._vAlertTable = {}
	self._vAlertTable[ALERT_TOO_MANY_TOWER_HITS] =	{ nNagCount = 6, flAlertLevel = 0, flAlertThreshold = 5,	nCoolDown = 2, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_TooManyTowerHitsTitle",	body = "ag_alert_TooManyTowerHitsBody" }
	self._vAlertTable[ALERT_TOO_MANY_CREEP_HITS] =	{ nNagCount = 6, flAlertLevel = 0, flAlertThreshold = 10,	nCoolDown = 16, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_TooManyCreepHitsTitle",	body = "ag_alert_TooManyCreepHitsBody" }
	self._vAlertTable[ALERT_LOW_HEALTH] = 			{ nNagCount = 3, flAlertLevel = 0, flAlertThreshold = 3,	nCoolDown = 30, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_LowHealthTitle",			body = "ag_alert_LowHealthBody" }
	self._vAlertTable[ALERT_FIRST_PURCHASE] =		{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 30, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_FirstPurchaseTitle",		body = "", 	keyTable = {customBody="#ag_alert_FirstPurchaseBody", keyname="%dota_purchase_quickbuy%", keyname2="%dota_courier_deliver%"} }
	self._vAlertTable[ALERT_FORCE_PURCHASE_ITEMS] =	{ nNagCount = 4, flAlertLevel = 0, flAlertThreshold = 25,	nCoolDown = 30, style = ALERT_STYLE_FORCE,		title = "ag_alert_ForcePurchaseItemsTitle",	body = "ag_alert_ForcePurchaseItemsBody" }
	self._vAlertTable[ALERT_NEED_DELIVER_ITEMS] =	{ nNagCount = 3, flAlertLevel = 0, flAlertThreshold = 30,	nCoolDown = 30, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_NeedDeliverItemsTitle",	body = "", keyTable = {customBody="#ag_alert_NeedDeliverItemsBody", keyname="%dota_courier_deliver%", keyname2=""}  }
	self._vAlertTable[ALERT_FORCE_LEVEL_UP] =		{ nNagCount = 4, flAlertLevel = 0, flAlertThreshold = 25,	nCoolDown = 30, style = ALERT_STYLE_FORCE,		title = "ag_alert_ForceLevelUpTitle",		body = "ag_alert_ForceLevelUpBody" }
	self._vAlertTable[ALERT_BEHIND_ON_TOWERS] =		{ nNagCount = 2, flAlertLevel = 0, flAlertThreshold = 20,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_BehindOnTowersTitle",		body = "ag_alert_BehindOnTowersBody" }
	self._vAlertTable[ALERT_BEHIND_ON_GOLD] =		{ nNagCount = 2, flAlertLevel = 0, flAlertThreshold = 20,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_BehindOnGoldTitle",		body = "ag_alert_BehindOnGoldBody" }
	self._vAlertTable[ALERT_BEHIND_ON_EXP] =		{ nNagCount = 2, flAlertLevel = 0, flAlertThreshold = 20,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_BehindOnExpTitle",		body = "ag_alert_BehindOnExpBody" }
	self._vAlertTable[ALERT_DEATH] =				{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_DeathTitle",				body = "ag_alert_DeathBody" }
	self._vAlertTable[ALERT_SECRET_SHOP] =			{ nNagCount = 2, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_SecretShopTitle",			body = "ag_alert_SecretShopBody" }
	self._vAlertTable[ALERT_SECRET_SHOP_FOUND] =	{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_SecretShopFoundTitle",	body = "ag_alert_SecretShopFoundBody" }
	self._vAlertTable[ALERT_PICKED_UP_RUNE] =		{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_info_FoundARuneTitle",			body = "ag_info_FoundARuneBody" }
	self._vAlertTable[ALERT_ROSHAN] =				{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_info_RoshanTitle",				body = "ag_info_RoshanBody" }
	self._vAlertTable[ALERT_SIDE_SHOP] =			{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_info_SideShopTitle",			body = "ag_info_SideShopBody" }
	self._vAlertTable[ALERT_NEUTRAL_CREEP] =		{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_info_CreepCampsTitle",			body = "ag_info_CreepCampsBody" }
	self._vAlertTable[ALERT_FOUNTAIN] =				{ nNagCount = 1, flAlertLevel = 0, flAlertThreshold = 1,	nCoolDown = 180, style = ALERT_STYLE_CONTINUE,	title = "ag_alert_FountainTitle",			body = "ag_alert_FountainBody" }

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

	Tutorial:StartTutorialMode()

	self._nImmuneFXIndex = -1
	self._flDialogFadeInTime = 0
	self._nAlertFadeCount = 3
	self._flAlertTime = 0
	self._flDelay = 0
	self._nTowerHits = 0
	self._flTowerLastHitTime = 0
	self._flAlertDelay = 0
	self._nActiveAlert = -1
	self._bInitialized = false
	self._nLastHits = 0
	self._nLastHitGoal = 10

	self._nFXIndex = -1
	self._flFXClearTime = -1


	self._nTowersKilledGood = 0
	self._nTowersKilledBad = 0
	self._nTowersKilledGoal = 6

	self._bStopTowerCheck = false

	GameRules:SetTimeOfDay( 0.75 )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetPreGameTime( 60.0 )
	GameRules:SetPostGameTime( 60.0 )
	GameRules:SetCustomGameEndDelay( 3 )

--	GameRules:SetPostGameTime( 60.0 )
--	GameRules:SetTreeRegrowTime( 60.0 )
	GameRules:SetCustomGameSetupTimeout( 0 )

	GameRules:GetGameModeEntity():SetBotsInLateGame( false )
	GameRules:GetGameModeEntity():SetBotThinkingEnabled( true )
	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )

	-- Custom console commands
	Convars:RegisterCommand( "tutorial_clear_panorama_panels", function(...) return self:_ClearPanoramaPanels( ... ) end, "Clear all of the panorama panels displayed by the tutorial.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_advance_state", function(...) return self:_TestAdvanceTutorial( ... ) end, "Advance the tutorial state.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_test_victory", function(...) return self:_TestTutorialVictory( ... ) end, "Advance the tutorial to the next state.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_change_to_late_game", function(...) return self:_ChangeToLateGame( ... ) end, "Advance the tutorial to the next state.", FCVAR_CHEAT )
	Convars:RegisterCommand( "tutorial_alert", function(...) return self:_TestAlert( ... ) end, "Test alert with the given index.", FCVAR_CHEAT )

	CustomGameEventManager:RegisterListener( "AbilityStartUse", function(...) return self:OnAbilityStartUse( ... ) end )
	CustomGameEventManager:RegisterListener( "AbilityLearnModeToggled", function(...) return self:OnAbilityLearnModeToggled( ... ) end )
	CustomGameEventManager:RegisterListener( "ButtonPressed", function(...) return self:OnDialogButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "PurchaseFailedNeedSecretShop", function(...) return self:OnPurchaseFailedNeedSecretShop( ... ) end )
	CustomGameEventManager:RegisterListener( "PlayerShopChanged", function(...) return self:OnPlayerShopChanged( ... ) end )


	-- Hook into game events allowing reload of functions at run time
	ListenToGameEvent( "npc_spawned",							Dynamic_Wrap( CTutorialAG, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_tutorial_task_advance",			Dynamic_Wrap( CTutorialAG, "OnTaskAdvance" ), self )
	ListenToGameEvent( "dota_player_gained_level",				Dynamic_Wrap( CTutorialAG, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_player_learned_ability",			Dynamic_Wrap( CTutorialAG, "OnPlayerLearnedAbility" ), self )
	ListenToGameEvent( "dota_player_used_ability",				Dynamic_Wrap( CTutorialAG, "OnPlayerUsedAbility" ), self )
	ListenToGameEvent( "entity_hurt",							Dynamic_Wrap( CTutorialAG, "OnEntityHurt" ), self )
	ListenToGameEvent( "dota_item_purchased",					Dynamic_Wrap( CTutorialAG, "OnItemPurchased" ), self )
	ListenToGameEvent( "dota_item_combined",					Dynamic_Wrap( CTutorialAG, "OnItemCombined" ), self )
	ListenToGameEvent( "last_hit",								Dynamic_Wrap( CTutorialAG, "OnLastHit" ), self )
	ListenToGameEvent( "dota_tower_kill",						Dynamic_Wrap( CTutorialAG, "OnTowerKill" ), self )
	ListenToGameEvent( "entity_killed", 						Dynamic_Wrap( CTutorialAG, 'OnEntityKilled' ), self )


	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CTutorialAG, "FilterModifyGold" ), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap( CTutorialAG, "FilterModifyExperience" ), self )

	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CTutorialAG, "FilterDamage" ), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CTutorialAG, "FilterExecuteOrder" ), self )
	GameRules:GetGameModeEntity():SetRuneSpawnFilter( Dynamic_Wrap( CTutorialAG, "FilterRuneSpawn" ), self )

	GameRules:GetGameModeEntity():SetTrackingProjectileFilter( Dynamic_Wrap( CTutorialAG, "FilterTrackingProjectile" ), self )

	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter( Dynamic_Wrap( CTutorialAG, "FilterAbilityTuningValue" ), self )

	-- Register OnThink with the game engine so it is called every 0.25 seconds
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 ) 

	if ( GameRules:GetCustomGameDifficulty() == 2 ) then
		GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_lina" )
	elseif ( GameRules:GetCustomGameDifficulty() == 1 ) then
		GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_sven" )
	else
		GameRules:GetGameModeEntity():SetCustomGameForceHero( "npc_dota_hero_luna" )
	end

	self._ChosenHero = 0
	if ( GameRules:GetCustomGameDifficulty() >= 0 and GameRules:GetCustomGameDifficulty() <= 2 ) then
		self._ChosenHero = GameRules:GetCustomGameDifficulty()
	end
end

-----------------------------------------------------------------------------------------
-- Debug Functions
-----------------------------------------------------------------------------------------

function CTutorialAG:_TestAdvanceTutorial( cmdName )
	print ("Want to advance tutorial round" )
	self:_FireEvent( ON_SKIP_STATE )
end

function CTutorialAG:_ClearPanoramaPanels( cmdName )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Destroy( -1, "details_dialog" )
	CustomUI:DynamicHud_Destroy( -1, "alert_dialog" )
end

function CTutorialAG:_TestTutorialVictory( cmdName )
	local heroUnit = PlayerResource:GetSelectedHeroEntity( 0 )
	if( heroUnit ~= nil ) then
		self:_SetState( "end" )
		self._entAncient:Kill( nil, heroUnit )
	end
end

function CTutorialAG:_ChangeToLateGame( cmdName )
	self._bLateGame = true
end

function CTutorialAG:_TestAlert( cmdName, nAlertNum )
	self:_ShowTriggeredAlert( tonumber( nAlertNum ) )
end


-----------------------------------------------------------------------------------------
-- Filters
-----------------------------------------------------------------------------------------

function CTutorialAG:FilterAbilityTuningValue( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("AbilityValue: " .. k .. " " .. tostring(v) )
--	end
end

function CTutorialAG:FilterTrackingProjectile( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("TP: " .. k .. " " .. tostring(v) )
--	end

	local hVictim = EntIndexToHScript( filterTable["entindex_target_const"] )
	local hAttacker = EntIndexToHScript( filterTable["entindex_source_const"] )

	if ( hVictim == nil or hAttacker == nil ) then
		return true
	end

	local bDoAttack = true

	if ( self._hPlayerHero == hVictim and hAttacker:IsTower() ) then
--		print("PLAYER IS BEING ATTACKED!!")
		if ( not Tutorial:GetTimeFrozen() and not self._bLateGame and hVictim:GetRangeToUnit( hAttacker ) < 800 ) then
			if ( self:_IncrementAlert( ALERT_TOO_MANY_TOWER_HITS, 2.0 / (self._nCurrentPlayerDifficulty + 1) ) ) then
				bDoAttack = false
			end
		end

		if ( self._nFXIndex ~= -1 ) then
			ParticleManager:DestroyParticle( self._nFXIndex, true )
		end

		self._nFXIndex = ParticleManager:CreateParticle( "particles/ui_mouseactions/unit_highlight.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker )
		ParticleManager:SetParticleControl( self._nFXIndex, 1, Vector( 255, 125, 0 ) )
		ParticleManager:SetParticleControl( self._nFXIndex, 2, Vector( 820, 32, 820 ) )
		self._flFXClearTime = 1.0
--		ParticleManager:ReleaseParticleIndex( self._nFXIndex )
	end
	return bDoAttack
end

function CTutorialAG:FilterDamage( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("Damage: " .. k .. " " .. tostring(v) )
--	end

	if ( filterTable["entindex_victim_const"] == nil or filterTable["entindex_attacker_const"] == nil ) then
--		for k, v in pairs( filterTable ) do
--			print("Damage: " .. k .. " " .. tostring(v) )
--		end		
		return true
	end

	local hVictim = EntIndexToHScript( filterTable["entindex_victim_const"] )
	local hAttacker = EntIndexToHScript( filterTable["entindex_attacker_const"] )

	if ( hAttacker:GetPlayerOwnerID() == 0 and hVictim ~= nil ) then
		if ( hVictim:IsBoss() ) then
			self:_IncrementAlert( ALERT_ROSHAN, 1.0 )
		elseif ( hVictim:IsNeutralUnitType() ) then
			self:_IncrementAlert( ALERT_NEUTRAL_CREEP, 1.0 )			
		end
	end

	local heroUnit = PlayerResource:GetSelectedHeroEntity( 0 )

	if ( hVictim ~= nil and hAttacker ~= nil and heroUnit ~= nil ) then
		if ( hVictim:IsCreep() and hAttacker:IsCreep() and hVictim:GetTeamNumber() == heroUnit:GetTeamNumber() and not self._bLateGame ) then
			if ( hVictim:GetRangeToUnit( heroUnit ) < 800 ) then
--				print("Want to increase creep damage " .. tostring(filterTable["damage"]) .. " -> " .. tostring(1.15*filterTable["damage"]) )
				filterTable["damage"] = 1.15*filterTable["damage"]
			end
		end
	end


	return true
end

function CTutorialAG:FilterRuneSpawn( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("rune spawn: " .. k .. " " .. tostring(v) )
--	end
	return true
end

function CTutorialAG:FilterExecuteOrder( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("Order: " .. k .. " " .. tostring(v) )
--	end

	if ( self._bGameStarted and Tutorial:GetTimeFrozen() ) then
		local orderType = filterTable["order_type"]
		if ( ( self._nActiveAlert == ALERT_FORCE_PURCHASE_ITEMS or self._nActiveAlert == ALERT_FIRST_PURCHASE ) and orderType == DOTA_UNIT_ORDER_PURCHASE_ITEM ) then
--			print("Clearing from purchase")
			self:_ClearAlerts()
			return true
		elseif ( self._nActiveAlert == ALERT_FORCE_LEVEL_UP and orderType == DOTA_UNIT_ORDER_TRAIN_ABILITY ) then
--			print("Clearing from level up")
			self:_ClearAlerts()
			return true			
		elseif ( self._nActiveAlert == ALERT_NEED_DELIVER_ITEMS and orderType == DOTA_UNIT_ORDER_CAST_NO_TARGET ) then
--			print("Clearing from deliver")
			self:_ClearAlerts()
			return true
		end		

		print("Aborting order " .. tostring( orderType ) .. " Alert is " .. tostring( self._nActiveAlert ) )
		return false
	end

	if ( filterTable["issuer_player_id_const"] == 0 ) then
		local orderType = filterTable["order_type"]
		if ( orderType == DOTA_UNIT_ORDER_PICKUP_RUNE ) then
			local rune = EntIndexToHScript( filterTable["entindex_target"] )
			self._hPickupRune = rune
			self:CheckRuneTip()


--			if ( rune ~= nil and not rune:IsNull() and self._hPlayerHero ~= nil ) then
--				if ( self._hPlayerHero:IsPositionInRange( rune:GetAbsOrigin(), 400 ) == true ) then
--					self:_IncrementAlert( ALERT_PICKED_UP_RUNE, 1.0 )
--					self._hPickupRune = nil
--				end
--			end
		else
			self._hPickupRune = nil
		end
	end


	-- We don't need to prevent any orders if the player is finished with their build
	if ( not self._bWhiteListEnabled ) then
		return true
	end

	if ( filterTable["issuer_player_id_const"] == 0 ) then
		if ( self._bLateGame ) then
			local orderType = filterTable["order_type"]
			if (orderType == DOTA_UNIT_ORDER_DROP_ITEM or orderType == DOTA_UNIT_ORDER_SELL_ITEM ) then
				local hAbility = EntIndexToHScript( filterTable["entindex_ability"] )
				if( hAbility ) then
					if( hAbility:GetClassname() == "item_tango" or hAbility:GetClassname() == "item_flask" or hAbility:GetClassname() == "item_tpscroll" ) then
						return true
					end
				end
			end
		end
	end

	-- The player isn't allowed to do actions that may break the tutorial.
	if ( filterTable["issuer_player_id_const"] == 0 ) then
		local orderType = filterTable["order_type"]
		if (orderType == DOTA_UNIT_ORDER_DROP_ITEM or
			orderType == DOTA_UNIT_ORDER_GIVE_ITEM or
			orderType == DOTA_UNIT_ORDER_SELL_ITEM or
			orderType == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM or
			orderType == DOTA_UNIT_ORDER_BUYBACK or
			orderType == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH ) then

			print("Skipping command from" .. tostring(issuer) )
			return false
		end
	end

	return true
end


function CTutorialAG:FilterModifyGold( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("MG: " .. k .. " " .. tostring(v) )
--	end

	-- give a bonus if the player isn't doing well
	if ( filterTable["player_id_const"] == 0 ) then
		print("modifying player gold, Difficulty " .. tostring( self._nCurrentPlayerDifficulty ) )
		if ( self._nCurrentPlayerDifficulty == 0 ) then
			filterTable["gold"] = 1.75*filterTable["gold"]
		elseif ( self._nCurrentPlayerDifficulty == 1 ) then
			filterTable["gold"] = 1.5*filterTable["gold"]
		elseif ( self._nCurrentPlayerDifficulty == 2 ) then
			filterTable["gold"] = 1.25*filterTable["gold"]
		end
	end

	return true
end

function CTutorialAG:FilterModifyExperience( filterTable )
--	for k, v in pairs( filterTable ) do
--		print("MG: " .. k .. " " .. tostring(v) )
--	end

	-- give a bonus if the player isn't doing well
	if ( filterTable["player_id_const"] == 0 ) then
		if ( self._nCurrentPlayerDifficulty == 0 ) then
			filterTable["experience"] = 1.3*filterTable["experience"]
		elseif ( self._nCurrentPlayerDifficulty == 1 ) then
			filterTable["experience"] = 1.2*filterTable["experience"]
		elseif ( self._nCurrentPlayerDifficulty == 2 ) then
			filterTable["experience"] = 1.1*filterTable["experience"]
		end
	end

	return true
end

-----------------------------------------------------------------------------------------
-- Events
-----------------------------------------------------------------------------------------

function CTutorialAG:OnDialogButtonPressed( eventSourceIndex, args )
	
	local bNotifyItemsPurchased = false

	if ( self._bPausedForDetails ) then

		print("paused for item details" )

		CustomUI:DynamicHud_Destroy( -1, "details_dialog" )	
		self._bPausedForDetails = false
		if ( not self._bStayPausedForDetails ) then
			self:SetGameFrozen( false )
		else
			self._bStayPausedForDetails = false
		end

		if ( self._nItemIndex > self._nEarlyGameItemIdx ) then
			print("Think I have my items purchased")
			bNotifyItemsPurchased = true
		end

		self:_SetPlayerInvulnerability( false )
	end

	print("Active alert " .. tostring( self._nActiveAlert ) )
	print("Force alert " .. tostring( self:_IsForceAlert( self._nActiveAlert ) ) )

	if ( self._nActiveAlert ~= -1 and not self:_IsForceAlert( self._nActiveAlert ) ) then
--		print("clearing from button")
		self:_ClearAlerts()
		return
	end

	if ( bNotifyItemsPurchased ) then
		self:_FireEvent( ON_EARLY_ITEMS_PURCHASED )
		self._bLateGame = true
		return
	end

	self:_FireEvent( ON_TIP_DISMISSED )
end

function CTutorialAG:OnTaskAdvance()

	if ( self._bShowedSecretLocation ) then
		self:_IncrementAlert( ALERT_SECRET_SHOP_FOUND, 1.0 )
	end

	self:_FireEvent( ON_TASK_ADVANCED )
end

function CTutorialAG:OnPlayerGainedLevel()
end

function CTutorialAG:OnPlayerLearnedAbility( event )
--	print("learned ability")
--	print( event.player )
--	print( event.abilityname )

	local player = EntIndexToHScript( event.player )
	local playerID = player:GetPlayerID()

	if ( playerID ~= 0 ) then
		return
	end

	if ( self._nActiveAlert == ALERT_FORCE_LEVEL_UP ) then
		self:_ClearAlerts()
	end

	self:_FireEvent( ON_ABILITY_LEARNED )

	local heroUnit = PlayerResource:GetSelectedHeroEntity( playerID )
	if heroUnit == nil then
		return
	end

	if heroUnit:IsRealHero() then
		local upgradeAbility = heroUnit:FindAbilityByName( event.abilityname )
		local buildAbility = nil
		local bBuildStats = false

		if ( self._vSkillBuild[self._nSkillIndex] == -1 ) then 
			bBuildStats = true
		else
			buildAbility = heroUnit:GetAbilityByIndex( self._vSkillBuild[self._nSkillIndex] )			
		end

		-- Type 2 is the attributes ability
		if ( upgradeAbility ~= nil and ( ( upgradeAbility == buildAbility ) or ( upgradeAbility:GetAbilityType() == 2 and bBuildStats ) ) ) then
			self:_AdvanceAbilityBuild()
		end
	end
end

function CTutorialAG:OnPlayerUsedAbility()
end

function CTutorialAG:OnEntityHurt( event )
	if ( event.entindex_killed == nil or event.entindex_attacker == nil ) then
		return
	end

	local hVictim = EntIndexToHScript( event.entindex_killed )
	local hAttacker = EntIndexToHScript( event.entindex_attacker )

	if ( hVictim ~= nil and hAttacker ~= nil ) then
		if ( not Tutorial:GetTimeFrozen() and hVictim:IsRealHero() and hVictim:GetPlayerID() == 0 and hAttacker:IsCreep() and not self._bLateGame ) then
			self:_IncrementAlert( ALERT_TOO_MANY_CREEP_HITS, 2.0 / (self._nCurrentPlayerDifficulty + 1) )
		end
	end
end

function CTutorialAG:_GetTrimmedItemName( sItemName )
	local i, j = string.find( sItemName, "item_recipe_")

	if ( i ~= nil and j ~= nil ) then
		return string.sub( sItemName, j + 1 )
	end

	i, j = string.find( sItemName, "item_")

	if ( i ~= nil and j ~= nil ) then
		return string.sub( sItemName, j + 1 )
	end
end

function CTutorialAG:OnItemPurchased( event )
--	print(event.PlayerID)
--	print(event.itemname)
	self:_HandleItemPurchase( event.itemname, event.PlayerID )

--	print("------ ON_ITEM_PURCHASED")
	if ( event.PlayerID == 0 ) then
		if ( self._nActiveAlert == ALERT_FORCE_PURCHASE_ITEMS ) then
--			print("clearing from purchase")
			self:_ClearAlerts()
		end

		self:_FireEvent( ON_ITEM_PURCHASED )
	end
end

function CTutorialAG:OnItemCombined( event )
--	print(event.PlayerID)
--	print(event.itemname)
	self:_HandleItemPurchase( event.itemname, event.PlayerID )

--	print("------ ON_ITEM_COMBINED")
--	self:_FireEvent( ON_ITEM_COMBINED )
end

function CTutorialAG:_HandleItemPurchase( itemName, nPlayerID )
--	print("item purchased " .. itemName )

	if ( itemName == "item_tpscroll" ) then
		print("Skipping tp scroll")
		return
	end
--	print(event.PlayerID)
--	print(event.itemname)

	if ( self._nItemIndex == 0 ) then
		return
	end

	local heroUnit = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if heroUnit == nil then
		return
	end

--	print( heroUnit )

	if heroUnit:IsRealHero() and nPlayerID == 0 then

		-- always remove the item from the whitelist
--		print( "removing " .. itemName )

		-- check if we need to buy two of these.
		local duplicateItem = -1
		for idx,dupItem in pairs( self._vDoubleBuyItems ) do
			if ( self._vDoubleBuyItems[idx] == itemName ) then
				print("found duplicate item!!")
				duplicateItem = idx
			end
		end

		-- don't remove a double item from the whitelist until we buy two.
		if ( duplicateItem ~= -1 ) then
			self._vDoubleBuyItems[duplicateItem] = nil
			return
		else
			Tutorial:RemoveShopWhitelistItem( itemName )
		end

		if ( self._vItemBuild[ self._nItemIndex ] ~= nil ) then
			if ( self._vItemBuild[ self._nItemIndex ][1] == itemName ) then
				print("Advancing from main item purchase")
				self:_AdvanceItemBuild()
			else
				-- if we are building a combined item we can skip the first entry
				local bSkip = ( table.getn( self._vItemBuild[ self._nItemIndex ] ) > 1 )
				local bAllComponentsPurchased = true
--				local bMissingComponent = false
				local bFound = false

				for k, v in pairs( self._vItemBuild[ self._nItemIndex ] ) do
--					print("Component check")
--					print(bSkip)
--					print(k)
--					print(v)

					if ( v == itemName ) then
						bFound = true
--						print("Component found")
					end

					if ( k <= 1 ) then
						-- we don't require non-components to be purchased
					else
--						print("Checking " .. v .. " is equal " .. itemName )

						if ( Tutorial:IsItemInWhiteList( v ) ) then
--							print("Component still in Whitelist")
							bAllComponentsPurchased = false
						end
					end
				end

--				if not bFound then
--					print("Missing component " .. v )
--					bMissingComponent = true
--				end

				if ( bFound and bAllComponentsPurchased ) then
					print("Advancing from components")
					self:_AdvanceItemBuild()
				end
			end

			-- if we didn't build the first item maybe we built all of the components?
		end
	end
end

function CTutorialAG:_FormatProgessText( nCurrent, nGoal )
	return tostring( nCurrent ) .. "/" .. tostring( nGoal )
end

function CTutorialAG:OnLastHit( event )
	if ( event.TowerKill == 0 and event.HeroKill == 0 and event.PlayerID == 0 ) then
		self._nLastHits = self._nLastHits + 1
		self:_FireEvent( ON_LAST_HIT )
		print("Last hits " .. tostring( self._nLastHits ) )

		if( self._CurrentState == "quest_last_hits" ) then
			local progressText = self:_FormatProgessText( self._nLastHits, self._nLastHitGoal )
			CustomUI:DynamicHud_SetDialogVariables( -1, "tutorial_objective", { ProgressTextVar = progressText } )
		end

	end

	if ( self._nLastHits == 10 ) then
		self:_FireEvent( ON_TEN_LAST_HITS )
	end
end

function CTutorialAG:OnTowerKill( event )
	if ( event.teamnumber == 3 ) then
		self:_FireEvent( ON_TOWER_KILL_GOOD )
		self._nTowersKilledGood = self._nTowersKilledGood + 1

		print("Towers killed " .. tostring( self._nTowersKilledGood ) )
		if( self._CurrentState == "quest_take_objectives" ) then
			local progressText = self:_FormatProgessText( self._nTowersKilledGood, self._nTowersKilledGoal )
			CustomUI:DynamicHud_SetDialogVariables( -1, "tutorial_objective", { ProgressTextVar = progressText } )
		end

	else
		self:_FireEvent( ON_TOWER_KILL_BAD )
		self._nTowersKilledBad = self._nTowersKilledBad + 1
	end		
end

function CTutorialAG:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if ( killedUnit == self._entAncient ) then
		self:_FireEvent( ON_FORT_KILLED )
		return
	end

	if killedUnit:IsRealHero() and killedUnit:GetPlayerID() == 0 then
		self:_IncrementAlert( ALERT_DEATH, 1.0 )
	end
end

function CTutorialAG:OnAbilityLearnModeToggled( eventSourceIndex, args )
end

function CTutorialAG:OnPlayerShopChanged( eventSourceIndex, args )
	if ( args.player_id == 0 ) then
		if( bit.band( args.shop_mask, 2 ) ~= 0 ) then
			self:_IncrementAlert( ALERT_SIDE_SHOP, 1 )
		elseif( bit.band( args.shop_mask, 4 ) ~= 0 ) then
			self:_IncrementAlert( ALERT_SECRET_SHOP_FOUND, 1.0 )
		end
	end
end

function CTutorialAG:OnPurchaseFailedNeedSecretShop( eventSourceIndex, args )
	print("Secret shop fail, Player = " .. args.player_id ) 
	if ( args.player_id == 0 ) then
		if ( self._nActiveAlert == ALERT_FORCE_PURCHASE_ITEMS ) then
			self:_ClearAlerts()
		end

		self:_ShowTriggeredAlert( ALERT_SECRET_SHOP )
		self:_FireEvent( ON_SHOP_FAIL_NEED_SECRET_SHOP )
		if not self._bShowedSecretLocation then 
			self._bShowedSecretLocation = true
			Tutorial:CreateLocationTask( Vector(-4404, 1158, 389 ) )
		end
	end
end

function CTutorialAG:OnAbilityStartUse( eventSourceIndex, args )
end

function CTutorialAG:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsRealHero() then
		if ( spawnedUnit:GetPlayerID() == 0 ) then
			self._hPlayerHero = spawnedUnit

			self:_FireEvent( ON_HERO_SPAWNED )

			if ( self._bGameStarted ) then
				self:_IncrementAlert( ALERT_FOUNTAIN, 1.0 )
			end
		end
	end
end

--function CTutorialAG:OnShopToggled( event )
--	print("Shop Toggled")
--end

function CTutorialAG:CheckRuneTip()
	if ( self._hPickupRune ~= nil and not self._hPickupRune:IsNull() and self._hPlayerHero ~= nil ) then
		if ( self._hPlayerHero:IsPositionInRange( self._hPickupRune:GetAbsOrigin(), 400 ) == true ) then
			self:_IncrementAlert( ALERT_PICKED_UP_RUNE, 1.0 )
			self._hPickupRune = nil
		end
	end
end

-----------------------------------------------------------------------------------------
-- State Management
-----------------------------------------------------------------------------------------

-- Evaluate the state of the game
function CTutorialAG:OnThink()
	if ( GameRules:IsGamePaused() ) then
		return 0.25
	end

	self:CheckRuneTip()

	if ( self._flDialogFadeInTime > 0 ) then
		self._flDialogFadeInTime = self._flDialogFadeInTime - 0.25
		if ( self._flDialogFadeInTime <= 0 ) then
			self:_FadeInDialog()
		end
	end

	if ( self._flFXClearTime > 0 and self._nFXIndex ~= -1 ) then
		self._flFXClearTime = self._flFXClearTime - 0.25
		if ( self._flFXClearTime <= 0 ) then
			ParticleManager:DestroyParticle( self._nFXIndex, true )
			self._nFXIndex = -1
		end
	end


	if ( self._bInitialized == false ) then
		self._bInitialized = true
		self:_FireEvent( ON_INITIALIZED )
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

	if ( self._difficultyCheckTime < GameRules:GetGameTime() ) then
		self._difficultyCheckTime = GameRules:GetGameTime() + 10
		self:_CheckAutoDifficulty()
	end

--	if ( self._nActiveAlert ~= ALERT_FORCE_PURCHASE_ITEMS and
--		 self._nActiveAlert ~= ALERT_FORCE_LEVEL_UP and
--		 self._nActiveAlert ~= ALERT_DEATH and
--		 self._nActiveAlert ~= ALERT_SECRET_SHOP ) then
--
--		if ( self._flAlertTime > 0 ) then
--			self._flAlertTime = self._flAlertTime - 0.25
--			if ( self._flAlertTime <= 0 ) then
--				self:_ClearAlerts()
--			end
--		end
--	end
	
	if ( self._nActiveAlert == -1 ) then
		self:_CheckForAlerts()
	end

	if ( self._CurrentState == "quest_take_objectives" ) then
		self:_CheckTowerState()
	end

	return 0.25
end


function CTutorialAG:_GetState()
	if ( self._CurrentState == nil ) then
		return nil
	end
	return self._vTransitionTable[ self._CurrentState ]
end

function CTutorialAG:_SetState( strNewState )
	self._CurrentState = strNewState

	print("SETTING STATE: " .. strNewState )

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

function CTutorialAG:_FireEvent( nEvent )
	vCurrentState = self:_GetState()
	if ( vCurrentState == nil ) then
		return
	end

	if ( nEvent == ON_SKIP_STATE ) then
		print("Skipping to next state")
	end

	if ( ( nEvent == ON_SKIP_STATE ) or ( nEvent == vCurrentState.nAdvanceEvent ) ) then
		print("Advance even hit")
		self:_SetState( vCurrentState.strNext )
	end
end

function CTutorialAG:SetGameFrozen( bFreeze )
	Tutorial:SetTimeFrozen( bFreeze )
	local entity = Entities:First()
	while( entity ~= nil ) do
		if ( entity:IsBaseNPC() ) then
			if ( entity:IsAlive() and ( entity:IsCreep() or entity:IsHero() ) ) then
				if ( bFreeze == true ) then
--					print("Making unit idle " .. entity:GetClassname() )
					entity:StartGesture( ACT_DOTA_IDLE )
				else
					entity:RemoveGesture( ACT_DOTA_IDLE )
				end
			end
		end
		entity = Entities:Next( entity )
	end
end

-----------------------------------------------------------------------------------------
-- Dynamic tips
-----------------------------------------------------------------------------------------

function CTutorialAG:_IsForceAlert( nAlert )
	if ( nAlert == ALERT_FORCE_PURCHASE_ITEMS or
		 nAlert == ALERT_FORCE_LEVEL_UP ) then
		return true
	end
	return false
end

function CTutorialAG:_ClearAlerts()
	self:_SetPlayerInvulnerability( false )

	self:SetGameFrozen( false )
	self._nActiveAlert = -1
	CustomUI:DynamicHud_Destroy( -1, "alert_dialog" )
end

function CTutorialAG:_CheckForAlerts()
	if not self._bGameStarted or GameRules:IsGamePaused() or Tutorial:GetTimeFrozen() or self._bLateGame then
		return
	end

	if ( self:_GetClosestTowerDistance() < 900 ) then
--		print( "Tower too close for alerts! " .. tostring( self:_GetClosestTowerDistance() ) )
		return
	end

	local flLowHealthThreshold = 1.00 / ( self._nCurrentPlayerDifficulty + 2 )
	local flForcePurchaseThreshold = 1.2
	local mMinForcePurchaseThreshold = 700
	local nForceLevelupDeficit = 0
	local nTowerDeficit = 1
	local nFirstPurchaseThreshold = 450

	local flLowGoldRatio = 0.66
	local flLowExpRatio = 0.66

	-- Check if we have low health.
	if ( self._hPlayerHero:IsAlive() and self._hPlayerHero:GetHealth() < flLowHealthThreshold*self._hPlayerHero:GetMaxHealth() ) then
		self:_IncrementAlert( ALERT_LOW_HEALTH, 0.3 )
	end

	-- Can we purchase our next item?
	if ( self:_GetNextItemCost() > 0 ) then
		if ( self._hPlayerHero:GetGold() > nFirstPurchaseThreshold ) then
			self:_IncrementAlert( ALERT_FIRST_PURCHASE, 1.0 )
		end
		if ( self:_GetCheapestComponentCost() > 0 and self._hPlayerHero:GetGold() > flForcePurchaseThreshold*self:_GetCheapestComponentCost() and self._hPlayerHero:GetGold() > mMinForcePurchaseThreshold ) then
			self:_IncrementAlert( ALERT_FORCE_PURCHASE_ITEMS, 0.3 )
		end
	end

	-- Do we have an item that we could put in our inventory?
	if ( self._hPlayerHero:GetNumItemsInStash() > 0 and self._hPlayerHero:GetNumItemsInInventory() < 6 ) then
		self:_IncrementAlert( ALERT_NEED_DELIVER_ITEMS, 0.3 )
	end

	-- Make sure our skill build is caught up.
--	if ( self._hPlayerHero:GetLevel() < 13 and self._hPlayerHero:GetLevel() > self._nSkillIndex ) then
--		self:_IncrementAlert( ALERT_CAN_LEVEL_UP, 0.25 )
--	end
	if ( self._hPlayerHero:GetLevel() < 13 and self._hPlayerHero:GetLevel() > ( nForceLevelupDeficit + self._nSkillIndex ) ) then
		self:_IncrementAlert( ALERT_FORCE_LEVEL_UP, 0.3 )
	end

	if ( self._nTowersKilledBad > ( nTowerDeficit + self._nTowersKilledBad ) ) then
		self:_IncrementAlert( ALERT_BEHIND_ON_TOWERS, 0.3 )
	end

	-- is the player behind in gold or mana?
	local nPlayerGold = PlayerResource:GetGoldPerMin( 0 )
	local nPlayerExp = PlayerResource:GetXPPerMin( 0 )

	local nDireGold = 0
	local nDireExp = 0

	local nMinimumXPM = 150
	local nMinimumGPM = 50

	local members = HeroList:GetAllHeroes()
  	for _,hero in ipairs(members) do
  		if ( hero ~= nil and hero:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
  			nDireGold = nDireGold + ( 0.2*PlayerResource:GetGoldPerMin( hero:GetPlayerID() ) )
  			nDireExp = nDireExp + ( 0.2*PlayerResource:GetXPPerMin( hero:GetPlayerID() ) )
  		end
  	end

  	if ( ( nPlayerGold + nMinimumGPM ) < ( flLowGoldRatio*( nDireGold + nMinimumGPM ) ) ) then
  		self:_IncrementAlert( ALERT_BEHIND_ON_GOLD, 0.3 )
  	end

  	if ( ( nPlayerExp + nMinimumXPM ) < ( flLowExpRatio*( nDireExp + nMinimumXPM ) ) ) then
		self:_IncrementAlert( ALERT_BEHIND_ON_EXP, 0.3 )
  	end

  	-- decay alert cooldowns
  	for k, v in pairs( self._vAlertTable ) do
		if ( self._vAlertTable[k]["flAlertLevel"] < 0 ) then
			self._vAlertTable[k]["flAlertLevel"] = self._vAlertTable[k]["flAlertLevel"] + 0.25

--			print("Cooldown " .. tostring(self._vAlertTable[k]["flAlertLevel"]))
		elseif ( self._vAlertTable[k]["flAlertLevel"] > 0 ) then
			self._vAlertTable[k]["flAlertLevel"] = self._vAlertTable[k]["flAlertLevel"] - 0.05

--			print("Decay " .. tostring(self._vAlertTable[k]["flAlertLevel"]))
		end
	end
end

function CTutorialAG:_IncrementAlert( nAlert, flAmount )
	if ( self._vAlertTable[nAlert]["nNagCount"] <= 0 ) then
		return false
	end

	self._vAlertTable[nAlert]["flAlertLevel"] =	self._vAlertTable[nAlert]["flAlertLevel"] + flAmount

--	print("Incrementing alert " .. tostring( nAlert ) .. " to " .. self._vAlertTable[nAlert]["flAlertLevel"] )

	if ( self._vAlertTable[nAlert]["flAlertLevel"] >= self._vAlertTable[nAlert]["flAlertThreshold"] ) then
		self:_ShowTriggeredAlert( nAlert )

		local hHero = PlayerResource:GetSelectedHeroEntity( 0 )
		if ( hHero ~= nil ) then
			ProjectileManager:ProjectileDodge( hHero )
		end

		-- make sure other alerts don't fire for a while.
		for k, v in pairs( self._vAlertTable ) do
			if ( k ~= nAlert and self._vAlertTable[k]["flAlertLevel"] > 0 ) then
				self._vAlertTable[nAlert]["flAlertLevel"] = self._vAlertTable[nAlert]["flAlertLevel"] - math.max( self._vAlertTable[nAlert]["flAlertLevel"], 10 )
			end
		end
		return true
	end
	return false
end

function CTutorialAG:_ShowTriggeredAlert( nAlert )

	self._flAlertTime = 5

	self._vAlertTable[nAlert]["nNagCount"] = self._vAlertTable[nAlert]["nNagCount"] - 1
	self._vAlertTable[nAlert]["flAlertLevel"] = -1*self._vAlertTable[nAlert]["nCoolDown"]

	CustomUI:DynamicHud_Destroy( -1, "alert_dialog" )
	local layout = "file://{resources}/layout/custom_game/tutorial_alert_continue.xml" -- ALERT_STYLE_SIDE

	if ( self._vAlertTable[nAlert]["style"] == ALERT_STYLE_FORCE ) then
		layout = "file://{resources}/layout/custom_game/tutorial_alert_force.xml"
	end

	self._nActiveAlert = nAlert
	self:SetGameFrozen( true )

	print( "Alert style " .. layout )

	if ( self._vAlertTable[nAlert]["keyTable"] ~= nil ) then
		CustomUI:DynamicHud_Create( -1, "alert_dialog", layout, { TitleTextVar = self._vAlertTable[nAlert]["title"], BodyTextVar = self._vAlertTable[nAlert]["body"] } )
		CustomGameEventManager:Send_ServerToAllClients( "set_custom_alert_string", self._vAlertTable[nAlert]["keyTable"] )
	else
		CustomUI:DynamicHud_Create( -1, "alert_dialog", layout, { TitleTextVar = self._vAlertTable[nAlert]["title"], BodyTextVar = self._vAlertTable[nAlert]["body"] } )
	end

	self:_QueueAlertFadeIn( nAlert )
end

-----------------------------------------------------------------------------------------
-- Dynamic Difficulty
-----------------------------------------------------------------------------------------

function CTutorialAG:_CheckAutoDifficulty()
	-- simple formula to determine which team is in the lead.

	local flPlayerBalanceDiscount = 0.78
	local flDifficultyIncrement = 0.35
	local nPlayerAdvantagePerIncrement = 8
	local nTimeDifficultyLimit = 80

	if ( PlayerResource:GetSelectedHeroEntity( 0 ) == nil ) then
		return
	end

	local nPlayerScore = PlayerResource:GetGoldPerMin( 0 ) + PlayerResource:GetXPPerMin( 0 )
	local nRadiantScore = 0
	local nDireScore = 0

	local members = HeroList:GetAllHeroes()
  	for _,hero in ipairs(members) do
  		if ( hero ~= nil and hero:GetTeamNumber() == DOTA_TEAM_BADGUYS ) then
  			nDireScore = nDireScore + PlayerResource:GetGoldPerMin( hero:GetPlayerID() ) + PlayerResource:GetXPPerMin( hero:GetPlayerID() )
  		elseif ( hero ~= nil and hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
  			nRadiantScore = nRadiantScore + PlayerResource:GetGoldPerMin( hero:GetPlayerID() ) + PlayerResource:GetXPPerMin( hero:GetPlayerID() )
  		end
  	end

  	-- use the player score if they are doing better than their team.
  	if ( (5*nPlayerScore) > nRadiantScore ) then
  		nRadiantScore = 5*nPlayerScore
  	end

	if( nRadiantScore > 0 and nDireScore > 0 ) then
--	  	print("RadiantScore " .. tostring( nRadiantScore ))
--  	print("   DireScore " .. tostring( nDireScore ))

		local balance = ( nRadiantScore + 100 ) / ( nDireScore + 100 )
		print("Relative Score = " .. tostring( balance ) )

		balance = ( flPlayerBalanceDiscount*( nRadiantScore + 100 ) ) / ( nDireScore + 100 )
		print("Discounted Score = " .. tostring( balance ) )

		-- Difficulty ranges from 0 (passive) to 4 (unfair)
		local flDifficultyIncrement = 0.5
		local intendedDifficulty = 0
		if ( balance > 1.0 ) then
			intendedDifficulty = 1 + math.floor( ( balance - 1 ) / flDifficultyIncrement )
		end

		local nTimeDifficultyMax = math.floor( GameRules:GetGameTime()/nTimeDifficultyLimit )
		print("Time difficulty limit " .. tostring(nTimeDifficultyMax))
			
		intendedDifficulty = math.min( intendedDifficulty, 4, nTimeDifficultyMax )
	  	local diffScale = nPlayerAdvantagePerIncrement * ( 4 - intendedDifficulty )
		
		-- save off the difficulty that we want for the player.
		self._nCurrentPlayerDifficulty = intendedDifficulty

		-- We may want a minimum value for the bots to make sure they will push.
		intendedDifficulty = math.max( intendedDifficulty, self._nMinDifficulty )
		print("IntendedDifficulty = " .. tostring( intendedDifficulty ) .. " AdvantageScale " .. tostring( diffScale ) )
--		print("diffScale = " .. tostring( diffScale ) )

		local members = HeroList:GetAllHeroes()
	  	for _,hero in ipairs(members) do
	  		if ( hero ~= nil ) then
	  			if ( hero:GetTeamNumber() == self._hPlayerHero:GetTeamNumber() ) then
		  			local teamDifficulty = intendedDifficulty
		  			if ( self._bLateGame ) then
		  				teamDifficulty = math.max( teamDifficulty, 2 )
		  			end
		  			if ( hero:GetClassname() == "npc_dota_hero_dazzle" ) then
		  				print("Setting dazzle difficulty " .. tostring( math.max( math.min( 1, nTimeDifficultyMax), teamDifficulty ) ) )
		  				hero:SetBotDifficulty( math.max( math.min( 1, nTimeDifficultyMax), teamDifficulty ) ) -- bots can't go passive after a while.
		  			else
			  			hero:SetBotDifficulty( teamDifficulty ) -- team may need additional boost to push desire
		  			end
	  			else
		  			if ( hero:GetClassname() == "npc_dota_hero_phantom_assassin" ) then
--		  				print("aSetting difficulty for " .. hero:GetClassname() .. " to " .. tostring( 0 ) )
		  				hero:SetBotDifficulty( 0 ) -- PA is too difficult to ever get a difficulty bump
		  			else
--		  				print("Setting difficulty for " .. hero:GetClassname() .. " to " .. tostring( intendedDifficulty ) )
		  				hero:SetBotDifficulty( intendedDifficulty ) -- bots can't go passive after a while.
		  			end
	  			end
	  		end
	  	end
	
	  	Tutorial:SetTutorialConvar( "dota_tutorial_percent_damage_decrease", tostring( diffScale ) )
		Tutorial:SetTutorialConvar( "dota_tutorial_percent_bot_exp_decrease", tostring( diffScale ) )
  	end
end

function CTutorialAG:_GetClosestTowerDistance()
	if ( not self._hPlayerHero ) then
		return 0
	end

	local flClosestDistance = 0
	for _,unitName in pairs( self._vTier1Towers ) do
		local unit = Entities:FindByName( nil, unitName )
		if unit then
			if unit:IsAlive() then
				if ( flClosestDistance == 0 or unit:GetRangeToUnit( self._hPlayerHero ) < flClosestDistance ) then
					flClosestDistance = unit:GetRangeToUnit( self._hPlayerHero )
				end
			end
		else
			print("Couldn't find unit " .. unitName )
		end
	end

	for _,unitName in pairs( self._vTier2Towers ) do
		local unit = Entities:FindByName( nil, unitName )
		if unit then
			if unit:IsAlive() then
				if ( flClosestDistance == 0 or unit:GetRangeToUnit( self._hPlayerHero ) < flClosestDistance ) then
					flClosestDistance = unit:GetRangeToUnit( self._hPlayerHero )
				end
			end
		else
			print("Couldn't find unit " .. unitName )
		end
	end

	return flClosestDistance	
end

function CTutorialAG:_AreAnyAlive( vUnitTable )
--	print(vUnitTable)
	for _,unitName in pairs( vUnitTable ) do
--		print("Checking " .. unitName)
		local unit = Entities:FindByName( nil, unitName )
		if not unit then
			-- skip this unit
		elseif unit:IsAlive() then
--			print( "Alive!" )
			return true
		end
	end
	return false
end

function CTutorialAG:_AreAnyDead( vUnitTable )
--	print(vUnitTable)
	for _,unitName in pairs( vUnitTable ) do
		local unit = Entities:FindByName( nil, unitName )
		if not unit or not unit:IsAlive() then
--			print( "Dead!" )
			return true
		end
--		print("Checking " .. unitName)
	end
	return false
end

function CTutorialAG:_CheckTowerState()

	if( self._bStopTowerCheck ) then
		return
	end

	if ( self:_AreAnyDead( self._vTier3Towers ) ) then
--		print("Want to push ancient")
		GameRules:GetGameModeEntity():SetBotsMaxPushTier( -1 )
		self:_FireEvent( ON_PUSH_T3 )
		self._bStopTowerCheck = true
		return
	end

	if ( self:_AreAnyAlive( self._vTier1Towers ) ) then
--		print("Want to push t1 towers")
		GameRules:GetGameModeEntity():SetBotsMaxPushTier( 1 )
	elseif ( self:_AreAnyAlive( self._vTier2Towers ) ) then
--		print("Want to push t2 towers")
		GameRules:GetGameModeEntity():SetBotsMaxPushTier( 2 )
	else
--		print("Want to push t3 towers")
		GameRules:GetGameModeEntity():SetBotsMaxPushTier( -1 )
		self:_FireEvent( ON_PUSH_T3 )
		self._bStopTowerCheck = true
	end
end


-----------------------------------------------------------------------------------------
-- Build management
-----------------------------------------------------------------------------------------

function CTutorialAG:_AdvanceItemBuild()
	if( self._vItemBuild[self._nItemIndex] ~= nil ) then
		if( self._vItemBuild[self._nItemIndex][1] ~= nil ) then

			-- Let the player know the details about this item.
			self:_TryAnnounceItem( self._vItemBuild[self._nItemIndex][1] )

			for k, v in pairs( self._vItemBuild[self._nItemIndex] ) do
	  			Tutorial:RemoveShopWhitelistItem( v )
	  		end		
		end
	end

	self._nItemIndex = self._nItemIndex + 1

--	print("Item Progress " .. tostring( self._nItemIndex ) )
	if( self._CurrentState == "quest_core_items" ) then
		local progressText = self:_FormatProgessText( (self._nItemIndex - self._nEarlyGameItemStart), ( 1 + ( self._nEarlyGameItemIdx - self._nEarlyGameItemStart) ) )
--		print("Progress text " .. progressText )
		CustomUI:DynamicHud_SetDialogVariables( -1, "tutorial_objective", { ProgressTextVar = progressText } )
	end

	if( self._vItemBuild[self._nItemIndex] ~= nil ) then
		for k, v in pairs( self._vItemBuild[self._nItemIndex] ) do
			if ( k == 1 ) then
				local itemTrimmed = self:_GetTrimmedItemName( v )
--				print("New quick buy " .. itemTrimmed )
				Tutorial:SetQuickBuy( itemTrimmed )
			end
--			print("Adding " .. v )
  			Tutorial:AddShopWhitelistItem( v )
  		end
  	else
  		self._bWhiteListEnabled = false
  		Tutorial:SetWhiteListEnabled( false )
	end

	local nextCost = self:_GetNextItemCost()
--	print("Next item costs " .. tostring( nextCost ) )
end

function CTutorialAG:_GetCheapestComponentCost()
	local currentItems = self._vItemBuild[ self._nItemIndex ]

	if ( currentItems == nil ) then
		return 0
	end

	if ( table.getn( currentItems ) == 1 ) then
--		print("Getting cost of " .. currentItems[1] )
		return GetItemCost( currentItems[1] )
	end

	local cheapestCost = 0
	for k, v in pairs( self._vItemBuild[self._nItemIndex] ) do
		if ( k ~= 1 ) then
			if ( Tutorial:IsItemInWhiteList( v ) ) then
--				print("Getting cost of " .. v .. " is " .. tostring( GetItemCost( v ) ) )
				if ( cheapestCost == 0 or GetItemCost( v ) < cheapestCost ) then
					cheapestCost = GetItemCost( v )
				end
			end
		end
	end

	return cheapestCost	
end

function CTutorialAG:_GetNextItemCost()
	local currentItems = self._vItemBuild[ self._nItemIndex ]

	if ( currentItems == nil ) then
		return 0
	end

	if ( table.getn( currentItems ) == 1 ) then
--		print("Getting cost of " .. currentItems[1] )
		return GetItemCost( currentItems[1] )
	end

	local totalCost = 0
	for k, v in pairs( self._vItemBuild[self._nItemIndex] ) do
		if ( k ~= 1 ) then
--			print("Getting cost of " .. v )
			totalCost = totalCost + GetItemCost( v )
		end
	end
	return totalCost
end

function CTutorialAG:_SetPlayerInvulnerability( bInvulnerable )
	if ( bInvulnerable ) then
		if ( self._hPlayerHero ~= nil and self._nImmuneFXIndex == -1 ) then
			self._hPlayerHero:AddNewModifier( self._hPlayerHero, nil, "modifier_invulnerable", {} )

			self._nImmuneFXIndex = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self._hPlayerHero )
		end
	else
		if ( self._hPlayerHero ~= nil ) then
			self._hPlayerHero:RemoveModifierByName( "modifier_invulnerable" )
			if ( self._nImmuneFXIndex ~= -1 ) then
				ParticleManager:DestroyParticle( self._nImmuneFXIndex, true )
				self._nImmuneFXIndex = -1
			end
		end
	end
end

function CTutorialAG:_SetBuildImage( imageClassName )
	local event_data =
	{
	    image_class = imageClassName,
	}
	CustomGameEventManager:Send_ServerToAllClients( "set_build_image", event_data )
end

function CTutorialAG:_QueueDetailsFadeIn()
	self:_SetPlayerInvulnerability( true )
	self._flDialogFadeInTime = 1.5
end

function CTutorialAG:_QueueInfoFadeIn()
	self:_SetPlayerInvulnerability( true )
	self._flDialogFadeInTime = 1.5
end

function CTutorialAG:_QueueAlertFadeIn( nAlert )

	-- Don't make the target invulnerable if they die.
	if ( nAlert == ALERT_DEATH ) then
		self:_FadeInDialog()
		return
	end

	self:_SetPlayerInvulnerability( true )

	if ( self._nAlertFadeCount > 0 ) then
		self._nAlertFadeCount = self._nAlertFadeCount - 1
		self._flDialogFadeInTime = 3.0
	else
		self._flDialogFadeInTime = 1.5		
	end
end

function CTutorialAG:_FadeInDialog()
	CustomGameEventManager:Send_ServerToAllClients( "fade_in_dialog", {} )
end

function CTutorialAG:_TryAnnounceItem( itemName )
	local itemDetails = self._vItemDetails[itemName]
	if itemDetails ~= nil then
		self:SetGameFrozen( true )
		CustomUI:DynamicHud_Create( -1, "details_dialog", "file://{resources}/layout/custom_game/tutorial_dialog_build_details.xml", { TitleTextVar = itemDetails.title, BodyTextVar = itemDetails.body } )
		self:_SetBuildImage( itemDetails.imageClass )
		self._bPausedForDetails = true
		self:_QueueDetailsFadeIn()
	end
end

function CTutorialAG:_AdvanceAbilityBuild()
--	print("advancing")

	self:_TryAnnounceBuild( self._nSkillIndex )

	self._nSkillIndex = self._nSkillIndex + 1
	local newSkill = self._vSkillBuild[self._nSkillIndex]

	if ( newSkill == nil ) then
		return
	end

	if ( self._nSkillIndex >= 14 ) then
		Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-1" )
	else
		Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", tostring( newSkill ) )
	end
end

function CTutorialAG:_TryAnnounceBuild( nLevel )
--	print("Anouncing " .. tostring(nLevel))
--	print( self._vSkillBuildTxt[nLevel] )

	local skillDetails = self._vSkillBuildTxt[nLevel]
	if skillDetails ~= nil then
--		print("anouncing build")
		self:SetGameFrozen( true )
		CustomUI:DynamicHud_Create( -1, "details_dialog", "file://{resources}/layout/custom_game/tutorial_dialog_build_details.xml", { TitleTextVar = skillDetails.title, BodyTextVar = skillDetails.body } )
		self:_SetBuildImage( skillDetails.imageClass )
		self._bPausedForDetails = true		
		if ( self._nSkillIndex == 0 ) then
			EmitGlobalSound("Tutorial.TaskProgress")
			self._bStayPausedForDetails = true
			self:_FadeInDialog()
		else
			self:_QueueDetailsFadeIn()
		end
	else
--		print("Build is nil")
	end
end

-----------------------------------------------------------------------------------------
-- Actions
-----------------------------------------------------------------------------------------

function CTutorialAG:_SelectLuna()

--	Tutorial:SelectHero( "npc_dota_hero_luna" )

	self._ItemBuildName = "luna_assist_game_item_build"

	self._vItemBuild[1] = { [1] = "item_tango" }
	self._vItemBuild[2] = { [1] = "item_flask" }
	self._vItemBuild[3] = { [1] = "item_circlet" }
	self._vItemBuild[4] = { [1] = "item_slippers" }

	self._vItemBuild[5] = { [1] = "item_power_treads", 			[2] = "item_boots", 			[3] = "item_gloves",			[4] = "item_belt_of_strength" }

	self._vItemBuild[6] = { [1] = "item_ring_of_aquila", 		[2] = "item_ring_of_protection",[3] = "item_sobi_mask", 		[4] = "item_recipe_wraith_band", [0] = "item_ring_of_basilius", [-1] = "item_wraith_band" }
	self._vItemBuild[7] = { [1] = "item_lifesteal" }
	self._vItemBuild[8] = { [1] = "item_yasha", 				[2] = "item_blade_of_alacrity",	[3] = "item_boots_of_elves",	[4] = "item_recipe_yasha" }

	self._vItemBuild[9] = { [1] = "item_helm_of_the_dominator", [2] = "item_helm_of_iron_will" }
	self._vItemBuild[10] = { [1] = "item_manta", 				[2] = "item_ultimate_orb", 		[3] = "item_recipe_manta" }

	self._vItemBuild[11] = { [1] = "item_black_king_bar", 		[2] = "item_ogre_axe", 			[3] = "item_mithril_hammer",	[4] = "item_recipe_black_king_bar" }
	self._vItemBuild[12] = { [1] = "item_butterfly", 			[2] = "item_eagle",				[3] = "item_talisman_of_evasion",[4] = "item_quarterstaff" }
	self._vItemBuild[13] = { [1] = "item_satanic", 				[2] = "item_reaver",			[3] = "item_recipe_satanic" }

	self._nEarlyGameItemIdx = 8
	self._nEarlyGameItemStart = 5

	self._vItemDetails["item_power_treads"] = 			{ title = "ag_detail_ItemLunaTreadsTitle", 		body = "ag_detail_ItemLunaTreadsBody",		imageClass="TreadsImage" }
	self._vItemDetails["item_ring_of_aquila"] = 		{ title = "ag_detail_ItemLunaAquilaTitle", 		body = "ag_detail_ItemLunaAquilaBody",		imageClass="AquilaImage" }
	self._vItemDetails["item_lifesteal"] = 				{ title = "ag_detail_ItemLunaLifestealTitle", 	body = "ag_detail_ItemLunaLifestealBody",	imageClass="LifestealImage" }
	self._vItemDetails["item_yasha"] = 					{ title = "ag_detail_ItemLunaYashaTitle", 		body = "ag_detail_ItemLunaYashaBody",		imageClass="YashaImage" }
	self._vItemDetails["item_helm_of_the_dominator"] = 	{ title = "ag_detail_ItemLunaHelmTitle", 		body = "ag_detail_ItemLunaHelmBody",		imageClass="HOTDImage" }
	self._vItemDetails["item_manta"] = 					{ title = "ag_detail_ItemLunaMantaTitle", 		body = "ag_detail_ItemLunaMantaBody",		imageClass="MantaImage" }
	self._vItemDetails["item_black_king_bar"] = 		{ title = "ag_detail_ItemLunaBKBTitle", 		body = "ag_detail_ItemLunaBKBBody",			imageClass="BKBImage" }
	self._vItemDetails["item_butterfly"] = 				{ title = "ag_detail_ItemLunaButterflyTitle", 	body = "ag_detail_ItemLunaButterflyBody",	imageClass="ButterflyImage" }
	self._vItemDetails["item_satanic"] = 				{ title = "ag_detail_ItemLunaSatanicTitle", 	body = "ag_detail_ItemLunaSatanicBody",		imageClass="SatanicImage" }

	self._vSwingHero[0] = "npc_dota_hero_lina"
	self._vSwingHero[1] = "npc_dota_hero_sven"

	self._vSelectAbilityText[0] = "ag_objective_LunaUnlockAbilityTitle"
	self._vSelectAbilityText[1] = "ag_objective_LunaUnlockAbilityBody"

	self._vBuildDetails[0] = "ag_info_AbilityItemBuildLunaTitle"
	self._vBuildDetails[1] = "ag_info_AbilityItemBuildLunaBody"

	self._vSkillBuild[0] = 2
	self._vSkillBuild[1] = 0
	self._vSkillBuild[2] = 0
	self._vSkillBuild[3] = 2
	self._vSkillBuild[4] = 0
	self._vSkillBuild[5] = 3
	self._vSkillBuild[6] = 0
	self._vSkillBuild[7] = 1
	self._vSkillBuild[8] = 1
	self._vSkillBuild[9] = 2
	self._vSkillBuild[10] = 3
	self._vSkillBuild[11] = 2
	self._vSkillBuild[12] = 1
	self._vSkillBuild[13] = 1
	self._vSkillBuild[14] = -1
	self._vSkillBuild[15] = 3
	self._vSkillBuild[16] = -1
	self._vSkillBuild[17] = -1
	self._vSkillBuild[18] = -1
	self._vSkillBuild[19] = -1
	self._vSkillBuild[20] = -1
	self._vSkillBuild[21] = -1
	self._vSkillBuild[22] = -1
	self._vSkillBuild[23] = -1
	self._vSkillBuild[24] = -1

	self._vSkillBuildTxt[0] = { title = "ag_detail_BuildLunarBlessingTitle",body = "ag_detail_BuildLunarBlessingBody",	imageClass="" }
	self._vSkillBuildTxt[1] = { title = "ag_detail_BuildLucentBeamTitle",	body = "ag_detail_BuildLucentBeamBody",		imageClass="" }
	self._vSkillBuildTxt[5] = { title = "ag_detail_BuildEclipseTitle",		body = "ag_detail_BuildEclipseBody",		imageClass="" }
	self._vSkillBuildTxt[7] = { title = "ag_detail_BuildMoonGlaiveTitle",	body = "ag_detail_BuildMoonGlaiveBody",		imageClass="" }
	self._vSkillBuildTxt[14] = { title = "ag_detail_BaseStatsTitle",		body = "ag_detail_BaseStatsBody",			imageClass=""  }

end

function CTutorialAG:_SelectSven()

--	Tutorial:SelectHero( "npc_dota_hero_sven" )

	self._ItemBuildName = "sven_assist_game_item_build"

	self._vItemBuild[1] = { [1] = "item_tango" }
	self._vItemBuild[2] = { [1] = "item_flask" }
	self._vItemBuild[3] = { [1] = "item_circlet" }
	self._vItemBuild[4] = { [1] = "item_gauntlets" }

	self._vItemBuild[5] = { [1] = "item_power_treads", 			[2] = "item_boots", 			[3] = "item_gloves",			[4] = "item_belt_of_strength" }

	self._vItemBuild[6] = { [1] = "item_ancient_janggo", 		[2] = "item_recipe_bracer",		[3] = "item_ring_of_regen", [4] = "item_wind_lace", [5] = "item_recipe_ancient_janggo", [0] = "item_bracer", }
	self._vItemBuild[7] = { [1] = "item_lifesteal" }
	self._vItemBuild[8] = { [1] = "item_lesser_crit", 			[2] = "item_blades_of_attack",	[3] = "item_broadsword",		[4] = "item_recipe_lesser_crit" }

	self._vItemBuild[9] = { [1] = "item_mask_of_madness", 		[2] = "item_recipe_mask_of_madness" }
	self._vItemBuild[10] = { [1] = "item_platemail" }
	self._vItemBuild[11] = { [1] = "item_hyperstone",  }

	self._vItemBuild[12] = { [1] = "item_assault", 				[2] = "item_chainmail",			[3] = "item_recipe_assault" }
	self._vItemBuild[13] = { [1] = "item_greater_crit", 		[2] = "item_demon_edge", 		[3] = "item_recipe_greater_crit" }

	self._nEarlyGameItemIdx = 8
	self._nEarlyGameItemStart = 5

	self._vItemDetails["item_power_treads"] = 			{ title = "ag_detail_ItemSvenTreadsTitle", 		body = "ag_detail_ItemSvenTreadsBody",		imageClass="TreadsImage" }
	self._vItemDetails["item_ancient_janggo"] = 		{ title = "ag_detail_ItemSvenDrumsTitle", 		body = "ag_detail_ItemSvenDrumsBody",		imageClass="DrumsImage"  }
	self._vItemDetails["item_lifesteal"] = 				{ title = "ag_detail_ItemSvenLifestealTitle", 	body = "ag_detail_ItemSvenLifestealBody",	imageClass="LifestealImage"  }
	self._vItemDetails["item_lesser_crit"] = 			{ title = "ag_detail_ItemSvenCritTitle", 		body = "ag_detail_ItemSvenCritBody",		imageClass="CrystalysImage"  }
	self._vItemDetails["item_mask_of_madness"] = 		{ title = "ag_detail_ItemSvenMaskTitle", 		body = "ag_detail_ItemSvenMaskBody",		imageClass="MOMImage"  }
	self._vItemDetails["item_platemail"] = 				{ title = "ag_detail_ItemSvenPlatemailTitle", 	body = "ag_detail_ItemSvenPlatemailBody",	imageClass="PlatemailImage"  }
	self._vItemDetails["item_hyperstone"] = 			{ title = "ag_detail_ItemSvenHyperstoneTitle", 	body = "ag_detail_ItemSvenHyperstoneBody",	imageClass="HyperstoneImage"  }
	self._vItemDetails["item_assault"] = 				{ title = "ag_detail_ItemSvenAssaultTitle", 	body = "ag_detail_ItemSvenAssaultBody",		imageClass="AssaultImage"  }
	self._vItemDetails["item_greater_crit"] = 			{ title = "ag_detail_ItemSvenGreaterCritTitle", body = "ag_detail_ItemSvenGreaterCritBody",	imageClass="DadealusImage"  }

	self._vSwingHero[0] = "npc_dota_hero_lina"
	self._vSwingHero[1] = "npc_dota_hero_luna"

	self._vSelectAbilityText[0] = "ag_objective_SvenUnlockAbilityTitle"
	self._vSelectAbilityText[1] = "ag_objective_SvenUnlockAbilityBody"

	self._vBuildDetails[0] = "ag_info_AbilityItemBuildSvenTitle"
	self._vBuildDetails[1] = "ag_info_AbilityItemBuildSvenBody"

	self._vSkillBuild[0] = 0
	self._vSkillBuild[1] = 2
	self._vSkillBuild[2] = 0
	self._vSkillBuild[3] = 2
	self._vSkillBuild[4] = 0
	self._vSkillBuild[5] = 3
	self._vSkillBuild[6] = 0
	self._vSkillBuild[7] = 1
	self._vSkillBuild[8] = 1
	self._vSkillBuild[9] = 2
	self._vSkillBuild[10] = 3
	self._vSkillBuild[11] = 2
	self._vSkillBuild[12] = 1
	self._vSkillBuild[13] = 1
	self._vSkillBuild[14] = -1
	self._vSkillBuild[15] = 3
	self._vSkillBuild[16] = -1
	self._vSkillBuild[17] = -1
	self._vSkillBuild[18] = -1
	self._vSkillBuild[19] = -1
	self._vSkillBuild[20] = -1
	self._vSkillBuild[21] = -1
	self._vSkillBuild[22] = -1
	self._vSkillBuild[23] = -1
	self._vSkillBuild[24] = -1

	self._vSkillBuildTxt[0] = { title = "ag_detail_BuildStormHammerTitle",	body = "ag_detail_BuildStormHammerBody",	imageClass=""  }
	self._vSkillBuildTxt[1] = { title = "ag_detail_BuildWarCryTitle",		body = "ag_detail_BuildWarCryBody",			imageClass=""  }
	self._vSkillBuildTxt[5] = { title = "ag_detail_BuildGodsStrengthTitle",	body = "ag_detail_BuildGodsStrengthBody",	imageClass=""  }
	self._vSkillBuildTxt[7] = { title = "ag_detail_BuildGreatCleaveTitle",	body = "ag_detail_BuildGreatCleaveBody",	imageClass=""  }
	self._vSkillBuildTxt[14] = { title = "ag_detail_BaseStatsTitle",		body = "ag_detail_BaseStatsBody",			imageClass=""  }

end

function CTutorialAG:_SelectLina()

--	Tutorial:SelectHero( "npc_dota_hero_lina" )

	self._ItemBuildName = "lina_assist_game_item_build"

	self._vItemBuild[1] = { [1] = "item_tango" }
	self._vItemBuild[2] = { [1] = "item_flask" }
	self._vItemBuild[3] = { [1] = "item_circlet" }
	self._vItemBuild[4] = { [1] = "item_gauntlets" }

	self._vItemBuild[5] = { [1] = "item_phase_boots", 			[2] = "item_boots", 			[3] = "item_blades_of_attack",	[4] = "item_blades_of_attack" }

	self._vItemBuild[6] = { [1] = "item_ancient_janggo", 		[2] = "item_recipe_bracer",		[3] = "item_ring_of_regen",		[4] = "item_wind_lace",			[5] = "item_recipe_ancient_janggo", [0] = "item_bracer", }
	self._vItemBuild[7] = { [1] = "item_cyclone", 				[2] = "item_wind_lace",			[3] = "item_staff_of_wizardry",	[4] = "item_void_stone",		[5] = "item_recipe_cyclone" }

	self._vItemBuild[8] = { [1] = "item_octarine_core", 		[2] = "item_point_booster", 	[3] = "item_vitality_booster", 	[4] = "item_energy_booster", 	[5] = "item_mystic_staff",  [0] = "item_soul_booster" }
	self._vItemBuild[9] = { [1] = "item_monkey_king_bar",		[2] = "item_demon_edge",		[3] = "item_javelin",			[4] = "item_javelin" }

	self._vDoubleBuyItems = { [1] = "item_blades_of_attack", [2] = "item_javelin" }

	self._nEarlyGameItemIdx = 7
	self._nEarlyGameItemStart = 5

	self._vItemDetails["item_phase_boots"] = 			{ title = "ag_detail_ItemLinaPhaseTitle", 		body = "ag_detail_ItemLinaPhaseBody",		imageClass="PhaseImage"  }
	self._vItemDetails["item_ancient_janggo"] = 		{ title = "ag_detail_ItemLinaDrumsTitle", 		body = "ag_detail_ItemLinaDrumsBody",		imageClass="DrumsImage"  }
	self._vItemDetails["item_cyclone"] = 				{ title = "ag_detail_ItemLinaCycloneTitle", 	body = "ag_detail_ItemLinaCycloneBody",		imageClass="EulsImage"  }
	self._vItemDetails["item_octarine_core"] = 			{ title = "ag_detail_ItemLinaOctarineTitle", 	body = "ag_detail_ItemLinaOctarineBody",	imageClass="OctarineImage"  }
	self._vItemDetails["item_monkey_king_bar"] = 		{ title = "ag_detail_ItemLinaMKBTitle", 		body = "ag_detail_ItemLinaMKBBody",			imageClass="MKBImage"  }

	self._vSwingHero[0] = "npc_dota_hero_sven"
	self._vSwingHero[1] = "npc_dota_hero_death_prophet"

	self._vSelectAbilityText[0] = "ag_objective_LinaUnlockAbilityTitle"
	self._vSelectAbilityText[1] = "ag_objective_LinaUnlockAbilityBody"

	self._vBuildDetails[0] = "ag_info_AbilityItemBuildLinaTitle"
	self._vBuildDetails[1] = "ag_info_AbilityItemBuildLinaBody"

	self._vSkillBuild[0] = 0
	self._vSkillBuild[1] = 1
	self._vSkillBuild[2] = 0
	self._vSkillBuild[3] = 1
	self._vSkillBuild[4] = 0
	self._vSkillBuild[5] = 3
	self._vSkillBuild[6] = 0
	self._vSkillBuild[7] = 2
	self._vSkillBuild[8] = 2
	self._vSkillBuild[9] = 1
	self._vSkillBuild[10] = 3
	self._vSkillBuild[11] = 1
	self._vSkillBuild[12] = 2
	self._vSkillBuild[13] = 2
	self._vSkillBuild[14] = -1
	self._vSkillBuild[15] = 3
	self._vSkillBuild[16] = -1
	self._vSkillBuild[17] = -1
	self._vSkillBuild[18] = -1
	self._vSkillBuild[19] = -1
	self._vSkillBuild[20] = -1
	self._vSkillBuild[21] = -1
	self._vSkillBuild[22] = -1
	self._vSkillBuild[23] = -1
	self._vSkillBuild[24] = -1

	self._vSkillBuildTxt[0] = { title = "ag_detail_BuildDragonSlaveTitle",	body = "ag_detail_BuildDragonSlaveBody",	imageClass=""  }
	self._vSkillBuildTxt[1] = { title = "ag_detail_BuildLightStrikeTitle",	body = "ag_detail_BuildLightStrikeBody",	imageClass=""  }
	self._vSkillBuildTxt[5] = { title = "ag_detail_BuildLagunaBladeTitle",	body = "ag_detail_BuildLagunaBladeBody",	imageClass=""  }
	self._vSkillBuildTxt[7] = { title = "ag_detail_BuildFireySoulTitle",	body = "ag_detail_BuildFireySoulBody",		imageClass=""  }
	self._vSkillBuildTxt[14] = { title = "ag_detail_BaseStatsTitle",		body = "ag_detail_BaseStatsBody",			imageClass=""  }
end

function CTutorialAG:_Setup()
--	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-2" )

	Tutorial:SetTutorialConvar( "dota_tutorial_prevent_start", "1" )

	Tutorial:SetTutorialConvar( "dota_bot_mode", "1" )
	Tutorial:SetTutorialConvar( "dota_bot_disable", "0" )
	Tutorial:SetTutorialConvar( "dota_bot_tutorial_boss", "0" )
--	Tutorial:SetTutorialConvar( "dota_tutorial_prevent_exp_gain", "1" )
	Tutorial:SetTutorialConvar( "dota_tutorial_percent_damage_decrease", "25" )
	Tutorial:SetTutorialConvar( "dota_tutorial_percent_bot_exp_decrease", "25" )
	Tutorial:SetTutorialConvar( "dota_tutorial_force_learn_ability", "-2" )

--	SendToServerConsole( "bind space +dota_camera_follow" )
--	SendToServerConsole( "host_writeconfig" )
	SendToServerConsole( "dota_bot_set_difficulty 0" )

	Tutorial:SelectPlayerTeam( "good" )

	if ( self._ChosenHero == 2 ) then
		self:_SelectLina()
	elseif ( self._ChosenHero == 1 ) then
		self:_SelectSven()
	else
		self:_SelectLuna()
	end

	Tutorial:SetTutorialConvar( "dota_camera_hold_select_to_follow", "1" )
	Tutorial:EnablePlayerOffscreenTip( true )
	Tutorial:EnableCreepAggroViz( true )
--	Tutorial:EnableTowerAggroViz( true )
	Tutorial:SetWhiteListEnabled( true )
	self._bWhiteListEnabled = true

--	Tutorial:SetWhiteListEnabled( true )

--	CustomUI:DynamicHud_Create( -1, "tutorial_code", "file://{resources}/layout/custom_game/tutorial_client_code.xml", {} )
--	CustomUI:DynamicHud_Create( -1, "hero_select", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", {} )

	CustomUI:DynamicHud_Create( -1, "tutorial_code", "file://{resources}/layout/custom_game/tutorial_client_code.xml", {} )
end

function CTutorialAG:_IntroducePrep()

--	Tutorial:SetTutorialConvar( "dota_camera_hold_select_to_follow", "1" )
--	Tutorial:EnablePlayerOffscreenTip( true )
--	Tutorial:EnableCreepAggroViz( true )
--	Tutorial:EnableTowerAggroViz( true )
--
--	Tutorial:SetWhiteListEnabled( true )
--	self._bWhiteListEnabled = true
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_PreGamePrepTitle", BodyTextVar = "ag_info_PreGamePrepBody" } )
end

function CTutorialAG:_IntroduceRole()
	self:SetGameFrozen( true )

	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_YourRoleTitle", BodyTextVar = "ag_info_YourRoleBody" } )

	Tutorial:AddBot( "npc_dota_hero_dazzle", "bot", "passive", true );

	Tutorial:AddBot( self._vSwingHero[0], "mid", "passive", true );

	Tutorial:AddBot( self._vSwingHero[1], "top", "passive", true );
	Tutorial:AddBot( "npc_dota_hero_crystal_maiden", "top", "passive", true );


	Tutorial:AddBot( "npc_dota_hero_nevermore", "bot", "passive", false );
	Tutorial:AddBot( "npc_dota_hero_zuus", "bot", "passive", false );

	Tutorial:AddBot( "npc_dota_hero_dragon_knight", "mid", "passive", false );

	Tutorial:AddBot( "npc_dota_hero_phantom_assassin", "top", "passive", false );
	Tutorial:AddBot( "npc_dota_hero_witch_doctor", "top", "passive", false );
end

function CTutorialAG:_IntroducePlan()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_GamePlanTitle", BodyTextVar = "ag_info_GamePlanBody" } )
end

function CTutorialAG:_IntroduceBuild()

	Tutorial:SetItemGuide( self._ItemBuildName )

	self:_AdvanceAbilityBuild()

	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = self._vBuildDetails[0], BodyTextVar = self._vBuildDetails[1] } )
end

function CTutorialAG:_QuestChooseAbility()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = self._vSelectAbilityText[0], BodyTextVar = self._vSelectAbilityText[1] } )
end

function CTutorialAG:_CompleteChooseAbility()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = self._vSelectAbilityText[0], BodyTextVar = self._vSelectAbilityText[1] } )
end

--function CTutorialAG:_IntroduceItemBuild()
--	self:SetGameFrozen( true )
--	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
--	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_ItemBuildLunaTitle", BodyTextVar = "ag_info_ItemBuildLunaBody" } )
--end

function CTutorialAG:_QuestBuyItems()
--	print("buy items quest started!!")
	self:_AdvanceItemBuild()
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "ag_objective_BuyItemsTitle", BodyTextVar = "ag_objective_BuyItemsBody" } )
end

function CTutorialAG:_QuestBuyItems2()
	print("second buy quest")
end

function CTutorialAG:_CompleteBuyItems()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "ag_objective_BuyItemsTitle", BodyTextVar = "ag_objective_BuyItemsBody" } )
end

function CTutorialAG:_IntroduceLane()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_LaningTitle", BodyTextVar = "ag_info_LaningBody" } )
end

function CTutorialAG:_QuestMoveToLane()
	self:SetGameFrozen( false )
	Tutorial:SetShopOpen( false )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	Tutorial:CreateLocationTask( Vector(-3634, -6127, 517 ) )
	EmitGlobalSound("ui.npe_objective_given")
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "ag_objective_MoveToLaneTitle", BodyTextVar = "ag_objective_MoveToLaneBody" } )
end

function CTutorialAG:_CompleteMoveToLane()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "ag_objective_MoveToLaneTitle", BodyTextVar = "ag_objective_MoveToLaneBody" } )
end

function CTutorialAG:_IntroduceLaning()
	self:SetGameFrozen( true )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank.xml", { TitleTextVar = "ag_info_LaningIntroTitle", BodyTextVar = "ag_info_LaningIntroBody" } )
end

function CTutorialAG:_StartGame()
	print("starting game")
	EmitGlobalSound( "GameStart.RadiantAncient" )
	self._bGameStarted = true
	self:SetGameFrozen( false )
	Tutorial:ForceGameStart()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
end

function CTutorialAG:_QuestLastHits()
	EmitGlobalSound("ui.npe_objective_given")
	local progressText = self:_FormatProgessText( self._nLastHits, self._nLastHitGoal )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective_progress.xml", { TitleTextVar = "ag_objective_GetLastHitsTitle", BodyTextVar = "ag_objective_GetLastHitsBody", ProgressTextVar = progressText } )
	Tutorial:AddShopWhitelistItem( "item_tpscroll" )
end

function CTutorialAG:_CompleteLastHits()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "ag_objective_GetLastHitsTitle", BodyTextVar = "ag_objective_GetLastHitsBody" } )
end
	

function CTutorialAG:_IntroduceCoreItems()
	self:SetGameFrozen( true )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank_pausing.xml", { TitleTextVar = "ag_info_CoreItemsTitle", BodyTextVar = "ag_info_CoreItemsBody" } )
	self:_QueueInfoFadeIn()
end

function CTutorialAG:_QuestCoreItems()
	self:_SetPlayerInvulnerability( false )
	EmitGlobalSound("ui.npe_objective_given")
	self:SetGameFrozen( false )
	local progressText = self:_FormatProgessText( self._nItemIndex - self._nEarlyGameItemStart, 1 + ( self._nEarlyGameItemIdx - self._nEarlyGameItemStart ) )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective_progress.xml", { TitleTextVar = "ag_objective_BuyEarlyItemsTitle", BodyTextVar = "ag_objective_BuyEarlyItemsBody", ProgressTextVar = progressText } )
end

function CTutorialAG:_CompleteCoreItems()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "ag_objective_BuyEarlyItemsTitle", BodyTextVar = "ag_objective_BuyEarlyItemsBody" } )
end

function CTutorialAG:_IntroduceObjectives()
	self:SetGameFrozen( true )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank_pausing.xml", { TitleTextVar = "ag_info_TakeObjectivesTitle", BodyTextVar = "ag_info_TakeObjectivesBody" } )
	self:_QueueInfoFadeIn()
end

function CTutorialAG:_QuestTakeTowers()
	self:_SetPlayerInvulnerability( false )
	self:SetGameFrozen( false )
	self._nMinDifficulty = 1
	GameRules:GetGameModeEntity():SetBotsMaxPushTier( 1 )
	GameRules:GetGameModeEntity():SetBotsInLateGame( true )
	GameRules:GetGameModeEntity():SetBotsAlwaysPushWithHuman( true )

	EmitGlobalSound("ui.npe_objective_given")

	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	local progressText = self:_FormatProgessText( self._nTowersKilledGood, self._nTowersKilledGoal )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective_progress.xml", { TitleTextVar = "ag_objective_TakeTowersTitle", BodyTextVar = "ag_objective_TakeTowersBody", ProgressTextVar = progressText } )
end

function CTutorialAG:_CompleteTakeTowers()
	EmitGlobalSound("Tutorial.TaskProgress")
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective_completed", "file://{resources}/layout/custom_game/tutorial_objective_completed.xml", { TitleTextVar = "ag_objective_TakeTowersTitle", BodyTextVar = "ag_objective_TakeTowersBody" } )
end

function CTutorialAG:_IntroduceHighground()
	self:SetGameFrozen( true )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective_completed" )
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_blank_pausing.xml", { TitleTextVar = "ag_info_HighgroundTitle", BodyTextVar = "ag_info_HighgroundBody" } )
	self:_QueueInfoFadeIn()
end

function CTutorialAG:_QuestBreakBase()
	self:_SetPlayerInvulnerability( false )
	self:SetGameFrozen( false )
	self._nMinDifficulty = 1
	GameRules:GetGameModeEntity():SetBotsInLateGame( true )
	CustomUI:DynamicHud_Destroy( -1, "tutorial_info" )
	CustomUI:DynamicHud_Create( -1, "tutorial_objective", "file://{resources}/layout/custom_game/tutorial_objective.xml", { TitleTextVar = "ag_objective_DestroyAncientTitle", BodyTextVar = "ag_objective_DestroyAncientBody" } )
end

function CTutorialAG:_EndTutorial()
	CustomUI:DynamicHud_Destroy( -1, "tutorial_objective" )
	Tutorial:EnablePlayerOffscreenTip( false )
end

function CTutorialAG:_VictoryTip()
	CustomUI:DynamicHud_Create( -1, "tutorial_info", "file://{resources}/layout/custom_game/tutorial_dialog_endgame.xml", { TitleTextVar = "ag_info_VictoryTitle", BodyTextVar = "ag_info_VictoryBody" } )
end