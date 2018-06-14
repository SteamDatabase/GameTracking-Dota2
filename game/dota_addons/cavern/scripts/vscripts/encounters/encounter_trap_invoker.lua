
require( "encounters/encounter_trap_base" )

if encounter_trap_invoker == nil then
	encounter_trap_invoker = class({},{}, encounter_trap_base)
end

--------------------------------------------------------------------

function encounter_trap_invoker:GetEncounterType()
	return CAVERN_ROOM_TYPE_TRAP
end

--------------------------------------------------------------------

function encounter_trap_invoker:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_trap_invoker:Start()
	encounter_trap_base.Start( self )

	self.EventQueue = CEventQueue()

	local vOffsetX = Vector( 400, 0, 0 )
	local vOffsetY = Vector( 0, 300, 0 )

	local invokerEast = self:SpawnNonCreepByName( "npc_dota_creature_invoker", self.hRoom:GetRoomCenter() + vOffsetX, true, nil, nil, DOTA_TEAM_BADGUYS )
	invokerEast.hRoom = self.hRoom

	local invokerWest = self:SpawnNonCreepByName( "npc_dota_creature_invoker", self.hRoom:GetRoomCenter() - vOffsetX, true, nil, nil, DOTA_TEAM_BADGUYS )
	invokerWest.hRoom = self.hRoom

	local invokerNorth = self:SpawnNonCreepByName( "npc_dota_creature_invoker", self.hRoom:GetRoomCenter() + vOffsetY, true, nil, nil, DOTA_TEAM_BADGUYS )
	invokerNorth.hRoom = self.hRoom

	local invokerSouth = self:SpawnNonCreepByName( "npc_dota_creature_invoker", self.hRoom:GetRoomCenter() - vOffsetY, true, nil, nil, DOTA_TEAM_BADGUYS )
	invokerSouth.hRoom = self.hRoom

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "EncounterTrapInvoker" ), function() return self:OnThink() end, 0.2 )

	return true
end

--------------------------------------------------------------------

function encounter_trap_invoker:OnThink()
	if IsServer() then
		-- empty
	end

	return nil
end

--------------------------------------------------------------------
