modifier_event_ogre_magi_casino_bloodlust = class( {} )

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:GetTexture()
	return "ogre_magi_bloodlust"
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:OnCreated( kv )
	if IsServer() then
		self.move_speed_pct = kv[ "move_speed_pct" ]
		self.attack_speed = kv[ "attack_speed" ]
		self.model_scale = kv[ "model_scale" ]
		self.encounters_remaining = kv[ "encounters_remaining" ]
		self:SetStackCount( self.encounters_remaining )

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:OnRefresh( kv )
    if IsServer() then
    	self.move_speed_pct = kv.move_speed_pct
    	self.attack_speed = kv.attack_speed
    	self.model_scale = kv.model_scale
    	self.encounters_remaining = kv.encounters_remaining
    	
    	self:SetStackCount( self.encounters_remaining )

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:AddCustomTransmitterData( )
	return
	{
		move_speed_pct = self.move_speed_pct,
		model_scale = self.model_scale,
		attack_speed = self.attack_speed,
	}
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:HandleCustomTransmitterData( data )
	self.move_speed_pct = data.move_speed_pct
	self.model_scale = data.model_scale
	self.attack_speed = data.attack_speed
end


--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:GetModifierModelScale( params )
	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_pct
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end

--------------------------------------------------------------------------------

function modifier_event_ogre_magi_casino_bloodlust:OnTooltip( params )
	return self:GetStackCount()
end