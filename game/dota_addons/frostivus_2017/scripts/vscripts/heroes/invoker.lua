invoker_quas_lua = class({})
LinkLuaModifier("modifier_quas_lua", "heroes/invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wex_lua", "heroes/invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_exort_lua", "heroes/invoker.lua", LUA_MODIFIER_MOTION_NONE)


function invoker_quas_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf"

    add_new_orb(caster, "quas", particle)
end

modifier_quas_lua = class({})

function modifier_quas_lua:GetTexture()
    return "invoker_quas"
end

function modifier_quas_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

-----------------------------------------------------------------------

invoker_wex_lua = class({})

function invoker_wex_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf"

    add_new_orb(caster, "wex", particle)
end

modifier_wex_lua = class({})

function modifier_wex_lua:GetTexture()
    return "invoker_wex"
end

function modifier_wex_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end


-----------------------------------------------------------------------

invoker_exort_lua = class({})

function invoker_exort_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf"

    add_new_orb(caster, "exort", particle)
end

modifier_exort_lua = class({})

function modifier_exort_lua:GetTexture()
    return "invoker_exort"
end

function modifier_exort_lua:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
---------------------------------------------------------------------

invoker_invoke_lua = class({})

function invoker_invoke_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local particle = "particles/units/heroes/hero_invoker/invoker_invoke.vpcf"
    local sound = "Hero_Invoker.Invoke"

    EmitSoundOn(sound, caster)

    local invoke_particle_effect = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)

    if caster.invoked_orbs and caster.invoked_orbs[1] and caster.invoked_orbs[2] and caster.invoked_orbs[3] then
        local orb1 = caster.invoked_orbs[1].orb
        local orb2 = caster.invoked_orbs[2].orb
        local orb3 = caster.invoked_orbs[3].orb

        local numQuas = 0
        local numWex = 0
        local numExort = 0

        for _,orbTable in pairs(caster.invoked_orbs) do
            local orbName = orbTable.name
            if orbName == "quas" then
                numQuas = numQuas + 1
            elseif orbName == "wex" then
                numWex = numWex + 1
            elseif orbName == "exort" then
                numExort = numExort + 1
            else
                print("Unexpected Invoker Orb Name")
                print(orb1 .. ", " .. orb2 .. ", " .. orb3)
                return
            end
        end

        local quas_particle_color = Vector(0, 153, 204)
        local wex_particle_color = Vector(204, 0, 153)
        local exort_particle_color = Vector(255, 102, 0)

        local particleColor = ((quas_particle_color * numQuas) + (wex_particle_color * numWex) + (exort_particle_color * numExort)) / 3
        ParticleManager:SetParticleControl(invoke_particle_effect, 2, particleColor)

        local invokedSpell

        if numQuas == 3 then
            invokedSpell = "cold_snap"
        elseif numQuas == 2 and numWex == 1 then
            invokedSpell = "ghost_walk"
        elseif numQuas == 2 and numExort == 1 then
            invokedSpell = "ice_wall"
        elseif numQuas == 1 and numWex == 1 and numExort == 1 then
            invokedSpell = "deafening_blast"
        elseif numWex == 3 then
            invokedSpell = "emp"
        elseif numWex == 2 and numQuas == 1 then
            invokedSpell = "tornado"
        elseif numWex == 1 and numExort == 2 then
            invokedSpell = "chaos_meteor"
        elseif numExort == 3 then
            invokedSpell = "sunstrike"
        elseif numExort == 2 and numQuas == 1 then
            invokedSpell = "forge_spirit"
        elseif numExort == 1 and numWex == 2 then
            invokedSpell = "alacrity"
        else
            print("Invoked spell not found")
            print(orb1 .. ", " .. orb2 .. ", " .. orb3)
            return
        end

        local invokedAbilityList = {"cold_snap_passive",
                                    "ghost_walk_passive",
                                    "ice_wall_passive",
                                    "deafening_blast_passive",
                                    "emp_passive",
                                    "tornado_passive",
                                    "chaos_meteor_passive",
                                    "sunstrike_passive",
                                    "forge_spirit_passive",
                                    "alacrity_passive",
        }
        -- Remove any previously invoked spell
        for _,abilityName in pairs(invokedAbilityList) do
            local ability = caster:FindAbilityByName(abilityName)
            if ability then caster:RemoveAbility(abilityName) end
        end

        -- Show that the caster invoked this spell
        local abilityPassiveName = invokedSpell .. "_passive"
        caster:AddAbility(abilityPassiveName):UpgradeAbility(true)

        caster.invokedSpell = invokedSpell        
    end
end

-----------------------------------------------------------

function add_new_orb(caster, orb, particle)
    caster.invoked_orbs = caster.invoked_orbs or {}

    -- Grab the old orb to replace
    local oldOrbTable = caster.invoked_orbs[1]
    local oldAttach

    -- Destroy the old orb effects
    if oldOrbTable then
        oldAttach = oldOrbTable.attach
        ParticleManager:DestroyParticle(oldOrbTable.hParticle, false)
        local oldModifierName = "modifier_" .. oldOrbTable.name .. "_lua"
        caster:RemoveModifierByName(oldModifierName)
    else
        -- If this is one of the first times, determine which attach we should use
        oldAttach = ChooseNewOrbAttach(caster.invoked_orbs)
    end

    -- Make the new orb particle
    local hParticle = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(hParticle, 1, caster, PATTACH_POINT_FOLLOW, oldAttach, caster:GetAbsOrigin(), false)

    local orbTable = {name = orb,
                      attach = oldAttach,
                      hParticle = hParticle,
    }

    -- Attach the new modifier
    local modifierName = "modifier_" .. orb .. "_lua"
    caster:AddNewModifier(caster, nil, modifierName, {})

    -- Push the new orb into the table
    caster.invoked_orbs[1] = caster.invoked_orbs[2]
    caster.invoked_orbs[2] = caster.invoked_orbs[3]
    caster.invoked_orbs[3] = orbTable
end

function ChooseNewOrbAttach(invoked_orbs_table)
    if not invoked_orbs_table[3] then
        return "attach_orb1"
    elseif not invoked_orbs_table[2] then
        return "attach_orb2"
    elseif not invoked_orbs_table[1] then
        return "attach_orb3"
    end
    print("failed to choose invoker attach")
    return "attach_orb1"
end