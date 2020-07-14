require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_EmptyCavern == nil then
	CMapEncounter_EmptyCavern = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyCavern:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_shop_keeper", context, -1 )
	PrecacheModel("models/heroes/bristleback/bristleback_back.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_bracer.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_head.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_necklace.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_weapon.vmdl", context)
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyCavern:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
	self:SetupBristlebackShop( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyCavern:GetPreviewUnit()
	return "npc_dota_shop_keeper"
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyCavern:CheckForCompletion()

	local connectedPlayers = GameRules.Aghanim:GetConnectedPlayers()
	for i=1,#connectedPlayers do
		local nPlayerID = connectedPlayers[i]
		print( )
		if GameRules.Aghanim:GetPlayerCurrentRoom( nPlayerID ) ~= self:GetRoom() then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------

return CMapEncounter_EmptyCavern
