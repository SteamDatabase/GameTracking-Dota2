
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_juggernaut == nil then
	encounter_combat_juggernaut = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_juggernaut:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_juggernaut:GetEncounterLevels()
	return { 2 }
end

--------------------------------------------------------------------

function encounter_combat_juggernaut:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 4
	local flOffsetMin = 250
	local flOffsetMax = 1000

	for i = 1, self.nNumUnitsToSpawn do
		local vSpawnPoint = self.hRoom.vRoomCenter + ( RandomVector( 1 ) * RandomFloat( flOffsetMin, flOffsetMax ) )
		local hUnit = self:SpawnCreepByName( "npc_dota_creature_juggernaut", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
		hUnit:FaceTowards( vSpawnPoint + RandomVector( 1 ) * flOffsetMin )
	end

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Juggernaut" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_juggernaut:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

