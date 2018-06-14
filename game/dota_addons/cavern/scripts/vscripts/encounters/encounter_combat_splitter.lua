
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_splitter == nil then
	encounter_combat_splitter = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_splitter:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_splitter:GetEncounterLevels()
	return { 3 }
end

--------------------------------------------------------------------

function encounter_combat_splitter:Start()

	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 50
	local flOffsetMin = 200
	local flOffsetMax = 400

	for i = 1,2 do
		local vSpawnPoint = self.hRoom.vRoomCenter + ( RandomVector( 1 ) * RandomFloat( flOffsetMin, flOffsetMax ) )
		local hUnit = self:SpawnCreepByName( "npc_dota_splitter_1", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * flOffsetMin )
	end

	return true
end

--------------------------------------------------------------------
