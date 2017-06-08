item_life_rune = class({})

--------------------------------------------------------------------------------

function item_life_rune:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

--------------------------------------------------------------------------------

function item_life_rune:OnSpellStart()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsRealHero() then
			if self:GetCaster().nRespawnsRemaining >= nMAX_RESPAWNS then
				local newItem = CreateItem( "item_life_rune", nil, nil )
				newItem:SetPurchaseTime( 0 )
				local drop = CreateItemOnPositionSync( self:GetCaster():GetAbsOrigin(), newItem )
				local dropTarget = self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
				newItem:LaunchLoot( false, 150, 0.75, dropTarget )
				self:SpendCharge()
				return
			end

			self:GetCaster().nRespawnsRemaining = math.min( self:GetCaster().nRespawnsRemaining + 1, nMAX_RESPAWNS )

			local hPlayer = self:GetCaster():GetPlayerOwner()
			if hPlayer then
				PlayerResource:SetCustomBuybackCooldown( hPlayer:GetPlayerID(), 0 )
				PlayerResource:SetCustomBuybackCost( hPlayer:GetPlayerID(), 0 )
			end
			
			local netTable = {}
			CustomGameEventManager:Send_ServerToPlayer( self:GetCaster():GetPlayerOwner(), "gained_life", netTable )
			CustomNetTables:SetTableValue( "respawns_remaining", string.format( "%d", self:GetCaster():entindex() ), { respawns = self:GetCaster().nRespawnsRemaining } )

			local gameEvent = {}
			gameEvent["player_id"] = self:GetCaster():GetPlayerOwner():GetPlayerID()
			gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_life_rune"
			gameEvent["message"] = "#Dungeon_FoundLifeRune"
			FireGameEvent( "dota_combat_event_message", gameEvent )
		end
		self:SpendCharge()
	end
end

--------------------------------------------------------------------------------