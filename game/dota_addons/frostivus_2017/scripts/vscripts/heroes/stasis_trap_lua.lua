stasis_trap_lua = class({})

function stasis_trap_lua:IsHidden()
    return true
end

function stasis_trap_lua:OnCreated()
    local caster = self:GetCaster()
    local ability = self
    local modifier = "modifier_stasis_trap"
end

function stasis_trap_lua:GetIntrinsicModifierName()
    return "modifier_stasis_trap"
end

-------------------------------------------------------------------------
LinkLuaModifier("modifier_stasis_trap", "heroes/stasis_trap_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stasis_trap_stun", "heroes/stasis_trap_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_stasis_trap = modifier_stasis_trap or class({})

function modifier_stasis_trap:OnCreated()
    local caster = self:GetCaster()
    local ability = self

    self:StartIntervalThink(0.03)
end

function modifier_stasis_trap:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local sound = "Hero_Techies.StasisTrap.Stun"
        local center = caster:GetAbsOrigin()

        if not caster:IsAlive() then
            self:Destroy()
        end

        -- Ability Specials
        local stun_duration = ability:GetSpecialValueFor("stun_duration")
        local activation_radius = ability:GetSpecialValueFor("activation_radius")
        local stun_radius = ability:GetSpecialValueFor("stun_radius")

        local nearbyEnemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          activation_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
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

            local particle = "particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf"
            local particle_explode_fx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle_explode_fx, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(stun_radiuse, 1, 1))
            ParticleManager:SetParticleControl(particle_explode_fx, 3, caster:GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle_explode_fx)

            local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          caster:GetAbsOrigin(),
                                          nil,
                                          stun_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

            for _,enemy in pairs(enemies) do
                --apply stun modifier
                enemy:AddNewModifier(caster, ability, "modifier_stasis_trap_stun", {duration = stun_duration})
            end

            caster:ForceKill(false)
            self:Destroy()
        end
    end
end

function modifier_stasis_trap:CheckState()
      local state = {
      [MODIFIER_STATE_INVISIBLE] = true,
      }
   
      return state
  end

modifier_stasis_trap_stun = class({})

function modifier_stasis_trap_stun:IsDebuff()
   return true
end
 
--------------------------------------------------------------------------------
 
function modifier_stasis_trap_stun:IsStunDebuff()
   return true
end
 
--------------------------------------------------------------------------------
 
function modifier_stasis_trap_stun:GetEffectName()
   return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_stasis_trap_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
 
--------------------------------------------------------------------------------
 
function modifier_stasis_trap_stun:DeclareFunctions()
    local funcs = {
      MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
   
    return funcs
end
 
--------------------------------------------------------------------------------
 
function modifier_stasis_trap_stun:GetOverrideAnimation( params )
  return ACT_DOTA_DISABLED
end

function modifier_stasis_trap_stun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }
 
    return state
end