modifier_npc_dialog = class({})

-----------------------------------------------------------------------

function modifier_npc_dialog:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_npc_dialog:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_npc_dialog:OnCreated( params )
	if IsServer() then
		self.vecPlayers = {}
		self.flTalkDistance = params.talk_distance or 250.0
	end
end

-----------------------------------------------------------------------

function modifier_npc_dialog:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_npc_dialog:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		
	}
	return state
end

-----------------------------------------------------------------------

function modifier_npc_dialog:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() or nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			if hOrderedUnit ~= nil and self.vecPlayers [ hOrderedUnit ] ~= nil then
				self.vecPlayers [ hOrderedUnit ] = nil
				--print( "--2--Hero " .. hOrderedUnit:GetUnitName() .. " has had a different order, stop thinking." )
			end
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			--print( "++++Hero " .. hOrderedUnit:GetUnitName() .. " is going towards " .. self:GetParent():GetUnitName() )
			self.vecPlayers[ hOrderedUnit ] = true
			self:StartIntervalThink( 0.25 )
			return
		end
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_npc_dialog:OnIntervalThink()
	if IsServer() then
		local bFoundValid = false
		for hPlayerEnt,v in pairs( self.vecPlayers ) do
			if v then
				if self.flTalkDistance >= ( hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
					--print( "xxxx Hero " .. hPlayerEnt:GetUnitName() .. " is in range, firing event" )
					hPlayerEnt:Interrupt()

					self:GetParent():FaceTowards( hPlayerEnt:GetOrigin() )
				
					local event = {}
					event[ "entindex_hero" ] = hPlayerEnt:GetEntityIndex()
					event[ "entindex_event_npc" ] = self:GetParent():GetEntityIndex()
					FireGameEvent( "aghsfort_interact_event_npc", event )

					self.vecPlayers[ hPlayerEnt ] = nil
				else
					bFoundValid = true
				end
			end
		end

		if bFoundValid ~= true then
			--print( "---No more heroes heading to " .. self:GetParent():GetUnitName() )
			self:StartIntervalThink( -1 )
		end
	end
end