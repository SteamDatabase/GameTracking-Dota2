modifier_boss_visage_familiar_passive = class({})

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:OnCreated( kv )

end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:GetMinHealth( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_passive:OnTakeDamage( params )
	if IsServer() then
		if params.unit == self:GetParent() and self:GetParent():GetHealthPercent() < 2 then
			self:GetAbility():OnSpellStart()

			local vLocation = self:GetParent():GetAbsOrigin()
			if RollPercentage( HEALTH_POTION_DROP_PCT * 3 ) then
				local newItem = CreateItem( "item_health_potion", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( true )
				end

				local drop = CreateItemOnPositionSync( vLocation, newItem )
				newItem:LaunchLoot( true, 300, 0.75, vLocation )
			end

			if RollPercentage( MANA_POTION_DROP_PCT * 3 ) then
				local newItem = CreateItem( "item_mana_potion", nil, nil )
				newItem:SetPurchaseTime( 0 )
				if newItem:IsPermanent() and newItem:GetShareability() == ITEM_FULLY_SHAREABLE then
					item:SetStacksWithOtherOwners( true )
				end

				local drop = CreateItemOnPositionSync( vLocation, newItem )
				newItem:LaunchLoot( true, 300, 0.75, vLocation )
			end
			
		end
	end
	return 0
end