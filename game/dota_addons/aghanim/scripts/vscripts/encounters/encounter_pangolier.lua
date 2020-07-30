require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_bonus_base" )

--------------------------------------------------------------------------------

if CMapEncounter_Pangolier == nil then
	CMapEncounter_Pangolier = class( {}, {}, CMapEncounter_BonusBase )
end


--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:Precache( context )
	CMapEncounter_BonusBase.Precache( self, context )
	PrecacheModel( "models/heroes/pangolier/pangolier_gyroshell2.vmdl", context )
	PrecacheModel( "models/items/rattletrap/mechanised_pilgrim_cog/mechanised_pilgrim_cog.vmdl", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_pangolier", context )
	PrecacheResource( "particle",  "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", context )
	PrecacheResource( "particle",  "particles/creatures/greevil/greevil_prison_bottom_ring.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pangolier.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_obsidian_destroyer", context )
	LinkLuaModifier( "modifier_pango_bonus", "modifiers/modifier_pango_bonus", LUA_MODIFIER_MOTION_NONE )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:constructor( hRoom, szEncounterName )
	CMapEncounter_BonusBase.constructor( self, hRoom, szEncounterName )
	self.bAllButtonsReady = false
	self.nPlayersReady = 0
	self.nHeroOnTrigger1 = 0
	self.nHeroOnTrigger2 = 0
	self.nHeroOnTrigger3 = 0
	self.nHeroOnTrigger4 = 0
	self.bCogsSpawned = false

	self:AddSpawner( CDotaSpawner( "spawner_peon", "spawner_peon",
	{ 
		{
			EntityName = "npc_dota_creature_bonus_greevil",
			Team = DOTA_TEAM_BADGUYS,
			Count = 3,
			PositionNoise = 300.0,
		},
	} ) )

	self:AddSpawner( CDotaSpawner( "spawner_captain", "spawner_captain",
	{ 
		{
			EntityName = "npc_dota_creature_evil_greevil",
			Team = DOTA_TEAM_BADGUYS,
			Count = 1,
			PositionNoise = 0.0,
		},
	} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:OnEncounterLoaded()
	CMapEncounter_BonusBase.OnEncounterLoaded( self )
	self:SetupBristlebackShop( false )
end

function CMapEncounter_Pangolier:Start()
	CMapEncounter_BonusBase.Start( self )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_bonus_room_start", {} )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:Transform()
	local hHeroes = HeroList:GetAllHeroes()

	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			--printf( "Start - Transforming into gyroshell" )
			local hAbility = hHero:AddAbility( "aghsfort_pangolier_gyroshell" )
			hAbility:UpgradeAbility( true )
			if hAbility ~= nil then
				PlayerResource:SetCameraTarget( hHero:GetPlayerOwnerID(), hHero )
				PlayerResource:SetOverrideSelectionEntity( hHero:GetPlayerOwnerID(), hHero )
				hHero:AddNewModifier( hHero, hAbility, "modifier_pango_bonus", { duration = -1 } )

				local vDir = hHero:GetForwardVector()
				local vTargetPos = hHero:GetAbsOrigin() + vDir
				local kv = {}
				kv[ "duration" ] = -1
				kv[ "vTargetX" ] = vTargetPos.x
				kv[ "vTargetY" ] = vTargetPos.y
				kv[ "vTargetZ" ] = vTargetPos.z
				hHero:AddNewModifier( hHero, hAbility, "modifier_pangolier_gyroshell", kv )
			else
				printf( "Start - Can't find ability" )
			end
		end
	end
	if not self.bCogsSpawned then
		self:SpawnCogs()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:SpawnCogs()
	--print("Spawning cogs")
	local cogUnits = Entities:FindAllByName( "spawner_cog" )
	
	for _, goalUnit in pairs(cogUnits) do
		local cogPos = goalUnit:GetAbsOrigin()
		local cogTable = 
		{
			origin = "0 0 0",
			angles = "0 0 0",
			targetname = "bumper_cog",
			model = "models/items/rattletrap/mechanised_pilgrim_cog/mechanised_pilgrim_cog.vmdl",
			scales = "2 2 2",
			defaultanim = "ACT_DOTA_IDLE"
		}
		local hUnit = SpawnEntityFromTableSynchronous( "prop_dynamic", cogTable )
		hUnit:SetAbsOrigin( cogPos )
	end
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arena_obstruction_enable_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
	self.bCogsSpawned = true
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:RemoveCogs()
	--print("Removing cogs")
	local cogUnits = Entities:FindAllByName( "bumper_cog" )
	local vPos = nil
	for _, cogUnit in pairs(cogUnits) do
		vPos = cogUnit:GetAbsOrigin()
		UTIL_Remove(cogUnit)
	end
	-- Remove Evil Greevils
	local creatures = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
	for _, hUnit in pairs(creatures) do
		if hUnit:GetUnitName() == "npc_dota_creature_evil_greevil" then
			--print("Removing an Evil Greevil")
			UTIL_Remove(hUnit)
		end
	end
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arena_obstruction_disable_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:GetPreviewUnit()
	return "npc_dota_creature_bonus_greevil"
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:OnTriggerStartTouch( event )
	CMapEncounter_BonusBase.OnTriggerStartTouch( self, event )

	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )

	if self.bAllButtonsReady == true then
		return
	end

	if self.bGameStarted == false then
		if szTriggerName == "trigger_player_1" then
			self.nHeroOnTrigger1 = 1
		elseif szTriggerName == "trigger_player_2" then
			self.nHeroOnTrigger2 = 1
		elseif  szTriggerName == "trigger_player_3" then
			self.nHeroOnTrigger3 = 1
		elseif  szTriggerName == "trigger_player_4" then
			self.nHeroOnTrigger4 = 1
		end
		self.nPlayersReady = self.nHeroOnTrigger1 + self.nHeroOnTrigger2 + self.nHeroOnTrigger3 + self.nHeroOnTrigger4
		local vecPlayers = GameRules.Aghanim:GetConnectedPlayers()
		if #vecPlayers > 0 then
			if self.nPlayersReady == #vecPlayers then
				--print("All players ready!")
				self.bAllButtonsReady = true
				self:GetSpawner( "spawner_peon" ):SpawnUnits()
				self:GetSpawner( "spawner_captain" ):SpawnUnits()
				self:StartBonusRound( 41.2 ) -- account for gyroshell cast time
				self:Transform()
				EmitGlobalSound( "BonusRoom.ChaseMusicLoop" )
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:OnTriggerEndTouch( event )
	CMapEncounter_BonusBase.OnTriggerEndTouch( self, event )
	if self.bAllButtonsReady == true then
		return
	end

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if szTriggerName == "trigger_player_1" then
		self.nHeroOnTrigger1 = 0
	elseif szTriggerName == "trigger_player_2" then
		self.nHeroOnTrigger2 = 0
	elseif  szTriggerName == "trigger_player_3" then
		self.nHeroOnTrigger3 = 0
	elseif  szTriggerName == "trigger_player_4" then
		self.nHeroOnTrigger4 = 0
	end
end

--------------------------------------------------------------------------------
--[[
function CMapEncounter_Pangolier:CheckForCompletion()
	return self.bGameStarted == true and not self:HasRemainingEnemies()
end
]]
--------------------------------------------------------------------------------

function CMapEncounter_Pangolier:OnComplete()
	CMapEncounter_BonusBase.OnComplete( self )
	
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			hHero:RemoveAbility( "pangolier_gyroshell" )
			hHero:RemoveModifierByName( "modifier_pangolier_gyroshell" )
			hHero:RemoveModifierByName( "modifier_pango_bonus" )
			hHero:RemoveModifierByName( "modifier_bonus_room_start" )
			PlayerResource:SetCameraTarget( hHero:GetPlayerOwnerID(), nil )
			PlayerResource:SetOverrideSelectionEntity( hHero:GetPlayerOwnerID(), nil )
		end
	end
	if self.bCogsSpawned then
		self:RemoveCogs()
	end

	StopGlobalSound( "BonusRoom.ChaseMusicLoop" )
end

--------------------------------------------------------------------------------

return CMapEncounter_Pangolier
