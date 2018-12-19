modifier_kotl_mana_leak_winter = class({})

function modifier_kotl_mana_leak_winter:OnCreated()
    self.hCaster = self:GetCaster()
    self.hAbility = self:GetAbility()
    self.hParent = self:GetParent()
    self.previousLocation = self.hParent:GetAbsOrigin()

    if IsServer() then      
        self.movement_mana_pct = self.hAbility:GetSpecialValueFor("movement_mana_pct") / 100
        self.mana_cap_interval = self.hAbility:GetSpecialValueFor("mana_cap_interval")    

        self:StartIntervalThink(self.mana_cap_interval)
    end
end

function modifier_kotl_mana_leak_winter:OnIntervalThink()
    if IsServer() then
        local distance = (self.hParent:GetAbsOrigin() - self.previousLocation):Length2D()
        local mana = distance * self.movement_mana_pct    

        if mana > 0 then
            self:GetParent():GiveMana(mana)
        end
        EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Target" , hParent)
        EmitSoundOn("Hero_KeeperOfTheLight.ManaLeak.Target.FP" , hParent)
        
        self.previousLocation = self:GetParent():GetAbsOrigin()

    end
end

function modifier_kotl_mana_leak_winter:GetEffectName()
    return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_mana_leak.vpcf"
end

function modifier_kotl_mana_leak_winter:IsHidden()
    return false
end