
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_pangoballer == nil then
	encounter_combat_pangoballer = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_pangoballer:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_pangoballer:GetEncounterLevels()
	return { 3 }
end

--------------------------------------------------------------------

function encounter_combat_pangoballer:Start()

	CCavernEncounter.Start( self )

	local nSmallOmnis = 8
	local nLargePangos = 2
	self.nNumUnitsToSpawn = nSmallOmnis + nLargePangos

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_small_omni", nSmallOmnis, 0.6 )
	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_large_pangoballer", nLargePangos, 0.2 )

	return true
end

--------------------------------------------------------------------
