
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_sniper == nil then
	encounter_combat_sniper = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_sniper:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_sniper:GetEncounterLevels()
	return { 2 }
end

--------------------------------------------------------------------

function encounter_combat_sniper:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 1
	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter 
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_sniper", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		--hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * flOffsetMin )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Sniper" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_sniper:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

