
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_PenguinSledding == nil then
	CMapEncounter_PenguinSledding = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	self.flPenguinTimeLimit = 55.0
	self:AddSpawner( CDotaSpawner( "penguin_spawner", "penguin_spawner",
		{ 
			{
				EntityName = "npc_dota_sled_penguin",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )

	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_wandering_ogre_seal", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:GetPreviewUnit()
	return "npc_dota_sled_penguin"
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )

end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:InitializeObjectives()
	self:AddEncounterObjective( "objective_saddle_up_on_penguin", 0, 4 )
	self:AddEncounterObjective( "objective_sled_to_collect_gold", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:Start()
	CMapEncounter_BonusBase.Start( self )

	if not IsServer() then
		return
	end

	self.flEndTime = 99999999999999999

	local hUnits = self:GetSpawner( "penguin_spawner" ):SpawnUnits()

	self.Penguins = {}

	local hFacingTargets = self:GetRoom():FindAllEntitiesInRoomByName( "penguin_facing_target", true )
	local hFacingTarget = hFacingTargets[ 1 ]

	local nPlayerID = 0
	for _, hPenguin in pairs ( hUnits ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end

		hPenguin.Encounter = self
		hPenguin:SetOwner( hPlayerHero )

		hPenguin:FaceTowards( hFacingTarget:GetAbsOrigin() )

		hPenguin.nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/gameplay/location_hint_goal.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer( nPlayerID ) )
		local vArrowFXPos = hPenguin:GetAbsOrigin()
		ParticleManager:SetParticleControl( hPenguin.nFXIndex, 0, vArrowFXPos )
		ParticleManager:SetParticleControl( hPenguin.nFXIndex, 1, Vector( 1.0, 0.8, 0.2 ) )

		local vLocation = hPenguin:GetAbsOrigin()
		local WorldTextHint = {}
		WorldTextHint["hint_text"] = "hint_ride_penguin"
		WorldTextHint["command"] = 18 -- DOTA_KEYBIND_HERO_MOVE
		WorldTextHint["ent_index"] = -1
		WorldTextHint["location_x"] = vLocation.x
		WorldTextHint["location_y"] = vLocation.y
		WorldTextHint["location_z"] = vLocation.z

		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "start_world_text_hint", WorldTextHint )

		table.insert( self.Penguins, hPenguin )
		nPlayerID = nPlayerID + 1
	end

	self.fCoinPileCreationInterval = 0.5
	self.fNextCoinPileSpawn = GameRules:GetGameTime() + self.fCoinPileCreationInterval

	local nTotalGold = 5000 -- this is probably not needed since we have the self.nGoldForBags value
	self.nTotalGoldBagsToSpawn = 475
	self.nGoldPerBag = nTotalGold / self.nTotalGoldBagsToSpawn
	--printf( "Start - self.nGoldPerBag: %d", self.nGoldPerBag )
	self.nGoldForBags = self.nGoldReward * AGHANIM_PLAYERS
	--printf( "Start - self.nGoldForBags: %d", self.nGoldForBags )
	self.nGoldReward = 0
	self.nMinCoinsPerTarget = 8
	self.nMaxCoinsPerTarget = 8

	self.nPreplacedBagsToSpawn = self.nTotalGoldBagsToSpawn / 3

	self.GoldBags = {}

	self.hPreplacedBagTargets = self:GetRoom():FindAllEntitiesInRoomByName( "gold_bag_target_preplaced", true )

	self.hDynamicBagTargets = self:GetRoom():FindAllEntitiesInRoomByName( "gold_bag_target", true )
	--printf( "#self.hDynamicBagTargets: %d", #self.hDynamicBagTargets )

	for _, hBagTarget in pairs( self.hPreplacedBagTargets ) do
		local nCoinSpawnsPerTarget = RandomInt( self.nMinCoinsPerTarget, self.nMaxCoinsPerTarget )
		for i = 1, nCoinSpawnsPerTarget do
	 		if TableLength( self.GoldBags ) >= self.nPreplacedBagsToSpawn then
	 			break
	 		end

			local vGoldBagPos = self:GetValidCoinSpawnPos( hBagTarget )
	 		self.nGoldForBags = self.nGoldForBags - self.nGoldPerBag

			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
	 		newItem:SetPurchaseTime( 0 )
	 		newItem:SetCurrentCharges( self.nGoldPerBag )

	 		-- NOTE: CreateItemOnPositionSync will drop the item to the ground, so the z height is going to be ignored 
	 		-- 	However, LaunchLootRequiredHeight will fix it back up for us.
	 		local drop = CreateItemOnPositionSync( vGoldBagPos, newItem )
	 		--drop:SetModelScale( 1.5 )
	 		local fHeight = 0
	 		newItem:LaunchLootRequiredHeight( true, fHeight, fHeight, 0.75, vGoldBagPos )
	 		table.insert( self.GoldBags, newItem )
		end
	end

	--printf( "[preplaced] total gold bags: %d", #self.GoldBags )

	-- Create wandering ogre seals
	self.hOgreSeals = {}
	self.hOgreSealSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "ogre_seal", true )
	--printf( "#self.hOgreSealSpawners: %d", #self.hOgreSealSpawners )

	local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
	local nTotalOgreSealsToSpawn = 7 + ( 2 * nAscLevel )
	--printf( "nTotalOgreSealsToSpawn: %d", nTotalOgreSealsToSpawn )

	for i = 1, nTotalOgreSealsToSpawn do
		if #self.hOgreSealSpawners > 0 then
			local nRandomIndex = RandomInt( 1, #self.hOgreSealSpawners )
			local hRandomOgreSealSpawner = self.hOgreSealSpawners[ nRandomIndex ]

			local vSpawnPos = hRandomOgreSealSpawner:GetAbsOrigin()
			local hOgreSeal = CreateUnitByName( "npc_dota_creature_wandering_ogre_seal", vSpawnPos, true, nil, nil, DOTA_TEAM_BADGUYS )
			if hOgreSeal ~= nil then
				table.insert( self.hOgreSeals, hOgreSeal )
				table.remove( self.hOgreSealSpawners, nRandomIndex )
			end
		else
			printf( "WARNING - self.hOgreSealSpawners is empty, can't spawn more seals" )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:OnThink()
	CMapEncounter_BonusBase.OnThink( self )

	if not IsServer() or GameRules:IsGamePaused() then
		return
	end

	if not self.bGameStarted then
		return
	end

	if self.bGameStarted and not self.bStartedMusic then
		EmitGlobalSound( "BonusRoom.ParadeMusicLoop" )
		self.bStartedMusic = true
	end

	if self:HasStarted() and not self:IsComplete() then
 		if TableLength( self.GoldBags ) >= self.nTotalGoldBagsToSpawn then
 			return
 		end

		if GameRules:GetGameTime() >= self.fNextCoinPileSpawn then
			local hRandomBagTarget = self.hDynamicBagTargets[ RandomInt( 1, #self.hDynamicBagTargets ) ]
			local nCoinSpawnsPerTarget = RandomInt( self.nMinCoinsPerTarget, self.nMaxCoinsPerTarget )
			for i = 1, nCoinSpawnsPerTarget do
		 		if TableLength( self.GoldBags ) >= self.nTotalGoldBagsToSpawn then
		 			break
		 		end

				local vGoldBagPos = self:GetValidCoinSpawnPos( hRandomBagTarget )
		 		self.nGoldForBags = self.nGoldForBags - self.nGoldPerBag

				local newItem = CreateItem( "item_bag_of_gold", nil, nil )
		 		newItem:SetPurchaseTime( 0 )
		 		newItem:SetCurrentCharges( self.nGoldPerBag )

		 		-- NOTE: CreateItemOnPositionSync will drop the item to the ground, so the z height is going to be ignored 
		 		-- 	However, LaunchLootRequiredHeight will fix it back up for us.
		 		local drop = CreateItemOnPositionSync( vGoldBagPos, newItem )
		 		--drop:SetModelScale( 1.5 )
		 		local fHeight = 0
		 		newItem:LaunchLootRequiredHeight( true, fHeight, fHeight, 0.75, vGoldBagPos )
		 		table.insert( self.GoldBags, newItem )
			end
			--printf( "[dynamic] total gold bags: %d", #self.GoldBags )

			self.fNextCoinPileSpawn = GameRules:GetGameTime() + self.fCoinPileCreationInterval
		end

		--printf( "Total gold bags spawned: %d", TableLength( self.GoldBags ) )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:OnComplete()
	CMapEncounter_BonusBase.OnComplete( self )

	StopListeningToGameEvent( self.nItemPickedUpListener ) -- redundant? already done in BonusBase

	for _, hPenguin in pairs ( self.Penguins ) do
		hPenguin:SetOwner( nil )
		hPenguin:RemoveModifierByName( "modifier_sled_penguin_passive" )
	end

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
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

	for _, hOgreSeal in pairs ( self.hOgreSeals ) do
		if hOgreSeal and not hOgreSeal:IsNull() then
			UTIL_Remove( hOgreSeal )
		end
	end

	StopGlobalSound( "BonusRoom.ParadeMusicLoop" )
end

---------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:GetValidCoinSpawnPos( hBagTarget )
	local fMinOffset = 25
	local fMaxOffset = 600

	local vPos = hBagTarget:GetAbsOrigin() + RandomVector( RandomFloat( fMinOffset, fMaxOffset ) )

	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( hBagTarget:GetOrigin(), vPos ) ) and ( nAttempts < 5 ) ) do
		vPos = hBagTarget:GetOrigin() + RandomVector( fMaxOffset )
		nAttempts = nAttempts + 1

		if nAttempts >= 5 then
			vPos = hBagTarget:GetOrigin()
		end
	end

	return vPos
end

--------------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:OnPlayerRidePenguin( nPlayerID, hPenguin )
	ParticleManager:DestroyParticle( hPenguin.nFXIndex, true )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "stop_world_text_hint", {} )

	--PlayerResource:SetCameraTarget( nPlayerID, hPenguin )
	--PlayerResource:SetOverrideSelectionEntity( nPlayerID, hPenguin )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "objective_saddle_up_on_penguin" )
	local nSaddledPlayers = nCurrentValue + 1
	self:UpdateEncounterObjective( "objective_saddle_up_on_penguin", nSaddledPlayers, nil )

	local nPlayerCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
		end
	end

	if nSaddledPlayers >= nPlayerCount  then
		self:DisableBlocker()
		self:StartBonusRound( self.flPenguinTimeLimit )
	end
end

---------------------------------------------------------------------------

function CMapEncounter_PenguinSledding:DisableBlocker()
	--print("Disabling Starting Blockers!")
	-- Disable any nav blockers in the start
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "starting_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

---------------------------------------------------------------------------

return CMapEncounter_PenguinSledding
