require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )


--------------------------------------------------------------------------------

if CMapEncounter_MortyLeaping == nil then
	CMapEncounter_MortyLeaping = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	LinkLuaModifier( "modifier_morty_start_passive", "modifiers/creatures/modifier_morty_start_passive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_ride_morty", "modifiers/modifier_ride_morty", LUA_MODIFIER_MOTION_BOTH )

	self.nGoldPerBag = 50 -- 2020 version (in Act 1) was 25
	self.flMortyTimeLimit = 45.0

	self:AddSpawner( CDotaSpawner( "morty_spawner", "morty_spawner",
		{ 
			{
				EntityName = "npc_aghsfort_morty",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit.vpcf", context )
	PrecacheResource( "particle", "particles/dev/library/base_follow_absorigin_continuous.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:GetPreviewUnit()
	return "npc_aghsfort_morty"
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:InitializeObjectives()
	self:AddEncounterObjective( "objective_saddle_up_on_morty", 0, 4 )
	self:AddEncounterObjective( "objective_jump_to_collect_gold", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:Start()
	CMapEncounter_BonusBase.Start( self )

	self.nAbilityListener = ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( getclass( self ), "OnNonPlayerUsedAbility" ), self )

	self.flEndTime = 99999999999999999
	self.Morties = {}

	local hUnits = self:GetSpawner( "morty_spawner" ):SpawnUnits()
	local nPlayerID = 0
	for _,hMorty in pairs ( hUnits ) do
		
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end

		hMorty:SetControllableByPlayer( nPlayerID, true )
		hMorty:SetOwner( hPlayerHero )
		local hBuff = hMorty:AddNewModifier( hMorty, nil, "modifier_morty_start_passive", {} )
		if hBuff then
			hBuff.Encounter = self
		end

		local kv = 
		{
			min_x = self:GetRoom():GetMins().x + 1000,
			min_y = self:GetRoom():GetMins().y + 2500,
			max_x = self:GetRoom():GetMaxs().x - 3500,
			max_y = self:GetRoom():GetMaxs().y - 550,
		}
		-- Removing this for now - the leash is preventing him from moving at all?
		-- Room dimensions are 13056 x 4672
		--hMorty:AddNewModifier( hMorty, nil, "modifier_morty_leash", kv )

		table.insert( self.Morties, hMorty )
		
		hMorty.nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/gameplay/location_hint_goal.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer( nPlayerID ) )
		ParticleManager:SetParticleControl( hMorty.nFXIndex, 0, hMorty:GetAbsOrigin() )
		ParticleManager:SetParticleControl( hMorty.nFXIndex, 1, Vector( 1.0, 0.8, 0.2 ) )

		local vLocation = hMorty:GetAbsOrigin()
		local WorldTextHint = {}
		WorldTextHint["hint_text"] = "hint_ride_morty"
		WorldTextHint["command"] = 18 -- DOTA_KEYBIND_HERO_MOVE
		WorldTextHint["ent_index"] = -1
		WorldTextHint["location_x"] = vLocation.x
		WorldTextHint["location_y"] = vLocation.y
		WorldTextHint["location_z"] = vLocation.z

		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "start_world_text_hint", WorldTextHint )

		nPlayerID = nPlayerID + 1
	end

	self.nGoldForBags = self.nGoldReward * AGHANIM_PLAYERS
	self.nGoldReward = 0

	local hTrigger = self:GetRoom():FindAllEntitiesInRoomByName( "gold_bag_trigger", false )
	if hTrigger[ 1 ] then
		local vMins = hTrigger[ 1 ]:GetBoundingMins()
		local vMaxs = hTrigger[ 1 ]:GetBoundingMaxs()
		vMins = hTrigger[ 1 ]:TransformPointEntityToWorld( vMins )
		vMaxs = hTrigger[ 1 ]:TransformPointEntityToWorld( vMaxs )

		local flMinHeight = 0
		local flMaxHeight = 128

		self.GoldBags = {}
		for i=1,300 do
			local flHeight = flMinHeight
			local nHigh = math.random( 0, 1 )
			if nHigh == 1 then
				flHeight = flMaxHeight
			end

			local vGoldBagPos = Vector( RandomFloat( vMins.x, vMaxs.x ), RandomFloat( vMins.y, vMaxs.y ), vMins.z )
	 		self.nGoldForBags = self.nGoldForBags - self.nGoldPerBag

			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	 		newItem:SetPurchaseTime( 0 )
	 		newItem:SetCurrentCharges( self.nGoldPerBag )

	 		-- Bump the height up by a constant amount over the ground minimally
	 		-- NOTE: We don't have to take flGroundHeight into account here
	 		-- because CreateItemOnPositionSync will automatically drop to ground
	 		flHeight = flHeight + 128

	 		-- NOTE: CreateItemOnPositionSync will drop the item to the ground, 
	 		-- so the z height is going to be ignored 
	 		-- However, LaunchLootRequiredHeight will fix it back up for us. 
	 		local drop = CreateItemOnPositionSync( vGoldBagPos, newItem )
	 		drop:SetModelScale( 1.5 )
	 		newItem:LaunchLootRequiredHeight( true, flHeight, flHeight, 0.75, vGoldBagPos )
	 		table.insert( self.GoldBags, newItem )
		end
	else
		print( "trigger not found" )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:OnThink()
	CMapEncounter_BonusBase.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:OnPlayerRideMorty( nPlayerID, hMorty )
	ParticleManager:DestroyParticle( hMorty.nFXIndex, true )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "stop_world_text_hint", {} )

	PlayerResource:SetCameraTarget( nPlayerID, hMorty )
	PlayerResource:SetOverrideSelectionEntity( nPlayerID, hMorty )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "objective_saddle_up_on_morty" )
	local nSaddledPlayers = nCurrentValue + 1
	self:UpdateEncounterObjective( "objective_saddle_up_on_morty", nSaddledPlayers, nil )

	local nPlayerCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
		end
	end

	if nSaddledPlayers >= nPlayerCount  then
		self:StartBonusRound( self.flMortyTimeLimit )
		for _,hMorty in pairs ( self.Morties ) do
			hMorty:RemoveModifierByName( "modifier_morty_start_passive" )

			local vLocation = hMorty:GetAbsOrigin()
			local WorldTextHint = {}
			WorldTextHint["hint_text"] = "hint_hop_with_morty"
			WorldTextHint["command"] = 53 -- DOTA_KEYBIND_ABILITY_PRIMARY1
			WorldTextHint["ent_index"] = -1
			WorldTextHint["location_x"] = vLocation.x
			WorldTextHint["location_y"] = vLocation.y
			WorldTextHint["location_z"] = vLocation.z
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( hMorty:GetPlayerOwnerID() ), "start_world_text_hint", WorldTextHint )
		end

		EmitGlobalSound( "BonusRoom.ParadeMusicLoop" )
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_MortyLeaping:OnComplete()
	CMapEncounter_BonusBase.OnComplete( self )

	StopListeningToGameEvent( self.nAbilityListener )
	StopListeningToGameEvent( self.nItemPickedUpListener )
	
	for _,hMorty in pairs ( self.Morties ) do
		hMorty:SetControllableByPlayer( -1, true )
		hMorty:SetOwner( nil )
	end

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
			hHero:RemoveModifierByName( "modifier_ride_morty" )
			
			PlayerResource:SetCameraTarget( nPlayerID, nil )
			PlayerResource:SetOverrideSelectionEntity( nPlayerID, nil )

			local hEndPosition = self:GetRoom():FindAllEntitiesInRoomByName( "bonus_room_end_position", true )
			FindClearSpaceForUnit( hHero, hEndPosition[1]:GetAbsOrigin(), true )
 			CenterCameraOnUnit( nPlayerID, hHero )
		end
	end

	for _,GoldBag in pairs ( self.GoldBags ) do
		if GoldBag and not GoldBag:IsNull() then
			UTIL_Remove( GoldBag:GetContainer() )
			UTIL_Remove( GoldBag )
		end
	end

	StopGlobalSound( "BonusRoom.ParadeMusicLoop" )
end

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------

function CMapEncounter_MortyLeaping:OnNonPlayerUsedAbility( event )
	local szAbilityName = event.abilityname
	local hCaster = EntIndexToHScript( event.caster_entindex )
	if hCaster and szAbilityName == "morty_hop" then
		for _,hMorty in pairs ( self.Morties ) do
			if hMorty == hCaster then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( hMorty:GetPlayerOwnerID() ), "stop_world_text_hint", {} )
				break
			end
		end
	end
end

-----------------------------------------

return CMapEncounter_MortyLeaping
