require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Event_BristlebackFragmentShop == nil then
	CMapEncounter_Event_BristlebackFragmentShop = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BristlebackFragmentShop:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_shop_keeper", context, -1 )
	PrecacheModel("models/heroes/bristleback/bristleback_back.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_bracer.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_head.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_necklace.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_weapon.vmdl", context)
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BristlebackFragmentShop:GetPreviewUnit()
	return "npc_dota_shop_keeper"
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BristlebackFragmentShop:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
	self:SetupBristlebackShop( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_Event_BristlebackFragmentShop:CheckForCompletion()
	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_Event_BristlebackFragmentShop
