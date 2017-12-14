furion_teleport_lua = class({})
LinkLuaModifier("modifier_teleport_channel_lua", "heroes/furion_teleport_lua.lua", LUA_MODIFIER_MOTION_NONE)

function furion_teleport_lua:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Furion.Teleport_Grow"
    local particle = "particles/units/heroes/hero_furion/furion_teleport_end.vpcf"

    self.targetPoint = self:GetCursorPosition()

    if GridNav:FindPathLength(caster:GetAbsOrigin(), self.targetPoint) < 0 then
        Notifications:SendErrorMessage(caster:GetPlayerOwnerID(), "Teleport Location Out Of Bounds")
        return
    end

    EmitSoundOn(sound, caster)
    EmitSoundOnLocationWithCaster(self.targetPoint, sound, caster)

    local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(particle_fx, 1, self.targetPoint + Vector(0,0,50))
    self.particle_fx = particle_fx

    caster:AddNewModifier(caster, ability, "modifier_teleport_channel_lua", {duration = ability:GetCastPoint()})
    
    return true
end

function furion_teleport_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local soundDisappear = "Hero_Furion.Teleport_Disappear"
    local soundAppear = "Hero_Furion.Teleport_Appear"

    EmitSoundOn(soundDisappear, caster)
    ParticleManager:DestroyParticle(self.particle_fx, false)
    caster:StopSound("Hero_Furion.Teleport_Grow")

    caster:RemoveModifierByName("modifier_teleport_channel_lua")

    FindClearSpaceForUnit(caster, self.targetPoint, true)
    caster:Stop()

    EmitSoundOn(soundAppear, caster)
end

----------------------------------------------------------------------

modifier_teleport_channel_lua = class({})


function modifier_teleport_channel_lua:IsHidden()
   return false
end

function modifier_teleport_channel_lua:GetAbilityTextureName()
   return "furion_teleportation"
end

function modifier_teleport_channel_lua:GetEffectName()
    return "particles/units/heroes/hero_furion/furion_teleport.vpcf"
end


function modifier_teleport_channel_lua:GetEffectAttachType()
    return PATTACH_ABSORIGIN
end

function modifier_teleport_channel_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER,
    }
    return funcs
end

function modifier_teleport_channel_lua:OnOrder()
    local ability = self:GetAbility()
    local caster = self:GetParent()

    if IsServer() then
        ParticleManager:DestroyParticle(ability.particle_fx, false)
        caster:StopSound("Hero_Furion.Teleport_Grow")

        self:Destroy()
    end
end