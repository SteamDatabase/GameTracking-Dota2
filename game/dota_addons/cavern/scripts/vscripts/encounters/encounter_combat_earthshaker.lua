
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_earthshaker == nil then
	encounter_combat_earthshaker = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_earthshaker:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_earthshaker:GetEncounterLevels()
	return { 4 }
end

--------------------------------------------------------------------

function encounter_combat_earthshaker:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 1
	local flOffsetMin = 0
	local flOffsetMax = 200

	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter + ( RandomVector( 1 ) * RandomFloat( flOffsetMin, flOffsetMax ) )
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_earthshaker", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * 50 )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Earthshaker" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_earthshaker:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

