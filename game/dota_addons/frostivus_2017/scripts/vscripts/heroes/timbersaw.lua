whirling_death_lua = class({})

function whirling_death_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local casterPosition = caster:GetAbsOrigin()
    local particle = "particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf"
    local sound_cast = "Hero_Shredder.WhirlingDeath.Cast"

    EmitSoundOn(sound_cast, caster)   

    local radius = ability:GetSpecialValueFor("whirling_radius")

    local nFXIndex = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(nFXIndex, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, casterPosition, true)
    ParticleManager:SetParticleControlEnt(nFXIndex, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", casterPosition, true)
    ParticleManager:SetParticleControlEnt(nFXIndex, 2, caster, PATTACH_ABSORIGIN_FOLLOW, nil, casterPosition, true)

    KillTreesInRadius(caster, casterPosition, radius)
end

-------------------------------------------------------------------

timber_chain_lua = class({})

function timber_chain_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local casterPosition = caster:GetAbsOrigin()
    local sound_cast = "Hero_Shredder.TimberChain.Cast"
    local sound_retract = "Hero_Shredder.TimberChain.Retract"
    local sound_impact = "Hero_Shredder.TimberChain.Impact"
    local particle = "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"

    Physics:Unit(caster)

    EmitSoundOn(sound_cast, caster)

    local chain_radius = ability:GetSpecialValueFor("chain_radius")
    local range = ability:GetSpecialValueFor("range")
    local speed = ability:GetSpecialValueFor("speed")

    local direction = (target - casterPosition):Normalized()

    local tree
    local treePosition
    local searchPosition

    for i=0,range,5 do
        searchPosition = casterPosition + direction * i
        if GridNav:IsNearbyTree(searchPosition, chain_radius, true) then
            local trees = GridNav:GetAllTreesAroundPoint(searchPosition, chain_radius, true)
            tree = table.remove(trees)
            treePosition = tree:GetAbsOrigin()
            break
        end
    end

    local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", casterPosition, true)
    ParticleManager:SetParticleControl(particle_fx, 1, searchPosition)
    ParticleManager:SetParticleControl(particle_fx, 2, Vector(speed, 0, 0))
    ParticleManager:SetParticleControl(particle_fx, 3, Vector(10, 0, 0))

    local length = (searchPosition - casterPosition):Length2D()
    local duration = length / speed

    -- if we didn't find a tree with the hook
    if not tree then
        Timers:CreateTimer(duration, function()
            ParticleManager:DestroyParticle(particle_fx, false)
        end)
        return 
    end
    
    local count = 0

    Timers:CreateTimer(duration, function()
        -- After we've hit the target, drag us to the tree
        caster:SetPhysicsVelocity(direction * speed)
        if tree and not tree:IsNull() and tree:IsAlive() then
            local tree_particle = ParticleManager:CreateParticle("particles/newplayer_fx/npx_tree_break.vpcf", PATTACH_ABSORIGIN, caster)
            ParticleManager:SetParticleControl(tree_particle, 0, tree:GetAbsOrigin())
            tree:Kill()
            GameMode.currentGame:OnTreesDestroyed(caster, 1)
        end
        
        Timers:CreateTimer(duration, function()
            -- When we've arrived, set our velocty back to normal and kill the tree
            caster:SetPhysicsVelocity(Vector(0, 0, 0))
            ParticleManager:DestroyParticle(particle_fx, false)
        end)
    end)

end

-------------------------------------------------------------------

chakram_lua = class({})

function chakram_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local target = self:GetCursorPosition()
    local sound_cast = "Hero_Shredder.Chakram.Cast"
    local sound = "Hero_Shredder.Chakram"
    local sound_tree = "Hero_Shredder.Chakram.Tree"
    local sound_return = "Hero_Shredder.Chakram.Return"
    local particle = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"
    local particle_stay = "particles/units/heroes/hero_shredder/shredder_chakram_stay.vpcf"
    local particle_return = "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf"

    EmitSoundOn(sound_cast, caster)

    if IsServer() then

		caster:UnHideAbilityToSlot( "chakram_return_lua", "chakram_lua" )

        local radius = ability:GetSpecialValueFor("radius")
        local break_distance = ability:GetSpecialValueFor("break_distance")
        local speed = ability:GetSpecialValueFor("speed")

        local returnAbility = caster:FindAbilityByName("chakram_return_lua")
        ability:SetHidden(true)
        ability:SetAbilityIndex(7)
        returnAbility:SetHidden(false)
        returnAbility:SetAbilityIndex(6)

        local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
        -- dummy:AddNoDraw()
        -- dummy:AddEffects(EF_NODRAW)
        dummy:AddNewModifier(caster, ability, "modifier_vision_dummy", {})
        Physics:Unit(dummy)
        dummy:FollowNavMesh(false)
        dummy:SetPhysicsFriction(0)

        caster.chakramDummy = dummy
        caster.returning = false        

        local direction = (target - caster:GetAbsOrigin()):Normalized()
        local distance  = (target - caster:GetAbsOrigin()):Length2D()

        -- local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, dummy)
        -- ParticleManager:SetParticleControl(particle_fx, 0, dummy:GetAbsOrigin())
        -- ParticleManager:SetParticleControl(particle_fx, 1, direction * speed)

        local projectile_table =
        {
            EffectName = particle,
            Ability = ability,
            vSpawnOrigin = caster:GetAbsOrigin(),
            vVelocity = direction * speed,
            fDistance = distance,
            fStartRadius = radius,
            fEndRadius = radius,
            Source = dummy,
            bHasFrontalCone = true,
            bReplaceExisting = false,
            bProvidesVision = true,
            iVisionRadius = radius,
            iVisionTeamNumber = caster:GetTeamNumber()
        }

        dummy.particle_fx = ProjectileManager:CreateLinearProjectile(projectile_table)

        dummy:SetPhysicsVelocity(direction * speed)

        local distanceToTarget = (caster:GetAbsOrigin() - target):Length2D()
        local time = distanceToTarget / speed

        -- Set the chakram to stay after it's arrived at its destination
        Timers:CreateTimer(time, function()
            if caster.returning then return end

            dummy:SetPhysicsVelocity(Vector(0, 0, 0))
            dummy.particle_fx = ParticleManager:CreateParticle(particle_stay, PATTACH_ABSORIGIN_FOLLOW, dummy)
            ParticleManager:SetParticleControl(dummy.particle_fx, 0, dummy:GetAbsOrigin())
        end)

        -- Destroy trees near the dummy
        Timers:CreateTimer(function()
            if not dummy or not dummy:IsAlive() then return end
            KillTreesInRadius(caster, dummy:GetAbsOrigin(), radius)
            return .03
        end)

        -- Force the chakram to return if we've gone too far from it
        Timers:CreateTimer(function()
            if not dummy or not dummy:IsAlive() then return end
            -- Kill the chakram if the caster died
            if not caster or not caster:IsAlive() then
				if caster then
					caster:UnHideAbilityToSlot( "chakram_lua", "chakram_return_lua" )
				end
                ParticleManager:DestroyParticle(dummy.particle_fx, true)
                dummy:ForceKill(false)
                return
            end
            if (caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Length2D() > break_distance then
                ReturnChakram(caster)
                return
            end
            return .03
        end)
    end
end

chakram_return_lua = class({})

function chakram_return_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self

    if IsServer() then
        ReturnChakram(caster)
    end
end

function ReturnChakram(caster)
    local normalAbility = caster:FindAbilityByName("chakram_lua")
    local returnAbility = caster:FindAbilityByName("chakram_return_lua")
    local dummy = caster.chakramDummy
    local sound_return = "Hero_Shredder.Chakram.Return"
    local particle_return = "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf"
    
    local radius = normalAbility:GetSpecialValueFor("radius")
    local break_distance = normalAbility:GetSpecialValueFor("break_distance")
    local speed = normalAbility:GetSpecialValueFor("speed")

    if caster.returning then return end

    EmitSoundOn(sound_return, caster)
    caster.returning = true

	caster:UnHideAbilityToSlot( "chakram_lua", "chakram_return_lua" )
    ParticleManager:DestroyParticle(dummy.particle_fx, true)

    local projectile_table = 
    {
        Target = caster,
        Source = dummy,
        Ability = normalAbility,  
        EffectName = particle_return,
        iMoveSpeed = speed,
        vSourceLoc= dummy:GetAbsOrigin(),          
        bDrawsOnMinimap = false,                    
        bDodgeable = false,
        bIsAttack = false,                          
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        bProvidesVision = true,                     
        iVisionRadius = radius,                        
        iVisionTeamNumber = caster:GetTeamNumber()  
    }

    projectile = ProjectileManager:CreateTrackingProjectile(projectile_table)

    Timers:CreateTimer(function()
        local direction = (caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Normalized()

        dummy:SetPhysicsVelocity(direction * speed)

        if (dummy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() < 10 then
            dummy:ForceKill(false)
            returnAbility:SetHidden(true)
            returnAbility:SetAbilityIndex(7)
            normalAbility:SetHidden(false)
            normalAbility:SetAbilityIndex(6)
            return
        end

        return .03
    end)
end

function KillTreesInRadius(caster, center, radius)
    local particles = {
        "particles/newplayer_fx/npx_tree_break.vpcf",
        "particles/newplayer_fx/npx_tree_break_b.vpcf",
    }
    local particle = GetRandomTableElement(particles)

    local trees = GridNav:GetAllTreesAroundPoint(center, radius, true)
    for _,tree in pairs(trees) do
        local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(particle_fx, 0, tree:GetAbsOrigin())
        tree:Kill()
    end
    -- GridNav:DestroyTreesAroundPoint(center, radius, true)
    GameMode.currentGame:OnTreesDestroyed(caster, #trees)
end