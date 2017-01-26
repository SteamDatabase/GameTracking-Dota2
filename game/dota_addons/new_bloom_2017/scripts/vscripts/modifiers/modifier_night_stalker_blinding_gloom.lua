modifier_night_stalker_blinding_gloom = class({})

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:OnCreated( kv )
	self.vision_radius = self:GetAbility():GetSpecialValueFor( "vision_radius" )
	self.movespeed_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:OnIntervalThink()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:OnDestroy()
	if IsServer() then
	end 
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:GetFixedDayVision( params )
	return self.vision_radius
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:GetFixedNightVision( params )
	return self.vision_radius
end

--------------------------------------------------------------------------------

function modifier_night_stalker_blinding_gloom:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movespeed_slow
end
