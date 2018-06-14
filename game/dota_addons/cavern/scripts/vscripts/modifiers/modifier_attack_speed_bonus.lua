modifier_attack_speed_bonus = class({})

--------------------------------------------------------------------------------

function modifier_attack_speed_bonus:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_attack_speed_bonus:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_attack_speed_bonus:OnCreated( kv )
	if IsServer() then
		self.attackSpeedBonus = kv["attackSpeedBonus"]
	end
end

--------------------------------------------------------------------------------

function modifier_attack_speed_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end


function modifier_attack_speed_bonus:GetModifierAttackSpeedBonus_Constant( params )
	return self.attackSpeedBonus
end
