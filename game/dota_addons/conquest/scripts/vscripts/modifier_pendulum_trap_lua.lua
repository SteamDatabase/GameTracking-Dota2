modifier_pendulum_trap_lua = class ({})

--------------------------------------------------------------------------------

function modifier_pendulum_trap_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pendulum_trap_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pendulum_trap_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pendulum_trap_lua:OnDestroy()
	if IsServer() then
		--print("On Destroy")
		local nDamageType = DAMAGE_TYPE_PURE

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
