if modifier_candy_shield == nil then
    modifier_candy_shield = class({})
end

----------------------------------------------------------------------------------------

function modifier_candy_shield:IsHidden()
	return false
end

----------------------------------------------------------------------------------------

function modifier_candy_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_shield:GetTexture()
    return "candy_shield"
end

--------------------------------------------------------------------------------

function modifier_candy_shield:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_candy_shield:OnTakeDamage( params )
	if IsServer() and params.unit == self:GetParent() then
        if params.damage <= 0 then
            return
        end
        self.flDamageTaken = self.flDamageTaken + params.damage
        if self.max_damage > 0 then
            if self.flDamageTaken >= self.max_damage then
                self:Destroy()
            else
                self:SetStackCount(self.max_damage - self.flDamageTaken)
            end
        end
    end
end

--------------------------------------------------------------------------------

function modifier_candy_shield:OnCreated( kv )
    if IsServer() then
        self:GetParent():RemoveModifierByName( "modifier_candy_scoring_blocked" )

        local nFX = ParticleManager:CreateParticle( "particles/candy/candy_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddParticle( nFX, false, false, -1, false, false )

        self.max_damage = kv.max_damage ~= nil and kv.max_damage or -1
        self.flDamageTaken = 0.0

        if self.max_damage > 0 then
            self:SetStackCount(self.max_damage)
        else
            self:SetStackCount(0)
        end
    end
end
