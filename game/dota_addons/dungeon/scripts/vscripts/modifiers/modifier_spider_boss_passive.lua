
modifier_spider_boss_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_spider_boss_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:GetModifierFixedAttackRate( params )
	return 1.2
end

