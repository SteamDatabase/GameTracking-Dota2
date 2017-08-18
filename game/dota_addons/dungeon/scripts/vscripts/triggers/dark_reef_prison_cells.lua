
function OnStartTouch( trigger )
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local Key = hActivatorHero:FindItemInInventory( "item_prison_cell_key" )
		if Key ~= nil then
			local RelayName = tostring( thisEntity:GetName() .. "_logic_relay" )
			local CellDoorRelay = Entities:FindByNameNearest( RelayName, hActivatorHero:GetOrigin(), 1500 )
			if CellDoorRelay == nil then
				print( "ERROR: No trigger relay found" )
				return
			end
			--print( "Triggering relay named " .. RelayName )
			CellDoorRelay:Trigger()
			Key:SpendCharge()
			GameRules.Dungeon:OnCustomZoneEvent( "dark_reef_b", "prison_cell_opened" )
		end
	end
end

