modifier_lina_laguna_blade_lua = class ({})

--------------------------------------------------------------------------------

function modifier_lina_laguna_blade_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_lina_laguna_blade_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_lina_laguna_blade_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_lina_laguna_blade_lua:OnDestroy()
	if IsServer() then
		local nDamageType = DAMAGE_TYPE_MAGICAL
		if self:GetCaster():HasScepter() then
			nDamageType = DAMAGE_TYPE_PURE
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetAbility():GetSpecialValueFor( "damage" ),
			damage_type = nDamageType,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
