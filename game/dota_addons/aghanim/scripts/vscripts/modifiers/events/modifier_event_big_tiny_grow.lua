
modifier_event_big_tiny_grow = class({})

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:GetTexture()
	return "npc_dota_hero_tiny"
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:OnCreated( kv )
	if IsServer() then
		self.movement_speed_reduction = kv[ "movement_speed_reduction" ]
		self.model_scale = kv[ "model_scale" ]
		self.bonus_hp = kv[ "bonus_hp" ]

		local nModelScale = self:GetParent():GetModelScale() + self.model_scale
		self:GetParent():SetHealthBarOffsetOverride( self:GetParent():GetBaseHealthBarOffset() * nModelScale / 100 )

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:OnRefresh( kv )
    if IsServer() then
    	self.movement_speed_reduction = kv.movement_speed_reduction
    	self.model_scale = kv.model_scale
    	self.bonus_hp = kv.bonus_hp

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:AddCustomTransmitterData( )
	return
	{
		movement_speed_reduction = self.movement_speed_reduction,
		model_scale = self.model_scale,
		bonus_hp = self.bonus_hp,
	}
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:HandleCustomTransmitterData( data )
	self.movement_speed_reduction = data.movement_speed_reduction
	self.model_scale = data.model_scale
	self.bonus_hp = data.bonus_hp
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:GetModifierModelScale( params )
	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:GetModifierHealthBonus( params )
	return self.bonus_hp
end

--------------------------------------------------------------------------------

function modifier_event_big_tiny_grow:GetModifierMoveSpeedBonus_Constant( params )
	return -1.0 * self.movement_speed_reduction
end

--------------------------------------------------------------------------------