aoe_rupture_lua = class({})
LinkLuaModifier("modifier_rupture_damage", "heroes/aoe_rupture_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aoe_rupture_lua", "heroes/aoe_rupture_lua.lua", LUA_MODIFIER_MOTION_NONE)

function aoe_rupture_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local sound_cast = "hero_bloodseeker.rupture.cast"
    local sound_hit = "hero_bloodseeker.rupture"

    EmitSoundOn(sound_cast, caster)   

    if IsServer() then
        -- basically global
        local aoe = 5000

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          target,
                                          nil,
                                          aoe,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO,
                                          DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                          FIND_ANY_ORDER,
                                          false)

        -- This is too loud if we do it on every unit hit
        EmitSoundOn(sound_hit, caster)
        for _,enemy in pairs(enemies) do            
            enemy:AddNewModifier(caster, ability, "modifier_rupture_damage", {duration = caster.ruptureDuration})
            enemy:AddNewModifier(caster, ability, "modifier_aoe_rupture_lua", {})
        end
    end
end

modifier_rupture_damage = class({})

function modifier_rupture_damage:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.previousLocation = self.parent:GetAbsOrigin()

    if IsServer() then      
        self.movement_damage_pct = self.ability:GetSpecialValueFor("movement_damage_pct") / 100
        self.damage_cap_interval = self.ability:GetSpecialValueFor("damage_cap_interval")    

        self:StartIntervalThink(self.damage_cap_interval)
    end
end

function modifier_rupture_damage:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_aoe_rupture_lua")
    end
end

function modifier_rupture_damage:OnIntervalThink()
    if IsServer() then
        local distance = (self.parent:GetAbsOrigin() - self.previousLocation):Length2D()
        local damage = distance * self.movement_damage_pct    

        if damage > 0 then
            local damageTable = {victim = self.parent,
                                 attacker = self.caster,
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_PURE,
                                 ability = self.ability,
            }

            ApplyDamage(damageTable)
        end

        self.previousLocation = self:GetParent():GetAbsOrigin()
    end
end

function modifier_rupture_damage:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_rupture_damage:IsHidden()
    return true
end

-- This function is just to show that you have the rupture modifier visible, but with no duration
modifier_aoe_rupture_lua = class({})

function modifier_aoe_rupture_lua:IsHidden()
    return false
end

function modifier_aoe_rupture_lua:GetTexture()
    return "bloodseeker_rupture"
end