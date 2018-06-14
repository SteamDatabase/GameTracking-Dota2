
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_combat_ghosts == nil then
	encounter_combat_ghosts = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_combat_ghosts:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_ghosts:GetEncounterLevels()
	return { 2 }
end

--------------------------------------------------------------------

function encounter_combat_ghosts:Start()
	CCavernEncounter.Start( self )
	
	self.nNumUnitsToSpawn = 15
	self:SpawnCreepsRandomlyInRoom( "npc_dota_creature_ghost", self.nNumUnitsToSpawn, 0.63 )
	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "Ghost" ), function() return self:OnThink() end, 0.0 )

	return true
end

--------------------------------------------------------------------

function encounter_combat_ghosts:OnThink()
	if IsServer() then
		if not self.bActive then
			return nil
		end

		return 1.0
	end
end

--------------------------------------------------------------------

