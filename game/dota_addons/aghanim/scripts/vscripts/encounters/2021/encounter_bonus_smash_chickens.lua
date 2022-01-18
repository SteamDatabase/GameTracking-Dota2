
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BonusSmashChickens == nil then
	CMapEncounter_BonusSmashChickens = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_bonus_ogre_passive", "modifiers/creatures/modifier_bonus_ogre_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_ogre_start_passive", "modifiers/creatures/modifier_bonus_ogre_start_passive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bonus_ogre_swallow", "modifiers/modifier_bonus_ogre_swallow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	self.flTimeLimit = 60.0

	self:AddSpawner( CDotaSpawner( "ogre_spawner", "ogre_spawner",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_ogre_tank",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_chicken_small",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 600.0,
			},
		} ) )


end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:GetPreviewUnit()
	return "npc_dota_creature_bonus_ogre_tank"
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:InitializeObjectives()
	self:AddEncounterObjective( "objective_saddle_up_on_ogre", 0, 4 )
	self:AddEncounterObjective( "objective_smash_the_chickens", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:Start()
	CMapEncounter_BonusBase.Start( self )

	if not IsServer() then
		return
	end

	self.flEndTime = 99999999999999999

	local hUnits = self:GetSpawner( "ogre_spawner" ):SpawnUnits()

	self.Ogres = {}

	local nPlayerID = 0
	for _, hOgre in pairs ( hUnits ) do

		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end

		hOgre.Encounter = self
		hOgre:SetControllableByPlayer( nPlayerID, true )
		hOgre:SetOwner( hPlayerHero )
		hOgre.nPlayerOwner = nPlayerID
		hOgre:SetSkin( nPlayerID )

		local hBuff = hOgre:AddNewModifier( hOgre, nil, "modifier_bonus_ogre_start_passive", {} )
		if hBuff then
			hBuff.Encounter = self
		end

		hOgre:AddNewModifier( hOgre, nil, "modifier_bonus_ogre_passive", {} )

		hOgre.nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/gameplay/location_hint_goal.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer( nPlayerID ) )
		local vArrowFXPos = hOgre:GetAbsOrigin()
		ParticleManager:SetParticleControl( hOgre.nFXIndex, 0, vArrowFXPos )
		ParticleManager:SetParticleControl( hOgre.nFXIndex, 1, Vector( 1.0, 0.8, 0.2 ) )

		local vLocation = hOgre:GetAbsOrigin()
		local WorldTextHint = {}
		WorldTextHint["hint_text"] = "hint_transform_into_ogre"
		WorldTextHint["command"] = 18 -- DOTA_KEYBIND_HERO_MOVE
		WorldTextHint["ent_index"] = -1
		WorldTextHint["location_x"] = vLocation.x
		WorldTextHint["location_y"] = vLocation.y
		WorldTextHint["location_z"] = vLocation.z

		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "start_world_text_hint", WorldTextHint )

		table.insert( self.Ogres, hOgre )
		nPlayerID = nPlayerID + 1
	end

	self.hChickenSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_peon", true )

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnThink()
	CMapEncounter_BonusBase.OnThink( self )

	if not IsServer() or GameRules:IsGamePaused() then
		return
	end

	if not self.bGameStarted then
		-- Force Swallow on Not Connected Players
		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetConnectionState( nPlayerID ) ~= DOTA_CONNECTION_STATE_CONNECTED then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				local hOgre = TableFindFirst( self.Ogres, function( hEntity ) return hEntity:GetOwnerEntity() == hHero end )
				if hHero ~= nil and hHero:HasModifier( "modifier_bonus_room_start" ) then
					self:OnHeroSwallowed( hHero, hOgre )
				end
			end
		end
		return
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnComplete()
		CMapEncounter_BonusBase.OnComplete( self )

	StopListeningToGameEvent( self.nItemPickedUpListener )
	
	for _,hOgre in pairs ( self.Ogres ) do
		hOgre:SetControllableByPlayer( -1, true )
		hOgre:SetOwner( nil )
		hOgre:AddEffects( EF_NODRAW )
		hOgre:ForceKill( false )
	end

	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
			hHero:RemoveModifierByName( "modifier_bonus_ogre_swallow" )
			
			PlayerResource:SetCameraTarget( nPlayerID, nil )
			PlayerResource:SetOverrideSelectionEntity( nPlayerID, nil )

			local hEndPosition = self:GetRoom():FindAllEntitiesInRoomByName( "bonus_room_end_position", true )
			FindClearSpaceForUnit( hHero, hEndPosition[1]:GetAbsOrigin(), true )
 			CenterCameraOnUnit( nPlayerID, hHero )
		end
	end

	StopGlobalSound( "BonusRoom.ParadeMusicLoop" )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnEntityKilled( event )
	CMapEncounter.OnEntityKilled( self, event )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:OnHeroSwallowed( hHero, hOgre )
	hHero:AddNewModifier( hOgre, nil, "modifier_bonus_ogre_swallow", {} )
	hHero:RemoveModifierByName( "modifier_bonus_room_start" )

	local nPlayerID = hHero:GetPlayerOwnerID()
	ParticleManager:DestroyParticle( hOgre.nFXIndex, true )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "stop_world_text_hint", {} )
	PlayerResource:SetOverrideSelectionEntity( nPlayerID, hOgre )

	local nSaddledPlayers = self:IncrementEncounterObjective( "objective_saddle_up_on_ogre" )

	local nPlayerCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
		end
	end

	if nSaddledPlayers >= nPlayerCount  then
		self:StartBonusRound( self.flTimeLimit )
	end
end

---------------------------------------------------------------------------

function CMapEncounter_BonusSmashChickens:StartBonusRound( flTimeLimit )
	CMapEncounter_BonusBase.StartBonusRound( self, flTimeLimit )

	EmitGlobalSound( "BonusRoom.ParadeMusicLoop" )

	for k, hOgre in pairs ( self.Ogres ) do
		hOgre:RemoveModifierByName( "modifier_bonus_ogre_passive" )
		hOgre:RemoveModifierByName( "modifier_bonus_ogre_start_passive" )
	end

	self:GetSpawner( "spawner_peon" ):SpawnUnits()

	local hLogicRelay = self:GetRoom():FindAllEntitiesInRoomByName( "block_stairs_relay", true )
	hLogicRelay[ 1 ]:Trigger( nil, nil )

	local hTeleportLocators = self:GetRoom():FindAllEntitiesInRoomByName( "teleport_position", true )
	if #hTeleportLocators ~= 4 then 
		print( "ERROR! didn't find enough locators" )
	end

	for i = 1, #hTeleportLocators do
		if self.Ogres[ i ] then 
			FindClearSpaceForUnit( self.Ogres[ i ], hTeleportLocators[ i ]:GetAbsOrigin(), true )
			if self.Ogres[ i ].nPlayerOwner then  
				CenterCameraOnUnit( self.Ogres[ i ].nPlayerOwner, self.Ogres[ i ] )
			end
		end
	end
end

---------------------------------------------------------------------------

return CMapEncounter_BonusSmashChickens
