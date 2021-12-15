
item_quest_star = class({})

--------------------------------------------------------------------------------

function item_quest_star:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_quest_star:OnSpellStart()
	if IsServer() then

		self:GetCaster():EmitSoundParams( "Item.BattlePointsClaimed", 0, 0.5, 0)

		local gameEvent = {}
		--gameEvent["player_id"] = self:GetCaster():GetPlayerID()
		gameEvent["teamnumber"] = -1
		--gameEvent["int_value"] = self:GetCurrentCharges()
		gameEvent["message"] = "#Aghanim_QuestStarFound"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		GameRules.Aghanim:GrantAllPlayersQuestStar()

		UTIL_Remove( self )
	end
end

--------------------------------------------------------------------------------
