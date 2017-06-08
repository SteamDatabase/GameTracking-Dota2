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

-----------------------------------------------------------------------

function modifier_npc_dialog:OnOrder( params )
	if IsServer() then
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end

		self:StartIntervalThink( -1 )
	end

	return 0
end


-----------------------------------------------------------------------

function modifier_npc_dialog:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Dungeon ~= nil then
					self.hPlayerEnt:Interrupt()
					GameRules.Dungeon:OnDialogBegin( self.hPlayerEnt, self:GetParent() )
					self:StartIntervalThink( -1 )
					self.hPlayerEnt = nil
				end
			end
		end
	end
end