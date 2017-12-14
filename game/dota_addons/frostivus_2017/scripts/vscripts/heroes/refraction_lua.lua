refraction_lua = class({})
LinkLuaModifier("modifier_refraction_lua", "heroes/refraction_lua.lua", LUA_MODIFIER_MOTION_NONE)

function refraction_lua:OnToggle()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_TemplarAssassin.Refraction"

    if self:GetToggleState() then
        caster:AddNewModifier(caster, ability, "modifier_refraction_lua", {})
    else
        local refraction_modifier = self:GetCaster():FindModifierByName("modifier_refraction_lua")
        if refraction_modifier ~= nil then
            refraction_modifier:Destroy()
        end
    end
end

------------------------------------------------------------

modifier_refraction_lua = class({})

function modifier_refraction_lua:OnCreated()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local particle = "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf"

    if IsServer() then
        self.particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(self.particle_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle_fx, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

        self:AddParticle( self.particle_fx, false, false, -1, false, true )
        self.tick_rate = ability:GetSpecialValueFor("tick_rate")
        self.manacost = ability:GetSpecialValueFor("mana_per_second") * self.tick_rate
        self:StartIntervalThink(self.tick_rate)
    end
end

function modifier_refraction_lua:OnDestroy()
    if IsServer() then
        self:StartIntervalThink(-1)
        -- ParticleManager:DestroyParticle(self.particle_fx, true)
    end
end

function modifier_refraction_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()

        if caster:GetMana() >= ability:GetManaCost(-1) then
            caster:SpendMana(self.manacost, ability)
        else
            ability:ToggleAbility()
        end
    end
end

function modifier_refraction_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end


function modifier_refraction_lua:CheckState()
    local funcs = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return funcs
end

function modifier_refraction_lua:OnTakeDamage(keys)
    local unit = keys.unit
    local parent = self:GetParent()

    if unit == parent then
        local damage = keys.damage
        local sound = "Hero_TemplarAssassin.Refraction.Absorb"

        EmitSoundOn(sound, parent)
    end
end