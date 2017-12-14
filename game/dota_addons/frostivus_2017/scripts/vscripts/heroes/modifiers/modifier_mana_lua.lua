modifier_mana_lua = class({})


function modifier_mana_lua:OnCreated( kv )    
    if IsServer() then
        self.manaBonus = kv.mana - self:GetCaster():GetMaxMana()
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_mana_lua:IsHidden()
    return true
end

function modifier_mana_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
    }

    return funcs
end

function modifier_mana_lua:GetModifierManaBonus( params )
    return self.manaBonus
end