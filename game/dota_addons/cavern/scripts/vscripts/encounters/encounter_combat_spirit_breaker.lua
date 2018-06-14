
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_spirit_breaker == nil then
	encounter_combat_spirit_breaker = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_spirit_breaker:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_spirit_breaker:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_spirit_breaker:Start()

	CCavernEncounter.Start( self )

	self.nNumUnitsToSpawn = 16
	local flOffsetMin = 250
	local flOffsetMax = 1000

	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter + ( RandomVector( 1 ) * RandomFloat( flOffsetMin, flOffsetMax ) )
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_spirit_breaker", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * flOffsetMin )
	end

	return true
end

--------------------------------------------------------------------
