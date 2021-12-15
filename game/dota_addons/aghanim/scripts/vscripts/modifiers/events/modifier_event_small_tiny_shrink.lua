
modifier_event_small_tiny_shrink = class({})

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:GetTexture()
	return "npc_dota_hero_tiny"
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:OnCreated( kv )
	if IsServer() then
		self.bonus_movement_speed = kv[ "bonus_movement_speed" ]
		self.model_scale = kv[ "model_scale" ]
		self.hp_penalty = kv[ "hp_penalty" ]

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:OnRefresh( kv )
    if IsServer() then
    	self.bonus_movement_speed = kv.bonus_movement_speed
    	self.model_scale = kv.model_scale
    	self.hp_penalty = kv.hp_penalty
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:AddCustomTransmitterData( )
	return
	{
		bonus_movement_speed = self.bonus_movement_speed,
		model_scale = self.model_scale,
		hp_penalty = self.hp_penalty,
	}
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:HandleCustomTransmitterData( data )
	self.bonus_movement_speed = data.bonus_movement_speed
	self.model_scale = data.model_scale
	self.hp_penalty = data.hp_penalty
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:GetModifierModelScale( params )
	return -self.model_scale
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:GetModifierHealthBonus( params )
	return -self.hp_penalty
end

--------------------------------------------------------------------------------

function modifier_event_small_tiny_shrink:GetModifierMoveSpeedBonus_Constant( params )
	if self:GetParent():HasModifier( "modifier_trap_room_player" ) then
		return 0
	end

	return self.bonus_movement_speed
end

--------------------------------------------------------------------------------