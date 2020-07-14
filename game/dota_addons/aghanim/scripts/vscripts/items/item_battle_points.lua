
item_battle_points = class({})

--------------------------------------------------------------------------------

function item_battle_points:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_battle_points:OnSpellStart()
	if IsServer() then

		self:GetCaster():EmitSoundParams( "Item.BattlePointsClaimed", 0, 0.5, 0)

		local gameEvent = {}
		gameEvent["player_id"] = self:GetCaster():GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["int_value"] = self:GetCurrentCharges()
		gameEvent["message"] = "#Aghanim_BattlePointsFound"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		GameRules.Aghanim:GrantAllPlayersPoints( self:GetCurrentCharges(), true, "item_battle_points" )

		UTIL_Remove( self )
	end
end

--------------------------------------------------------------------------------
