
---------------------------------------------------------------------------------

function OnStartTouch( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local hBuff = hActivatorHero:FindModifierByName( "modifier_sled_penguin_movement" )
		if hBuff ~= nil then
			hBuff:GetCaster():RemoveModifierByName( "modifier_sled_penguin_movement" )
			hActivatorHero:RemoveModifierByName( "modifier_sled_penguin_movement" )

			local newItem = CreateItem( "item_bag_of_gold", nil, nil )
			newItem:SetPurchaseTime( 0 )
			newItem:SetCurrentCharges( 400 )
			local drop = CreateItemOnPositionSync( hBuff:GetCaster():GetAbsOrigin(), newItem )
			local dropTarget = hBuff:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
			newItem:LaunchLoot( true, 150, 0.75, dropTarget )
		end
	end
	
end
