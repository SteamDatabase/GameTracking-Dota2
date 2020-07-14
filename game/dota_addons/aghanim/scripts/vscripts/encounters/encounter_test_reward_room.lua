require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TestRewardRoom == nil then
	CMapEncounter_TestRewardRoom = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TestRewardRoom:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_TestRewardRoom
