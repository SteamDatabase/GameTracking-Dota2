
require( "cavern_encounter" )

if encounter_combat_minimages == nil then
	encounter_combat_minimages = class({},{},CCavernEncounter)
end

--------------------------------------------------------------------

function encounter_combat_minimages:GetEncounterType()
	return CAVERN_ROOM_TYPE_MOB
end

--------------------------------------------------------------------

function encounter_combat_minimages:GetEncounterLevels()
	return { 1 }
end

--------------------------------------------------------------------

function encounter_combat_minimages:Start()
	
	CCavernEncounter.Start( self )

	self.EventQueue = CEventQueue()

	self.Units = {}
	--self.WaveSound = { "antimage_anti_attack_03", "antimage_anti_attack_03", "antimage_anti_attack_03"}

	self.nNumUnitsToSpawn = 8

	self:Spawn(self.nNumUnitsToSpawn)
	
	return true;
end

--------------------------------------------------------------------

function encounter_combat_minimages:Spawn(nCreepCount)
	local flCurrentAngle = 0
	local flAngleIncrement = 2*math.pi/nCreepCount
	local flSpawnTime = 0
	local flSpawnDelay = 0.1
	
	--printf("spawning %d minimages", nCreepCount)

	for i=1,nCreepCount do
		local vSpawnPoint = self.hRoom.vRoomCenter + Vector( math.cos(flCurrentAngle), math.sin(flCurrentAngle) )*600

		self.EventQueue:AddEvent( flSpawnTime, 
		function()
			local hUnit = self:SpawnCreepByName( "npc_dota_minimage", vSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS )
			table.insert( self.Units, hUnit )
		end )
		flCurrentAngle = flCurrentAngle + flAngleIncrement
		flSpawnTime = flSpawnTime + flSpawnDelay
	end

	return true
end

--------------------------------------------------------------------
