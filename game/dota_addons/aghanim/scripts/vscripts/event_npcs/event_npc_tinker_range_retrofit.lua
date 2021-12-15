require( "event_npc" )

--------------------------------------------------------------------------------

if CEvent_NPC_Tinker_RangeRetrofit == nil then
	CEvent_NPC_Tinker_RangeRetrofit = class( {}, {}, CEvent_NPC )
	LinkLuaModifier( "modifier_tinker_event_range_retrofit", "modifiers/events/modifier_tinker_event_range_retrofit", LUA_MODIFIER_MOTION_NONE )
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetEventNPCName()
	return "npc_dota_creature_tinker_event"
end

--------------------------------------------------------------------------------

EVENT_NPC_TINKER_DECLINE = 0
EVENT_NPC_TINKER_ACCEPT_CAST_RANGE = 1
EVENT_NPC_TINKER_ACCEPT_ATTACK_RANGE = 2


EVENT_NPC_TINKER_ATTACK_RANGE_MELEE = 50
EVENT_NPC_TINKER_CAST_RANGE_MELEE = 250
EVENT_NPC_TINKER_ATTACK_RANGE_RANGED = 100
EVENT_NPC_TINKER_CAST_RANGE_RANGED = 325

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}
	for nOptionResponse = EVENT_NPC_TINKER_DECLINE, EVENT_NPC_TINKER_ACCEPT_ATTACK_RANGE do
		table.insert( EventOptionsResponses, nOptionResponse )
	end
	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}
	if nOptionResponse == EVENT_NPC_TINKER_DECLINE then 
		EventOption[ "dismiss" ] = 1 
	end
	if nOptionResponse == EVENT_NPC_TINKER_ACCEPT_CAST_RANGE or nOptionResponse == EVENT_NPC_TINKER_ACCEPT_ATTACK_RANGE then 
		if nOptionResponse == EVENT_NPC_TINKER_ACCEPT_CAST_RANGE then 
			EventOption[ "ability_name" ] = "tinker_laser"
		else
			EventOption[ "ability_name" ] = "tinker_heat_seeking_missile"
		end
		if hPlayerHero:IsRangedAttacker() then
			EventOption[ "dialog_vars" ][ "attack_range" ] = EVENT_NPC_TINKER_ATTACK_RANGE_RANGED
			EventOption[ "dialog_vars" ][ "cast_range" ] = EVENT_NPC_TINKER_CAST_RANGE_RANGED
		else
			EventOption[ "dialog_vars" ][ "attack_range" ] = EVENT_NPC_TINKER_ATTACK_RANGE_MELEE
			EventOption[ "dialog_vars" ][ "cast_range" ] = EVENT_NPC_TINKER_CAST_RANGE_MELEE
		end
	end 
	
	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	if nOptionResponse == EVENT_NPC_TINKER_ACCEPT_CAST_RANGE or nOptionResponse == EVENT_NPC_TINKER_ACCEPT_ATTACK_RANGE  then
		local nAttackRange = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "dialog_vars" ][ "attack_range" ]
		local nCastRange = self.EventOptions[ hPlayerHero:GetPlayerID() ][ nOptionResponse ][ "dialog_vars" ][ "cast_range" ]
		
		hPlayerHero.nTinkerRetrofitMode = nOptionResponse
		if nOptionResponse == EVENT_NPC_TINKER_ACCEPT_CAST_RANGE then 
			local gameEvent = {}
			gameEvent["player_id"] = hPlayerHero:GetPlayerID()
			gameEvent["teamnumber"] = -1
			gameEvent["int_value"] = nCastRange
			gameEvent["int_value2"] = nAttackRange
			gameEvent["message"] = "#DOTA_HUD_TinkerEvent_AcceptCastRange"

			--DeepPrintTable( gameEvent )
			FireGameEvent( "dota_combat_event_message", gameEvent )

			nAttackRange = nAttackRange * -1

			self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_1 ) 

			local projectile =
			{
				Target = hPlayerHero,
				Source = self:GetEntity(),
				vTargetLoc = hPlayerHero:GetAbsOrigin(),
				Ability = self:GetEntity():FindAbilityByName( "aghsfort_tinker_retrofit_ability" ),
				EffectName = "particles/units/heroes/hero_tinker/tinker_laser.vpcf",
				iMoveSpeed = 900,
				bDodgeable = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
			}

			ProjectileManager:CreateTrackingProjectile( projectile )

			EmitSoundOn( "Hero_Tinker.Laser", self:GetEntity() )

			
		else
			local gameEvent = {}
			gameEvent["player_id"] = hPlayerHero:GetPlayerID()
			gameEvent["teamnumber"] = -1
			gameEvent["int_value"] = nAttackRange
			gameEvent["int_value2"] = nCastRange
			gameEvent["message"] = "#DOTA_HUD_TinkerEvent_AcceptAttackRange"

			--DeepPrintTable( gameEvent )
			FireGameEvent( "dota_combat_event_message", gameEvent )

			nCastRange = nCastRange * -1 

			self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_2 )

			local projectile =
			{
				Target = hPlayerHero,
				Source = self:GetEntity(),
				vTargetLoc = hPlayerHero:GetAbsOrigin(),
				Ability =  self:GetEntity():FindAbilityByName( "aghsfort_tinker_retrofit_ability" ),
				EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
				iMoveSpeed = 700,
				bDodgeable = false,
				bProvidesVision = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3,
			}

			ProjectileManager:CreateTrackingProjectile( projectile )

			EmitSoundOn( "Hero_Tinker.Heat-Seeking_Missile" , self:GetEntity() )
		end

		local kv = { }
		kv[ "duration" ] = -1
		kv[ "attack_range" ] = nAttackRange
		kv[ "cast_range" ] = nCastRange 
		hPlayerHero:AddNewModifier( self:GetEntity(), nil, "modifier_tinker_event_range_retrofit", kv )
	end

	if nOptionResponse == EVENT_NPC_TINKER_DECLINE then 
		return EVENT_NPC_OPTION_DISMISS
	end

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 



	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_Tinker_RangeRetrofit:GetInteractEventNPCVoiceLine( hPlayerHero )
	local MorphGreetings =
	{
		
	}
	return MorphGreetings[ RandomInt( 1, #MorphGreetings ) ]
end

return CEvent_NPC_Tinker_RangeRetrofit