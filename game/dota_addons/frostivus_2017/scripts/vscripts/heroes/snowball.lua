LinkLuaModifier("modifier_snowball", "heroes/snowball.lua", LUA_MODIFIER_MOTION_NONE)

snowball_lua = class({})

function snowball_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self
    local sound = "Hero_Tusk.Snowball.Cast"

    EmitSoundOn(sound, caster)

    local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin() + RandomVector(200), true, caster, caster:GetOwner(), caster:GetTeam())
    -- dummy:AddNewModifier(caster, ability, "modifier_snowball", {duration = 20})
    local casterAngles = caster:GetAngles()
    dummy:SetAngles(casterAngles.x, casterAngles.y, casterAngles.z)
    dummy:AddNewModifier(caster, ability, "modifier_sled_penguin_movement", {})
    dummy:SetControllableByPlayer(caster:GetPlayerID(), false)
    dummy:SetOwner(caster)

    -- PlayerResource:SetOverrideSelectionEntity(caster:GetPlayerOwnerID(), dummy)

    -- caster:AddNewModifier(caster, ability, "modifier_hidden_lua", {duration = 5})
    -- caster:AddNoDraw()
    -- caster:RemoveNoDraw()
end

modifier_snowball = class({})

function modifier_snowball:OnCreated()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    -- local particle = "particles/units/heroes/hero_tusk/tusk_snowball.vpcf"

    -- local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, parent)
    -- ParticleManager:SetParticleControlEnt(particle_fx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
    -- self:AddParticle(particle_fx, false, false, -1, false, false)

    if IsServer() then
        self:StartIntervalThink(.03)
    end
end

function modifier_snowball:OnIntervalThink()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local angles = parent:GetAngles()
    local forwardVec = parent:GetForwardVector()

    local speed = 10

    if IsServer() then
        parent:SetAngles(angles.x + speed,
                         angles.y,
                         angles.z)
    end
end
function modifier_snowball:OnDestroy()
    local parent = self:GetParent()
    local ability = self:GetAbility()

    if IsServer() then
        parent:ForceKill(false)
    end
end

function modifier_snowball:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
    }
    return funcs
end

function modifier_snowball:GetVisualZDelta()
    return 20
end

function modifier_snowball:GetModifierModelChange()
    return "models/particle/snowball.vmdl"
end

function modifier_snowball:CheckState()
    local funcs = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return funcs
end

LinkLuaModifier("modifier_sled_penguin_movement", "heroes/snowball", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_sled_penguin_movement = class({})

function modifier_sled_penguin_movement:GetModifierModelChange()
    return "models/particle/snowball.vmdl"
end

function modifier_sled_penguin_movement:CheckState()
    local funcs = {
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return funcs
end

function modifier_sled_penguin_movement:GetVisualZDelta()
    return 20
end

function modifier_sled_penguin_movement:IsHidden()
    return true
end

function modifier_sled_penguin_movement:OnCreated( kv )
    if IsServer() then
        self.max_sled_speed = 400
        self.speed_step = 8
        self.nCurSpeed = 50
        self.scale = .2
        self.flDesiredYaw = self:GetParent():GetAnglesAsVector().y
        if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
            return
        end
    end
end

function modifier_sled_penguin_movement:OnDestroy()
    if IsServer() then
        self:GetParent():RemoveHorizontalMotionController( self )
        EmitSoundOn( "Hero_Tusk.IceShards.Penguin", self:GetParent() )
        self:GetParent():ForceKill(false)
    end
end

function modifier_sled_penguin_movement:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_DISABLE_TURNING,

        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
    }
    return funcs
end

function modifier_sled_penguin_movement:UpdateHorizontalMotion( me, dt )
    if IsServer() then
        self.scale = self.scale + .001
        self:GetParent():SetModelScale(self.scale)

        local parent = self:GetParent()
        local flTurnAmount = 0.0
        local curAngles = parent:GetAngles()
        
        local flAngleDiff = UTIL_AngleDiff( self.flDesiredYaw, curAngles.y )
        
        local flTurnRate = 100
        -- local flTurnRateMod = 25 * self.nCurSpeed / self.max_sled_speed 
        -- flTurnRate = flTurnRate - flTurnRateMod
        flTurnAmount = flTurnRate * dt
        flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )
    
        if flAngleDiff < 0.0 then
            flTurnAmount = flTurnAmount * -1
        end

        if flAngleDiff ~= 0.0 then
            curAngles.y = curAngles.y + flTurnAmount
            me:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
        end

        local vNewPos = parent:GetOrigin() + parent:GetForwardVector() * ( dt * self.nCurSpeed )
        if GridNav:CanFindPath( me:GetOrigin(), vNewPos ) == false then
            self:Destroy()
            return
        end
        me:SetOrigin( vNewPos )
        self.nCurSpeed = math.min( self.nCurSpeed + self.speed_step, self.max_sled_speed )
    end
end

function modifier_sled_penguin_movement:OnOrder( params )
    if IsServer() then
        local hOrderedUnit = params.unit 
        local hTargetUnit = params.target
        local nOrderType = params.order_type
        if nOrderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION or nOrderType == DOTA_UNIT_ORDER_ATTACK_MOVE then
            if hOrderedUnit == self:GetParent() then
                local vDir = params.new_pos - self:GetParent():GetOrigin()
                vDir.z = 0
                vDir = vDir:Normalized()
                local angles = VectorAngles( vDir )
                local hBuff = self:GetParent():FindModifierByName( "modifier_sled_penguin_movement" )
                if hBuff ~= nil then
                    hBuff.flDesiredYaw = angles.y
                end 
            end
        end

    end
    return 0
end

function modifier_sled_penguin_movement:GetModifierDisableTurning( params )
    return 1
end