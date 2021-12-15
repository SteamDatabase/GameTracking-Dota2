
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

LinkLuaModifier( "modifier_mango_orchard_mute", "modifiers/modifier_mango_orchard_mute", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CMapEncounter_Bonus_MangoOrchard == nil then
	CMapEncounter_Bonus_MangoOrchard = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	self:AddSpawner( CDotaSpawner( "morty_spawner", "morty_spawner",
		{ 
			{
				EntityName = "npc_aghsfort_morty_mango_orchard",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	self:AddSpawner( CDotaSpawner( "spawner_farmer", "spawner_farmer",
		{ 
			{
				EntityName = "npc_dota_creature_ogre_tank_mango_farmer",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

	

	self.flMangoInterval = 4.0
	self.nTreesPerInterval = 1
	self.flNextMangoTime = -1
	self.hMorties = {}
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )

	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )
	PrecacheResource( "model", "models/props_tree/mango_tree.vmdl", context )

	PrecacheResource( "model", "models/heroes/snapfire/snapfire_customgame.vmdl", context )
	PrecacheResource( "model", "models/heroes/snapfire/snapfire_mount.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/gold_bag_2_bag.vmdl", context )
	PrecacheResource( "particle", "particles/creatures/mango_orchard_mango_linear.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", context )
	PrecacheResource( "particle", "particles/dev/library/base_follow_absorigin_continuous.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )

	PrecacheUnitByNameSync( "npc_aghsfort_morty_mango_orchard", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:GetPreviewUnit()
	return "npc_aghsfort_morty_mango_orchard"
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )

	local hTreeSpawnPoints = self:GetRoom():FindAllEntitiesInRoomByName( "mango_tree_spawner", true )
	local nTreesToSpawn = math.ceil( #hTreeSpawnPoints * 0.75 )

	self.MangoTrees = {}
	
	for i = 1, nTreesToSpawn do 
		local nIndex = self:RoomRandomInt( 1, #hTreeSpawnPoints )
		local hTree = SpawnMangoTree( hTreeSpawnPoints[nIndex]:GetAbsOrigin(), DOTA_TEAM_GOODGUYS, 9999, 99999, 0 )
		table.insert( self.MangoTrees, hTree )
		table.remove( hTreeSpawnPoints, nIndex )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:InitializeObjectives()
	self:AddEncounterObjective( "objective_step_on_the_button", 0, 0 )
	self:AddEncounterObjective( "objective_feed_the_morties_mangoes", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:Start()
	CMapEncounter_BonusBase.Start( self )

	self.hMorties = self:GetSpawner( "morty_spawner" ):SpawnUnits()
	self.hFarmers = self:GetSpawner( "spawner_farmer" ):SpawnUnits()

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do 
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end
	end
	
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:StartBonusRound( flDuration )
	CMapEncounter_BonusBase.StartBonusRound( self, flDuration )

	self.nGoodViewer = AddFOWViewer( DOTA_TEAM_GOODGUYS, Vector( -3584, 13563, 640 ), 700, flDuration, false )
	self.nBadViewer = AddFOWViewer( DOTA_TEAM_BADGUYS, Vector( -3584, 13563, 640 ), 2500, flDuration, false )
	self.nEntityHurtEvent = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( getclass( self ), 'OnEntityHurt' ), self ) 

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			local kv = {}
			kv[ "silence" ] = false 
			kv[ "duration" ] = -1
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_aghsfort_player_transform", kv )
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_mango_orchard_mute", kv )
			hPlayerHero:RemoveModifierByName( "modifier_bonus_room_start" )
			hPlayerHero.hMangoOrchardHiddenAbilities = {}
			local hSlot0Ability = nil
			for i = 0,DOTA_MAX_ABILITIES-1 do
				local hAbility = hPlayerHero:GetAbilityByIndex( i )
				if hAbility and not hAbility:IsCosmetic( nil ) and not hAbility:IsAttributeBonus() and hAbility:GetAssociatedPrimaryAbilities() == nil and not hAbility:IsHidden() and hAbility:IsActivated() then
					hAbility:SetHidden( true )
					hAbility:SetActivated( false )
					if i == 0 then 
						hSlot0Ability = hAbility 
					end

					table.insert( hPlayerHero.hMangoOrchardHiddenAbilities, hAbility )
				end
			end

			if hSlot0Ability then 
				local hTossMangoAbility = hPlayerHero:AddAbility( "mango_orchard_toss_mango" )
				if hTossMangoAbility then
					hPlayerHero:SwapAbilities( hSlot0Ability:GetAbilityName(), hTossMangoAbility:GetAbilityName(), false, true )
					hTossMangoAbility:UpgradeAbility( true )
					hTossMangoAbility:SetActivated( true )
					hTossMangoAbility:SetCurrentAbilityCharges( 0 )
					hTossMangoAbility.hOriginalAbility = hSlot0Ability
				end
			end
		end
	end

	for _,hFarmer in pairs ( self.hFarmers ) do 
		hFarmer.bBonusActive = true
	end

	self:SpawnMangoes()
	self:SpawnMangoes()
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:OnThink()
	CMapEncounter_BonusBase.OnThink( self )

	if not GameRules:IsGamePaused() and self.bGameStarted and GameRules:GetGameTime() > self.flNextMangoTime then
		self.flNextMangoTime = self.flNextMangoTime + self.flMangoInterval
		self:SpawnMangoes()	
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:SpawnMangoes()
	local nNumMangoes = self.nTreesPerInterval
	while nNumMangoes > 0 do 
		local nIndex = self:RoomRandomInt( 1, #self.MangoTrees )
		local hTree = self.MangoTrees[ nIndex ]
		if hTree and hTree:IsNull() == false then 
			local newItem = CreateItem( "item_mango_orchard_mango", nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( 1 )
				
			local drop = CreateItemOnPositionSync( hTree:GetAbsOrigin(), newItem )
			local dropTarget = FindPathablePositionNearby( hTree:GetAbsOrigin(), 50, 250 )
			newItem:LaunchLootInitialHeight( true, 128, 256, 0.75, dropTarget )
			
		end
		nNumMangoes = nNumMangoes - 1
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:OnComplete()
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			local hTossMangoAbility = hPlayerHero:GetAbilityByIndex( 0 )
			if hTossMangoAbility:GetAbilityName() ~= "mango_orchard_toss_mango" then 
				print( "WARNING	!  Got the wrong ability in index 0" )
			end

			local hOriginalAbility = hTossMangoAbility.hOriginalAbility
			if hOriginalAbility and hTossMangoAbility then 
				hPlayerHero:SwapAbilities( hOriginalAbility:GetAbilityName(), hTossMangoAbility:GetAbilityName(), true, false )
				hPlayerHero:RemoveAbilityFromIndexByName( "mango_orchard_toss_mango" )

			end

			if hPlayerHero.hMangoOrchardHiddenAbilities then
				for _, hAbility in pairs ( hPlayerHero.hMangoOrchardHiddenAbilities ) do 
					hAbility:SetHidden( false )
					hAbility:SetActivated( true )	
				end
			end

			hPlayerHero:RemoveModifierByName( "modifier_aghsfort_player_transform" )
			hPlayerHero:RemoveModifierByName( "modifier_mango_orchard_mute" )
			hPlayerHero:RemoveModifierByName( "modifier_bonus_room_start" )
		end
	end

	for _,hTree in pairs ( self.MangoTrees ) do
		--hTree:CutDown( DOTA_TEAM_GOODGUYS )
	end

	for _,item in pairs( Entities:FindAllByClassname( "dota_item_drop" ) ) do
		local containedItem = item:GetContainedItem()
		if containedItem and containedItem:GetAbilityName() == "item_mango_orchard_mango" then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
			ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			
			UTIL_RemoveImmediate( containedItem )
			UTIL_RemoveImmediate( item )
		end
	end

	for _,hMorty in pairs( self.hMorties ) do
		hMorty:AddEffects( EF_NODRAW )
		hMorty:ForceKill( false )
	end

	StopGlobalSound( "BonusRoom.ChaseMusicLoop" )

	CMapEncounter_BonusBase.OnComplete( self )

	if self.nGoodViewer ~= nil then 
		RemoveFOWViewer( DOTA_TEAM_GOODGUYS, self.nGoodViewer )
	end
	if self.nBadViewer ~= nil then 
		RemoveFOWViewer( DOTA_TEAM_BADGUYS, self.nBadViewer )
	end

	if self.nEntityHurtEvent ~= nil then
		StopListeningToGameEvent( self.nEntityHurtEvent )
	end

	local hRelays
	hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "exit_gate_relay", false )
	for _, hRelay in pairs( hRelays ) do
		print( 'FOUND RELAY! Triggering!' )
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:OnTriggerStartTouch( event )
	CMapEncounter_BonusBase.OnTriggerStartTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )

	if self.bGameStarted == false and szTriggerName == "trigger_start_round" then
		
		self:StartBonusRound( 60.0 )

		EmitGlobalSound( "BonusRoom.ChaseMusicLoop" )
	end
end


--------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------

function CMapEncounter_Bonus_MangoOrchard:OnEntityHurt( event )
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim == nil or hVictim:IsRealHero() == false then
		return
	end

	local hAttacker = nil 
	if event.entindex_attacker ~= nil then
		hAttacker = EntIndexToHScript( event.entindex_attacker )
	end

	if hAttacker == nil or hAttacker:IsNull() or hAttacker:GetUnitName() ~= "npc_dota_creature_ogre_tank_mango_farmer" then 
		return 
	end

	local hTossMangoAbility = hVictim:FindAbilityByName( "mango_orchard_toss_mango" ) 
	if hTossMangoAbility == nil then 
		return 
	end

	local nNumMangoes = hTossMangoAbility:GetCurrentAbilityCharges()
	if nNumMangoes <= 0 then 
		return 
	end

	for i = 1, nNumMangoes do 
		local newItem = CreateItem( "item_mango_orchard_mango", nil, nil )
		newItem:SetPurchaseTime( 0 )
		newItem:SetCurrentCharges( 1 )
			
		local drop = CreateItemOnPositionSync( hVictim:GetAbsOrigin(), newItem )
		local dropTarget = FindPathablePositionNearby( hVictim:GetAbsOrigin(), 200, 400 )
		newItem:LaunchLoot( true, 256, 0.75, dropTarget )
	end

	hTossMangoAbility:SetCurrentAbilityCharges( 0 )
end

---------------------------------------------------------------------------

return CMapEncounter_Bonus_MangoOrchard
