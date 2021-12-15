require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_BonusBase == nil then
	CMapEncounter_BonusBase = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.bGameStarted = false
	self.PlayerGoldCollected = {}
	self.flEndTime = 9999999999999
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:Precache( context )
	CMapEncounter.Precache( self, context )
end
--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:GetMaxSpawnedUnitCount()
	return 0
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:Start()
	CMapEncounter.Start( self )

	self.nItemPickedUpListener = ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( getclass( self ), "OnItemPickedUp" ), self )
	self.nGoldReward = 0
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:StartBonusRound( flTimeLimit )
	EmitGlobalSound( "RoundStart" )

	self.bGameStarted = true
	self.flEndTime = GameRules:GetGameTime() + flTimeLimit
	
	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		self.PlayerGoldCollected[ nPlayerID ] = {}
		self.PlayerGoldCollected[ nPlayerID ][ "bags" ] = 0
		self.PlayerGoldCollected[ nPlayerID ][ "gold" ] = 0
	end

	local BonusStartData = {}
	BonusStartData[ "end_time" ] = self.flEndTime
	CustomNetTables:SetTableValue( "encounter_state", "bonus", self.PlayerGoldCollected )
	CustomGameEventManager:Send_ServerToAllClients( "bonus_start", BonusStartData )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:OnComplete()
	CMapEncounter.OnComplete( self )

	StopListeningToGameEvent( self.nItemPickedUpListener )

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		CenterCameraOnUnit( nPlayerID, PlayerResource:GetSelectedHeroEntity( nPlayerID ) )
	end

	CustomGameEventManager:Send_ServerToAllClients( "bonus_complete", self.PlayerGoldCollected )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusBase:CheckForCompletion()
	return GameRules:GetGameTime() > self.flEndTime
end

---------------------------------------------------------
-- dota_item_picked_up
-- * PlayerID
-- * HeroEntityIndex
-- * UnitEntityIndex (only if parent is not a hero)
-- * itemname
-- * ItemEntityIndex
---------------------------------------------------------

function CMapEncounter_BonusBase:OnItemPickedUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local hCollector = nil

	if event.HeroEntityIndex then
		hCollector = EntIndexToHScript( event.HeroEntityIndex )
	elseif event.UnitEntityIndex then
		hCollector = EntIndexToHScript( event.UnitEntityIndex )
	end

	if hCollector and item and ( item:GetAbilityName() == "item_bag_of_gold" or item:GetAbilityName() == "item_bag_of_gold2" ) then
		--printf( "hCollector name: %s", hCollector:GetUnitName() )
		--printf( "hCollector player id: %d", hCollector:GetPlayerID() )
		--printf( "self.PlayerGoldCollected table: " )
		--PrintTable( self.PlayerGoldCollected, " -- " )

		-- Don't count if Morty picks it up
		if hCollector:GetUnitName() == "npc_aghsfort_morty" then
			return
		end

		if hCollector:GetUnitName() == "npc_dota_creature_bonus_hoodwink" then
			hCollector = PlayerResource:GetSelectedHeroEntity( hCollector:GetPlayerOwnerID() )
			if hCollector == nil then
				return
			end
		end

		if not self.PlayerGoldCollected or #self.PlayerGoldCollected <= 0 then
			printf( "WARNING - self.PlayerGoldCollected is nil or empty" )
			return
		end

		--printf( "encounter name: %s", self:GetEncounter():GetName() )
		self.PlayerGoldCollected[ hCollector:GetPlayerID() ][ "bags" ] = self.PlayerGoldCollected[ hCollector:GetPlayerID() ][ "bags" ] + 1
		self.PlayerGoldCollected[ hCollector:GetPlayerID() ][ "gold" ] = self.PlayerGoldCollected[ hCollector:GetPlayerID() ][ "gold" ] + item:GetCurrentCharges()

		CustomNetTables:SetTableValue( "encounter_state", "bonus", self.PlayerGoldCollected )
	end
end

-----------------------------------------

return CMapEncounter_BonusBase
