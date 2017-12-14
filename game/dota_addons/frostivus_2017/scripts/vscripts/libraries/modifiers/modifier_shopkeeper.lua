modifier_shopkeeper = class({})

function modifier_shopkeeper:DeclareFunctions()
    local funcs = {
        --MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
        MODIFIER_PROPERTY_MIN_HEALTH,
    }

    return funcs
end

function modifier_shopkeeper:CheckState()
  local state = {
    --[MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    --[MODIFIER_STATE_ATTACK_IMMUNE] = true,
    --[MODIFIER_STATE_NIGHTMARED] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    --[MODIFIER_STATE_UNSELECTABLE] = true,
  }

  return state
end

function modifier_shopkeeper:GetAbsoluteNoDamageMagical()
  return 1
end

function modifier_shopkeeper:GetAbsoluteNoDamagePhysical()
  return 1
end

function modifier_shopkeeper:GetAbsoluteNoDamagePure()
  return 1
end

function modifier_shopkeeper:GetMinHealth()
  return 1
end

function modifier_shopkeeper:IsHidden()
    return false--true
end