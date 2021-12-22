require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TrapBase == nil then
	CMapEncounter_TrapBase = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_pendulum_trap", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.HeroesOnGoal = {}
	self.nHeroOnTrigger1 = 0
	self.nHeroOnTrigger2 = 0
	self.nHeroOnTrigger3 = 0
	self.nHeroOnTrigger4 = 0
	self.nHeroesOnGoal = 0

	self.vecHeroesDied = {}
	self.vecHeroesTookDamage = {}
	self.vecHeroesRewarded = {}
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:InitializeObjectives()
	self:AddEncounterObjective( "navigate_the_traps", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:GetMaxSpawnedUnitCount()
	return 0
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:GetAvailableTrapRoomAbilities()
	local Abilities = {
		-- Include at least four abilities so each player can get a unique one
		"trap_room_sprint",
		"trap_room_phase_shift",
		"trap_room_invuln",
		"aghsfort_trap_room_hookshot",
		"aghsfort_trap_room_meathook",
	}

	return Abilities
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:GetBlacklistedTrapModifiers()
	local vecBlacklistedModiifers =
	{
		"modifier_aghsfort_winter_wyvern_arctic_burn_flight",
		"modifier_aghsfort_phoenix_sun_ray",
		"modifier_aghsfort_templar_assassin_refraction_absorb",
		"modifier_aghsfort_viper_corrosive_skin_flying",
		"modifier_aghsfort_phoenix_icarus_dive",
	}

	return vecBlacklistedModiifers
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:Start()
	CMapEncounter.Start( self )

	self.nHurtListener = ListenToGameEvent( "entity_hurt", Dynamic_Wrap( getclass( self ), "OnEntityHurt" ), self )

	local TrapRoomAbilities = self:GetAvailableTrapRoomAbilities()

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then 
			local vecBlacklistedModiifers = self:GetBlacklistedTrapModifiers()
			for _,szModifierName in pairs ( vecBlacklistedModiifers ) do 
				hPlayerHero:RemoveModifierByName( szModifierName )
			end

			local kv = {}
			kv[ "duration" ] = -1

			if #TrapRoomAbilities <= 0 then
				printf( "ERROR - CMapEncounter_TrapBase:Start() - #TrapRoomAbilities is %d. Ensure the table has enough abilities in it for all players.", #TrapRoomAbilities )
				return
			end

			local nRandomIndex = RandomInt( 1, #TrapRoomAbilities )
			local szRandomAbility = TrapRoomAbilities[ nRandomIndex ]
			table.remove( TrapRoomAbilities, nRandomIndex )
			--printf( "after clearing the ability key in TrapRoomAbilities, #TrapRoomAbilities: %d", #TrapRoomAbilities )

			kv[ "trap_room_ability_name" ] = szRandomAbility
			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_trap_room_player", kv )

			hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_aghsfort_player_transform", { duration = -1 } )
		end
	end

	local PendulumSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "pendulum_trap", false )
	for _,Spawner in pairs ( PendulumSpawners ) do
		local hPendulum = CreateUnitByName( "npc_dota_pendulum_trap", Spawner:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
		if hPendulum then
			print( "Found pendulum")
			hPendulum:SetForwardVector( Spawner:GetForwardVector() )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:CheckForCompletion()
	local nHeroesAlive = 0
	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero and ( hPlayerHero:IsAlive() or hPlayerHero:GetRespawnsDisabled() == false ) then 
			nHeroesAlive = nHeroesAlive + 1
		end
	end
	self.nHeroesOnGoal = self.nHeroOnTrigger1 + self.nHeroOnTrigger2 + self.nHeroOnTrigger3 + self.nHeroOnTrigger4
	return nHeroesAlive > 0 and self.nHeroesOnGoal == nHeroesAlive
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnTriggerStartTouch( event )

	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() then
		local bTrapEndTrigger = false
		if szTriggerName == "trigger_player_1" then
			bTrapEndTrigger = true
			self.nHeroOnTrigger1 = 1
		elseif szTriggerName == "trigger_player_2" then
			bTrapEndTrigger = true
			self.nHeroOnTrigger2 = 1
		elseif  szTriggerName == "trigger_player_3" then
			bTrapEndTrigger = true
			self.nHeroOnTrigger3 = 1
		elseif  szTriggerName == "trigger_player_4" then
			bTrapEndTrigger = true
			self.nHeroOnTrigger4 = 1
		end

		if self:IsComplete() or not bTrapEndTrigger then 
			return
		end

		local bFoundHero = false 
		for _,Hero in pairs( self.vecHeroesRewarded ) do 
			if hUnit == Hero then 
				bFoundHero = true
				break 
			end
		end

		if not bFoundHero then 
			local flMultiplier = TRAP_ROOM_PERFECT_COMPLETION_GOLD_REWARD_PCT
			for _,DamagedHero in pairs( self.vecHeroesTookDamage ) do 
				if hUnit == DamagedHero then 
					flMultiplier = TRAP_ROOM_NO_DEATH_COMPLETION_GOLD_REWARD_PCT
					break 
				end
			end

			for _,KilledHero in pairs( self.vecHeroesDied ) do 
				if hUnit == KilledHero then 
					flMultiplier = TRAP_ROOM_COMPLETION_GOLD_REWARD_PCT
					break 
				end
			end

			local nPlayerID = hUnit:GetPlayerOwnerID()
			local nGoldReward = math.ceil( ENCOUNTER_DEPTH_GOLD_REWARD[ self:GetDepth() ] * flMultiplier )
			local nAdjustedGoldReward = math.ceil( nGoldReward * GameRules.Aghanim:GetGoldModifier() / 100 )
			if nPlayerID ~= -1 then
				local nActualGold = PlayerResource:GetSelectedHeroEntity( nPlayerID ):ModifyGoldFiltered( nAdjustedGoldReward, true, DOTA_ModifyGold_Unspecified )
				table.insert( self.vecHeroesRewarded, hUnit )

				local gameEvent = {}
	 			gameEvent[ "player_id" ] = nPlayerID
 				gameEvent[ "teamnumber" ] = DOTA_TEAM_GOODGUYS
 				gameEvent[ "int_value" ] = nActualGold
	 			gameEvent[ "message" ] = "#Aghanim_PlayerTrapRoomComplete"
	 			if flMultiplier == TRAP_ROOM_PERFECT_COMPLETION_GOLD_REWARD_PCT then 
	 				gameEvent[ "message" ] = "#Aghanim_PlayerTrapRoomComplete_Perfect"
	 			end
	 			if flMultiplier == TRAP_ROOM_NO_DEATH_COMPLETION_GOLD_REWARD_PCT then 
	 				gameEvent[ "message" ] = "#Aghanim_PlayerTrapRoomComplete_NoDeath"
	 			end
	 			FireGameEvent( "dota_combat_event_message", gameEvent )

	 			local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/hand_of_midas.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nFXIndex, 1, hRecipient, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOnLocationForPlayer( "DOTA_Item.Hand_Of_Midas", hUnit:GetAbsOrigin(), nPlayerID )
			end
		end

		--table.insert( self.HeroesOnGoal, hUnit )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() then
		if szTriggerName == "trigger_player_1" then
			self.nHeroOnTrigger1 = 0
		elseif szTriggerName == "trigger_player_2" then
			self.nHeroOnTrigger2 = 0
		elseif  szTriggerName == "trigger_player_3" then
			self.nHeroOnTrigger3 = 0
		elseif  szTriggerName == "trigger_player_4" then
			self.nHeroOnTrigger4 = 0
		end
		--[[
		for k,hHero in pairs( self.HeroesOnGoal ) do
			if hHero == hUnit then
				table.remove( self.HeroesOnGoal, k )
			end
		end
		]]
	end
end

--------------------------------------------------------------------------------
-- entity_hurt
-- > entindex_killed - int    // ugh, yes. it's called killed even if it's just damage
-- > entindex_attacker - int
-- > entindex_inflictor - int
-- > damagebits - int
--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnEntityHurt( event )
	local hVictim = nil
	if event.entindex_killed ~= nil then
		hVictim = EntIndexToHScript( event.entindex_killed )
	end

	if hVictim == nil or hVictim:IsRealHero() == false then
		return
	end

	table.insert( self.vecHeroesTookDamage, hVictim )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnComplete()
	CMapEncounter.OnComplete( self )

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero and not hPlayerHero:IsNull() and hPlayerHero:IsRealHero() then 
			hPlayerHero:RemoveModifierByName( "modifier_trap_room_player" )
			hPlayerHero:RemoveModifierByName( "modifier_aghsfort_player_transform" )
		end
	end

	StopListeningToGameEvent( self.nHurtListener )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnEntityKilled( event )
	CMapEncounter.OnEntityKilled( self, event )

	local killedHero = EntIndexToHScript( event.entindex_killed )
	if killedHero == nil or killedHero:IsRealHero() == false then
		return
	end

	table.insert( self.vecHeroesTookDamage, killedHero )
	table.insert( self.vecHeroesDied, killedHero )	
end

return CMapEncounter_TrapBase
