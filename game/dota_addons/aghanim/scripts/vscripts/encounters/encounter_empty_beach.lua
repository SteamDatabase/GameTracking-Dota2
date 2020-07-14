require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_EmptyBeach == nil then
	CMapEncounter_EmptyBeach = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheUnitByNameSync( "npc_dota_shop_keeper", context, -1 )
	PrecacheModel("models/items/wards/crab_trap_ward_ward/crab_trap_ward_ward.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_back.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_bracer.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_head.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_necklace.vmdl", context)
	PrecacheModel("models/heroes/bristleback/bristleback_weapon.vmdl", context)
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
	self:SetupBristlebackShop( true )
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:OnComplete()
	CMapEncounter.OnComplete( self )
	self:SpawnWards()
end


--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:GetPreviewUnit()
	return "npc_dota_shop_keeper"
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:CheckForCompletion()

	local connectedPlayers = GameRules.Aghanim:GetConnectedPlayers()
	for i=1,#connectedPlayers do
		local nPlayerID = connectedPlayers[i]
		if GameRules.Aghanim:GetPlayerCurrentRoom( nPlayerID ) ~= self:GetRoom() then
			return false
		end
	end

	return true
end

--------------------------------------------------------------------------------

function CMapEncounter_EmptyBeach:SpawnWards()
	local wardUnits = Entities:FindAllByName( "spawner_ward" )
	local wardUnit = "npc_dota_observer_ward_beach"
	for _, spawnerUnit in pairs(wardUnits) do
		local hUnit = CreateUnitByName( wardUnit, spawnerUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
		if hUnit ~= nil then
			--print("Placing a ward")
			hUnit:SetForwardVector( RandomVector( 1 ) )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_EmptyBeach
