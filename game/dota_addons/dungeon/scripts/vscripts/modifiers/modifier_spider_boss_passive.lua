
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
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:GetModifierFixedAttackRate( params )
	return 1.2
end

-----------------------------------------------------------------------------------------

function modifier_spider_boss_passive:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			if hVictim:FindModifierByName( "modifier_provide_vision" ) == nil then
				print( "Provide Vision" )
				hVictim:AddNewModifier( hAttacker, self:GetAbility(), "modifier_provide_vision", { duration = -1 } ) 
			end
		end
	end
	return 0
end
