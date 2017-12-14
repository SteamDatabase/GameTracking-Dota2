custom_berserkers_call = class({})
LinkLuaModifier( "modifier_berserkers_call_lua", "heroes/axe_berserkers_call_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

function custom_berserkers_call:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorTarget()
    local sound = "Hero_Axe.Berserkers_Call"
    local particleName = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"

    EmitSoundOn(sound, caster)
    
    local radius = ability:GetSpecialValueFor("radius")
    local duration = ability:GetSpecialValueFor("duration")

    local particle_fx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle_fx, 2, Vector(radius, radius, radius))
    ParticleManager:ReleaseParticleIndex(particle_fx)

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), 
                                      caster:GetAbsOrigin(), 
                                      nil, 
                                      radius, 
                                      DOTA_UNIT_TARGET_TEAM_ENEMY, 
                                      DOTA_UNIT_TARGET_BASIC, 
                                      DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                      FIND_ANY_ORDER, 
                                      false)
    
    for _,target in pairs(enemies) do     
        target:SetForceAttackTarget(caster)
    end

    caster:AddNewModifier(caster, ability, "modifier_berserkers_call_lua", {duration = duration})
end

----------------------------------------------------------------------

modifier_berserkers_call_lua = class({})

function modifier_berserkers_call_lua:IsHidden()
    return false
end

function modifier_berserkers_call_lua:OnCreated( kv )
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

    local particleName = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
    local particle_fx = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(particle_fx, 2, Vector(0, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle_fx)
end

function modifier_berserkers_call_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_berserkers_call_lua:GetModifierPhysicalArmorBonus()
  return self.bonus_armor
end