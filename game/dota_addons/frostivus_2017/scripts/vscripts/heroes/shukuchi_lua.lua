shukuchi_lua = class({})

function shukuchi_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Weaver.Shukuchi"

    local duration = ability:GetSpecialValueFor("duration")

    EmitSoundOn(sound, caster)        

    caster:AddNewModifier(caster, ability, "modifier_shukuchi_lua", {duration = duration})
end

-------------------------------------------------------------------------
LinkLuaModifier("modifier_shukuchi_lua", "heroes/shukuchi_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shukuchi_lua = modifier_shukuchi_lua or class({})

function modifier_shukuchi_lua:OnCreated()
    self.move_speed = self:GetAbility():GetSpecialValueFor("move_speed")  
    if IsServer() then
        local caster = self:GetCaster()
        --local target = self:GetParent()

        local particleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(particleIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true)
        ParticleManager:SetParticleControl(particleIndex, 1, Vector(50, 50, 0))
        self:AddParticle(particleIndex, false, false, -1, false, true)
    end
end

function modifier_shukuchi_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }

    return funcs
end

function modifier_shukuchi_lua:GetModifierMoveSpeed_Absolute( params )
    return self.move_speed
end