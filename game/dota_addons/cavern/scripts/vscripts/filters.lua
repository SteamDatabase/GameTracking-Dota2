---------------------------------------------------------------------------
--	HealingFilter
--  *entindex_target_const
--	*entindex_healer_const
--	*entindex_inflictor_const
--	*heal
---------------------------------------------------------------------------

function CCavern:HealingFilter( filterTable )
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

function CCavern:DamageFilter( filterTable )
	return true
end


---------------------------------------------------------------------------
--	ItemAddedToInventoryFilter
--  *item_entindex_const
--	*item_parent_entindex_const
--	*inventory_parent_entindex_const
--	*suggested_slot
---------------------------------------------------------------------------

function CCavern:ItemAddedToInventoryFilter( filterTable )
	if filterTable["item_entindex_const"] == nil then 
		return true
	end

 	if filterTable["inventory_parent_entindex_const"] == nil then
		return true
	end

	local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
	local hInventoryParent = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )
	if hItem ~= nil and hInventoryParent ~= nil and hItem:GetAbilityName() ~= "item_tombstone" then
		hItem:SetPurchaser( hInventoryParent )
	end

	return true
end


---------------------------------------------------------------------------
--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration
---------------------------------------------------------------------------

function CCavern:ModifierGainedFilter( filterTable )
	return true
end