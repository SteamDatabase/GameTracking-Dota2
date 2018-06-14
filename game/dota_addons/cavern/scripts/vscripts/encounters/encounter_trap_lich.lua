
require( "encounters/encounter_trap_base" )

if encounter_trap_lich == nil then
	encounter_trap_lich = class({},{}, encounter_trap_base)
end

--------------------------------------------------------------------

function encounter_trap_lich:GetEncounterType()
	return CAVERN_ROOM_TYPE_TRAP
end

--------------------------------------------------------------------

function encounter_trap_lich:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_trap_lich:Start()
	encounter_trap_base.Start( self )
	self.EventQueue = CEventQueue()
	local hLich = self:SpawnNonCreepByName( "npc_dota_creature_lich", self.hRoom:GetRoomCenter() + Vector(0,250,0), true, nil, nil, DOTA_TEAM_BADGUYS )
	hLich.Statues = {}
	--hLich:AddNewModifier( hLich, nil, "modifier_creature_lich_statue", {} )
	hLich:AddNewModifier( hLich, nil, "modifier_invulnerable", {} )
	--hLich:AddNewModifier( hLich, nil, "modifier_creature_invoker", {} )

	for x = -1.5,1.5 do
		for y = -1.5,1.5 do
			if x == 0 and y == 0 then
			else
				local vPos = self.hRoom.vRoomCenter + 0.40*x*self.hRoom.vHalfX + 0.35*y*self.hRoom.vHalfY
				local hStatue = self:SpawnNonCreepByName( "npc_dota_creature_lich_statue", vPos, true, nil, nil, DOTA_TEAM_GOODGUYS )
							hStatue:SetForwardVector( Vector(RandomFloat(-0.5,0.5),-1,0) )
				hStatue:AddNewModifier( hStatue, nil, "modifier_creature_lich_statue", {} )
				--if y == -0.5 then
				table.insert( hLich.Statues, hStatue )
				--end
			end
		end
	end

	return true
end

--------------------------------------------------------------------
