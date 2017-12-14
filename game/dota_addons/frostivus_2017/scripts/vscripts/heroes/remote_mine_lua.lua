remote_mine_lua = class({})

function remote_mine_lua:IsHidden()
    return true
end

function remote_mine_lua:OnCreated()
    local caster = self:GetCaster()
    local sound = "Hero_Techies.RemoteMine.Toss"

    EmitSoundOn(sound, caster)
end

function remote_mine_lua:GetIntrinsicModifierName()
    return "modifier_remote_mine"
end

-------------------------------------------------------------------------
LinkLuaModifier("modifier_remote_mine", "heroes/remote_mine_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_remote_mine = modifier_remote_mine or class({})

function modifier_remote_mine:OnCreated()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    -- Ability Special
    local tick_rate = ability:GetSpecialValueFor("tick_rate")

    self:StartIntervalThink(tick_rate)
end

function modifier_remote_mine:OnIntervalThink()
    if IsServer() then   
        local caster = self:GetCaster()
        local ability = self:GetAbility() 
        if not caster:IsAlive() then self:Destroy() end        

        local damage_per_tick = ability:GetSpecialValueFor("damage_per_tick")

        local damageTable = {victim = caster,
                             attacker = caster, 
                             damage = damage_per_tick,
                             damage_type = DAMAGE_TYPE_MAGICAL,
                             ability = ability
        } 

        ApplyDamage(damageTable)
    end
end

function modifier_remote_mine:OnDestroy()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Techies.LandMine.Detonate"
        local particle_explosion = "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf"
        local center = caster:GetAbsOrigin()

        local damage = ability:GetSpecialValueFor("damage")
        local damage_radius = ability:GetSpecialValueFor("damage_radius")

        EmitSoundOn(sound, caster)

        ScreenShake(self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true)

        local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle_explosion_fx, 0, center)
        ParticleManager:SetParticleControl(particle_explosion_fx, 1, Vector(damage_radius, 1, 1))
        ParticleManager:SetParticleControl(particle_explosion_fx, 3, center)
        ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          center,
                                          nil,
                                          damage_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

        for _,enemy in pairs(enemies) do
            local damageTable = {victim = enemy,
                                 attacker = caster, 
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_MAGICAL,
                                 ability = self.ability
            }

            ApplyDamage(damageTable)
        end
    end
end