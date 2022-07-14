modifier_treant_great_protector = class({})

--------------------------------------------------------------------------------

function modifier_treant_great_protector:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	if IsServer() then
		self.nHealTicks = 0
		self:StartIntervalThink( 0.05 )
	end

end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:OnRemoved()
	if IsServer() then
		local flHealth = self:GetParent():GetHealth() 
		local flMaxHealth = self:GetParent():GetMaxHealth()
		local flHealthPct = flHealth / flMaxHealth

		self:GetParent():CalculateStatBonus( true )

		local flNewHealth = self:GetParent():GetHealth()  
		local flNewMaxHealth = self:GetParent():GetMaxHealth()

		local flNewDesiredHealth = flNewMaxHealth * flHealthPct
		if flNewHealth ~= flNewDesiredHealth then
			self:GetParent():ModifyHealth( flNewDesiredHealth, self:GetAbility(), false, 0 )
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:OnIntervalThink()
	if IsServer() then
		self:GetParent():Heal( ( self.bonus_strength * 20 ) * 0.05, self:GetAbility() )
		self.nHealTicks = self.nHealTicks + 1
		if self.nHealTicks >= 20 then
			self:StartIntervalThink( -1 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

--------------------------------------------------------------------------------


function modifier_treant_great_protector:OnAttackLanded( params )
	if IsServer() then
		local hTarget = params.target

		if hTarget == nil or hTarget ~= self:GetParent() then
			return 0
		end

		--EmitSoundOn( "Hero_Treant.Overgrowth.Target", hTarget )
	end
end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:GetModifierModelScale( params )
	return self.model_scale
end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:GetModifierExtraStrengthBonus( params )
	return self.bonus_strength
end

--------------------------------------------------------------------------------

function modifier_treant_great_protector:GetModifierMoveSpeed_Limit( params )
	return self.move_speed
end

--------------------------------------------------------------------------------
