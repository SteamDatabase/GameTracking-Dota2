mirana_arrow_lua = class({})
LinkLuaModifier("modifier_arrow_lua", "heroes/mirana_arrow_lua.lua", LUA_MODIFIER_MOTION_NONE)

function mirana_arrow_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Mirana.ArrowCast"
    local particle = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
    local targetPoint = self:GetCursorPosition()
    local direction = (targetPoint - caster:GetAbsOrigin()):Normalized()

    local spawnPoint = caster:GetAbsOrigin() + direction * 51
    
    -- Ability specials
    local arrow_speed = ability:GetSpecialValueFor("arrow_speed")
    local arrow_width = ability:GetSpecialValueFor("arrow_width")
    local arrow_range = ability:GetSpecialValueFor("arrow_range")

    local projectile = {Ability = ability,
                        EffectName = particle,
                        vSpawnOrigin = spawnPoint,
                        fDistance = arrow_range,
                        fStartRadius = arrow_width,
                        fEndRadius = arrow_width,
                        Source = caster,
                        bHasFrontalCone = false,
                        bReplaceExisting = false,
                        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                                                          
                        iUnitTargetType = DOTA_UNIT_TARGET_BASIC,                           
                        bDeleteOnHit = true,
                        vVelocity = direction * arrow_speed,
                        bProvidesVision = false, 
                        iVisionRadius = 100,
                        iVisionTeamNumber = caster:GetTeamNumber()                      
    }

    ProjectileManager:CreateLinearProjectile(projectile)

    EmitSoundOn(sound, caster)

    ability:SetActivated(false)
end

function mirana_arrow_lua:OnProjectileHit(target, location)    
    local caster = self:GetCaster()
    local ability = self
    local modifier = "modifier_arrow_lua"
    local soundImpact = "Hero_Mirana.ArrowImpact"

    ability:EndCooldown()
    ability:SetActivated(true)

    if not target then return end

    local stun_duration = ability:GetSpecialValueFor("stun_duration")

    target:AddNewModifier(self:GetCaster(), self, modifier, {duration = stun_duration})

    local damageTable = {victim = target,
                         attacker = caster,
                         damage = 1,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }

    ApplyDamage(damageTable)    

    -- Sound removed so you can hear the bell ring
    --EmitSoundOn(soundImpact, target)

    return true
end

----------------------------------------------------------------------

modifier_arrow_lua = class({})

function modifier_arrow_lua:GetAbilityTextureName()
   return "mirana_arrow"
end

function modifier_arrow_lua:IsHidden()
    return false
end

function modifier_arrow_lua:IsDebuff()
    return true
end

function modifier_arrow_lua:IsStunDebuff()
    return true
end


function modifier_arrow_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_arrow_lua:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end


function modifier_arrow_lua:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

function modifier_arrow_lua:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
end

function modifier_arrow_lua:CheckState()
    local state = {[MODIFIER_STATE_STUNNED] = true}
    return state
end