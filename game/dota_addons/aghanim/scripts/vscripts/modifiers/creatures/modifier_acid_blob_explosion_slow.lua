
modifier_acid_blob_explosion_slow = class({})

------------------------------------------------------------------------------------

function modifier_acid_blob_explosion_slow:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

------------------------------------------------------------------------------------

function modifier_acid_blob_explosion_slow:OnCreated( kv )
	self.explosion_slow_percent = self:GetAbility():GetSpecialValueFor( "explosion_slow_percent" )
end

------------------------------------------------------------------------------------

function modifier_acid_blob_explosion_slow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

------------------------------------------------------------------------------------

function modifier_acid_blob_explosion_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return self.explosion_slow_percent
end

--------------------------------------------------------------------------------
