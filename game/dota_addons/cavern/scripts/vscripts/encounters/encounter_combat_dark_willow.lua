
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_dark_willow == nil then
	encounter_combat_dark_willow = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_dark_willow:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_dark_willow:GetEncounterLevels()
	return { 2 }
end

--------------------------------------------------------------------

function encounter_combat_dark_willow:Start()

	CCavernEncounter.Start( self )
	
	local nStalkers = 8
	local nDarkWillows = 1
	self.nNumUnitsToSpawn = nStalkers + nDarkWillows

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_night_stalker", nStalkers, 0.5 )

	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_dark_willow", nDarkWillows, 0.2 )

	return true
end

--------------------------------------------------------------------
