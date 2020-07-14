
item_arcane_fragments = class({})

--------------------------------------------------------------------------------

function item_arcane_fragments:Precache( context )
	PrecacheResource( "particle", "particles/msg_fx/msg_bp.vpcf", context )
	PrecacheResource( "particle", "particles/generic_gameplay/arcane_fragments_splash.vpcf", context )	
end

--------------------------------------------------------------------------------

function item_arcane_fragments:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_arcane_fragments:OnSpellStart()
	if IsServer() then

		self:GetCaster():EmitSoundParams( "Item.ArcaneFragmentsClaimed", 0, 0.5, 0)
		local gameEvent = {}
		gameEvent["player_id"] = self:GetCaster():GetPlayerID()
		gameEvent["teamnumber"] = -1
		gameEvent["int_value"] = self:GetCurrentCharges()
		gameEvent["message"] = "#Aghanim_ArcaneFragmentsFound"
		FireGameEvent( "dota_combat_event_message", gameEvent )

		GameRules.Aghanim:GrantAllPlayersPoints( self:GetCurrentCharges(), false, "item_arcane_fragments" )

		UTIL_Remove( self )
	end
end

--------------------------------------------------------------------------------
