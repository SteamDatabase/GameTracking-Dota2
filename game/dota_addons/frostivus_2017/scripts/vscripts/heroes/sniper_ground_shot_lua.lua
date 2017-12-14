sniper_ground_shot_lua = class({})

function sniper_ground_shot_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Ability.Assassinate"
    local soundLaunch = "Hero_Sniper.AssassinateProjectile" 
    local particle = "particles/abilities/sniper_assassinate.vpcf"
    local targetPoint = self:GetCursorPosition()
    local casterPosition = caster:GetAbsOrigin()

    local forwardVec = (targetPoint - casterPosition):Normalized()
    local velocityVec = Vector(forwardVec.x, forwardVec.y, 0)

    EmitSoundOn(sound, caster)
    EmitSoundOn(soundLaunch, caster)
    
    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
    local projectile_range = ability:GetSpecialValueFor("projectile_range")
    local projectile_width = ability:GetSpecialValueFor("projectile_width")

    local projectile = {Ability = ability,
                        EffectName = particle,
                        vSpawnOrigin = casterPosition,
                        fDistance = projectile_range,
                        fStartRadius = projectile_width,
                        fEndRadius = projectile_width,
                        Source = caster,
                        bHasFrontalCone = true,
                        bReplaceExisting = false,
                        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                                                          
                        iUnitTargetType = DOTA_UNIT_TARGET_BASIC,                           
                        bDeleteOnHit = false,
                        vVelocity = velocityVec * projectile_speed,
                        bProvidesVision = false, 
                        iVisionRadius = 100,
                        iVisionTeamNumber = caster:GetTeamNumber()                      
    }

    ProjectileManager:CreateLinearProjectile(projectile)
end

function sniper_ground_shot_lua:OnProjectileHit(target, location) 
    if target == nil then return end   
    local caster = self:GetCaster()
    local ability = self

    --EmitSoundOn(soundImpact, target)

    local particle_sparks = "particles/units/heroes/hero_sniper/sniper_assassinate_impact_sparks.vpcf"
    local particle_light = "particles/units/heroes/hero_sniper/sniper_assassinate_endpoint.vpcf"

    local particle_sparks_fx = ParticleManager:CreateParticle(particle_sparks, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle_sparks_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle_sparks_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_sparks_fx)

    local particle_light_fx = ParticleManager:CreateParticle(particle_light, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle_light_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_light_fx)

    local damage = ability:GetSpecialValueFor("damage")

    local damageTable = {victim = target,
                         attacker = caster,
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }

    ApplyDamage(damageTable)
    

    return false
end