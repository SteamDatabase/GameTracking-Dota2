require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_GoldShop == nil then
	CMapEncounter_Event_GoldShop = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_GoldShop:GetPreviewUnit()
	return "npc_dota_shop_keeper_lost_meepo"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_GoldShop:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_GoldShop
