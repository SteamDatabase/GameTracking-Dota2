--[[ addon_game_mode.lua ]]

print( "Loading addon named Dungeon." )

if CDungeon == nil then
	CDungeon = class({})
	_G.CDungeon = CDungeon
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Required .lua files, which help organize functions contained in our addon.
-- Make sure to call these beneath the mode's class creation.
------------------------------------------------------------------------------------------------------------------------------------------------------
require( "constants" ) -- require constants first
require( "utility_functions" ) -- require utility_functions early (other required files may use its functions)
require( "precache" )
require( "events" )
require( "filters" )
require( "triggers" )
require( "units/ai/ai_chaser" )
require( "zones/zones" )
require( "units/breakable_container_surprises" )
require( "units/treasure_chest_surprises" )

if GetMapName() == "ep_1" then
	require( "zones/dialog_ep_1" )
end

LinkLuaModifier( "modifier_boss_intro", "modifiers/modifier_boss_intro", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pre_teleport", "modifiers/modifier_pre_teleport", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_intro", "modifiers/modifier_boss_intro", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_command_restricted", "modifiers/modifier_command_restricted", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dialog", "modifiers/modifier_npc_dialog", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dialog_notify", "modifiers/modifier_npc_dialog_notify", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stack_count_animation_controller", "modifiers/modifier_stack_count_animation_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_techies_land_mine", "modifiers/modifier_creature_techies_land_mine", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_guardian_statue", "modifiers/modifier_temple_guardian_statue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_tank_melee_smash_thinker", "modifiers/modifier_ogre_tank_melee_smash_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_king_boss_caustic_finale", "modifiers/modifier_sand_king_boss_caustic_finale", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_juggle", "modifiers/modifier_invoker_juggle", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function Precache( context )
	GameRules.Dungeon = CDungeon()

    for _,Item in pairs( g_ItemPrecache ) do
    	PrecacheItemByNameSync( Item, context )
    end

     for _,Unit in pairs( g_UnitPrecache ) do
    	PrecacheUnitByNameAsync( Unit, function( unit ) end )
    end

     for _,Model in pairs( g_ModelPrecache ) do
    	PrecacheResource( "model", Model, context  )
    end

    for _,Particle in pairs( g_ParticlePrecache ) do
    	PrecacheResource( "particle", Particle, context  )
    end

    for _,ParticleFolder in pairs( g_ParticleFolderPrecache ) do
    	PrecacheResource( "particle_folder", ParticleFolder, context )
    end

    for _,Sound in pairs( g_SoundPrecache ) do
    	PrecacheResource( "soundfile", Sound, context )
    end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function Activate()
	GameRules.Dungeon:InitGameMode()
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:InitGameMode()
	self._GameMode = GameRules:GetGameModeEntity()

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
	GameRules:GetGameModeEntity():SetUnseenFogOfWarEnabled( true )
	if GameRules:GetGameModeEntity().SetCustomTerrainWeatherEffect ~= nil then
		GameRules:GetGameModeEntity():SetCustomTerrainWeatherEffect( "particles/test_particle/dungeon_footsteps_sand.vpcf" )
	end
	GameRules:SetCustomGameSetupTimeout( 0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetHeroSelectionTime( 30.0 )
	GameRules:SetTimeOfDay( 0.25 )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetPreGameTime( 0.0 )
	GameRules:SetPostGameTime( 45.0 )
	GameRules:SetTreeRegrowTime( 0.1 )
	GameRules:SetStartingGold( 250 )
	GameRules:SetGoldTickTime( 999999.0 )
	GameRules:SetGoldPerTick( 0 )
	GameRules:GetGameModeEntity():SetRemoveIllusionsOnDeath( true )
	GameRules:GetGameModeEntity():SetDaynightCycleDisabled( true )
	GameRules:GetGameModeEntity():SetStashPurchasingDisabled( true )
	GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled( true )
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled( true )
 	GameRules:GetGameModeEntity():DisableHudFlip( true )
 	GameRules:GetGameModeEntity():SetLoseGoldOnDeath( false )
 	GameRules:GetGameModeEntity():SetFriendlyBuildingMoveToEnabled( true )
 	GameRules:GetGameModeEntity():SetDeathOverlayDisabled( true )
 	GameRules:GetGameModeEntity():SetHudCombatEventsDisabled( true )
	GameRules:GetGameModeEntity():SetWeatherEffectsDisabled( true )
	GameRules:GetGameModeEntity():SetCameraSmoothCountOverride( 2 )
	GameRules:GetGameModeEntity():SetSelectionGoldPenaltyEnabled( false )
 	GameRules:SetCustomGameAllowHeroPickMusic(false)
 	GameRules:SetCustomGameAllowBattleMusic(false)
	GameRules:SetCustomGameAllowMusicAtGameStart(true)

	self.flItemExpireTime = 30.0
	self.bPlayerHasSpawned = false
	self.PrecachedEnemies = {}
	self.PrecachedVIPs = {}
	self.CheckpointsActivated = {}
	self.Zones = {}
	self.nUndergroundGateActivators = 0
	self.nTempleExitActivators = 0
	self.bTempleExitThinking = false
	self.nFortressExitActivators = 0
	self.bFortressExitThinking = false
	self.flVictoryTime = nil

	self.RelicsFound = {}
	self.RelicsDefinition = {}
	self:LoadRelics()

	self.ChefNotesFound = {}
	self.InvokerFound = {}

	-- Event Registration: Functions are found in dungeon_events.lua
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( CDungeon, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent( "dota_player_reconnected", Dynamic_Wrap( CDungeon, 'OnPlayerReconnected' ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDungeon, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( CDungeon, 'OnEntityKilled' ), self )
	ListenToGameEvent( "dota_player_gained_level", Dynamic_Wrap( CDungeon, "OnPlayerGainedLevel" ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( CDungeon, "OnItemPickedUp" ), self )
	ListenToGameEvent( "dota_holdout_revive_complete", Dynamic_Wrap( CDungeon, "OnPlayerRevived" ), self )
	ListenToGameEvent( "dota_buyback", Dynamic_Wrap( CDungeon, "OnPlayerBuyback" ), self )
	ListenToGameEvent( "dota_item_spawned", Dynamic_Wrap( CDungeon, "OnItemSpawned" ), self )

	

	CustomGameEventManager:RegisterListener( "dialog_complete", function(...) return self:OnDialogEnded( ... ) end )
	CustomGameEventManager:RegisterListener( "boss_fight_start", function(...) return self:OnBossFightBegin( ... ) end )
	CustomGameEventManager:RegisterListener( "scroll_clicked", function(...) return self:OnScrollClicked( ... ) end )
	CustomGameEventManager:RegisterListener( "dialog_confirm", function(...) return self:OnDialogConfirm( ... ) end )
	CustomGameEventManager:RegisterListener( "dialog_confirm_expire", function(...) return self:OnDialogConfirmExpired( ... ) end )
	CustomGameEventManager:RegisterListener( "relic_claimed", function(...) return self:OnRelicClaimed( ... ) end )

	-- Filter Registration: Functions are found in filters.lua
	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( CDungeon, "HealingFilter" ), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CDungeon, "DamageFilter" ), self )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( CDungeon, "ItemAddedToInventoryFilter" ), self )


	Convars:RegisterCommand( "dungeon_test_zone", function(...) return self:TestZone( ... ) end, "Test a zone.", 0 )

	for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		PlayerResource:SetCustomTeamAssignment( nPlayerID, DOTA_TEAM_GOODGUYS )
	end

	self:SetupZones()

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0.5 )
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if self.flVictoryTime ~= nil and GameRules:GetGameTime() > self.flVictoryTime then
			GameRules.Dungeon:OnGameFinished()
			GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
		end

		for _,Zone in pairs( self.Zones ) do
			if Zone ~= nil then
				Zone:OnThink()
			end
		end

		for i,Zone in pairs( self.Zones ) do
			if not Zone.bNoLeaderboard then
				local netTable = {}
				netTable["ZoneName"] = Zone.szName
				CustomNetTables:SetTableValue( "zone_names", string.format( "%d", i ), netTable )
			end
		end

		for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				local Hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if Hero ~= nil then
					for _,Zone in pairs( self.Zones ) do
						if Zone ~= nil and Zone:ContainsUnit( Hero ) then
							local netTable = {}
							netTable["ZoneName"] = Zone.szName
							CustomNetTables:SetTableValue( "player_zone_locations", string.format( "%d", nPlayerID ), netTable )
						end
					end
				end
			end
		end


		self:CheckForDefeat()
		self:ThinkLootExpire()
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 0.5
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ForceAssignHeroes()
	for nPlayerID = 0, ( DOTA_MAX_TEAM_PLAYERS - 1 ) do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
			local hPlayer = PlayerResource:GetPlayer( nPlayerID )
			if hPlayer and not PlayerResource:HasSelectedHero( nPlayerID ) then
				hPlayer:MakeRandomHeroSelection()
			end
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:SetupZones()
	self.Zones = {}
	--PrintTable( ZonesDefinition, "  " )
	for _,zone in pairs( ZonesDefinition ) do
		if zone ~= nil then
			print( "CDungeon:SetupZones() - Setting up zone " .. zone.szName .. " from definition." )
			local newZone = CDungeonZone()
			newZone:Init( zone )
			table.insert( self.Zones, newZone )
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:GetZoneByName( szZoneName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone.szName == szZoneName then
			return zone
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:CheckForDefeat()
	if self.bPlayerHasSpawned == false then
		return
	end

	local bAnyHeroesAlive = false
	local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:HasOwnerAbandoned() == false and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( Hero:IsAlive() or Hero:IsReincarnating() or Hero.nRespawnsRemaining >= nBUYBACK_COST )  then
			bAnyHeroesAlive = true
		end
	end

	if bAnyHeroesAlive == false then
		GameRules.Dungeon:OnGameFinished()
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ThinkLootExpire()
	if self.flItemExpireTime <= 0.0 then
		return
	end

	local flCutoffTime = GameRules:GetGameTime() - self.flItemExpireTime

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop" ) ) do
		local containedItem = item:GetContainedItem()
		if containedItem ~= nil and containedItem:GetAbilityName() ~= "item_orb_of_passage" and containedItem:GetAbilityName() ~= "item_life_rune" and containedItem.bIsRelic ~= true then
			self:ProcessItemForLootExpire( item, flCutoffTime )
		end
	end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:ProcessItemForLootExpire( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
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
--
--------------------------------------------------------------------------------
function CDungeon:HasDialog( hDialogEnt )
	if hDialogEnt == nil or hDialogEnt:IsNull() then
		return false
	end
	
	for k,v in pairs ( DialogDefinition ) do
		if k == hDialogEnt:GetUnitName() then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
function CDungeon:GetDialog( hDialogEnt )
	if self:HasDialog( hDialogEnt ) == false then
		return nil
	end

	local Dialog = DialogDefinition[hDialogEnt:GetUnitName()]
	if Dialog == nil then
		return nil
	end

	if hDialogEnt.nCurrentLine == nil then
		hDialogEnt.nCurrentLine = 1
	end

	return Dialog[hDialogEnt.nCurrentLine]
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:GetDialogLine( hDialogEnt, nLineNumber )
	if self:HasDialog( hDialogEnt ) == false then
		return nil
	end

	local Dialog = DialogDefinition[hDialogEnt:GetUnitName()]
	if Dialog == nil then
		return nil
	end

	return Dialog[nLineNumber]
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:IsQuestActive( szQuestName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone:IsQuestActive( szQuestName ) == true then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:IsQuestComplete( szQuestName )
	for _,zone in pairs( self.Zones ) do
		if zone ~= nil and zone:IsQuestComplete( szQuestName ) == true then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:TestZone( cmdName, szZoneName )
	local szTeleportEntityName = nil
	local vTeleportPos = nil
	local nZoneIndex = 0

	for i=1,#self.Zones do
		if self.Zones[i].szName == szZoneName then
			nZoneIndex = i
			szTeleportEntityName = self.Zones[i].szTeleportEntityName
			vTeleportPos = self.Zones[i].vTeleportPos
		end
	end

	local hTeleportEntity = Entities:FindByName( nil, szTeleportEntityName )
	if szTeleportEntityName == nil and vTeleportPos == nil then
		print( "CDungeon:TestZone - ERROR - No teleport position or entity defined for zone " .. szZoneName )
		return
	end

	if hTeleportEntity ~= nil then
		vTeleportPos = hTeleportEntity:GetOrigin()
	end

	local nGold = 0
	local nXP = 0
	local bCaptainSpawned = false

	for j=1,nZoneIndex do
		local Zone = self.Zones[j]
		if Zone ~= nil then
			local nQuestRewardGold = 0
			local nQuestRewardXP = 0
			for _,Quest in pairs( Zone.Quests ) do
				if Quest.RewardGold ~= nil then
					nQuestRewardGold = nQuestRewardGold + ( Quest.RewardGold )
					print( "CDungeon:TestZone - Awarding " .. Quest.RewardGold  .. " gold from quest " .. Quest.szQuestName )
				end
				if Quest.RewardXP ~= nil then
					nQuestRewardXP = nQuestRewardXP + ( Quest.RewardXP )
					print( "CDungeon:TestZone - Awarding " .. Quest.RewardXP .. " XP from quest " .. Quest.szQuestName )
				end

			end

			if Zone.nGoldRemaining ~= nil then
				nGold = nGold + ( Zone.nGoldRemaining * 0.25 ) + nQuestRewardGold
				print( "CDungeon:TestZone - Awarding " .. ( Zone.nGoldRemaining * 0.25 ) .. " gold from zone " .. Zone.szName )
			end
			if Zone.nXPRemaining ~= nil then
				nXP = nXP + ( Zone.nXPRemaining * 0.25 ) + nQuestRewardXP
				print( "CDungeon:TestZone - Awarding " .. ( Zone.nXPRemaining * 0.25 ) .. " gold from zone " .. Zone.szName )
			end

			-- For assault tests
			if Zone.szName == "darkforest_pass" and bCaptainSpawned == false then
				bCaptainSpawned = true
				local hSpawner = Entities:FindByNameNearest( "desert_outpost_teleport", Vector( 0, 0, 0 ), 99999 )
				local hUnit = CreateUnitByName( "npc_dota_radiant_captain", hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
				if hUnit ~= nil then
					hUnit.zone = self
					hUnit:RemoveAbility( "imprisoned_soldier" )
					hUnit:RemoveModifierByName( "modifier_imprisoned_soldier" )
					hUnit:RemoveModifierByName( "modifier_imprisoned_soldier_animation" )
					hUnit:AddNewModifier( hUnit, nil, "modifier_npc_dialog", { duration = -1 } )
					hUnit:Interrupt()
				end

				for i=1,10 do
					local hCreep = CreateUnitByName( "npc_dota_radiant_soldier", hSpawner:GetOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
					if hCreep ~= nil then
						hCreep.zone = self
						hCreep:RemoveAbility( "imprisoned_soldier" )
						hCreep:RemoveModifierByName( "modifier_imprisoned_soldier" )
						hCreep:RemoveModifierByName( "modifier_imprisoned_soldier_animation" )
						hCreep:Interrupt()
					end
				end
			end
		end
	end

	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer( nPlayerID ) then
			local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hHero ~= nil then
				local nXPToGive = nXP - PlayerResource:GetTotalEarnedXP( nPlayerID )
				local nGoldToGive = nGold - PlayerResource:GetTotalEarnedGold( nPlayerID )
				hHero:AddExperience( nXPToGive, DOTA_ModifyXP_Unspecified, false, false )
				PlayerResource:ModifyGold( nPlayerID, nGoldToGive, true, DOTA_ModifyGold_Unspecified )
				FindClearSpaceForUnit( hHero, vTeleportPos, true )
				PlayerResource:SetBuybackCooldownTime( nPlayerID, 0 )
				PlayerResource:SetBuybackGoldLimitTime( nPlayerID, 0 )
				PlayerResource:ResetBuybackCostTime( nPlayerID )
			end
		end
	end

	GameRules:SetUseUniversalShopMode( true )
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function CDungeon:LoadRelics()
	local ItemData = LoadKeyValues( "scripts/npc/npc_items_custom.txt" )
	if ItemData ~= nil then
		for k,v in pairs( ItemData ) do
			local nDungeonItemDef = v["DungeonItemDef"] or nil
			if nDungeonItemDef ~= nil then
				local szDungeonAction = v["DungeonAction"]
				if szDungeonAction == nil then
					print( "CDungeon:LoadRelics() - WARNING: RELIC " .. k .. " DEFINED WITHOUT CORRESPONDING EVENT ACTION" )
					szDungeonAction = szDungeonAction * szDungeonAction
				else
					print( "CDungeon:LoadRelics() - Adding Relic " .. k .. " with item def " .. nDungeonItemDef )
					local Relic = {}
					Relic["RelicName"] = k
					Relic["DungeonItemDef"] = nDungeonItemDef
					Relic["DungeonAction"] = szDungeonAction
					table.insert( self.RelicsDefinition, Relic )
				end
			end
		end
	end	
end


function CDungeon:FireDeathTaunt( killerUnit )
	if killerUnit:GetUnitName() == "npc_dota_creature_sand_king" then
		local nLine = RandomInt( 0, 4 )
		if nLine == 0 then
			EmitSoundOn( "sandking_skg_kill_01", killerUnit )
		end
		if nLine == 1 then
			EmitSoundOn( "sandking_skg_kill_02", killerUnit )
		end
		if nLine == 2 then
			EmitSoundOn( "sandking_skg_kill_06", killerUnit )
		end
		if nLine == 3 then
			EmitSoundOn( "sandking_skg_kill_08", killerUnit )
		end
		if nLine == 4 then
			EmitSoundOn( "sandking_skg_lasthit_02", killerUnit )
		end
		killerUnit.flSpeechCooldown = GameRules:GetGameTime() + 3.0
	end
end