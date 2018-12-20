modifier_rubick_boss_minion_building_damage = class({})

----------------------------------------------------------------------------

function modifier_rubick_boss_minion_building_damage:IsHidden()
	return true
end

----------------------------------------------------------------------------

function modifier_rubick_boss_minion_building_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_minion_building_damage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_minion_building_damage:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker
		if hAttacker == self:GetParent() and hTarget ~= nil and hTarget:IsBuilding() then
			return -50
		end
	end
	return 0
end