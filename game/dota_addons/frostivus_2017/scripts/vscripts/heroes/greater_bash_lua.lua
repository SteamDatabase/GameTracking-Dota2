greater_bash_lua = class({})
LinkLuaModifier("modifier_greater_bash_lua", "heroes/greater_bash_lua.lua", LUA_MODIFIER_MOTION_NONE)

function greater_bash_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local soundPreAttack = "Hero_Spirit_Breaker.PreAttack"
    local soundAttack = "Hero_Spirit_Breaker.GreaterBash"
    local casterPosition = caster:GetAbsOrigin()
    local direction = caster:GetForwardVector()
    
    local damage = ability:GetSpecialValueFor("damage")
    local knockback_distance = ability:GetSpecialValueFor("knockback_distance")
    local knockback_height = ability:GetSpecialValueFor("knockback_height")
    local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
    local damage_radius = ability:GetSpecialValueFor("damage_radius")

    local center = caster:GetAbsOrigin() + direction * damage_radius

    EmitSoundOn(soundPreAttack, caster)

    caster:Stop()
    caster:StartGesture(ACT_DOTA_ATTACK)

    caster.attacking = true

    Timers:CreateTimer(.5, function()
        if not caster.attacking then return end
        caster.attacking = false

        local searchArea = FindUnitsInRadius(caster:GetTeam(),
                                             center,
                                             nil, 
                                             damage_radius, 
                                             DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                             DOTA_UNIT_TARGET_ALL, 
                                             0,
                                             0, 
                                             false)

        for _,target in pairs(searchArea) do
            EmitSoundOn(soundAttack, target)

            local damageTable = {attacker = caster,
                                 victim = target,
                                 ability = ability,
                                 damage = damage,
                                 damage_type = DAMAGE_TYPE_PHYSICAL,
            }
            ApplyDamage(damageTable)

            local knockback = {should_stun = 1,                                
                               knockback_duration = knockback_duration,
                               duration = knockback_duration,
                               knockback_distance = knockback_distance,
                               knockback_height = knockback_height,
                               center_x = casterPosition.x,
                               center_y = casterPosition.y,
                               center_z = casterPosition.z,
            }

            --target:RemoveModifierByName("modifier_knockback")
            target:AddNewModifier(caster, ability, "modifier_knockback", knockback)            
        end
    end)
end

function greater_bash_lua:GetIntrinsicModifierName()
    return "modifier_greater_bash_lua"
end

----------------------------------------

modifier_greater_bash_lua = class({})

function modifier_greater_bash_lua:IsHidden()
    return true
end

function modifier_greater_bash_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_UNIT_MOVED,
    }
    return funcs
end

function modifier_greater_bash_lua:OnUnitMoved(keys)
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