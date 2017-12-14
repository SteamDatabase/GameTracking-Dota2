modifier_health_lua = class({})


function modifier_health_lua:OnCreated( kv )    
    if IsServer() then
        self.healthBonus = kv.health - self:GetCaster():GetHealth()
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_health_lua:IsHidden()
    return true
end

function modifier_health_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function modifier_health_lua:GetModifierHealthBonus( params )
    return self.healthBonus
end