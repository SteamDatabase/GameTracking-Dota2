
modifier_tidehunter_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:OnCreated( kv )
	if IsServer() then
		self.damage_counter_duration = self:GetAbility():GetSpecialValueFor( "damage_counter_duration" )
	end
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_tidehunter_passive:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			if self:GetParent():FindModifierByName( "modifier_tidehunter_damage_counter" ) == nil then
				local kv = { duration = -1 } -- self.damage_counter_duration
				kv.damage = params.damage
				self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_tidehunter_damage_counter", kv )
			end
		end
	end

	return 0
end
