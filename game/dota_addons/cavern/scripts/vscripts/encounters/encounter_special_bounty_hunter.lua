
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_special_bounty_hunter == nil then
	encounter_special_bounty_hunter = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_special_bounty_hunter:GetEncounterType()
	return CAVERN_ROOM_TYPE_SPECIAL
end

--------------------------------------------------------------------

function encounter_special_bounty_hunter:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------

function encounter_special_bounty_hunter:Start()
	CCavernEncounter.Start( self )

	local vSpawnPoint = self.hRoom.vRoomCenter
	local szUnitName = "npc_dota_statue_bounty_hunter"
	local hUnit = self:SpawnNonCreepByName( szUnitName, vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
	if hUnit == nil then
		print( string.format( "encounter_special_shrine -- ERROR: Failed to spawn unit \"%s\"", szUnitName ) )
		return
	end

	self:SpawnForestInRoom()

	return true
end

--------------------------------------------------------------------
