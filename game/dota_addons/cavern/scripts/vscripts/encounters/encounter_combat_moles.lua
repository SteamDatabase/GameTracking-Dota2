
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_moles == nil then
	encounter_combat_moles = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_moles:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_moles:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_moles:Start()

	CCavernEncounter.Start( self )
	
	local nSmallMoles = 9
	local nLargeMoles = 2
	self.nNumUnitsToSpawn = nSmallMoles + nLargeMoles

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_small_eimermole", nSmallMoles, 0.5 )

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_large_eimermole", nLargeMoles, 0.2 )

	return true
end

--------------------------------------------------------------------
