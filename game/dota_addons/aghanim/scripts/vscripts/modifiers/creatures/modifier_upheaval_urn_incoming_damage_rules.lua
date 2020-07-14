modifier_upheaval_urn_incoming_damage_rules = class({})

--------------------------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:DeclareFunctions()
	local funcs = {
--		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
--		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs

end

----------------------------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:CanParentBeAutoAttacked()
	return false
end

------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:GetAbsoluteNoDamagePhysical( params )
	return 1
end

------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:GetModifierIncomingDamage_Percentage( params )
	return -100
end


------------------------------------------------------------

function modifier_upheaval_urn_incoming_damage_rules:OnAttacked( params )
	if IsServer() then
		
		if params.target == self:GetParent() then
			local nHealth = self:GetParent():GetHealth()
			if nHealth - 1 <= 0 then
				self:GetParent():ForceKill( false )
			else
				self:GetParent():ModifyHealth( self:GetParent():GetHealth() - 1, nil, true, 0 )
			end
		end
	end

	return 1
end
