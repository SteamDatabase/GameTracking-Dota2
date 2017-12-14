lion_finger_lua = class({})

function lion_finger_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound_cast = "Hero_Lion.FingerOfDeath"
    local sound_impact = "Hero_Lion.FingerOfDeathImpact"
    local particle = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"

    if not target.isMonkeyKing then
        EmitSoundOn(sound_cast, caster)
    end

    local particle_finger_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)

    --ParticleManager:SetParticleControl(particle_finger_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(particle_finger_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(particle_finger_fx, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_finger_fx, 2, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_finger_fx)

    target:Kill(ability, caster)
    target:AddNoDraw()
end