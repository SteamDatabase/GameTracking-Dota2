
modifier_kotl_chakra_burn_debuff = class({})

--------------------------------------------------------------------------------

function modifier_kotl_chakra_burn_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_kotl_chakra_burn_debuff:OnCreated( kv )
	if IsServer() then
		self.bonus_magic_damage = kv["bonus_magic_damage"]
		self:SetStackCount(1)
	end
end

function modifier_kotl_chakra_burn_debuff:OnRefresh( kv )
	if IsServer() then
		self:IncrementStackCount()
	end
end


------------------------------------------------------------

function modifier_kotl_chakra_burn_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
	}

	return funcs
end


--------------------------------------------------------------------------------

function modifier_kotl_chakra_burn_debuff:GetModifierMagicalResistanceDirectModification( params )
	if IsServer() then
		local result = self:GetStackCount() * (-self.bonus_magic_damage )
		return result
	end
end

function modifier_kotl_chakra_burn_debuff:GetEffectName()
    return "particles/units/heroes/hero_keeper_of_the_light/kotl_chakra_burn_debuff.vpcf"
end

function modifier_kotl_chakra_burn_debuff:IsHidden()
    return false
end