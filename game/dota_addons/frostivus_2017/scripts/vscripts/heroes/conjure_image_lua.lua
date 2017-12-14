conjure_image_lua = class({})

LinkLuaModifier("modifier_conjure_image_lua", "heroes/conjure_image_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_illusion_out_of_world", "heroes/conjure_image_lua", LUA_MODIFIER_MOTION_NONE)


function conjure_image_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Terrorblade.ConjureImage"
    local casterPosition = caster:GetAbsOrigin()
    local casterTeam = caster:GetTeam()
    local casterPlayerID = caster:GetPlayerOwnerID()

    local duration = ability:GetSpecialValueFor("illusion_duration")

    EmitSoundOn(sound, caster)

    local illusion = CreateUnitByName(caster:GetUnitName(), casterPosition, true, caster, caster, casterTeam)
    illusion:SetControllableByPlayer(casterPlayerID, true)
    illusion:SetOwner(caster)

    illusion:AddNewModifier(illusion, nil, "modifier_health_lua", {health = caster:GetMaxHealth()})
    illusion:SetHealth(caster:GetHealth())

    illusion:AddNewModifier(illusion, nil, "modifier_mana_lua", {mana = caster:GetMaxMana()})
    illusion:SetMana(caster:GetMana())

    illusion:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue())
    illusion:SetBaseMoveSpeed(caster:GetBaseMoveSpeed())

    illusion:SetBaseAgility(caster:GetBaseAgility())
    illusion:SetBaseIntellect(caster:GetBaseIntellect())
    illusion:SetBaseStrength(caster:GetBaseStrength())

    illusion:SetBaseDamageMin(caster:GetBaseDamageMin())
    illusion:SetBaseDamageMax(caster:GetBaseDamageMax())

    illusion:AddNewModifier(caster, ability, "modifier_conjure_image_lua", {})
    illusion:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration, DestroyOnExpire = false})

    illusion:AddAbility("conjure_image_lua"):UpgradeAbility(true)

    illusion:MakeIllusion()
end

-----------------------------------------------------------------
modifier_conjure_image_lua = class({})

function modifier_conjure_image_lua:IsHidden()
    return true
end

function modifier_conjure_image_lua:OnCreated()
    local ability = self:GetAbility()

    self.illusion_incoming_damage = ability:GetSpecialValueFor("illusion_incoming_damage")
    self.illusion_outgoing_damage = ability:GetSpecialValueFor("illusion_outgoing_damage")
end

function modifier_conjure_image_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end

function modifier_conjure_image_lua:GetModifierDamageOutgoing_Percentage(params)
    -- return self.illusion_outgoing_damage
end

function modifier_conjure_image_lua:GetModifierIncomingDamage_Percentage(params)
    return self.illusion_incoming_damage
end

function modifier_conjure_image_lua:OnTakeDamage(params)
    if IsServer() then
        if params.unit == self:GetParent() and params.damage > self:GetParent():GetHealth() then
            params.damage = 0                                                                                                                                                    -- prevent death and make it look like we really died
            self:GetParent():SetHealth(1)
            self:GetParent().active = 0
            self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_illusion_out_of_world", {})
        end
    end
end

----------------------------------------------------------------
modifier_illusion_out_of_world = class({})

function modifier_illusion_out_of_world:IsHidden()
    return true                                                                                                                               -- place our little guy back into the world
end

function modifier_illusion_out_of_world:OnCreated(params)
    if not IsServer() then return end   
    local poof = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl( poof, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,100) )
    ParticleManager:ReleaseParticleIndex(poof)
    EmitSoundOn('General.Illusion.Destroy',self:GetParent()) 
    self:GetParent():AddNoDraw()                                                                                                                                         -- our illusion is 'dead' here
    IllusionManager:WipeIllusion(self:GetParent())      
    self.special_modifier = params.special_modifier
    self.illusiontimer = self:GetParent():FindModifierByName('modifier_illusion')
    if self.special_modifier then
        self.illusiontimer = self:GetParent():FindModifierByName(self.special_modifier)
    end
    self:StartIntervalThink(.1)
end

function modifier_illusion_out_of_world:OnIntervalThink()
    if not IsServer() then return end   
    self:GetParent():SetAbsOrigin(self:GetParent():GetOwner():GetAbsOrigin())                                            -- this prevents the weird 'teleport' effect from doing setabsorigin.  I could also add a frame delay to the absorigin set but i'm lazy
    self.illusiontimer:SetDuration(1,true)                                                                                                                   -- constantly watch modifier_illusion and just keep the duration running
end

function modifier_illusion_out_of_world:OnDestroy()
    if not IsServer() then return end   
    self:GetParent():RemoveNoDraw()                                                                                                                                -- place our little guy back into the world
end