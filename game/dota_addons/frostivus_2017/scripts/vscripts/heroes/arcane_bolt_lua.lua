arcane_bolt_lua = class({})

function arcane_bolt_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound = "Hero_SkywrathMage.ArcaneBolt.Cast"
    local particle = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
    
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
                        iVisionRadius = 100,
                        iVisionTeamNumber = caster:GetTeamNumber()
    }

    ProjectileManager:CreateTrackingProjectile(projectile)

    EmitSoundOn(sound, caster)
end

function arcane_bolt_lua:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local ability = self
    local soundImpact = "Hero_SkywrathMage.ArcaneBolt.Impact"

    EmitSoundOn(soundImpact, target)

    local damage = ability:GetSpecialValueFor("damage")  

    local damageTable = {victim = target,
                         attacker = caster, 
                         damage = damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         ability = ability
                         }
        
    ApplyDamage(damageTable)
	return true;
end