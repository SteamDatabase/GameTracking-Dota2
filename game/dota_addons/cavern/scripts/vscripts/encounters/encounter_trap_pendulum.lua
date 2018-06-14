require( "encounters/encounter_trap_base" )

if encounter_trap_pendulum == nil then
	encounter_trap_pendulum = class({},{},encounter_trap_base)
end

--------------------------------------------------------------------

function encounter_trap_pendulum:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_trap_pendulum:Start()

	encounter_trap_base.Start( self )

	local vExtent = self.hRoom.hRoomVolume:GetBoundingMaxs() - self.hRoom.hRoomVolume:GetBoundingMins()
	local vHalfX = Vector( vExtent.x / 2.0, 0, 0 )
	local vHalfY = Vector( 0, vExtent.y / 2.0, 0 )
	local nTreasureCount = self.hRoom:GetRoomLevel()
	self.hChests = {}

	local PendulumAngYaw = { 0, 90, 0, 90 }
	local vPendulumPos =
	{
		self.hRoom:GetRoomCenter() + ( vHalfX * 0.5 ),
		self.hRoom:GetRoomCenter() + ( vHalfY * 0.5 ),
		self.hRoom:GetRoomCenter() - ( vHalfX * 0.5 ),
		self.hRoom:GetRoomCenter() - ( vHalfY * 0.5 )
	}

	for k = 1, 4 do
		local hPendulum = self:SpawnNonCreepByName( "npc_dota_pendulum_trap", vPendulumPos[k], true, nil, nil, DOTA_TEAM_BADGUYS )
		local vAngles = hPendulum:GetAnglesAsVector()
		hPendulum:SetAbsAngles( vAngles.x, vAngles.y - PendulumAngYaw[k], vAngles.z )	
	end
	
	return true
end

--------------------------------------------------------------------
