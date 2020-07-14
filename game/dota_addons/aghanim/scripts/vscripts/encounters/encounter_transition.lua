require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Transition == nil then
	CMapEncounter_Transition = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Transition:GetPreviewUnit()
	return "npc_dota_creature_temple_guardian"
end

--------------------------------------------------------------------------------

function CMapEncounter_Transition:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_Transition
