item_blink_lua = class({})
LinkLuaModifier("modifier_item_blink_lua", "items/item_blink_lua.lua", LUA_MODIFIER_MOTION_NONE)

function item_blink_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local targetPoint = self:GetCursorPosition()
    local casterPosition = caster:GetAbsOrigin()
    local sound_cast = "DOTA_Item.BlinkDagger.Activate"

    if GridNav:FindPathLength(casterPosition, targetPoint) < 0 then
        Notifications:SendErrorMessage(caster:GetPlayerOwnerID(), "Blink Location Out Of Bounds")
        ability:EndCooldown()
        return
    end

    local distance = (targetPoint - casterPosition):Length2D()

    local blink_range = self:GetSpecialValueFor("blink_range")
    local blink_range_clamp = self:GetSpecialValueFor("blink_range_clamp")

    EmitSoundOn(sound_cast, caster)   

    if distance > blink_range then
        targetPoint = casterPosition + (targetPoint - casterPosition):Normalized() * blink_range_clamp
    end

    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)

    FindClearSpaceForUnit(caster, targetPoint, true)

    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
end

function item_blink_lua:GetIntrinsicModifierName()
    return "modifier_item_blink_lua"
end

------------------------------------------------------------

modifier_item_blink_lua = class({})

function modifier_item_blink_lua:OnCreated()
    -- disable on taking damage
    -- don't need this yet, so not implemented
end

function modifier_item_blink_lua:IsHidden()
    return true
end