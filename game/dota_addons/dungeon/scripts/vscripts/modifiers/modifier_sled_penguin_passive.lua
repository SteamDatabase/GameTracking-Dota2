modifier_sled_penguin_passive = class({})
----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:OnCreated( kv )
	if IsServer() then
		self.hPlayerEnt = nil
		self.bRideComplete = false
		self.bRideStarted = false
	end
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_passive:CheckState()
	local state =
	{

	}
	return state
end


-----------------------------------------------------------------------

function modifier_sled_penguin_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnOrder( params )
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

		self:GetParent():RemoveModifierByName( "modifier_npc_dialog" )

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

function modifier_sled_penguin_passive:OnIntervalThink()
	if IsServer() then
		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.Dungeon ~= nil and self.bRideStarted == false then
					self.hPlayerEnt:Interrupt()
					GameRules.Dungeon:OnDialogBegin( self.hPlayerEnt, self:GetParent() )
					self:StartIntervalThink( -1 )
					self.bRideStarted = true
					EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
					self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement", {} )
					self.hPlayerEnt:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement", {} )
				end
			end
		end
	end
end

