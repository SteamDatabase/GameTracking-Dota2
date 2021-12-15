
require( "encounters/encounter_boss_base" )
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

LinkLuaModifier( "modifier_primal_beast_outro_aura", "modifiers/creatures/modifier_primal_beast_outro_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_outro_aura_effect", "modifiers/creatures/modifier_primal_beast_outro_aura_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_cinematic_controller", "modifiers/creatures/modifier_primal_beast_cinematic_controller", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_clone", "modifiers/creatures/modifier_aghanim_clone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_clone_portal_out", "modifiers/creatures/modifier_aghanim_clone_portal_out", LUA_MODIFIER_MOTION_VERTICAL )

--------------------------------------------------------------------------------

_G.INTRO_PHASE_INVISIBLE = 1
_G.INTRO_PHASE_LEAP_INTO_MAP = 2
_G.INTRO_PHASE_LAND = 3
_G.INTRO_PHASE_ROAR = 4
_G.INTRO_PHASE_COMPLETE = 5

--------------------------------------------------------------------------------

_G.VICTORY_PHASE_LEAP_TO_MIDDLE = 1
_G.VICTORY_PHASE_ROAR = 2 
_G.VICTORY_PHASE_LEAP_OUT_OF_MAP = 3
_G.VICTORY_PHASE_BEAST_HIDE = 4
_G.VICTORY_PHASE_AGHANIM_PORTAL_IN = 5
_G.VICTORY_PHASE_AGHANIM_FIGHT_SUCCESS = 6
_G.VICTORY_PHASE_AGHANIM_DESTROY_PORTAL = 7
_G.VICTORY_PHASE_AGAHNIM_INTRODUCE_CLONE = 8
_G.VICTORY_PHASE_AGHANIM_BEGIN_FREE_CLONE = 9
_G.VICTORY_PHASE_AGHANIM_FREE_CLONE = 10
_G.VICTORY_PHASE_AGHANIM_END_FREE_CLONE = 11
_G.VICTORY_PHASE_AGHANIM_SPEAK_CLONE = 12
_G.VICTORY_PHASE_AGHANIM_PORTAL_OUT_CLONE = 13
_G.VICTORY_PHASE_AGHANIM_VICTORY_SPEECH = 14
_G.VICTORY_PHASE_AGHANIM_COMPLETE = 15

--------------------------------------------------------------------------------

if CMapEncounter_PrimalBeast == nil then
	CMapEncounter_PrimalBeast = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------


function CMapEncounter_PrimalBeast:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )

	PrecacheResource( "particle", "particles/status_fx/status_effect_ghost.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_faceless_chronosphere.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/aghanim_clone_trap.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/aghanim_clone_trap_upper.vpcf", context )
	PrecacheResource( "particle", "particles/gameplay/agh_clone_prison_debuff.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_aghsfort_primal_beast_boss", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_barbarian", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_blacksmith", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_bucket", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_dude", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_goat", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_mad_maghs", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_mecha", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_bathtime", context, -1 ) 
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_donkey", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_aghanim_clone_roshan", context, -1 )
end

--------------------------------------------------------------------------------

_G.AGHANIM_CLONE_EVENT_ACTIONS =
{
	npc_dota_aghanim_clone_barbarian 		= "aghs_model_unlocked_beastmaster",
	npc_dota_aghanim_clone_bathtime 		= "aghs_model_unlocked_bubble_bath",
	npc_dota_aghanim_clone_blacksmith 		= "aghs_model_unlocked_mechanic",
	npc_dota_aghanim_clone_bucket 			= "aghs_model_unlocked_bucket",
	npc_dota_aghanim_clone_dude 			= "aghs_model_unlocked_bro",
	npc_dota_aghanim_clone_goat 			= "aghs_model_unlocked_goat", 
	npc_dota_aghanim_clone_mad_maghs 		= "aghs_model_unlocked_mad_max",
	npc_dota_aghanim_clone_mecha			= "aghs_model_unlocked_future",
	npc_dota_aghanim_clone_roshan			= "aghs_model_unlocked_roshan",
	npc_dota_aghanim_clone_donkey			= "aghs_model_unlocked_courier",
}

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetEventActionForClone()
	return AGHANIM_CLONE_EVENT_ACTIONS[ self.hAghanimClone:GetUnitName() ]
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	-- Need this boolean for trigger to detect players outide the arena
	self.bArenaIsLocked = false


	self.szBossSpawner = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_aghsfort_primal_beast_boss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )


	self.flNextCinematicSequenceTime = -1

	self.nIntroSequencePhase = 0
	self.nVictorySequencePhase = 0

	self.bInVictorySequence = false
	self.bVictoryLeaptToMiddle = false 
	self.bVictoryOrderedLeapToMiddle = false
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:Start()
	CMapEncounter_BossBase.Start( self )

	local hAghanim = GameRules.Aghanim:GetAnnouncer():GetUnit()
			
	local AghanimCloneLocator = self:GetRoom():FindAllEntitiesInRoomByName( "spawner_aghanim_clone", true )
	local vAghanimCloneLocation = AghanimCloneLocator[ 1 ]:GetAbsOrigin() 
	if self.hAghanimClone == nil then

		local szCloneName = nil
		local vecCloneNames = 
		{
			"npc_dota_aghanim_clone_dude",
			"npc_dota_aghanim_clone_donkey",
			"npc_dota_aghanim_clone_roshan",
			"npc_dota_aghanim_clone_mecha",
			"npc_dota_aghanim_clone_mad_maghs",
			"npc_dota_aghanim_clone_goat",
			"npc_dota_aghanim_clone_bucket",
			"npc_dota_aghanim_clone_blacksmith",
			"npc_dota_aghanim_clone_barbarian",
			"npc_dota_aghanim_clone_bathtime",
		}

		szCloneName = vecCloneNames[ RandomInt( 1, #vecCloneNames ) ]

		self.hAghanimClone = CreateUnitByName( szCloneName, vAghanimCloneLocation, true, hAghanim, hAghanim:GetOwner(), hAghanim:GetTeamNumber() )
		if self.hAghanimClone then
			self.hAghanimClone:SetAbsAngles( 0, 315, 0 )
			self.hAghanimClone:AddNewModifier( self.hAghanimClone, nil, "modifier_aghanim_clone", {} )
			self.hAghanimClone:AddNewModifier( self.hAghanimClone, nil, "modifier_aghanim_animation_activity_modifier", {} )
		end

		local CameraDummyLocator = self:GetRoom():FindAllEntitiesInRoomByName( "clone_scene_camera_target", true )
		local vCameraDummyLocation = CameraDummyLocator[ 1 ]:GetAbsOrigin() 
		self.hCameraDummy = CreateUnitByName( szCloneName, vCameraDummyLocation, true, hAghanim, hAghanim:GetOwner(), hAghanim:GetTeamNumber() )
		if self.hCameraDummy then 
			self.hCameraDummy:AddEffects( EF_NODRAW )
			self.hCameraDummy:AddNewModifier( self.hCameraDummy, nil, "modifier_aghanim_clone", {} )
		end
	end
end


--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:OnTriggerStartTouch( event )
	if self.bArenaIsLocked == false then
		return
	end
	--print("OnTriggerStartTouch")
	-- Get the trigger outside the gate
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	-- Teleport hero to location inside the arena
	if szTriggerName == "arena_teleport_trigger" then
		--print( "Player has left the arena!" )
		local hTeleportTarget = Entities:FindByName( nil, "teleport_players" )
		local vTeleportPos = hTeleportTarget:GetAbsOrigin()
		FindClearSpaceForUnit( hUnit, vTeleportPos, true )
	end

end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:OnTriggerEndTouch( event )

end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
	self.hBeast = hBoss
	self.hBeast.bOutroComplete = false
	self.hBeast:AddEffects( EF_NODRAW )
end


--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:OnThink()
	if self.bBossIntroduced == false then 
		for nPlayerID = 0,AGHANIM_PLAYERS-1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero then
				local flDist = ( hPlayerHero:GetAbsOrigin() - self.hAghanimClone:GetAbsOrigin() ):Length2D()
				if flDist < 450 then
					self:IntroduceBoss( self.hBeast )
					break 
				end
			end
		end
	end

	if self.bInVictorySequence then 
		if self.nVictorySequencePhase == 0 then 
			print( "Outro Cinematic: Switch to phase VICTORY_PHASE_LEAP_TO_MIDDLE" )
			self:IncrementCinematicPhase( 0.0 )
		end
		self:OnThinkVictorySequence()
		return
	end

	local flNow = GameRules:GetGameTime()
	if self.bBossIntroduced and self.bBossFightStarted == false then
		if self.nIntroSequencePhase == 0 then 
			print( "Intro Cinematic: Switch to phase INTRO_PHASE_INVISIBLE" )
			self:IncrementCinematicPhase( 0.0 )
		end
		self:OnThinkIntroSequence()
		return
	end

	if self.bBossFightStarted == false then 
		return 
	end

	self:UpdateBossHP()

	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			local hVisionBuff = hPlayerHero:FindModifierByName( "modifier_provide_vision" )
			if hVisionBuff == nil then
				for _,hBoss in pairs( self.Bosses ) do
					if hBoss and hBoss:IsNull() == false and hBoss:IsAlive() then
						hPlayerHero:AddNewModifier( hBoss, nil, "modifier_provide_vision", { duration = -1 } )
						break
					end
				end
			end	
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:StartBossFight()
	--print( "CMapEncounter_PrimalBeast:StartBossFight()" )
	CMapEncounter_BossBase.StartBossFight( self )

	local LeapRelay = self:GetRoom():FindAllEntitiesInRoomByName( "primal_beast_leapout_relay", true )
	LeapRelay[ 1 ]:Trigger( nil, nil )

	self.hBeast.bAbsoluteNoCC = true
	self.hBeast.bStarted = true
	local hAbility = self.hBeast:AddAbility( "ability_primalbeast_absolute_no_cc" )
	if hAbility then
		hAbility:UpgradeAbility( false )
	end
	hAbility = self.hBeast:AddAbility( "provides_vision" )
	if hAbility then
		hAbility:UpgradeAbility( false )
	end

	self.hBeast:AddNewModifier( self.hBeast, nil, "modifier_primal_beast_cinematic_controller", {} )
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:IntroduceBoss( hEncounteredBoss )
	--CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )
	self.bBossIntroduced = true

	for nPlayerID = 0,AGHANIM_PLAYERS-1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
		if hPlayerHero then
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_boss_intro", {  } )
		end
	end
	
	self:AddEncounterObjective( tostring( "defeat_boss_" .. self:GetBossUnitName() ), 0, 0 )

	local netTable = {}
	netTable[ "boss_ent_index" ] = self.hBeast:entindex()
	netTable[ "camera_pitch" ] = self:GetBossIntroCameraPitch()
	netTable[ "camera_distance" ] = self:GetBossIntroCameraDistance()
	netTable[ "camera_height" ] = self:GetBossIntroCameraHeight()
	netTable[ "camera_yaw_rotate_speed" ] = self:GetBossIntroCameraYawRotateSpeed()
	netTable[ "camera_inital_yaw" ] = self:GetBossIntroCameraInitialYaw()
	self.flBossIntroEndTime = GameRules:GetGameTime() + 99999 -- controlled by cinematic think

	CustomGameEventManager:Send_ServerToAllClients( "boss_intro_begin", netTable )

	-- Close the entrance gate
	self:CloseGate()
	self.bArenaIsLocked = true
	-- Enable the room bounds
	local hTriggers = self:GetRoom():FindAllEntitiesInRoomByName( "primal_beast_boss_room_bounds", false )
	local hTeleportPositions = self:GetRoom():FindAllEntitiesInRoomByName( "teleport_players", false )
	if #hTriggers > 0 and #hTeleportPositions > 0 then
		local hTrigger = hTriggers[1]
		local hTeleportPosition = hTeleportPositions[1]
		if hTrigger ~= nil and hTeleportPosition ~= nil then

			local vMins = hTrigger:GetBoundingMins()
			local vMaxs = hTrigger:GetBoundingMaxs()
			vMins = hTrigger:TransformPointEntityToWorld( vMins )
			vMaxs = hTrigger:TransformPointEntityToWorld( vMaxs )

			local flSize = vMaxs.x - vMins.x
			local flSizeY = vMaxs.y - vMins.y
			if flSizeY > flSize then
				flSize = flSizeY
			end

			local netTable = {}
			netTable[ "room_name" ] = self:GetRoom():GetName()
			netTable[ "map_name" ] = "a3_4_primal_beast"
			netTable[ "x" ] = hTrigger:GetAbsOrigin().x
			netTable[ "y" ] = hTrigger:GetAbsOrigin().y
			netTable[ "size" ] = flSize
			netTable[ "scale" ] = 8

			for nPlayerID = 0, AGHANIM_PLAYERS-1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
				if hPlayerHero then
					if not hTrigger:IsTouching( hPlayerHero ) then
						FindClearSpaceForUnit( hPlayerHero, hTeleportPosition:GetAbsOrigin() + RandomVector( 250 ), true )
					end
					
					local kv = 
					{
						min_x = vMins.x,
						min_y = vMins.y,
						max_x = vMaxs.x,
						max_y = vMaxs.y,
					}
					hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_morty_leash", kv )

					CustomNetTables:SetTableValue( "game_global", "minimap_info" .. nPlayerID, netTable )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:CloseGate()
	--print("Closing the gate!")
	-- Closing the entrance gate
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "arena_gate_relay", false )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:OnComplete()
	self:RunEncounterAbilityFunctions( "ENCOUNTER_COMPLETE" )
	
	-- Delete any unclaimed treasures
	for i=1,#self.hTreasureList do
		UTIL_Remove( self.hTreasureList[i] )
	end
	self.hTreasureList = {}

	local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
	for _,unit in pairs( units ) do
		if unit:GetUnitName() == "aghsfort_primal_beast_rock" or unit:GetUnitName() == "aghsfort_primal_beast_rock_golem" then
			unit:ForceKill( false )
		end
	end


	self:RegisterSummonForAghanim()
	
	--CustomNetTables:SetTableValue( "room_data", "status", { complete=true } )
	CustomGameEventManager:Send_ServerToAllClients( "complete_encounter", self.ClientData )

	local gameEvent = {}
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Aghanim_QuestStarFound"
	FireGameEvent( "dota_combat_event_message", gameEvent )

	GameRules.Aghanim:GrantAllPlayersQuestStar()
	GameRules.Aghanim:GrantAllPlayersAghanimClone( self:GetEventActionForClone() )
	GameRules.Aghanim:MarkGameWon()
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:IncrementCinematicPhase( flTime )
	self.flNextCinematicSequenceTime = GameRules:GetGameTime() + flTime 

	if self.bInVictorySequence then 
		self.nVictorySequencePhase = self.nVictorySequencePhase + 1 
		print( "Victory Sequence: Entering phase " .. self.nVictorySequencePhase .. " at " .. self.flNextCinematicSequenceTime )
	else
		self.nIntroSequencePhase = self.nIntroSequencePhase + 1
		print( "Intro Sequence: Entering phase " .. self.nIntroSequencePhase .. " at " .. self.flNextCinematicSequenceTime )
	end	
end

--------------------------------------------------------------------------------
--[  INTRO --]

function CMapEncounter_PrimalBeast:OnThinkIntroSequence()
	if self.flNextCinematicSequenceTime > GameRules:GetGameTime() then 
		return 
	end

	-- current ACT_DOTA_SPAWN 8.56s
	if self.nIntroSequencePhase == INTRO_PHASE_INVISIBLE then
		self.hBeast:StartGesture( ACT_DOTA_SPAWN ) 
		self:IncrementCinematicPhase( 0.5 ) -- make this long enough to hide the start of the beast animation
		return
	end

	if self.nIntroSequencePhase == INTRO_PHASE_LEAP_INTO_MAP then 
		self.hBeast:RemoveEffects( EF_NODRAW ) 
		self:IncrementCinematicPhase( 1.25 ) 
		return
	end

	if self.nIntroSequencePhase == INTRO_PHASE_LAND then 
		ScreenShake( self.hBeast:GetAbsOrigin(), 10.0, 300.0, 0.5, 1300.0, 0, true )

		for nPlayerID = 0, AGHANIM_PLAYERS-1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero then
				local flDist = ( hPlayerHero:GetAbsOrigin() - self.hBeast:GetAbsOrigin() ):Length2D()
				if flDist < 300 then 
					local kv = 
					{
						center_x = self.hBeast:GetAbsOrigin().x,
						center_y = self.hBeast:GetAbsOrigin().y,
						center_z = self.hBeast:GetAbsOrigin().z,
						duration = 0.5,
						should_stun = true, 
						knockback_duration = 0.2,
						knockback_distance = 300,
						knockback_height = 0,
					}

					hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_knockback", kv )
				end
			end
		end

		self:IncrementCinematicPhase( 3.44 )
		return
	end

	if self.nIntroSequencePhase == INTRO_PHASE_ROAR then 
		for nPlayerID = 0, AGHANIM_PLAYERS-1 do
			local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
			if hPlayerHero then
				local flDist = ( hPlayerHero:GetAbsOrigin() - self.hBeast:GetAbsOrigin() ):Length2D()
				if flDist < 600 then 
					local kv = 
					{
						center_x = self.hBeast:GetAbsOrigin().x,
						center_y = self.hBeast:GetAbsOrigin().y,
						center_z = self.hBeast:GetAbsOrigin().z,
						duration = 0.5,
						should_stun = true, 
						knockback_duration = 0.5,
						knockback_distance = 600,
						knockback_height = 0,
					}

					hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_knockback", kv )
				end
			end
		end

		ScreenShake( self.hBeast:GetAbsOrigin(), 10.0, 300.0, 0.5, 1300.0, 0, true )
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/primal_beast/primal_beast_tectonic_shift_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hBeast, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeast:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2.4, 0.0, 0.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:IncrementCinematicPhase( 3.4 )
		return
	end

	if self.nIntroSequencePhase == INTRO_PHASE_COMPLETE then 
		self.flNextCinematicSequenceTime = -1
		self:StartBossFight()
		return
	end
end

--------------------------------------------------------------------------------
--[  OUTRO --]

function CMapEncounter_PrimalBeast:OnThinkVictorySequence()
	if self.flNextCinematicSequenceTime > GameRules:GetGameTime() then 
		return 
	end

	local hAghanim = GameRules.Aghanim:GetAnnouncer():GetUnit()
	if self.nVictorySequencePhase == VICTORY_PHASE_LEAP_TO_MIDDLE then 
		CustomGameEventManager:Send_ServerToAllClients( "begin_primal_beast_victory", {} )

		if self.bVictoryLeaptToMiddle == false and self.bVictoryOrderedLeapToMiddle == false then 
			self.hBeast:RemoveModifierByName( "modifier_aghsfort_primal_beast_boss_onslaught_windup")
			self.hBeast:Interrupt()

			print( "Outro Cinematic: Issuing order to leap to the mid" )
			self.hBeast.AI:LeapToMiddle()
			self.flNextCinematicSequenceTime = self.flNextCinematicSequenceTime + GetSpellCastTime( self.hBeast.AI.hRapidVaultAbility ) + 0.1  
			self.bVictoryOrderedLeapToMiddle = true 
			return
		end

		if self.hBeast:FindModifierByName( "modifier_aghsfort_primal_beast_boss_rapid_vault" ) == nil then 
			CustomGameEventManager:Send_ServerToAllClients( "pan_camera_to_beast", { ent_index = self.hBeast:entindex() } )
			ScreenShake( self.hBeast:GetAbsOrigin(), 10.0, 300.0, 0.5, 1300.0, 0, true )
			self:IncrementCinematicPhase( 0.5 )
			return
		end

		return 
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_ROAR then 
		CustomGameEventManager:Send_ServerToAllClients( "unlock_camera_from_beast", {} )
		self.hBeast:FaceTowards( self.hBeast:GetAbsOrigin() + Vector( 0, -50, 0 ) )
		self.hBeast:StartGesture( ACT_DOTA_DEFEAT )
		self:IncrementCinematicPhase( 0.5 )
		return 
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_LEAP_OUT_OF_MAP then 
		ScreenShake( self.hBeast:GetAbsOrigin(), 10.0, 300.0, 0.5, 1300.0, 0, true )
		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/primal_beast/primal_beast_tectonic_shift_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hBeast, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeast:GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 2.4, 0.0, 0.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		
		local AghanimTeleportLocator = self:GetRoom():FindAllEntitiesInRoomByName( "aghanim_teleport_point", true )
		local vAghanimTeleportLocation = AghanimTeleportLocator[ 1 ]:GetAbsOrigin()	
		hAghanim:AddEffects( EF_NODRAW )
		hAghanim:FaceTowards( hAghanim:GetAbsOrigin() + Vector( 75, 0, 0 ) ) 
		FindClearSpaceForUnit( hAghanim, vAghanimTeleportLocation, true )

		self:IncrementCinematicPhase( 4.75 ) -- this should be slightly less than ACT_DOTA_DEFEAT's duration
		return 
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_BEAST_HIDE then 
		local OutOfMapLocator = self:GetRoom():FindAllEntitiesInRoomByName( "primal_beast_leapout_point", true )
		local vLeapPosition = OutOfMapLocator[ 1 ]:GetAbsOrigin()
		local LeapRelay = self:GetRoom():FindAllEntitiesInRoomByName( "primal_beast_leapout_relay", true )
		LeapRelay[ 1 ]:Trigger( nil, nil )

		self.hBeast:AddEffects( EF_NODRAW )
		self.hBeast:AddNewModifier( hPlayerHero, nil, "modifier_boss_intro", {} )
		FindClearSpaceForUnit( self.hBeast, vLeapPosition, true )
		self:IncrementCinematicPhase( 1.0 ) -- some delay to complete the animation before panning camera
		return
	end

---- [ BEAST HIDDEN --]

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_PORTAL_IN then 
		CustomGameEventManager:Send_ServerToAllClients( "begin_aghanim_clone_scene", { ent_index = self.hCameraDummy:entindex() } )

		self.nPortalFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/portal_summon.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPortalFX, 0, hAghanim:GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nPortalFX, 0, hAghanim:GetForwardVector() )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", hAghanim )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", hAghanim )
		self:IncrementCinematicPhase( 1.1 )
		return 
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_FIGHT_SUCCESS then 
		GameRules.Aghanim:GetAnnouncer():OnPrimalBeastDefeated() 
		hAghanim:RemoveEffects( EF_NODRAW )
		hAghanim:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY_START )
		self:IncrementCinematicPhase( 8.3 )
		return
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_DESTROY_PORTAL then 
		hAghanim:RemoveGesture( ACT_DOTA_VICTORY_START )
		hAghanim:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY )
		ParticleManager:DestroyParticle( self.nPortalFX, false )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", hAghanim )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", hAghanim )
		self:IncrementCinematicPhase( 0.1 )
		return 
	end


	if self.nVictorySequencePhase == VICTORY_PHASE_AGAHNIM_INTRODUCE_CLONE then 
		if GameRules.Aghanim:GetAnnouncer():IsCurrentlySpeaking() then 
			return
		end
		
		GameRules.Aghanim:GetAnnouncer():OnCloneIntroducePre()
		hAghanim:FaceTowards( self.hAghanimClone:GetAbsOrigin() )
		self:IncrementCinematicPhase( 0.1 )
		return
	end
	
	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_BEGIN_FREE_CLONE then 
		StartSoundEventFromPositionReliable( "Aghanim.StaffBeams.WindUp", hAghanim:GetAbsOrigin() )
			
		hAghanim:RemoveGesture( ACT_DOTA_VICTORY )
		hAghanim:StartGestureFadeWithSequenceSettings( ACT_DOTA_CAST_ABILITY_2 )
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAghanim )

		self:IncrementCinematicPhase( 2.0 )
		return
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_FREE_CLONE then 
		EmitSoundOn( "Hero_Phoenix.SunRay.Cast", hAghanim )
		EmitSoundOn( "Hero_Phoenix.SunRay.Loop", hAghanim )
		
		hAghanim:RemoveGesture( ACT_DOTA_CAST_ABILITY_2 )
		hAghanim:StartGestureFadeWithSequenceSettings( ACT_DOTA_CHANNEL_ABILITY_2 )
		self.nBeamFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/staff_beam.vpcf", PATTACH_CUSTOMORIGIN, hAghanim )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 0, hAghanim, PATTACH_POINT_FOLLOW, "attach_staff_fx", hAghanim:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 1, self.hAghanimClone, PATTACH_ABSORIGIN_FOLLOW, nil, self.hAghanimClone:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 2, hAghanim, PATTACH_ABSORIGIN_FOLLOW, nil, self.hAghanimClone:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 9, hAghanim, PATTACH_POINT_FOLLOW, "attach_hitloc", hAghanim:GetAbsOrigin(), true )
		self:IncrementCinematicPhase( 7.0 )
		return
	end

		
	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_END_FREE_CLONE then 
		hAghanim:RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_2 )
		hAghanim:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY )
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		ParticleManager:DestroyParticle( self.nBeamFX, false )
		StopSoundOn( "Hero_Phoenix.SunRay.Cast", hAghanim )
		StopSoundOn( "Hero_Phoenix.SunRay.Loop", hAghanim )
		EmitSoundOn( "Hero_Phoenix.SunRay.Stop", hAghanim )

		self.hAghanimClone:RemoveModifierByName( "modifier_aghanim_clone" )
		self.hAghanimClone:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY_START )

		self:IncrementCinematicPhase( 3.0 )
		return
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_SPEAK_CLONE then 
		self.hAghanimClone:RemoveGesture( ACT_DOTA_VICTORY_START )
		self.hAghanimClone:StartGestureFadeWithSequenceSettings( ACT_DOTA_VICTORY_START )
		self.hAghanimClone:FaceTowards( self.hAghanimClone:GetAbsOrigin() + Vector( 50, -75, 0 ) ) 
		hAghanim:FaceTowards( hAghanim:GetAbsOrigin() + Vector( 90, 0, 0 ) ) 
		GameRules.Aghanim:GetAnnouncer():OnCloneIntroducePost( self.hAghanimClone:GetUnitName() ) 

		self.nPortalFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/portal_summon.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPortalFX, 0, self.hAghanimClone:GetAbsOrigin() )
		ParticleManager:SetParticleControlForward( self.nPortalFX, 0, self.hAghanimClone:GetForwardVector() )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Open", self.hAghanimClone )
		EmitSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self.hAghanimClone )

		self.hAghanimClone:AddNewModifier( hAghanim, nil, "modifier_aghanim_clone_portal_out", {} )
		self:IncrementCinematicPhase( 0.1 )
	end


	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_PORTAL_OUT_CLONE then 
		if GameRules.Aghanim:GetAnnouncer():IsCurrentlySpeaking() then 
			return 
		end

		local hPortalBuff = self.hAghanimClone:FindModifierByName( "modifier_aghanim_clone_portal_out" )
		if hPortalBuff then
			hPortalBuff.bDescend = true 
		end
		
		self:IncrementCinematicPhase( 2.0 ) 
		return
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_VICTORY_SPEECH then 
		self.hAghanimClone:RemoveModifierByName( "modifier_aghanim_clone_portal_out" )
		self.hAghanimClone:AddEffects( EF_NODRAW )
		ParticleManager:DestroyParticle( self.nPortalFX, false )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Open", self.hAghanimClone )
		StopSoundOn( "SeasonalConsumable.TI10.Portal.Loop", self.hAghanimClone )

		GameRules.Aghanim:GetAnnouncer():OnGameWon()
		self:IncrementCinematicPhase( 1.0 ) 
		return 0.1
	end

	if self.nVictorySequencePhase == VICTORY_PHASE_AGHANIM_COMPLETE then 
		if GameRules.Aghanim:GetAnnouncer():IsCurrentlySpeaking() then 
			return 
		end

		print( "Outro Cinematic: Marking encounter complete.  Game won!" )
		self:OnComplete()
		self.bInVictorySequence = false 
		return 
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetPreviewUnit()
	return "npc_dota_creature_aghsfort_primal_beast_boss"
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroVoiceLine()
	return nil
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroGesture()
	return ACT_DOTA_SPAWN
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroDuration()
	return 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroCameraPitch()
	return 40
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroCameraHeight()
	return 225
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroCameraYawRotateSpeed()
	return 0.05
end

--------------------------------------------------------------------------------

function CMapEncounter_PrimalBeast:GetBossIntroCameraInitialYaw()
	return 345
end

--------------------------------------------------------------------------------

return CMapEncounter_PrimalBeast
