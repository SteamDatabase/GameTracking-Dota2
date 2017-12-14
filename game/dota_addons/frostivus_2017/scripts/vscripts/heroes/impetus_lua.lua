impetus_lua = class({})

function impetus_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound_pre_attack = "Hero_Enchantress.PreAttack"
    local sound_attack = "Hero_Enchantress.Attack"
    
    local speed = caster:GetProjectileSpeed()    
    local particle = "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf"
    --particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf

    self.startPosition = caster:GetAbsOrigin()

    EmitSoundOn(sound_attack, caster)

    local projectile = {Target = target,
                        Source = caster,
                        Ability = ability,
                        EffectName = particle,
                        iMoveSpeed = speed,
                        bDodgeable = false, 
                        bVisibleToEnemies = true,
                        bReplaceExisting = false,
                        bProvidesVision = true,
                        iVisionRadius = 100,
                        iVisionTeamNumber = caster:GetTeamNumber()
    }

    ProjectileManager:CreateTrackingProjectile(projectile)
end

function impetus_lua:OnProjectileHit(target, location)
    local caster = self:GetCaster()
    local casterTeam = caster:GetTeamNumber()
    local ability = self
    local sound_impact = "Hero_Enchantress.ProjectileImpact"

    EmitSoundOn(sound_impact, target)

    local distance = (caster:GetAbsOrigin() - location):Length2D()
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, distance, nil)
    
    GameMode.currentGame:OnImpetusHit(caster, distance)
	return true
end