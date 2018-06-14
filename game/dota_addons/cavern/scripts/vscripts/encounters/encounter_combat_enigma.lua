
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_enigma == nil then
	encounter_combat_enigma = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_enigma:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_enigma:GetEncounterLevels()
	return { 3 }
end

--------------------------------------------------------------------

function encounter_combat_enigma:Start()

	CCavernEncounter.Start( self )

	self.nNumUnitsToSpawn = 10
	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_satyr_soulstealer", self.nNumUnitsToSpawn-1, 0.6 )
	self:SpawnCreepByName( "npc_dota_creature_enigma", self.hRoom.vRoomCenter, true, nil, nil, DOTA_TEAM_BADGUYS )

	return true
end

--------------------------------------------------------------------
