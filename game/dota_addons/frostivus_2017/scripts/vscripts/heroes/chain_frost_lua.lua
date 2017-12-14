chain_frost_lua = class({})
LinkLuaModifier( "modifier_chain_frost_lua", "heroes/chain_frost_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

function chain_frost_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound = "Hero_Lich.ChainFrost"
    local particle = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
    
    -- Ability specials
    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")

    local projectile = {Target = target,
                        Source = caster,
                        Ability = ability,
                        EffectName = particle,
                        iMoveSpeed = projectile_speed,
                        bDodgeable = false, 
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = true,
                        iVisionRadius = projectile_vision,
                        iVisionTeamNumber = caster:GetTeamNumber()
    }

    ProjectileManager:CreateTrackingProjectile(projectile)

    EmitSoundOn(sound, caster)
end

function chain_frost_lua:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local casterTeam = caster:GetTeamNumber()
    local ability = self
    local particle = "particles/units/heroes/hero_lich/lich_chain_frost.vpcf"
    local modifier = "modifier_chain_frost_lua"
    local soundImpact = "Hero_Lich.ChainFrostImpact.LF"
    local targetPosition = target:GetAbsOrigin()
    --"Hero_Lich.ChainFrostImpact.Creep"
    --"Hero_Lich.ChainFrostLoop"  

    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
    local jump_range = ability:GetSpecialValueFor("jump_range")   
    local damage = ability:GetSpecialValueFor("damage")  
    local jump_interval = ability:GetSpecialValueFor("jump_interval") 
    local slow_duration = ability:GetSpecialValueFor("slow_duration")

    EmitSoundOn(soundImpact, target)

    target:AddNewModifier(caster, ability, "modifier_chain_frost_lua", {duration = slow_duration})

    local damageTable = {victim = target,
                         attacker = caster, 
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }
        
    ApplyDamage(damageTable)

    local enemies = FindUnitsInRadius(casterTeam,
                                      targetPosition,
                                      nil,
                                      jump_range,
                                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                                      DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                      DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                                      FIND_ANY_ORDER,
                                      false)

    local minDistance = 10000
    local nextTarget
    for _,enemy in pairs(enemies) do
        if enemy ~= target then
            distance = (target:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
            if distance < minDistance then
                nextTarget = enemy
                minDistance = distance
            end
        end
    end

    if not nextTarget then return true end

    local projectile = {Target = nextTarget,
                        Source = target,
                        Ability = ability,
                        EffectName = particle,
                        iMoveSpeed = projectile_speed,
                        bDodgeable = false, 
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = true,
                        iVisionRadius = projectile_vision,
                        iVisionTeamNumber = casterTeam
    }

    ProjectileManager:CreateTrackingProjectile(projectile)
	return true
end

----------------------------------------------------------------------

modifier_chain_frost_lua = class({})

function modifier_chain_frost_lua:GetAbilityTextureName()
   return "lich_chain_frost"
end

function modifier_chain_frost_lua:IsHidden()
    return false
end

function modifier_chain_frost_lua:IsDebuff()
    return true
end

function modifier_chain_frost_lua:OnCreated( kv )   
    self.moveSpeedSlow = self:GetAbility():GetSpecialValueFor("slow_movement_speed")
end

function modifier_chain_frost_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_chain_frost_lua:GetModifierMoveSpeedBonus_Percentage( params )
    return self.moveSpeedSlow
end

function modifier_chain_frost_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end