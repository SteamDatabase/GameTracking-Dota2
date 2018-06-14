if CCavernGate == nil then
	CCavernGate = class({})	
end

require( "utility_functions" ) 

--------------------------------------------------------------------

function CCavernGate:constructor( hTrigger, vGatePosition )

	self.vGatePosition = vGatePosition
	self.hTrigger = hTrigger	
	self.Blocker = nil
	
end

--------------------------------------------------------------------

function CCavernGate.Reset()
	CCavernGate._Gates = {}
end

--------------------------------------------------------------------

function CCavernGate.GetGateFromPosition( vGatePosition )
	local hTrigger = Entities:FindByNameNearest( "gate_trigger", vGatePosition, 384.0 )
	assert( hTrigger ~= nil, string.format( "Failed to find gate_trigger at %s", vGatePosition ) )

	local nTriggerEntityIndex = hTrigger:GetEntityIndex()

	if( CCavernGate._Gates[nTriggerEntityIndex] == nil ) then
		local hGate = CCavernGate( hTrigger, vGatePosition )
		CCavernGate._Gates[nTriggerEntityIndex] = hGate 
		return hGate
	else
		return CCavernGate._Gates[nTriggerEntityIndex] 
	end
end

--------------------------------------------------------------------

function CCavernGate:GetPositionOfGate()
	return self.vGatePosition
end

--------------------------------------------------------------------


function CCavernGate:SetObstructions( bEnable )
	local hObstructionEnts = Entities:FindAllByNameWithin( "gate_obstruction", self:GetPositionOfGate(), 500 )
	if #hObstructionEnts ~= 10 then
		print( string.format( "CCavernGate:SetObstructions - ERROR: Found wrong count of gate_obstruction entities (%d) at position %s", #hObstructionEnts, self:GetPositionOfGate() ) )
		return
	end

	for _, hObstruction in pairs( hObstructionEnts ) do
		hObstruction:SetEnabled( bEnable, true )
	end
end

--------------------------------------------------------------------

function CCavernGate:SetPath( hOriginRoom, hNeighborRoom, nPathType )
	if nPathType == CAVERN_PATH_TYPE_DESTRUCTIBLE then
		if self.Blocker ~= nil then
			UTIL_Remove( self.Blocker )
			self.Blocker = nil
		end
		if hNeighborRoom ~= nil then
			self:SetObstructions( true )

			local nOriginRoomLevel = hOriginRoom.nRoomLevel
			local nNeighborRoomLevel = hNeighborRoom.nRoomLevel
			-- make it so that treasure rooms count as one extra level for purposes of gates
			if hOriginRoom.nRoomType == CAVERN_ROOM_TYPE_TREASURE then
				nOriginRoomLevel = nOriginRoomLevel + 1
			end
			if hNeighborRoom.nRoomType == CAVERN_ROOM_TYPE_TREASURE then
				nNeighborRoomLevel = nNeighborRoomLevel + 1
			end
			nGateLevelUp = math.max( nOriginRoomLevel, nNeighborRoomLevel ) - 1

			-- Buildings don't allow setting angles after they've been spawned, so if we can we should spawn the building with proper angles already in place somehow
			if nGateLevelUp <= 1 then
				-- Tier 1
				self.Blocker = CreateUnitByName( "npc_dota_cavern_gate_destructible_tier1", self.vGatePosition, false, nil, nil, DOTA_TEAM_BADGUYS )
			elseif nGateLevelUp <= 2 then
				-- Tier 2
				self.Blocker = CreateUnitByName( "npc_dota_cavern_gate_destructible_tier2", self.vGatePosition, false, nil, nil, DOTA_TEAM_BADGUYS )
			else
				-- Tier 3
				self.Blocker = CreateUnitByName( "npc_dota_cavern_gate_destructible_tier3", self.vGatePosition, false, nil, nil, DOTA_TEAM_BADGUYS )
			end

			assert( self.Blocker ~= nil, string.format( "Failed to create gate at %s", self.vGatePosition ) )

			--printf("room levels %s %s %s", hOriginRoom.nRoomLevel, hNeighborRoom.nRoomLevel, nGateLevelUp)
			local vGateAngles = self.hTrigger:GetAnglesAsVector()
			vGateAngles.y = vGateAngles.y + 90
			self.Blocker.hGate = self
			self.Blocker:SetAngles( vGateAngles.x, vGateAngles.y, vGateAngles.z )
			self.Blocker:AddNewModifier( self.Blocker, nil, "modifier_destructible_gate", { duration = -1 } )
		end
	elseif nPathType == CAVERN_PATH_TYPE_BLOCKED then

		if self.Blocker ~= nil then
			UTIL_Remove( self.Blocker )
			self.Blocker = nil
		end
		self:SetObstructions( true )
		self.Blocker = CreateUnitByName( "npc_dota_cavern_gate_blocked", self.vGatePosition, false, nil, nil, DOTA_TEAM_BADGUYS )
		local vGateAngles = self.hTrigger:GetAnglesAsVector()
		self.Blocker:SetAngles( vGateAngles.x, vGateAngles.y, vGateAngles.z )
		self.Blocker.hGate = self
		self.Blocker:AddNewModifier( self.Blocker, nil, "modifier_blocked_gate", {} )
	elseif nPathType == CAVERN_PATH_TYPE_OPEN then
		if self.Blocker ~= nil then
			--print( "Kill" )
			self.Blocker:ForceKill( false )
			self.Blocker = nil
		end
		self:SetObstructions( false )
	end

	--[[
	if self.Blocker and self.Blocker:HasModifier( "modifier_invulnerable" ) then
		self.Blocker:RemoveModifierByName( "modifier_invulnerable" )
	end
	]]
end
