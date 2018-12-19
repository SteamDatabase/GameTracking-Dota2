
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
	end
end

----------------------------------------------------------------------------------

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
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET and nOrderType ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
			return
		end

		if hTargetUnit == nil or hTargetUnit ~= self:GetParent() or hTargetUnit:HasModifier( "modifier_sled_penguin_movement" ) or hTargetUnit:HasModifier( "modifier_sled_penguin_crash" ) then
			return
		end

		if hOrderedUnit ~= nil and hOrderedUnit:IsRealHero() and hOrderedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS and hOrderedUnit:HasModifier( "modifier_sled_penguin_movement" ) == false then
			self.hPlayerEnt = hOrderedUnit
			self:StartIntervalThink( 0.25 )
			return
		end
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnDestroy()
	if IsServer() then
		if self.hPlayerEnt ~= nil and self.hPlayerEnt:IsNull() == false then
			self.hPlayerEnt:RemoveModifierByName( "modifier_sled_penguin_movement" )
		end
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_sled_penguin_passive:OnIntervalThink()
	if IsServer() then
		if self:GetParent():HasModifier( "modifier_sled_penguin_movement" ) or self:GetParent():HasModifier( "modifier_sled_penguin_crash" ) then
			self:StartIntervalThink( -1 )
			return
		end

		if self.hPlayerEnt ~= nil then
			local flTalkDistance = 250.0
			if flTalkDistance >= ( self.hPlayerEnt:GetOrigin() - self:GetParent():GetOrigin() ):Length2D() then
				if GameRules.holdOut ~= nil and self.hPlayerEnt:HasModifier( "modifier_sled_penguin_movement" ) == false then
					self.hPlayerEnt:Interrupt()
					EmitSoundOn( "SledPenguin.PlayerHopOn", self:GetParent() )
					self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement", {} )
					self.hPlayerEnt:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sled_penguin_movement", {} )
				end
			end
		end
	end
end

-----------------------------------------------------------------------

