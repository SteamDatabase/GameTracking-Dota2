
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "encounters/encounter_trap_base" )

--------------------------------------------------------------------------------

if CMapEncounter_TempleGarden == nil then
	CMapEncounter_TempleGarden = class( {}, {}, CMapEncounter_TrapBase )
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGarden:GetPreviewUnit()
	return "npc_dota_breathe_fire_trap"
end

--------------------------------------------------------------------------------
--[[
function CMapEncounter_TempleGarden:Start()
	CMapEncounter_TrapBase.Start( self )
	if not IsServer() then
		return
	end
	local wardUnits = Entities:FindAllByName( "spawner_ward" )
	local wardUnit = "npc_dota_observer_ward_journey"
	for _, spawnerUnit in pairs(wardUnits) do
		local hUnit = CreateUnitByName( wardUnit, spawnerUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
		if hUnit ~= nil then
			--print("Placing a ward")
			hUnit:SetForwardVector( RandomVector( 1 ) )
		end
	end
end
]]
--------------------------------------------------------------------------------

function CMapEncounter_TempleGarden:CheckForCompletion()
      if not IsServer() then
            return
      end
      local bIsComplete = CMapEncounter_TrapBase.CheckForCompletion( self )
      if bIsComplete then
         self:DisableTraps()
      end

      return bIsComplete
end

--------------------------------------------------------------------------------

function CMapEncounter_TempleGarden:DisableTraps()
	--print("Disabling Traps!")
	-- Disable any traps in the map
	local hRelays = self:GetRoom():FindAllEntitiesInRoomByName( "disable_traps_relay", false )
	--local hRelays = Entities:FindAllByName( "disable_traps_relay" )
	for _, hRelay in pairs( hRelays ) do
		hRelay:Trigger( nil, nil )
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_TempleGarden
