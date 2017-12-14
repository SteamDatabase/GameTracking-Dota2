modifier_chain_frost_lua = class({})

function imba_lich_chain_frost:GetAbilityTextureName()
   return "lich_chain_frost"
end

function modifier_chain_frost_lua:IsHidden()
    return false
end

function modifier_pudge_rot_lua:IsDebuff()
    return true
end

function modifier_chain_frost_lua:OnCreated( kv )   
    self.moveSpeedSlow = self:GetAbility():GetSpecialValueFor("slow_movement_speed")
end

function modifier_chain_frost_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_chain_frost_lua:GetModifierMoveSpeedBonus_Percentage( params )
    return self.moveSpeedSlow
end

function modifier_chain_frost_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end