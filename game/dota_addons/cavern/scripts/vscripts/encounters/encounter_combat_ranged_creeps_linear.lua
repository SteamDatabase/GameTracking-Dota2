
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_ranged_creeps_linear == nil then
	encounter_combat_ranged_creeps_linear = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_ranged_creeps_linear:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_ranged_creeps_linear:GetEncounterLevels()
	return { 2 }
end

--------------------------------------------------------------------

function encounter_combat_ranged_creeps_linear:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 8
	self:SpawnCreepsRandomlyInRoom( "npc_dota_ranged_creep_linear", self.nNumUnitsToSpawn, 0.65 )

	return true
end

--------------------------------------------------------------------
