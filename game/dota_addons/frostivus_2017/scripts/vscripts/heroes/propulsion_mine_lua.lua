place_propulsion_mine_lua = class({})

function place_propulsion_mine_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target_point = self:GetCursorPosition()
    local sound = "Hero_Techies.LandMine.Plant"
    local casterTeam = caster:GetTeam()
    local casterPlayerID = caster:GetPlayerOwnerID()

    -- if caster.placedMine then
    --     return
    -- end

    EmitSoundOn(sound, caster)

    local mine = CreateUnitByName("propulsion_mine", target_point, true, caster, caster, casterTeam)
    mine:SetControllableByPlayer(casterPlayerID, true)
    mine:SetOwner(caster)

    mine:FindAbilityByName("propulsion_mine_lua"):UpgradeAbility(true)

    mine.placer = caster
    if not caster.placedMines then
        caster.placedMines = {}
    end
    table.insert(caster.placedMines, mine)

    -- ability:SetActivated(false)
end

-------------------------------------------------------------------------

detonate_propulsion_mine_lua = class({})

function detonate_propulsion_mine_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self

    if not caster.placedMines or TableCount(caster.placedMines) == 0 then
        return
    end

    for _,mine in pairs(caster.placedMines) do
        mine:FindModifierByName("modifier_propulsion_mine"):Explode()
    end

    caster.placedMines = {}
end

-------------------------------------------------------------------------

propulsion_mine_lua = class({})

function propulsion_mine_lua:IsHidden()
    return true
end

function propulsion_mine_lua:OnCreated()
    print("Propulsion Mine Created")
    local caster = self:GetCaster()
    local sound = "Hero_Techies.RemoteMine.Plant"

    EmitSoundOn(sound, caster)
end

function propulsion_mine_lua:GetIntrinsicModifierName()
    return "modifier_propulsion_mine"
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_propulsion_mine", "heroes/propulsion_mine_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_propulsion_mine = modifier_propulsion_mine or class({})

function modifier_propulsion_mine:IsHidden()
    return true
end

function modifier_propulsion_mine:Explode()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound_activate = "Hero_Techies.RemoteMine.Activate"
        local sound_detonate = "Hero_Techies.RemoteMine.Detonate"
        local particle_explosion = "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf"
        local center = caster:GetAbsOrigin()

        EmitSoundOn(sound_activate, caster.placer)
        EmitSoundOn(sound_detonate, caster)

        local damage = ability:GetSpecialValueFor("damage")
        local knockback_distance = ability:GetSpecialValueFor("knockback_distance")
        local knockback_height = ability:GetSpecialValueFor("knockback_height")
        local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
        local radius = ability:GetSpecialValueFor("radius")

        local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle_explosion_fx, 0, center)
        ParticleManager:SetParticleControl(particle_explosion_fx, 1, Vector(radius, 1, 1))
        ParticleManager:SetParticleControl(particle_explosion_fx, 3, center)
        ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

        local searchArea = FindUnitsInRadius(caster:GetTeam(),
                                             center,
                                             nil, 
                                             radius, 
                                             DOTA_UNIT_TARGET_TEAM_BOTH, 
                                             DOTA_UNIT_TARGET_HERO, 
                                             0,
                                             0, 
                                             false)

        for _,target in pairs(searchArea) do
            local damageTable = {attacker = caster,
                                 victim = target,
                                 ability = ability,
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_MAGICAL,
            }
            ApplyDamage(damageTable)

            local knockback = {should_stun = 1,                                
                               knockback_duration = knockback_duration,
                               duration = knockback_duration,
                               knockback_distance = knockback_distance,
                               knockback_height = knockback_height,
                               center_x = center.x,
                               center_y = center.y,
                               center_z = center.z,
            }

            --target:RemoveModifierByName("modifier_knockback")
            target:AddNewModifier(caster, ability, "modifier_knockback", knockback)            
        end

        -- local hero = caster.placer
        -- hero.placedMine = false
        -- hero:FindAbilityByName("place_propulsion_mine_lua"):SetActivated(true)

        caster:ForceKill(false)
    end
end

function modifier_propulsion_mine:CheckState()
    local funcs = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return funcs
end