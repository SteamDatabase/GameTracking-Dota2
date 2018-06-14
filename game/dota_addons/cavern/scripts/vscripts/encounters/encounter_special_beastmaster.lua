
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_special_beastmaster == nil then
	encounter_special_beastmaster = class({},{}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_special_beastmaster:GetEncounterType()
	return CAVERN_ROOM_TYPE_SPECIAL
end

--------------------------------------------------------------------

function encounter_special_beastmaster:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_special_beastmaster:Start()
	CCavernEncounter.Start( self )

	local vStatueSpawnPoint = self.hRoom:GetRoomCenter()
	local szUnitName = "npc_dota_statue_beastmaster"
	local hUnit = self:SpawnNonCreepByName( szUnitName, vStatueSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
	if hUnit == nil then
		print( string.format( "encounter_special_beastmaster -- ERROR: Failed to spawn unit \"%s\"", szUnitName ) )
		return
	end

	self:SpawnForestInRoom()

	return true
end

--------------------------------------------------------------------
