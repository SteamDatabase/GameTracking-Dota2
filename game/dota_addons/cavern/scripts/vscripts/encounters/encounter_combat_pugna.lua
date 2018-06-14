
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_pugna == nil then
	encounter_combat_pugna = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_pugna:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_pugna:GetEncounterLevels()
	return { 4 }
end

--------------------------------------------------------------------

function encounter_combat_pugna:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 1
	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter 
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_pugna", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * 50 )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Pugna" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_pugna:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

