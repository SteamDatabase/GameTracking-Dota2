
require( "encounters/encounter_trap_base" )

if encounter_trap_pudge == nil then
	encounter_trap_pudge = class({},{}, encounter_trap_base)
end

--------------------------------------------------------------------

function encounter_trap_pudge:GetEncounterType()
	return CAVERN_ROOM_TYPE_TRAP
end

--------------------------------------------------------------------

function encounter_trap_pudge:GetEncounterLevels()
	return { 2, 3, 4 }
end

--------------------------------------------------------------------
function encounter_trap_pudge:Start()
	encounter_trap_base.Start( self )

	self.EventQueue = CEventQueue()

	local vExtent = self.hRoom.hRoomVolume:GetBoundingMaxs() - self.hRoom.hRoomVolume:GetBoundingMins()
	local vHalfX = Vector( ( vExtent.x / 2.0 ) - 500, 0, 0 )
	local vHalfY = Vector( 0, ( vExtent.y / 2.0 ) - 500, 0 )
	local nPudgesPerCorner = 1

	for j = 1, nPudgesPerCorner do 
		local hPudgeNE = self:SpawnNonCreepByName( "npc_dota_creature_pudge", self.hRoom:GetRoomCenter() + vHalfY + vHalfX, true, nil, nil, DOTA_TEAM_BADGUYS )
		local hPudgeNW = self:SpawnNonCreepByName( "npc_dota_creature_pudge", self.hRoom:GetRoomCenter() + vHalfY - vHalfX, true, nil, nil, DOTA_TEAM_BADGUYS )
		local hPudgeSE = self:SpawnNonCreepByName( "npc_dota_creature_pudge", self.hRoom:GetRoomCenter() - vHalfY + vHalfX, true, nil, nil, DOTA_TEAM_BADGUYS )
		local hPudgeSW = self:SpawnNonCreepByName( "npc_dota_creature_pudge", self.hRoom:GetRoomCenter() - vHalfY - vHalfX, true, nil, nil, DOTA_TEAM_BADGUYS )
		hPudgeNE.hRoom = self.hRoom
		hPudgeNW.hRoom = self.hRoom
		hPudgeSE.hRoom = self.hRoom
		hPudgeSW.hRoom = self.hRoom
	end

	--self:SpawnTreesAroundShop()

	self.hRoom.hRoomVolume:SetContextThink( GetEncounterContext( "EncounterTrapPudge" ), function() return self:OnThink() end, 0.2 )

	return true
end

--------------------------------------------------------------------

function encounter_trap_pudge:OnThink()
	if IsServer() then
		-- empty
	end

	return nil
end

--------------------------------------------------------------------

function encounter_trap_pudge:SpawnTreesAroundShop()
	if IsServer() then
		local nTreeCount = 20
		local fCurrentAngle = 0
		local fAngleIncrement = ( 2 * math.pi ) / nTreeCount
		local fSpawnTime = 0
		local fSpawnDelay = 0.1

		for i = 1, nTreeCount do
			if self:IsAngleCloseToCardinal( fCurrentAngle ) == false then
				local nRadius = CAVERN_SHOP_RADIUS + 70
				local vSpawnPoint = self.hRoom.vRoomCenter + Vector( math.cos( fCurrentAngle ), math.sin( fCurrentAngle ) ) * nRadius
				local szRandomCavernTreeModel = _G.CavernTreeModelNames[ RandomInt( 1, #_G.CavernTreeModelNames ) ]
				local nDuration = 10000

				self.EventQueue:AddEvent( fSpawnTime, 
				function()
					self:SpawnTempTreeWithModel( vSpawnPoint, nDuration, szRandomCavernTreeModel )
				end )
			end

			fCurrentAngle = fCurrentAngle + fAngleIncrement
			fSpawnTime = fSpawnTime + fSpawnDelay
		end
	end

	return
end

--------------------------------------------------------------------

function encounter_trap_pudge:IsAngleCloseToCardinal( fAngle )
	-- Check 0 degrees
	if ( -0.30 < fAngle and fAngle < 0.30 ) then
		return true
	end

	-- Check 90 degrees
	if ( 1.27 < fAngle and fAngle < 1.87 ) then
		return true
	end

	-- Check 180 degrees
	if ( 2.84 < fAngle and fAngle < 3.44 ) then
		return true
	end

	-- Check 270 degrees
	if ( 4.42 < fAngle and fAngle < 5.02 ) then
		return true
	end

	return false
end

--------------------------------------------------------------------
