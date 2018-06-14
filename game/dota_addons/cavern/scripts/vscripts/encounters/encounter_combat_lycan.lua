
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_lycan == nil then
	encounter_combat_lycan = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_lycan:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_lycan:GetEncounterLevels()
	return { 4 }
end

--------------------------------------------------------------------

function encounter_combat_lycan:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 1
	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter 
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_lycan", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * 50 )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Lycan" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_lycan:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

