if modifier_creature_buff == nil then
modifier_creature_buff = class({})
end

-----------------------------------------------------------------------------------------

function modifier_creature_buff:constructor()
	self.nArmor  = 0
	self.nBonusDamage = 0
end

------------------------------------------------------------------------------

function modifier_creature_buff:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_buff:OnCreated( kv )
	self:SetHasCustomTransmitterData( true )
	self:OnRefresh( kv )
end

--------------------------------------------------------------------------------

function modifier_creature_buff:OnRefresh( kv )
	self.damage_buff_pct = kv.damage_buff_pct
	self.hp_buff_pct = kv.hp_buff_pct
	self.model_scale = kv.model_scale
	self.armor_buff = kv.armor_buff

	if IsServer() then
		self.nBonusDamage = ( ( self:GetParent():GetBaseDamageMin() + self:GetParent():GetBaseDamageMax() / 2 ) * self.damage_buff_pct ) / 100
		self.nArmor = self.armor_buff
		self:SendBuffRefreshToClients()
	end
end

--------------------------------------------------------------------------------

function modifier_creature_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_buff:AddCustomTransmitterData( )
	return
	{
		armor = self.nArmor,
		damage = self.nBonusDamage,
	}
end

--------------------------------------------------------------------------------

function modifier_creature_buff:HandleCustomTransmitterData( data )
	if data.armor ~= nil then
		self.nArmor = tonumber( data.armor )
	end
	if data.damage ~= nil then
		self.nBonusDamage = tonumber( data.damage )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_buff:GetModifierExtraHealthPercentage( params )
	if self.hp_buff_pct == nil then return 0 end
	return self.hp_buff_pct
end

--------------------------------------------------------------------------------

function modifier_creature_buff:GetModifierPhysicalArmorBonus( params )
	return self.nArmor
end

--------------------------------------------------------------------------------

function modifier_creature_buff:GetModifierModelScale( params )
	if self.model_scale == nil then return 0 end
	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_creature_buff:GetModifierPreAttack_BonusDamage( params )
	return self.nBonusDamage
end
