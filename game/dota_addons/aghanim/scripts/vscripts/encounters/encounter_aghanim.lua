require( "encounters/encounter_boss_base" )
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )


--------------------------------------------------------------------------------

if CMapEncounter_Aghanim == nil then
	CMapEncounter_Aghanim = class( {}, {}, CMapEncounter_BossBase )
end

--------------------------------------------------------------------------------


function CMapEncounter_Aghanim:Precache( context )
	CMapEncounter_BossBase.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_boss_aghanim", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:constructor( hRoom, szEncounterName )

	CMapEncounter_BossBase.constructor( self, hRoom, szEncounterName )

	-- Agh Victory phase
	self.AGH_VICTORY_NOT_STARTED = 0
	self.AGH_VICTORY_BESTED = 1
	self.AGH_VICTORY_VICTORY_SPEECH = 2
	self.AGH_VICTORY_BOWING = 3
	self.AGH_VICTORY_FINISHED = 4

	self.nVictoryState = self.AGH_VICTORY_NOT_STARTED
	self.szBossSpawner = "spawner_boss"

	self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{ 
			{
				EntityName = "npc_dota_boss_aghanim",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:Start()
	CMapEncounter_BossBase.Start( self )

	self.nHeroOnTrigger1 = 0
	self.nHeroOnTrigger2 = 0
	self.nHeroOnTrigger3 = 0
	self.nHeroOnTrigger4 = 0
	self.nPlayersReady = 0
	ListenToGameEvent( "trigger_start_touch", Dynamic_Wrap( getclass( self ), "OnTriggerStartTouch" ), self )
	ListenToGameEvent( "trigger_end_touch", Dynamic_Wrap( getclass( self ), "OnTriggerEndTouch" ), self )
end


--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:OnTriggerStartTouch( event )
	if self.bAllButtonsReady == true then
		return
	end

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	-- Assign an integer to the trigger	
	if szTriggerName == "trigger_player_1" then
		self.nHeroOnTrigger1 = 1
	elseif szTriggerName == "trigger_player_2" then
		self.nHeroOnTrigger2 = 1
	elseif  szTriggerName == "trigger_player_3" then
		self.nHeroOnTrigger3 = 1
	elseif  szTriggerName == "trigger_player_4" then
		self.nHeroOnTrigger4 = 1
	end
	local hHeroes = HeroList:GetAllHeroes()
	local nTotalHeroes = #hHeroes
	self.nPlayersReady = self.nHeroOnTrigger1 + self.nHeroOnTrigger2 + self.nHeroOnTrigger3 + self.nHeroOnTrigger4
	if self.nPlayersReady == nTotalHeroes then

		local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "aghanim_gate_open_relay", false )
		for _, hRelay in pairs( hRelays ) do
			hRelay:Trigger( nil, nil )
			self.bAllButtonsReady = true
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:OnTriggerEndTouch( event )
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

function CMapEncounter_Aghanim:OnBossSpawned( hBoss )
	CMapEncounter_BossBase.OnBossSpawned( self, hBoss )

	hBoss.AI:SetEncounter( self )
	self.hAghanim = hBoss
	self.hAghanim.bOutroComplete = false
end


--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:OnThink()
	CMapEncounter_BossBase.OnThink( self )

	if self.nVictoryState > self.AGH_VICTORY_NOT_STARTED then
		self:OnThinkVictorySequence()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:IntroduceBoss( hEncounteredBoss )
	CMapEncounter_BossBase.IntroduceBoss( self, hEncounteredBoss )

	-- local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "aghanim_gate_close_relay", false )
	-- for _, hRelay in pairs( hRelays ) do
	-- 	hRelay:Trigger( nil, nil )
	-- end

	local hTriggers = self:GetRoom():FindAllEntitiesInRoomByName( "aghanim_boss_room_bounds", false )
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
			netTable[ "map_name" ] = "aghanim_arena_boss_room"
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

function CMapEncounter_Aghanim:OnComplete()
	CMapEncounter.OnComplete( self )
	GameRules.Aghanim:MarkGameWon()
end

---------------------------------------------------------------------------

function CMapEncounter_Aghanim:BossSpeak( szSoundEvent, bLaugh )

	-- Use response rules to talk
	return

end

---------------------------------------------------------------------------

function CMapEncounter_Aghanim:AghanimSpeak( flDelay, bForce, hCriteriaTable )

	-- Don't speak after we started our victory sequence

	if self.nVictoryState > self.AGH_VICTORY_VICTORY_SPEECH then
		return false
	end

	-- We're juking the announcer to speak through our own unit
	-- So we can share in the "is speaking" logic as well as the global criteria
	-- And also other game code that triggers announcer lines
	return GameRules.Aghanim:GetAnnouncer():Speak( flDelay, bForce, hCriteriaTable )

end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:CheckForCompletion()
	return self.nVictoryState == self.AGH_VICTORY_FINISHED
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:BeginVictorySequence()

	-- A brutal hack. We need to know how long the victory speech is to know when to stop
	-- but the only way to achieve that is to make this line server-authoritative
	GameRules.Aghanim:GetAnnouncer():SetServerAuthoritative( true ) 

	self:AghanimSpeak( 0.0, true,
	{ 
		announce_event = "bested",
	})

	self.nVictoryState = self.AGH_VICTORY_BESTED

end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:OnThinkVictorySequence()
	-- Wait until he finishes his line
	if GameRules.Aghanim:GetAnnouncer():IsCurrentlySpeaking() == false then
		if self.nVictoryState == self.AGH_VICTORY_BESTED then
			self:AghanimSpeak( 0.0, true,
			{
				announce_event = "victory_speech",
			})
			
			GameRules.Aghanim:GetAnnouncer():OverrideSpeakingUnit( nil )
			self.nVictoryState = self.AGH_VICTORY_VICTORY_SPEECH
		elseif self.nVictoryState == self.AGH_VICTORY_VICTORY_SPEECH then
			self.nVictoryState = self.AGH_VICTORY_BOWING
		elseif self.nVictoryState == self.AGH_VICTORY_BOWING and self.hAghanim.bOutroComplete == true then
			self.nVictoryState = self.AGH_VICTORY_FINISHED
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetPreviewUnit()
	return "npc_dota_boss_aghanim"
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroVoiceLine()

	-- Sort of a hack. Starting with the intro voice, we are going to 
	-- juke the announcer to play lines through us. BossSpeak() is commented
	-- out so it does nothing

	-- While the boss is spawned, don't do any announcer lines
	GameRules.Aghanim:GetAnnouncer():OverrideSpeakingUnit( self.hAghanim )

	self:AghanimSpeak( 0.0, true,
	{ 
		announce_event = "boss_intro",
	})

	return nil
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroGesture()
	return ACT_DOTA_SPAWN
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroDuration()
	return 5.0
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroCameraPitch()
	return 40
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroCameraDistance()
	return 800
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetBossIntroCameraHeight()
	return 225
end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetLaughLine()

	-- No laughing after we started our end sequence
	if self.nVictoryState > self.AGH_VICTORY_NOT_STARTED then
		return ""
	end

	local bDidSpeak = self:AghanimSpeak( 0.0, false,
	{ 
		announce_event = "laugh",
	})

	-- Just the laugh system into not trying to laugh again for a while
	if bDidSpeak == true then
		return ""
	end

	return nil

end

--------------------------------------------------------------------------------

function CMapEncounter_Aghanim:GetAbilityUseLine( szAbilityName )

	local bForce = false
	if ( szAbilityName == "aghanim_staff_beams" ) or ( szAbilityName == "aghanim_blink" ) or ( szAbilityName == "aghanim_shard_attack" )
		 or ( szAbilityName == "aghanim_summon_portals" )  or ( szAbilityName == "aghanim_spell_swap" ) then
		bForce = true
	end

	self:AghanimSpeak( 0.0, bForce,
	{ 
		announce_event = "ability_use",
		ability_name = szAbilityName,
	})

	return nil

end


--------------------------------------------------------------------------------

return CMapEncounter_Aghanim
