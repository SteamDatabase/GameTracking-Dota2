place_land_mine_lua = class({})

function place_land_mine_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local sound = "Hero_Techies.LandMine.Plant"
    local modifier_charges = "modifier_imba_proximity_mine_charges"
    local casterTeam = caster:GetTeam()
    local casterPlayerID = caster:GetPlayerOwnerID()

    EmitSoundOn(sound, caster)

    local direction = (target_point - caster:GetAbsOrigin()):Normalized()

    local mine = CreateUnitByName("zuus_race_land_mine", target_point, true, caster, caster, casterTeam)
    mine:SetControllableByPlayer(casterPlayerID, true)
    mine:SetOwner(caster)
end

-------------------------------------------------------------------------

proximity_mine_lua = class({})

function proximity_mine_lua:IsHidden()
    return true
end

function proximity_mine_lua:GetIntrinsicModifierName()
    return "modifier_proximity_mine"
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_proximity_mine", "heroes/proximity_mine_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_proximity_mine = modifier_proximity_mine or class({})

function modifier_proximity_mine:OnCreated()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
    local particle_mine_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_mine_fx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, caster:GetAbsOrigin())
    self:AddParticle(particle_mine_fx, false, false, -1, false, false)

    self:StartIntervalThink(0.03)
end

function modifier_proximity_mine:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Techies.LandMine.Detonate"
        local center = caster:GetAbsOrigin()

        if not caster:IsAlive() then
            self:Destroy()
        end

        -- Ability Specials
        local damage = ability:GetSpecialValueFor("damage")
        local activation_radius = ability:GetSpecialValueFor("activation_radius")
        local damage_radius = ability:GetSpecialValueFor("damage_radius")

        local nearbyEnemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                                caster:GetAbsOrigin(),
                                                nil,
                                                activation_radius,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_HERO,
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                                FIND_ANY_ORDER,
                                                false)

        -- local found_enemy = false
        -- for _,enemy in pairs(enemies) do
        --     found_enemy = true
        --     break
        -- end

        if #nearbyEnemies > 0 then
            --explode
            EmitSoundOn(sound, caster)

            local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
            local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          damage_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

            for _,enemy in pairs(enemies) do
                local distance = (caster:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
                local damageTable = {victim = enemy,
                                     attacker = caster, 
                                     damage = damage * (1 - distance/400),
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                                     ability = self.ability
                }

                ApplyDamage(damageTable)
            end

            caster:ForceKill(false)
            self:Destroy()
        end
    end    
end

function modifier_proximity_mine:CheckState()
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
 
    return state
end