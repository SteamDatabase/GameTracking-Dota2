require( "cavern_encounter" )

if encounter_trap_base == nil then
	encounter_trap_base = class({},{},CCavernEncounter)
end

--------------------------------------------------------------------

function encounter_trap_base:GetEncounterType()
	return CAVERN_ROOM_TYPE_TRAP
end

--------------------------------------------------------------------

function encounter_trap_base:Start()
	CCavernEncounter.Start( self )
end

--------------------------------------------------------------------
function encounter_trap_base:OnStartComplete()
	CCavernEncounter.OnStartComplete( self )
end

--------------------------------------------------------------------

function encounter_trap_base:IsCleared()
	return false
end

--------------------------------------------------------------------

function encounter_trap_base:GetTreasureLevel()
	return self.hRoom:GetRoomLevel()
end

--------------------------------------------------------------------
