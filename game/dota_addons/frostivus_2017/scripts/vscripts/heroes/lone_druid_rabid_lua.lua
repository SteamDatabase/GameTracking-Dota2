lone_druid_rabid_lua = class({})
LinkLuaModifier("modifier_rabid_lua", "heroes/lone_druid_rabid_lua.lua", LUA_MODIFIER_MOTION_NONE)

function lone_druid_rabid_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound_cast = "Hero_LoneDruid.Rabid"

    local duration = ability:GetSpecialValueFor("duration")  

    EmitSoundOn(sound_cast, caster)   

    if IsServer() then
       caster:AddNewModifier(caster, ability, "modifier_rabid_lua", {duration = duration})
    end
end

modifier_rabid_lua = class({})

function modifier_rabid_lua:OnCreated()
    local caster = self:GetCaster()
    local casterPosition = caster:GetAbsOrigin()
    local ability = self:GetAbility()
    local particle = "particles/units/heroes/hero_lone_druid/lone_druid_rabid_buff.vpcf"
    local particleEffect

    self.bonus_move_speed = ability:GetSpecialValueFor("bonus_move_speed")
    self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")

    --caster:Purge(false, true, false, false, false)

    if IsServer() then
        local nFXIndex = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
        ParticleManager:SetParticleControlEnt(nFXIndex, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
        ParticleManager:SetParticleControlEnt(nFXIndex, 2, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", casterPosition, true)
        self:AddParticle(nFXIndex, false, false, -1, false, false)
    end
end

function modifier_rabid_lua:GetEffectName()
    return "particles/units/heroes/hero_lone_druid/lone_druid_rabid_buff_speed_ring.vpcf"
end

function modifier_rabid_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_rabid_lua:CheckState()
    local state = {
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
 
    return state
end

function modifier_rabid_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_rabid_lua:GetModifierMoveSpeedBonus_Constant()
    return self.bonus_move_speed
end

function modifier_rabid_lua:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end