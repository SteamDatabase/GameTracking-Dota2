
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_special_breakable_containers == nil then
	encounter_special_breakable_containers = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_special_breakable_containers:GetEncounterType()
	return CAVERN_ROOM_TYPE_SPECIAL
end

--------------------------------------------------------------------

function encounter_special_breakable_containers:GetEncounterLevels()
	return { 1, 2, 3 }
end

--------------------------------------------------------------------

function encounter_special_breakable_containers:Start()

	CCavernEncounter.Start( self )
	
	local nSpawnCount = 25 * self.hRoom:GetRoomLevel()

	for i = 1, nSpawnCount do
		local hUnit = self:SpawnNonCreepByName( "npc_dota_crate", self.hRoom.vRoomCenter + RandomVector( RandomFloat( 0, 700 ) ), true, nil, nil, DOTA_TEAM_BADGUYS )
		if hUnit ~= nil then
			hUnit.hEncounter = self -- unit will catch this in the modifier's OnCreated
			hUnit:AddNewModifier( hUnit, self, "modifier_breakable_container", { } )
		end
	end

	return true
end

--------------------------------------------------------------------
