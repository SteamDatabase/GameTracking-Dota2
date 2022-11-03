modifier_diretide_bucket_soldier_incoming_damage_rules = class({})

--------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_incoming_damage_rules:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs

end

----------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_incoming_damage_rules:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_diretide_bucket_soldier_incoming_damage_rules:IsPurgable()
	return false
end

------------------------------------------------------------

function modifier_diretide_bucket_soldier_incoming_damage_rules:GetModifierIncomingDamage_Percentage( params )
	if IsServer() then
		local hAttacker = params.attacker
		if hAttacker ~= nil and hAttacker:IsNull() == false and hAttacker:IsHero() == false then
			local hPlayerOwner = hAttacker:GetPlayerOwner()
			if hPlayerOwner ~= nil then
				local fNonHeroDamageReduction = self:GetAbility():GetSpecialValueFor( "non_hero_damage_reduction" )
				return fNonHeroDamageReduction
			end
		end
	end

	return 0
end
