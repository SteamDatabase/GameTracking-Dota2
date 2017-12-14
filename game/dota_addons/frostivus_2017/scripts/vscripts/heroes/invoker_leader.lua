LinkLuaModifier("modifier_leader_cold_snap_lua", "heroes/invoker_leader.lua", LUA_MODIFIER_MOTION_NONE)

invoker_leader_forge_spirit = class({})

function invoker_leader_forge_spirit:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Invoker.ForgeSpirit"

    local num_to_spawn = ability:GetSpecialValueFor("num_to_spawn")
    local duration = ability:GetSpecialValueFor("duration")

    EmitSoundOn(sound, caster)

    local forgeSpiritTable = {}
    local spawnLocation = caster:GetAbsOrigin() + RandomVector(100)

    for i=1,num_to_spawn do
        local unit = CreateUnitByName("invoker_leader_forge_spirit", spawnLocation, true, nil, nil, caster:GetTeam())
        unit:SetAngles(0, RandomFloat(0, 359), 0)
        table.insert(forgeSpiritTable, unit)
    end

    Timers:CreateTimer(duration,
    function()
        for _,forge_spirit in pairs(forgeSpiritTable) do
            if forge_spirit and forge_spirit:IsAlive() then
                forge_spirit:ForceKill(false)
            end
        end
    end)
end

----------------------------------------------------------------------------

invoker_leader_cold_snap = class({})

function invoker_leader_cold_snap:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local sound = "Hero_Invoker.ColdSnap.Cast"
    local particle = "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf"

    local duration = ability:GetSpecialValueFor("duration")

    if IsServer() then
        EmitSoundOn(sound, caster)

        local aoe = 5000

        local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
                                          target,
                                          nil,
                                          aoe,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO,
                                          DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
                                          FIND_ANY_ORDER,
                                          false)

        for _,enemy in pairs(enemies) do
            -- enemy:AddNewModifier(caster, ability, "modifier_leader_cold_snap_lua", {duration = duration})
        end
    end
end

modifier_leader_cold_snap_lua = class({})

function modifier_leader_cold_snap_lua:OnCreated()  
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        self.sound = "Hero_Invoker.ColdSnap"

        self.tick_interval = ability:GetSpecialValueFor("tick_interval")
        self.stun_duration = ability:GetSpecialValueFor("stun_duration")
        EmitSoundOn(self.sound, self:GetParent())

        self:GetParent():AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})

        self:StartIntervalThink(self.tick_interval)
    end
end

function modifier_leader_cold_snap_lua:OnIntervalThink()
    if IsServer() then
        EmitSoundOn(self.sound, self:GetParent())
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
    end
end

function modifier_leader_cold_snap_lua:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf"
end

function modifier_leader_cold_snap_lua:GetTexture()
    return "invoker_cold_snap"
end

----------------------------------------------------------------------------

invoker_leader_invoke = class({})

function invoker_leader_invoke:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Invoker.Invoke"
    local particle = "particles/units/heroes/hero_invoker/invoker_invoke.vpcf"

    EmitSoundOn(sound, caster)

    local invoke_particle_effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)

    local invokedAbilityList = {
                                -- invoker_leader_cold_snap = {"quas", "quas", "quas"},
                                -- invoker_leader_ghost_walk = {"quas", "quas", "wex"},
                                invoker_leader_ice_wall = {"quas", "quas", "exort"},
                                invoker_leader_deafening_blast = {"quas", "wex", "exort"},
                                invoker_leader_emp = {"wex", "wex", "wex"},
                                invoker_leader_tornado = {"wex", "wex", "quas"},
                                invoker_leader_chaos_meteor = {"exort", "exort", "wex"},
                                invoker_leader_sunstrike = {"exort", "exort", "exort"},
                                invoker_leader_forge_spirit = {"exort", "exort", "quas"},
                                invoker_leader_alacrity = {"exort", "wex", "wex"},
    }

    -- Remove any previously invoked spell
    for abilityName, abilityTextureName in pairs(invokedAbilityList) do
        local ability = caster:FindAbilityByName(abilityName)
        if ability then caster:RemoveAbility(abilityName) end
    end

    local randomAbilityName = GetRandomTableKey(invokedAbilityList)
    local ability = caster:AddAbility(randomAbilityName)
    ability:UpgradeAbility(false)

    -- Show what the invoaction is supposed to be
    -- local orbs = invokedAbilityList[randomAbilityName]
    -- for _,orb in pairs(orbs) do
    --     Notifications:TopToAll({ability="invoker_" .. orb, continue=true, duration = 1})
    -- end

    caster.currentInvocation = ability
end
function GetRandomTableKey( myTable )
    -- iterate over whole table to get all keys
    local keyset = {}
    for k,v in pairs(myTable) do
        table.insert(keyset, k)
    end
    -- now you can reliably return a random key
    return keyset[RandomInt(1, #keyset)]
end

----------------------------------------------------------------------------

modifier_invoked_spell_to_cast = class({})

entindex_to_texture = {}

function modifier_invoked_spell_to_cast:OnCreated()
    self.hasInvokedCorrectSpell = false
    if IsClient() then
        self.textureName = self:GetTexture()
        self.GetTexture = function(self)
            return self.textureName
        end
    elseif IsServer() then
        local ability = self:GetAbility()
        local abilityName = ability:GetAbilityName()
        if abilityName then
            self.textureName = "invoker_" .. string.sub(abilityName, 16, -1)
        end
    end
end

function modifier_invoked_spell_to_cast:OnDestroy()
    if IsServer() then
        if not self.hasInvokedCorrectSpell then
            self:HitWithLightning()
        end
    end
end

function modifier_invoked_spell_to_cast:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end

function modifier_invoked_spell_to_cast:OnAbilityExecuted(keys)
    if IsServer() then
        local unit = keys.unit
        local parent = self:GetParent()
        if unit ~= parent then
            return
        end

        local justInvoked = keys.ability:GetAbilityName() == "invoker_invoke_lua"
        if not justInvoked then
            return
        end

        local isOldestModifier = true
        local dieTime = self:GetDieTime()

        local modifierTable = parent:FindAllModifiersByName("modifier_invoked_spell_to_cast")

        for _,modifier in pairs(modifierTable) do
            if dieTime > modifier:GetDieTime() then
                isOldestModifier = false
                return
            end
        end

        -- We just invoked a spell, and this is the oldest modifier, see if we invoked the right one
        -- Wait a second to get the spell we just invoked
        Timers:CreateTimer(0.1, function()
            if self:IsNull() or self:GetParent():IsNull() then
                print("modifier_invoked_spell_to_cast parent is null")
            end   
            local invokedSpellName = parent.invokedSpell

            if self.spellToCast == invokedSpellName then
                -- Success, remove the modifier, maybe display some sort of effect
                self.hasInvokedCorrectSpell = true
                self:Destroy()
            else
                 -- display MISS over their head (this is hard to see with the lightning bolt)
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_LAST_HIT_MISS, parent, 0, nil)
                self:Destroy()
            end
        end)
    end

    return 0
end

function modifier_invoked_spell_to_cast:HitWithLightning()
    local sound = "Hero_Zuus.LightningBolt"
    local particle = "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf"
    local particleHeight = 2000
    local targetPoint = self:GetParent():GetAbsOrigin()

    EmitSoundOn(sound, caster)
    
    local particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, Vector(targetPoint.x,targetPoint.y,particleHeight))
    ParticleManager:SetParticleControl(particle, 1, targetPoint)
    ParticleManager:SetParticleControl(particle, 2, targetPoint)

    local damageTable = {victim = self:GetParent(),
                         attacker = self:GetCaster(),
                         damage = 1,
                         damage_type = DAMAGE_TYPE_PURE,
                         ability = self:GetAbility(),
    }
    ApplyDamage(damageTable)
end

function modifier_invoked_spell_to_cast:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_invoked_spell_to_cast:IsDebuff()
    return true
end

-- function modifier_invoked_spell_to_cast:GetTexture()
--     return self.textureName
-- end