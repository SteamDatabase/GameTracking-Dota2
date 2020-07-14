modifier_tornado_harpy_intrinsic = class({})


function modifier_tornado_harpy_intrinsic:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end


function modifier_tornado_harpy_intrinsic:OnAbilityExecuted(keys)
    if IsServer() then
        local unit = keys.unit
        local parent = self:GetParent()
        if unit ~= parent then
            return
        end

        local justCast = keys.ability:GetAbilityName() == "harpy_storm_chain_lightning"
        if not justCast then
            return
        end

        local duration = self:GetAbility():GetSpecialValueFor("duration")
        parent:AddNewModifier(parent, self:GetAbility(), "modifier_tornado_harpy_surge", {duration = duration})

    end

    return 0
end