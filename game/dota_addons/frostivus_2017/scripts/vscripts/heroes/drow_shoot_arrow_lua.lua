drow_shoot_arrow_lua = class({})

function drow_shoot_arrow_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local sound_attack = "Hero_DrowRanger.Attack"
    local sound_impact = "Hero_DrowRanger.ProjectileImpact"
    --"Hero_DrowRanger.FrostArrows"
    local speed = caster:GetProjectileSpeed()    
    local particle = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
    --particles/frostivus_gameplay/drow_linear_frost_arrow.vpcf

    caster:Stop()
    caster:StartGestureWithPlaybackRate( ACT_DOTA_ATTACK, 3 )
    caster.attacking = true

    Timers:CreateTimer(.3, function()
        if not caster.attacking then return end
        caster.attacking = false

        local projectile = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
        ParticleManager:SetParticleControl(projectile, 0, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")))
        ParticleManager:SetParticleControl(projectile, 1, target)
        ParticleManager:SetParticleControl(projectile, 2, Vector(speed, 0, 0))
        ParticleManager:SetParticleControl(projectile, 3, target)

        EmitSoundOn(sound_attack, caster)

        local damage = ability:GetSpecialValueFor("damage")
        local damage_aoe = ability:GetSpecialValueFor("damage_aoe")

        local distanceToTarget = (caster:GetAbsOrigin() - target):Length2D()
        local time = distanceToTarget/speed

        Timers:CreateTimer(time, function()
            ParticleManager:DestroyParticle(projectile, false)

            EmitSoundOn(sound_impact, caster)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                              target,
                                              nil,
                                              damage_aoe,
                                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                                              DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                              DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                              FIND_ANY_ORDER,
                                              false)

            for _,enemy in pairs(enemies) do 
                local damageTable = {victim = enemy,
                                     attacker = caster,
                                     damage = damage,
                                     damage_type = DAMAGE_TYPE_PHYSICAL,
                                     ability = ability}

                ApplyDamage(damageTable)
            end
        end)
    end)
end

function drow_shoot_arrow_lua:GetIntrinsicModifierName()
    return "modifier_shoot_arrow_lua"
end

----------------------------------------
LinkLuaModifier("modifier_shoot_arrow_lua", "heroes/drow_shoot_arrow_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_shoot_arrow_lua = class({})

function modifier_shoot_arrow_lua:IsHidden()
    return true
end

function modifier_shoot_arrow_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED,
    }
    return funcs
end

function modifier_shoot_arrow_lua:OnUnitMoved(keys)
    if IsServer() then
        local unit = keys.unit
        local caster = self:GetParent()
        if unit == caster and caster.attacking then
            caster.attacking = false
            caster:RemoveGesture(ACT_DOTA_ATTACK)
            self:GetAbility():EndCooldown()
        end
    end
end