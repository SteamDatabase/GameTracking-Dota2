modifier_tornado_harpy_surge = class({})


function modifier_tornado_harpy_surge:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
    return funcs
end


function modifier_tornado_harpy_surge:GetModifierMoveSpeedBonus_Constant(params)

	return self:GetAbility():GetSpecialValueFor("speed_boost")
  
end

