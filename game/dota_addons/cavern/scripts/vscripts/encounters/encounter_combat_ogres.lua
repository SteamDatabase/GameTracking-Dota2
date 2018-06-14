
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_ogres == nil then
	encounter_combat_ogres = class( {}, {}, CCavernEncounter )
end


--------------------------------------------------------------------

function encounter_combat_ogres:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_ogres:GetEncounterLevels()
	return { 4 }
end


--------------------------------------------------------------------

function encounter_combat_ogres:Start()

	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 2

	for i = 1, self.nNumUnitsToSpawn do
		local vRandomOffset = RandomVector( 500 )
		self:SpawnCreepByName( "npc_dota_creature_ogre_tank", self.hRoom.vRoomCenter + vRandomOffset, true, nil, nil, DOTA_TEAM_BADGUYS )
	end

	return true
end

--------------------------------------------------------------------
