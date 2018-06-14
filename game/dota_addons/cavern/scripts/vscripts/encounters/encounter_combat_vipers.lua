
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_vipers == nil then
	encounter_combat_vipers = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_vipers:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_vipers:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_vipers:Start()

	CCavernEncounter.Start( self )
	
	local nLittleVipers = 10
	local nBigVipers = 2
	self.nNumUnitsToSpawn = nLittleVipers + nBigVipers

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_viper", nLittleVipers, 0.65 )

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_big_viper", nBigVipers, 0.2 )

	return true
end

--------------------------------------------------------------------
