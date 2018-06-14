
require( "cavern_encounter" )

--------------------------------------------------------------------

if encounter_special_serpent_wards == nil then
	encounter_special_serpent_wards = class( {}, {}, CCavernEncounter )
end

--------------------------------------------------------------------

function encounter_special_serpent_wards:GetEncounterType()
	return CAVERN_ROOM_TYPE_SPECIAL
end

--------------------------------------------------------------------

function encounter_special_serpent_wards:GetEncounterLevels()
	return { 1, 2, 3, 4 }
end

--------------------------------------------------------------------

function encounter_special_serpent_wards:Start()

	CCavernEncounter.Start( self )

	--[[
	local vLeftColumnStart = self.hRoom.vRoomCenter - 0.80*self.hRoom.vHalfX - 0.40*self.hRoom.vHalfY
	local vRightColumnStart = self.hRoom.vRoomCenter + 0.80*self.hRoom.vHalfX - 0.40*self.hRoom.vHalfY
	local vBottomRowStart = self.hRoom.vRoomCenter + 0.35*self.hRoom.vHalfX - 0.40*self.hRoom.vHalfY
	local dx = 100
	local dy = 150
	for x=1,2 do
		for y=1,5 do
			local vPos = vLeftColumnStart + Vector(x*dx,0,0) + Vector(0,y*dy,0)
			local hUnit = self:SpawnNonCreepByName( "npc_dota_creature_shadow_shaman_ward", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
			local vPos = vRightColumnStart - Vector(x*dx,0,0) + Vector(0,y*dy,0)
			local hUnit = self:SpawnNonCreepByName( "npc_dota_creature_shadow_shaman_ward", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
			local vPos = vBottomRowStart - Vector(y*dy,0,0) - Vector(0,x*dx,0)
			local hUnit = self:SpawnNonCreepByName( "npc_dota_creature_shadow_shaman_ward", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
		end
	end
	--]]

	local vLeftColumnStart = self.hRoom.vRoomCenter - 0.85*self.hRoom.vHalfX - 0.85*self.hRoom.vHalfY
	local dx = 200
	local dy = 200
	for x=1,10 do
		for y=1,7 do
			local vPos = vLeftColumnStart + Vector(x*dx,0,0) + Vector(0,y*dy,0)
			local hUnit = self:SpawnNonCreepByName( "npc_dota_creature_shadow_shaman_ward", vPos, false, nil, nil, DOTA_TEAM_BADGUYS )
		end
	end

	return true
end

--------------------------------------------------------------------
