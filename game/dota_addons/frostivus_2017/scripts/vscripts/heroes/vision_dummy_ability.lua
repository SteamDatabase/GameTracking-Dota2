vision_dummy_ability = class({})
LinkLuaModifier("modifier_vision_dummy", "heroes/modifiers/modifier_vision_dummy.lua", LUA_MODIFIER_MOTION_NONE)

function vision_dummy_ability:IsHidden()
    return true
end

function vision_dummy_ability:GetIntrinsicModifierName()
    return "modifier_vision_dummy"
end