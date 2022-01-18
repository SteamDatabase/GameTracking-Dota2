
require( "event_npc" )

LinkLuaModifier( "modifier_event_ogre_magi_casino_bloodlust", "modifiers/events/modifier_event_ogre_magi_casino_bloodlust", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

if CEvent_NPC_OgreMagiCasino == nil then
	CEvent_NPC_OgreMagiCasino = class( {}, {}, CEvent_NPC )
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetEventNPCName()
	return "npc_dota_creature_event_ogre_magi"
end

--------------------------------------------------------------------------------


EVENT_NPC_OGRE_MAGI_RANDOM_NEUTRAL_ITEM = 0
EVENT_NPC_OGRE_MAGI_GET_BLOODLUSTED = 1
EVENT_NPC_OGRE_MAGI_RANDOM_GOLD = 2

OGRE_MAGI_RANDOM_GOLD_SMALL_PCT = 60
OGRE_MAGI_RANDOM_GOLD_MED_PCT = 30
OGRE_MAGI_RANDOM_GOLD_BIG_PCT = 10

OGRE_MAGI_RANDOM_GOLD_SMALL_MIN = 150
OGRE_MAGI_RANDOM_GOLD_SMALL_MAX = 300
OGRE_MAGI_RANDOM_GOLD_MED_MIN = 300
OGRE_MAGI_RANDOM_GOLD_MED_MAX = 750
OGRE_MAGI_RANDOM_GOLD_BIG_MIN = 750
OGRE_MAGI_RANDOM_GOLD_BIG_MAX = 1000

OGRE_MAGI_BLOODLUST_ENCOUNTERS = 3
OGRE_MAGI_BLOODLUST_ATTACK_SPEED = 60
OGRE_MAGI_BLOODLUST_MOVE_SPEED_PCT = 15
OGRE_MAGI_BLOODLUST_MODEL_SCALE = 25
OGRE_MAGI_UPGRADE_SHARD_COST = 300

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetEventOptionsResponses( hPlayerHero )
	local EventOptionsResponses = {}

	for nOptionResponse = EVENT_NPC_OGRE_MAGI_RANDOM_NEUTRAL_ITEM, EVENT_NPC_OGRE_MAGI_RANDOM_GOLD do
		table.insert( EventOptionsResponses, nOptionResponse )
	end

	return EventOptionsResponses
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetEventOptionData( hPlayerHero, nOptionResponse )
	local EventOption = {}
	EventOption[ "dialog_vars" ] = {}

	-- if nOptionResponse == EVENT_NPC_OGRE_MAGI_UPGRADE_SHARD then 
	-- 	EventOption[ "description" ] = "#npc_dota_creature_event_ogre_magi_upgrade_shard"
	-- 	EventOption[ "item_name" ] = "item_aghanims_shard_roshan"
	-- end

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_RANDOM_NEUTRAL_ITEM then 
		EventOption[ "image" ] = "items/sample_picker.png"	
	end

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_GET_BLOODLUSTED then 
		EventOption[ "ability_name" ] = "ogre_magi_bloodlust"
		EventOption[ "dialog_vars" ][ "bloodlust_encounters" ] = OGRE_MAGI_BLOODLUST_ENCOUNTERS
	end

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_RANDOM_GOLD then 
		EventOption[ "image" ] = "items/hand_of_midas_ogre_arcana.png"
		EventOption[ "dialog_vars" ][ "min_gold_value" ] = OGRE_MAGI_RANDOM_GOLD_SMALL_MIN
		EventOption[ "dialog_vars" ][ "max_gold_value" ] = OGRE_MAGI_RANDOM_GOLD_BIG_MAX
	end

	return EventOption
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetInteractionLimitForNPC()
	return EVENT_NPC_SINGLE_CHOICE 
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetStockCountType( hPlayerHero, nOptionResponse )
	return EVENT_NPC_STOCK_TYPE_INDEPENDENT
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetOptionGoldCost( nPlayerID, nOptionResponse )
	if nOptionResponse == EVENT_NPC_OGRE_MAGI_UPGRADE_SHARD then 
		return OGRE_MAGI_UPGRADE_SHARD_COST
	end

	return 0
end


--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:OnInteractWithNPCResponse( hPlayerHero, nOptionResponse )
	-- if nOptionResponse == EVENT_NPC_OGRE_MAGI_UPGRADE_SHARD then
	-- 	if hPlayerHero.MinorAbilityUpgrades == nil or hPlayerHero.MinorAbilityUpgrades == {} then 
	-- 		print( "No minor upgrade shards" )
	-- 		return EVENT_NPC_OPTION_INVALID
	-- 	end

	-- 	local vecShardRewards = {}
	-- 	local nCurDepth = GameRules.Aghanim:GetCurrentRoom():GetDepth()
	-- 	for i = nCurDepth, 2, -1 do 
	-- 		local szNextDepth = tostring( i )
	-- 		local vecDepthRewards = CustomNetTables:GetTableValue( "reward_choices", szNextDepth )
	-- 		if vecDepthRewards ~= nil then 
	-- 			PrintTable( vecDepthRewards, " xxx " )
	-- 			local PlayerReward = vecDepthRewards[ tostring( hPlayerHero:GetPlayerOwnerID() ) ]
	-- 			if PlayerReward then 
	-- 				PrintTable( PlayerReward, " yyy " )
	-- 			end

	-- 			if PlayerReward and PlayerReward[ "elite" ] == 0 and PlayerReward[ "reward_type" ] == "REWARD_TYPE_MINOR_ABILITY_UPGRADE" then 
	-- 				print( "found potential upgradable minor shard" )
	-- 				PrintTable( PlayerReward, "-->" )
	-- 				table.insert( vecShardRewards, PlayerReward )
	-- 			end
	-- 		else
	-- 			print( "No minor upgrade rewards found????" )
	-- 		end
	-- 	end

	-- 	if #vecShardRewards == 0 then 
	-- 		print( "No minor upgrade rewards found" )
	-- 		return EVENT_NPC_OPTION_INVALID 
	-- 	end

	-- 	local nIndexToChoose = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, #vecShardRewards )
	-- 	local RewardToUpgrade = vecShardRewards[ nIndexToChoose ]
	-- 	if RewardToUpgrade == nil then 
	-- 		print( "Random selection failed" )
	-- 		return EVENT_NPC_OPTION_INVALID
	-- 	end

	-- 	local UpgradeDataTable = deepcopy( MINOR_ABILITY_UPGRADES[ hPlayerHero:GetUnitName() ][ RewardToUpgrade[ "id" ] ] )
	-- 	if UpgradeDataTable == nil then 
	-- 		print( "Can't find upgrade in data table" )
	-- 		return EVENT_NPC_OPTION_INVALID
	-- 	end
		
	-- 	print( "Upgrading shard:" )
	-- 	PrintTable( RewardToUpgrade, "-$$$- " )
		
	-- 	RewardToUpgrade[ "elite" ] = 1

	-- 	for szAbilityName,vecAbilityUpgrades in pairs ( hPlayerHero.MinorAbilityUpgrades ) do 
	-- 		if szAbilityName == UpgradeDataTable[ "ability_name" ] then
	-- 			for szSpecialValueName, vecSpecialValueUpgrades in pairs ( vecAbilityUpgrades ) do 
	-- 				if UpgradeDataTable[ "special_values" ] == nil then 
	-- 					if szSpecialValueName == UpgradeDataTable[ "special_value_name" ] then 
	-- 						for k,v in pairs( vecSpecialValueUpgrades ) do 
	-- 							if not v[ "elite" ] then 
	-- 								local flOldValue = v[ "value" ]
	-- 								v[ "value" ] = v[ "value" ] * ELITE_VALUE_MODIFIER
	-- 								print( "Found and upgraded shard for " .. szAbilityName .. " " .. szSpecialValueName .. " from " .. flOldValue .. " to " .. v[ "value"] )
	-- 								break
	-- 							end
	-- 						end
	-- 					end
	-- 				else
	-- 					for _,SpecialValue in pairs ( UpgradeDataTable[ "special_values" ] ) do
	-- 						if szSpecialValueName == SpecialValue[ "special_value_name" ] then 
	-- 							for k,v in pairs( vecSpecialValueUpgrades ) do 
	-- 								if not v[ "elite" ] then 
	-- 									local flOldValue = v[ "value" ]
	-- 									v[ "value" ] = v[ "value" ] * ELITE_VALUE_MODIFIER
	-- 									print( "Found and upgraded shard for " .. szAbilityName .. " " .. szSpecialValueName .. " from " .. flOldValue .. " to " .. v[ "value"] )
	-- 									break
	-- 								end
	-- 							end
	-- 						end
	-- 					end
	-- 				end
	-- 			end

	-- 			break 
	-- 		end
	-- 	end

	-- 	CustomNetTables:SetTableValue( "minor_ability_upgrades", tostring( hPlayerHero:GetPlayerOwnerID() ), hPlayerHero.MinorAbilityUpgrades )

	-- 	local Buff = hPlayerHero:FindModifierByName( "modifier_minor_ability_upgrades" )
	-- 	if Buff == nil then
	-- 		print( "Error - No minor ability upgrade buff!" )
	-- 		return
	-- 	end
		
	-- 	Buff:ForceRefresh()

	-- 	local hAbility = hPlayerHero:FindAbilityByName( UpgradeDataTable[ "ability_name" ] )
	-- 	if hAbility ~= nil then
	-- 		if hAbility:GetIntrinsicModifierName() ~= nil then
	-- 			local hIntrinsicModifier = hPlayerHero:FindModifierByName( hAbility:GetIntrinsicModifierName() )
	-- 			if hIntrinsicModifier then
	-- 				hIntrinsicModifier:ForceRefresh()
	-- 			end
	-- 		end
	-- 	end

	-- 	local gameEvent = {}
	-- 	gameEvent[ "string_replace_token" ] = UpgradeDataTable[ "description" ]
	-- 	gameEvent[ "ability_name" ] = UpgradeDataTable[ "ability_name" ]
	-- 	if UpgradeDataTable[ "value" ] then 
	-- 		gameEvent["value"] = tonumber( UpgradeDataTable[ "value" ] * ELITE_VALUE_MODIFIER )
	-- 	else	
	-- 		if UpgradeDataTable[ "special_values" ] then 
	-- 			local nValue = 1
	-- 			for _,SpecialValue in pairs ( UpgradeDataTable[ "special_values" ] ) do
	-- 				local szValueName = "value" .. tostring( nValue )
	-- 				gameEvent[ szValueName ] = tonumber( SpecialValue[ "value" ] * ELITE_VALUE_MODIFIER )
	-- 				nValue = nValue + 1
	-- 			end
	-- 		end
	-- 	end
	-- 	gameEvent[ "player_id" ] = hPlayerHero:GetPlayerOwnerID()
	-- 	gameEvent[ "teamnumber"]  = -1
	-- 	gameEvent[ "message" ] = "#DOTA_HUD_EventOgreMagi_UpgradeShard"
	-- 	FireGameEvent( "dota_combat_event_message", gameEvent )
	-- end

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_RANDOM_NEUTRAL_ITEM then 
		local bGoodItem = false 
		if GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 0, 1 ) == 1 then
			bGoodItem = true
		end

		local szItemName = nil 
		if bGoodItem == false and GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, 100 ) == 1 then
			szItemName = "item_royal_jelly"
			if GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 0, 1 ) == 1 then 
				szItemName = "item_mango_tree"
			end
		else
			szItemName = GameRules.Aghanim:PrepareNeutralItemDrop( GameRules.Aghanim:GetCurrentRoom(), bGoodItem )
		end
		 
		if szItemName == nil or szItemName == "" then 
			print( "item response is nil?" )
			return nil
		end

		GameRules.Aghanim:MarkNeutralItemAsDropped( szItemName )

		local hItem = DropNeutralItemAtPositionForHero( szItemName, self:GetEntity():GetAbsOrigin(), hPlayerHero, -1, true )
		if hItem then 
			hPlayerHero:PickupDroppedItem( hItem )
		end

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. szItemName
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventOgreMagi_RandomNeutralItem"
		
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end 

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_GET_BLOODLUSTED then 
		self:GetEntity():FaceTowards( hPlayerHero:GetAbsOrigin() )
		self:GetEntity():StartGesture( ACT_DOTA_CAST_ABILITY_3 )

		EmitSoundOn( "Hero_OgreMagi.Bloodlust.Target", hPlayerHero )
		EmitSoundOn( "Hero_OgreMagi.Bloodlust.Target.FP", hPlayerHero )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetEntity() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetEntity(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetEntity():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetEntity(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetEntity():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, hPlayerHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, hPlayerHero, PATTACH_ABSORIGIN_FOLLOW, nil, hPlayerHero:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local kv = 
		{
			duration = -1,
			move_speed_pct = OGRE_MAGI_BLOODLUST_MOVE_SPEED_PCT,
			attack_speed = OGRE_MAGI_BLOODLUST_ATTACK_SPEED,
			model_scale = OGRE_MAGI_BLOODLUST_MODEL_SCALE,
			encounters_remaining = OGRE_MAGI_BLOODLUST_ENCOUNTERS,
		}
	
		hPlayerHero:AddNewModifier( hPlayerHero, nil, "modifier_event_ogre_magi_casino_bloodlust", kv )

		local gameEvent = {}
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["int_value"] = OGRE_MAGI_BLOODLUST_ENCOUNTERS
		gameEvent["teamnumber"] = -1
		gameEvent["message"] = "#DOTA_HUD_EventOgreMagi_Bloodlust"
		
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	if nOptionResponse == EVENT_NPC_OGRE_MAGI_RANDOM_GOLD then 
		local nResult = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( 1, 100 )
		local nGoldReward = 0

		local nBigRewardThreshold = 100 - OGRE_MAGI_RANDOM_GOLD_BIG_PCT 
		local nMedRewardThreshold = nBigRewardThreshold - OGRE_MAGI_RANDOM_GOLD_MED_PCT 
		local nSmallRewardThreshold = nMedRewardThreshold - OGRE_MAGI_RANDOM_GOLD_SMALL_PCT

		local gameEvent = {}
		gameEvent["message"] = "#DOTA_Hud_EventOgreMagi_GambleGold"
		gameEvent["player_id"] = hPlayerHero:GetPlayerOwnerID()
		gameEvent["teamnumber"] = -1

		if nResult >= nBigRewardThreshold then 
			nGoldReward = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( OGRE_MAGI_RANDOM_GOLD_BIG_MIN, OGRE_MAGI_RANDOM_GOLD_BIG_MAX )
			gameEvent["message"] = "#DOTA_Hud_EventOgreMagi_GambleGold_Jackpot"
		end 

		if nResult < nBigRewardThreshold and nResult >= nMedRewardThreshold then 
			nGoldReward = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( OGRE_MAGI_RANDOM_GOLD_MED_MIN, OGRE_MAGI_RANDOM_GOLD_MED_MAX )
		end

		if nResult < nMedRewardThreshold and nResult >= nSmallRewardThreshold then
			nGoldReward = GameRules.Aghanim:GetCurrentRoom():RoomRandomInt( OGRE_MAGI_RANDOM_GOLD_SMALL_MIN, OGRE_MAGI_RANDOM_GOLD_SMALL_MAX )
		end

		local nActualGold = self:GiveGoldToPlayer( hPlayerHero, nGoldReward )

 		gameEvent[ "int_value" ] = nActualGold
 		FireGameEvent( "dota_combat_event_message", gameEvent )
	end  

	return nOptionResponse
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetInteractResponseEventNPCVoiceLine( hPlayerHero, nOptionResponse )
	local szLines = {} 


	return szLines[ RandomInt( 1, #szLines ) ]
end

--------------------------------------------------------------------------------

function CEvent_NPC_OgreMagiCasino:GetInteractEventNPCVoiceLine( hPlayerHero )
	local OgreGreetings =
	{

	}

	return OgreGreetings[ RandomInt( 1, #OgreGreetings ) ]
end

--------------------------------------------------------------------------------

return CEvent_NPC_OgreMagiCasino
