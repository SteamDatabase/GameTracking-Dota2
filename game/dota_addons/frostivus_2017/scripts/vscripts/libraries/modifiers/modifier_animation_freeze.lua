modifier_animation_freeze = class({})

function modifier_animation_freeze:OnCreated(keys) 

end

function modifier_animation_freeze:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE --+ MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_animation_freeze:IsHidden()
  return true
end

function modifier_animation_freeze:IsDebuff() 
  return false
end

function modifier_animation_freeze:IsPurgable() 
  return false
end

function modifier_animation_freeze:CheckState() 
  local state = {
    [MODIFIER_STATE_FROZEN] = true,
  }

  return state
end

