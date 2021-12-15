
require( "event_npc" )

LinkLuaModifier( "modifier_event_necrophos_life_cost", "modifiers/events/modifier_event_necrophos_life_cost", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_Necrophos == nil then
	CEvent_NPC_Necrophos = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetEventNPCName()
	return "npc_dota_creature_event_necrophos"
end

--------------------------------------------------------------------------------

EVENT_NPC_NECROPHOS_GET_LIFE = 0
EVENT_NPC_NECROPHOS_GET_SHARD = 1

NECROPHOS_LIVES_GAINED = 1
NECROPHOS_MAX_HP_LOSS = 20

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:constructor( vPos )
	self.vecPlayerHPValues = {}
	self.MinorUpgrades =  {}

	for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
		if hPlayerHero then
			-- Cache Get-Life's HP cost
			local nHPValue = math.floor( hPlayerHero:GetMaxHealth() * ( NECROPHOS_MAX_HP_LOSS / 100 ) )
			self.vecPlayerHPValues[ nPlayerID ] = nHPValue 

			self.MinorUpgrades[ nPlayerID ] = {}

			-- Choose shard upgrade
			local PossibleUpgrades = deepcopy( MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ] )
			for nMinorUpgrade=#PossibleUpgrades,1,-1 do
				local PossibleUpgrade = PossibleUpgrades[ nMinorUpgrade ]
				local szUpgradeAbilityName = PossibleUpgrade[ "ability_name" ]
				local hAbilityUpgrade = hPlayerHero:FindAbilityByName( szUpgradeAbilityName )
				if ( hAbilityUpgrade == nil or hAbilityUpgrade:IsHidden() ) then
					-- print( "Removing upgrade " .. szUpgradeAbilityName .. " for hero " .. hPlayerHero:GetUnitName() )
					table.remove( PossibleUpgrades, nMinorUpgrade )
				end
			end

			local nIndex = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, #PossibleUpgrades )
			local Upgrade = PossibleUpgrades[ nIndex ] 

			if Upgrade[ "special_values" ] == nil then 
				Upgrade[ "value" ] = Upgrade[ "value" ]
			else
				for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
					SpecialValue[ "value" ] = SpecialValue[ "value" ]
				end
			end

			table.insert( self.MinorUpgrades[ nPlayerID ], EVENT_NPC_NECROPHOS_GET_SHARD, Upgrade ) 
			table.remove( PossibleUpgrades, nIndex )
		end
	end

	CEvent_NPC.constructor( self, vPos )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}

	for nOptionResponse = EVENT_NPC_NECROPHOS_GET_LIFE, EVENT_NPC_NECROPHOS_GET_SHARD do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	if nOptionResponse == EVENT_NPC_NECROPHOS_GET_LIFE then
		EventOption[ "ability_name" ] = "necrolyte_death_seeker"
		EventOption[ "dialog_vars" ][ "lives_gained" ] = NECROPHOS_LIVES_GAINED
		EventOption[ "dialog_vars" ][ "hp_penalty" ] = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ] 
	elseif nOptionResponse == EVENT_NPC_NECROPHOS_GET_SHARD then
		EventOption[ "ability_name" ] = "necrolyte_death_pulse"

		local Upgrade = self.MinorUpgrades[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
		if Upgrade == nil then 
			return nil 
		end

		EventOption[ "dialog_vars" ] = {}
		if Upgrade[ "special_values" ] == nil then 
			EventOption[ "dialog_vars" ][ "value" ] = FormatValue( Upgrade[ "value" ] )
		else
			local nValue = 1
			for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
				EventOption[ "dialog_vars" ][ "value" .. tostring( nValue ) ] = FormatValue( SpecialValue[ "value" ] )
				nValue = nValue + 1
			end
		end

		EventOption[ "ability_name" ] = Upgrade[ "ability_name" ]
		EventOption[ "dialog_vars" ][ "ability_name" ] = tostring( "#DOTA_Tooltip_Ability_" .. Upgrade[ "ability_name" ] )
		EventOption[ "description" ] = Upgrade[ "description" ]
		EventOption[ "minor_shard" ] = 1
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_NECROPHOS_GET_LIFE then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )

		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_4 )

		EmitSoundOn( "Event_Necrophos.DeathSeeker", self:GetEntity() )

		--[[
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, self:GetEntity() );
		ParticleManager:SetParticleControl( nFXIndex, 0, hPlayerHero:GetAbsOrigin() + Vector( 0, 0, 1024 ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		]]

		-- Grant extra life if we can
		if hPlayerHero.nRespawnsRemaining >= hPlayerHero.nRespawnsMax then
			local newItem = CreateItem( "item_life_rune", nil, nil )
			newItem:SetPurchaseTime( 0 )
			local drop = CreateItemOnPositionSync( hPlayerHero:GetAbsOrigin(), newItem )
			local dropTarget = hPlayerHero:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
			newItem:LaunchLoot( false, 150, 0.75, dropTarget )
		else
			hPlayerHero.nRespawnsRemaining = math.min( hPlayerHero.nRespawnsRemaining + 1, hPlayerHero.nRespawnsMax )
			local hPlayer = hPlayerHero:GetPlayerOwner()
			if hPlayer then
				PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
				PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 0 )
			end
			
			local netTable = {}
			CustomGameEventManager:Send_ServerToPlayer( hPlayerHero:GetPlayerOwner(), "gained_life", netTable )
			CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", hPlayerHero:entindex() ), { respawns = hPlayerHero.nRespawnsRemaining } )
		end

		-- Hero pays in blood
		local kv =
		{
			duration = -1,
			hp_penalty = self.vecPlayerHPValues[ hPlayerHero:GetPlayerOwnerID() ],
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_necrophos_life_cost", kv )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, hPlayerHero:GetOrigin() )
		ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetEntity():GetForwardVector() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 10, hPlayerHero, PATTACH_ABSORIGIN_FOLLOW, nil, hPlayerHero:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Dungeon.BloodSplatterImpact", hTarget )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventNecrophos_GetLife"
		
		FireGameEvent( "dota_combat_event_message", gameEvent )
	elseif nOptionResponse == EVENT_NPC_NECROPHOS_GET_SHARD then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )

		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_1 )

		EmitSoundOn( "Event_Necrophos.GhostShroud.Cast", self:GetEntity() )

		--[[
		local nPulseNovaFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, hPlayerHero )
		ParticleManager:ReleaseParticleIndex( nPulseNovaFX )

		local kv =
		{
			duration = -1,
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_leshrac_pulse_nova", kv )
		]]

		local Upgrade = self.MinorUpgrades[ hPlayerHero:GetPlayerID() ][ nOptionResponse ]
		if Upgrade == nil then 
			print( "error, upgrade was not found" )
			return EVENT_NPC_OPTION_INVALID
		end

		--Upgrade[ "elite" ] = false

		GameRules.Aghanim:AddMinorAbilityUpgrade( hPlayerHero, Upgrade )
		EmitSoundOnLocationForPlayer( "hud.equip.agh_shard", hPlayerHero:GetAbsOrigin(), hPlayerHero:GetPlayerID() )

		local gameEvent = {}

		gameEvent["string_replace_token"] = Upgrade[ "description" ]
		gameEvent["ability_name"] = Upgrade[ "ability_name" ]
		if Upgrade[ "value" ] then 
			gameEvent["value"] = tonumber( Upgrade[ "value" ])
		else	
			if Upgrade[ "special_values" ] then 
				local nValue = 1
				for _,SpecialValue in pairs ( Upgrade[ "special_values" ] ) do
					local szValueName = "value" .. tostring( nValue )
					gameEvent[ szValueName ] = tonumber( SpecialValue[ "value" ] )
					nValue = nValue + 1
				end
			end
		end

		gameEvent["player_id"] = hPlayerHero:GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_ShardPurchase_Toast"

		--DeepPrintTable( RewardChoices )
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 

	if nOptionResponse == EVENT_NPC_NECROPHOS_GET_LIFE then
		szLines = 
		{
			"necrolyte_necr_ability_sadist_02",
			"necrolyte_necr_level_08",
			"necrolyte_necr_level_09",
			"necrolyte_necr_level_10",
			"necrolyte_necr_respawn_12",
			"necrolyte_necr_respawn_14",
			"necrolyte_necr_happy_04",
			"necrolyte_necr_happy_06",
		} 
	elseif nOptionResponse == EVENT_NPC_NECROPHOS_GET_SHARD then
		szLines = 
		{
			"necrolyte_necr_level_01",
			"necrolyte_necr_level_02",
			"necrolyte_necr_rare_01",
			"necrolyte_necr_rare_03",
			"necrolyte_necr_happy_01",
			"necrolyte_necr_happy_02",
			"necrolyte_necr_happy_03",
		} 
	end

	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Necrophos:GetInteractEventNPCVoiceLine( hPlayerHero )
	local NecrophosGreetings =
	{
		"necrolyte_necr_breath_01",
		"necrolyte_necr_breath_02",
		"necrolyte_necr_level_03",
		"necrolyte_necr_level_07",
		"necrolyte_necr_respawn_08",
		"necrolyte_necr_respawn_13",
		"necrolyte_necr_spawn_02",
		"necrolyte_necr_spawn_03",
		"necrolyte_necr_spawn_04",
		"necrolyte_necr_rare_04",
	}

	return NecrophosGreetings[ RandomInt( 1, #NecrophosGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_Necrophos
