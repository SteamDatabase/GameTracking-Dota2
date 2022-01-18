
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_Bonus_Hooking == nil then
	CMapEncounter_Bonus_Hooking = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )


	LinkLuaModifier( "modifier_bonus_pudge_start_passive", "modifiers/creatures/modifier_bonus_pudge_start_passive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_pudge_passive", "modifiers/creatures/modifier_bonus_pudge_passive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_pudge_swallow", "modifiers/modifier_bonus_pudge_swallow", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_fish_gold", "modifiers/creatures/modifier_bonus_fish_gold", LUA_MODIFIER_MOTION_NONE )

	self.flPudgeTimeLimit = 60.0
	self.fFishCreationInterval = 2.5
	self.fMineCreationInterval = 5
	self.iGoldFishChance = 15
	self.iMaxFish = 16
	self.nCurrentFish = 0

	self:AddSpawner( CDotaSpawner( "pudge_spawner", "pudge_spawner",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_pudge",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )


	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
	{ 
		{
			EntityName = "npc_dota_creature_bonus_fish",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 600.0,
		},
	} ) )

	self:AddSpawner( CDotaSpawner( "spawner_mines", "spawner_mines",
	{ 
		{
			EntityName = "npc_dota_creature_bonus_room_mine",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 900.0,
		},
	} ) )

end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )

	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/bonus_fish/bonus_fish_gold_bottom_ring.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_pudge", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_fish", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_room_mine", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:GetPreviewUnit()
	return "npc_dota_creature_bonus_pudge"
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:InitializeObjectives()
	self:AddEncounterObjective( "objective_saddle_up_on_pudge", 0, 4 )
	self:AddEncounterObjective( "objective_hook_the_fishes", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:Start()
	CMapEncounter_BonusBase.Start( self )

	if not IsServer() then
		return
	end

	self.flEndTime = 99999999999999999

	local hUnits = self:GetSpawner( "pudge_spawner" ):SpawnUnits()


--	self.fFishCreationInterval = 4
	self.fNextFishSpawn = GameRules:GetGameTime() + self.fFishCreationInterval
	self.fNextMineSpawn = GameRules:GetGameTime() + self.fMineCreationInterval
--	self.iGoldFishChance = 15


	self.Pudges = {}

--	local hFacingTargets = self:GetRoom():FindAllEntitiesInRoomByName( "penguin_facing_target", true )
--	local hFacingTarget = hFacingTargets[ 1 ]

	local nPlayerID = 0
	for _, hPudge in pairs ( hUnits ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end

		hPudge.Encounter = self
		hPudge:SetControllableByPlayer( nPlayerID, true )
		hPudge:SetOwner( hPlayerHero )


		local hBuff = hPudge:AddNewModifier( hPudge, nil, "modifier_bonus_pudge_start_passive", {} )
		if hBuff then
			hBuff.Encounter = self
		end

		hPudge:AddNewModifier( hPudge, nil, "modifier_bonus_pudge_passive", {} )

----		hPudge:FaceTowards( hFacingTarget:GetAbsOrigin() )
--
		hPudge.nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/gameplay/location_hint_goal.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer( nPlayerID ) )
		local vArrowFXPos = hPudge:GetAbsOrigin()
		ParticleManager:SetParticleControl( hPudge.nFXIndex, 0, vArrowFXPos )
		ParticleManager:SetParticleControl( hPudge.nFXIndex, 1, Vector( 1.0, 0.8, 0.2 ) )

		local vLocation = hPudge:GetAbsOrigin()
		local WorldTextHint = {}
		WorldTextHint["hint_text"] = "hint_get_in_his_belly"
		WorldTextHint["command"] = 18 -- DOTA_KEYBIND_HERO_MOVE
		WorldTextHint["ent_index"] = -1
		WorldTextHint["location_x"] = vLocation.x
		WorldTextHint["location_y"] = vLocation.y
		WorldTextHint["location_z"] = vLocation.z

		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "start_world_text_hint", WorldTextHint )

		table.insert( self.Pudges, hPudge )
		nPlayerID = nPlayerID + 1
	end

	self.hFishSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_peon", true )

end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:OnThink()
	CMapEncounter_BonusBase.OnThink( self )

	if not IsServer() or GameRules:IsGamePaused() then
		return
	end

	if not self.bGameStarted then
		-- Force Swallow on Not Connected Players
		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetConnectionState( nPlayerID ) ~= DOTA_CONNECTION_STATE_CONNECTED then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				local hPudge = TableFindFirst( self.Pudges, function( hEntity ) return hEntity:GetOwnerEntity() == hHero end )
				if hHero ~= nil and hHero:HasModifier( "modifier_bonus_room_start" ) then
					self:OnHeroSwallowed( hHero, hPudge )
				end
			end
		end
		return
	end

	if self.bGameStarted and not self.bStartedMusic then
		EmitGlobalSound( "BonusRoom.ParadeMusicLoop" )
		self.bStartedMusic = true
	end

	if self:HasStarted() and not self:IsComplete() then
		if GameRules:GetGameTime() >= self.fNextFishSpawn then
			if self.nCurrentFish < self.iMaxFish then
				self:GetSpawner( "spawner_peon" ):SpawnUnits()
				self.fNextFishSpawn = GameRules:GetGameTime() + self.fFishCreationInterval
			end

			if GameRules:GetGameTime() >= self.fNextMineSpawn then
				self:GetSpawner( "spawner_mines" ):SpawnUnits()
				self.fNextMineSpawn = GameRules:GetGameTime() + self.fMineCreationInterval
			end
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:OnComplete()
		CMapEncounter_BonusBase.OnComplete( self )

	StopListeningToGameEvent( self.nItemPickedUpListener )
	
	for _,hPudge in pairs ( self.Pudges ) do
		hPudge:SetControllableByPlayer( -1, true )
		hPudge:SetOwner( nil )
	end

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
			hHero:RemoveModifierByName( "modifier_bonus_pudge_swallow" )
			
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

function CMapEncounter_Bonus_Hooking:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerName() == "spawner_peon" then
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				self.nCurrentFish = self.nCurrentFish + 1
				if RandomInt(0,100) < self.iGoldFishChance then
					 hUnit:AddNewModifier( hUnit, nil, "modifier_bonus_fish_gold", {} )
				end
			end
		end
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:OnEntityKilled( event )
	CMapEncounter.OnEntityKilled( self, event )

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if killedUnit:GetUnitName() =="npc_dota_creature_bonus_fish" then
		--print(killedUnit:GetUnitName())
		self.nCurrentFish = self.nCurrentFish - 1
	end
end
--------------------------------------------------------------------------------

function CMapEncounter_Bonus_Hooking:OnHeroSwallowed( hHero, hPudge )
	hHero:AddNewModifier( hPudge, nil, "modifier_bonus_pudge_swallow", {} )
	hHero:RemoveModifierByName( "modifier_bonus_room_start" )

	local nPlayerID = hHero:GetPlayerOwnerID()
	ParticleManager:DestroyParticle( hPudge.nFXIndex, true )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "stop_world_text_hint", {} )
	PlayerResource:SetOverrideSelectionEntity( nPlayerID, hPudge )

	local nSaddledPlayers = self:IncrementEncounterObjective( "objective_saddle_up_on_pudge" )

	local nPlayerCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
		end
	end

	if nSaddledPlayers >= nPlayerCount  then
		self:StartBonusRound( self.flPudgeTimeLimit )
--		PlayerResource:SetCameraTarget( nPlayerID, nil )
		for k, hPudge in pairs ( self.Pudges ) do
			local name = string.format( "pier_%i", k )
			local hPier = Entities:FindByName( nil, name )
			if hPier ~= nil then 
				hPudge:SetOrigin(hPier:GetOrigin())

			end
			hPudge:RemoveModifierByName( "modifier_bonus_pudge_start_passive" )
			self:GetSpawner( "spawner_peon" ):SpawnUnits()
		end
	end
end


---------------------------------------------------------------------------

return CMapEncounter_Bonus_Hooking
