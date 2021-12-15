require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TestImmediateVictory == nil then
	CMapEncounter_TestImmediateVictory = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TestImmediateVictory:GetPreviewUnit()
	return "npc_dota_shop_keeper"
end

--------------------------------------------------------------------------------

function CMapEncounter_TestImmediateVictory:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_TestImmediateVictory
