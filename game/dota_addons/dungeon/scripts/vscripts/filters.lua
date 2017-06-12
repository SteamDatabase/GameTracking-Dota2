---------------------------------------------------------------------------
--	HealingFilter
--  *entindex_target_const
--	*entindex_healer_const
--	*entindex_inflictor_const
--	*heal
---------------------------------------------------------------------------

function CDungeon:HealingFilter( filterTable )
	local nHeal = filterTable["heal"]
	if filterTable["entindex_healer_const"] == nil then
		return true
	end

	local hHealingHero = EntIndexToHScript( filterTable["entindex_healer_const"] )
	if nHeal > 0 and hHealingHero ~= nil and hHealingHero:IsRealHero() then
		for _,Zone in pairs( self.Zones ) do
			if Zone:ContainsUnit( hHealingHero ) then
				Zone:AddStat( hHealingHero:GetPlayerID(), ZONE_STAT_HEALING, nHeal )
				return true
			end
		end
	end
	return true
end

---------------------------------------------------------------------------
--	DamageFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage
---------------------------------------------------------------------------

function CDungeon:DamageFilter( filterTable )
	local flDamage = filterTable["damage"]
	if filterTable["entindex_attacker_const"] == nil then
		return true
	end
	local hAttackerHero = EntIndexToHScript( filterTable["entindex_attacker_const"] )
	if flDamage > 0 and hAttackerHero ~= nil and hAttackerHero:IsRealHero() then
		for _,Zone in pairs( self.Zones ) do
			if Zone:ContainsUnit( hAttackerHero ) then
				Zone:AddStat( hAttackerHero:GetPlayerID(), ZONE_STAT_DAMAGE, flDamage )
				return true
			end
		end
	end
	return true
end

---------------------------------------------------------------------------
--	ItemAddedToInventoryFilter
--  *item_entindex_const
--	*item_parent_entindex_const
--	*inventory_parent_entindex_const
--	*suggested_slot
---------------------------------------------------------------------------

function CDungeon:ItemAddedToInventoryFilter( filterTable )
	if filterTable["item_entindex_const"] == nil then 
		return true
	end

 	if filterTable["inventory_parent_entindex_const"] == nil then
		return true
	end

	local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
	local hInventoryParent = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )
	if hItem ~= nil and hItem.bIsRelic ~= true and hInventoryParent ~= nil and hItem:GetAbilityName() ~= "item_tombstone" then
		if hItem:GetAbilityName() == "item_orb_of_passage" then
			if hInventoryParent:IsRealHero() == false and hInventoryParent:IsIllusion() == false then
				local drop = CreateItemOnPositionSync( hInventoryParent:GetAbsOrigin(), hItem )
				local dropTarget = hInventoryParent:GetAbsOrigin() + RandomVector( 1 ) * 200
				hItem:LaunchLoot( false, 150, 0.75, dropTarget )
				return true
			end
			if hItem.bKeyItemNotified ~= true and hInventoryParent:IsRealHero() then
				hItem.bKeyItemNotified = true
				
				local gameEvent = {}
				gameEvent["player_id"] = hInventoryParent:GetPlayerID()
				gameEvent["team_number"] = DOTA_TEAM_GOODGUYS
				gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. hItem:GetAbilityName()
				gameEvent["message"] = "#Dungeon_KeyItem"
				FireGameEvent( "dota_combat_event_message", gameEvent )

				local szEventZoneName = nil
				for _,Zone in pairs( self.Zones ) do
					if Zone:ContainsUnit( hInventoryParent ) then
						szEventZoneName = Zone.szName
					end
				end
				if szEventZoneName ~= nil then
					for _,Zone in pairs ( self.Zones ) do
						Zone:OnKeyItemPickedUp( szEventZoneName, hItem:GetAbilityName() )
					end
				end
			end
		end

		hItem:SetPurchaser( hInventoryParent )
		if hItem:GetAbilityName() == "item_life_rune" then
			hItem:SetCastOnPickup( true )
		end
	end

	return true
end