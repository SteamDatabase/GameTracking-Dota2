require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TestImmediateVictory_Event == nil then
	CMapEncounter_TestImmediateVictory_Event = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TestImmediateVictory_Event:GetPreviewUnit()
	return "npc_dota_shop_keeper"
end

--------------------------------------------------------------------------------

function CMapEncounter_TestImmediateVictory_Event:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_TestImmediateVictory_Event
