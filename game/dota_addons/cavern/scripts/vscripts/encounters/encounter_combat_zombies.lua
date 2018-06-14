
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_zombies == nil then
	encounter_combat_zombies = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_zombies:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_zombies:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_zombies:Start()

	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 15
	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_basic_zombie", self.nNumUnitsToSpawn, 0.7 )

	return true
end

--------------------------------------------------------------------
