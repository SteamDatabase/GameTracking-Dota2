
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_BonusGallery == nil then
	CMapEncounter_BonusGallery = class( {}, {}, CMapEncounter_BonusBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )

	LinkLuaModifier( "modifier_bonus_hoodwink_start_passive", "modifiers/creatures/modifier_bonus_hoodwink_start_passive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_hoodwink_passive", "modifiers/creatures/modifier_bonus_hoodwink_passive", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_hoodwink_swallow", "modifiers/modifier_bonus_hoodwink_swallow", LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_bonus_balloon_gold", "modifiers/creatures/modifier_bonus_balloon_gold", LUA_MODIFIER_MOTION_NONE )

	self.flHoodwinkTimeLimit = 60.0
	self.fBalloonCreationInterval = 2.5
	self.fMineCreationInterval = 10
	self.iGoldBalloonChance = 15
	self.iMaxBalloon = 16
	self.nCurrentBalloon = 0

	self:AddSpawner( CDotaSpawner( "hoodwink_spawner", "hoodwink_spawner",
		{ 
			{
				EntityName = "npc_dota_creature_bonus_hoodwink",
				Team = DOTA_TEAM_GOODGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
	{ 
		{
			EntityName = "npc_dota_creature_bonus_balloon",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 100.0,
		},
	} ) )

	self:AddSpawner( CDotaSpawner( "spawner_mines", "spawner_mines",
	{ 
		{
			EntityName = "npc_dota_creature_bonus_balloon_mine",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 100.0,
		},
	} ) )

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )

	PrecacheResource( "particle", "particles/gameplay/location_hint_goal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infest_cast.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/bonus_fish/bonus_fish_gold_bottom_ring.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/balloon/balloon_death_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_idle_throw.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hoodwink.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_hoodwink", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_balloon", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_bonus_balloon_mine", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:GetPreviewUnit()
	return "npc_dota_creature_bonus_hoodwink"
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:InitializeObjectives()
	self:AddEncounterObjective( "objective_saddle_up_on_hoodwink", 0, 4 )
	self:AddEncounterObjective( "objective_shoot_the_balloons", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:Start()
	CMapEncounter_BonusBase.Start( self )

	if not IsServer() then
		return
	end

	self.flEndTime = 99999999999999999

	local hUnits = self:GetSpawner( "hoodwink_spawner" ):SpawnUnits()


	--self.fBalloonCreationInterval = 4
	self.fNextBalloonSpawn = GameRules:GetGameTime() + self.fBalloonCreationInterval
	self.fNextMineSpawn = GameRules:GetGameTime() + self.fMineCreationInterval
	--self.iGoldBalloonChance = 15


	self.Hoodwinks = {}

	--local hFacingTargets = self:GetRoom():FindAllEntitiesInRoomByName( "penguin_facing_target", true )
	--local hFacingTarget = hFacingTargets[ 1 ]

	local nPlayerID = 0
	for _, hHoodwink in pairs ( hUnits ) do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end

		hHoodwink.Encounter = self
		hHoodwink:SetControllableByPlayer( nPlayerID, true )
		hHoodwink:SetOwner( hPlayerHero )


		local hBuff = hHoodwink:AddNewModifier( hHoodwink, nil, "modifier_bonus_hoodwink_start_passive", {} )
		if hBuff then
			hBuff.Encounter = self
		end

		hHoodwink:AddNewModifier( hHoodwink, nil, "modifier_bonus_hoodwink_passive", {} )

		local hAbility = hHoodwink:FindAbilityByName("hoodwink_hunters_boomerang")
		if hAbility then
			hAbility:SetActivated( true )
			hAbility:SetHidden( false )
			hAbility:UpgradeAbility( true )
		end

		--hHoodwink:FaceTowards( hFacingTarget:GetAbsOrigin() )

		hHoodwink.nFXIndex = ParticleManager:CreateParticleForPlayer( "particles/gameplay/location_hint_goal.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer( nPlayerID ) )
		local vArrowFXPos = hHoodwink:GetAbsOrigin()
		ParticleManager:SetParticleControl( hHoodwink.nFXIndex, 0, vArrowFXPos )
		ParticleManager:SetParticleControl( hHoodwink.nFXIndex, 1, Vector( 1.0, 0.8, 0.2 ) )

		local vLocation = hHoodwink:GetAbsOrigin()
		local WorldTextHint = {}
		WorldTextHint["hint_text"] = "hint_transform_into_hoodwink"
		WorldTextHint["command"] = 18 -- DOTA_KEYBIND_HERO_MOVE
		WorldTextHint["ent_index"] = -1
		WorldTextHint["location_x"] = vLocation.x
		WorldTextHint["location_y"] = vLocation.y
		WorldTextHint["location_z"] = vLocation.z

		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "start_world_text_hint", WorldTextHint )

		table.insert( self.Hoodwinks, hHoodwink )
		nPlayerID = nPlayerID + 1
	end

	self.hBalloonSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_peon", true )

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnThink()
	CMapEncounter_BonusBase.OnThink( self )

	if not IsServer() or GameRules:IsGamePaused() then
		return
	end

	if not self.bGameStarted then
		-- Force Swallow on Not Connected Players
		for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) and PlayerResource:GetConnectionState( nPlayerID ) ~= DOTA_CONNECTION_STATE_CONNECTED then
				local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				local hHoodwink = TableFindFirst( self.Hoodwinks, function( hEntity ) return hEntity:GetOwnerEntity() == hHero end )
				if hHoodwink ~= nil and hHero:HasModifier( "modifier_bonus_room_start" ) then
					self:OnHeroSwallowed( hHero, hHoodwink )
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
		if GameRules:GetGameTime() >= self.fNextBalloonSpawn then
			if self.nCurrentBalloon < self.iMaxBalloon then
				self:GetSpawner( "spawner_peon" ):SpawnUnits()
				self.fNextBalloonSpawn = GameRules:GetGameTime() + self.fBalloonCreationInterval
			end

			if GameRules:GetGameTime() >= self.fNextMineSpawn then
				self:GetSpawner( "spawner_mines" ):SpawnUnits()
				self.fNextMineSpawn = GameRules:GetGameTime() + self.fMineCreationInterval
			end
		end
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnComplete()
		CMapEncounter_BonusBase.OnComplete( self )

	StopListeningToGameEvent( self.nItemPickedUpListener )
	
	for _,hHoodwink in pairs ( self.Hoodwinks ) do
		hHoodwink:SetControllableByPlayer( -1, true )
		hHoodwink:SetOwner( nil )
	end

	for nPlayerID=0,AGHANIM_PLAYERS-1 do
		local hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hHero then
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
			hHero:RemoveModifierByName( "modifier_bonus_hoodwink_swallow" )
			
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

function CMapEncounter_BonusGallery:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner:GetSpawnerName() == "spawner_peon" then
		for _,hUnit in pairs ( hSpawnedUnits ) do
			if hUnit then
				self.nCurrentBalloon = self.nCurrentBalloon + 1
				if RandomInt(0,100) < self.iGoldBalloonChance then
					 hUnit:AddNewModifier( hUnit, nil, "modifier_bonus_balloon_gold", {} )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnEntityKilled( event )
	CMapEncounter.OnEntityKilled( self, event )

	local killedUnit = EntIndexToHScript( event.entindex_killed )
	if killedUnit == nil then
		return
	end

	if killedUnit:GetUnitName() =="npc_dota_creature_bonus_balloon" then
		--print(killedUnit:GetUnitName())
		self.nCurrentBalloon = self.nCurrentBalloon - 1
	end
end
--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnHeroSwallowed( hHero, hHoodwink )
	hHero:AddNewModifier( hHoodwink, nil, "modifier_bonus_hoodwink_swallow", {} )
	hHero:RemoveModifierByName( "modifier_bonus_room_start" )
	
	local nPlayerID = hHero:GetPlayerOwnerID()
	ParticleManager:DestroyParticle( hHoodwink.nFXIndex, true )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "stop_world_text_hint", {} )
	PlayerResource:SetOverrideSelectionEntity( nPlayerID, hHoodwink )

	local nSaddledPlayers = self:IncrementEncounterObjective( "objective_saddle_up_on_hoodwink" )

	local nPlayerCount = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS and PlayerResource:IsValidPlayerID( nPlayerID ) then
			nPlayerCount = nPlayerCount + 1
		end
	end

	if nSaddledPlayers >= nPlayerCount  then
		print("nSaddledPlayers = nPlayerCount")
		self:StartBonusRound( self.flHoodwinkTimeLimit )
		--PlayerResource:SetCameraTarget( nPlayerID, nil )
		for k, hHoodwink in pairs ( self.Hoodwinks ) do
			local name = string.format( "pier_%i", k )
			print(name)
			local hPier = Entities:FindByName( nil, name )
			if hPier ~= nil then 
				hHoodwink:SetOrigin(hPier:GetOrigin())

			end
			hHoodwink:RemoveModifierByName( "modifier_bonus_hoodwink_start_passive" )
			self:GetSpawner( "spawner_peon" ):SpawnUnits()
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_BonusGallery:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Remove rogue units before they fall out of the world
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	if szTriggerName == "rogue_unit_trigger" then
		if hUnit then
			print( "Removing rogue unit!" )
			hUnit:ForceKill( false )
		end
	end

end

---------------------------------------------------------------------------

return CMapEncounter_BonusGallery
