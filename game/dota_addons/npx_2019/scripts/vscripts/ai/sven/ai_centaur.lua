
--[[ ai/sven/ai_escaping_creep.lua ]]

--------------------------------------------------------------------------------



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity:SetContextThink( "EscapingCreepThink", EscapingCreepThink, 3.5 )	
end

--------------------------------------------------------------------------------

function EscapingCreepThink()
	if not IsServer() then
		return
	end
	
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = Vector( 176.738, -1330.3, 128 )
	})	
	
	return 1.0
end

--------------------------------------------------------------------------------
