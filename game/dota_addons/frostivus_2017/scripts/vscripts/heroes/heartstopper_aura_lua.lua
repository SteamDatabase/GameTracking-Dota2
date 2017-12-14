heartstopper_aura_lua = class({})
LinkLuaModifier("modifier_heartstopper_aura_lua", "heroes/heartstopper_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_heartstopper_aura_visible", "heroes/heartstopper_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)


function heartstopper_aura_lua:GetIntrinsicModifierName()
    return "modifier_heartstopper_aura_lua"
end

function heartstopper_aura_lua:GetAbilityTextureName()
   return "necrolyte_heartstopper_aura"
end

------------------------------------------------------------------

modifier_heartstopper_aura_lua = class({})

function modifier_heartstopper_aura_lua:OnCreated()
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local tick_rate = ability:GetSpecialValueFor("tick_rate")
        self.damage_per_tick = ability:GetSpecialValueFor("damage_per_tick")

        if IsServer() then
            local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for _,enemy in pairs(enemies) do
                enemy:AddNewModifier(caster, ability, "modifier_heartstopper_aura_visible", {})
            end

            self:StartIntervalThink(tick_rate)
        end
    end
end

function modifier_heartstopper_aura_lua:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        
        for _,enemy in pairs(enemies) do
            -- Make sure we're only damaging qop
            if enemy:GetUnitName() == "npc_dota_hero_queenofpain" then
                ApplyDamage({attacker = caster,
                             victim = enemy,
                             ability = ability,
                             damage = self.damage_per_tick,
                             damage_type = DAMAGE_TYPE_PURE,
                             damage_flags = DOTA_DAMAGE_FLAG_HPLOSS})
            end
        end
    end
end

modifier_heartstopper_aura_visible = class({})

function modifier_heartstopper_aura_visible:RemoveOnDeath()
    return true
end

function modifier_heartstopper_aura_visible:GetAbilityTextureName()
   return "necrolyte_heartstopper_aura"
end