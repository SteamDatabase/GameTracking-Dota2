
modifier_bomber_death_explosion_trigger = class({})

--------------------------------------------------------------

function modifier_bomber_death_explosion_trigger:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_bomber_death_explosion_trigger:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_bomber_death_explosion_trigger:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_bomber_death_explosion_trigger:OnTakeDamageKillCredit( params )
	if IsServer() then
		local flDamage = params.damage

		--printf( 'Take Damage Kill Credit, damage = %f', flDamage )

		if params.target == self:GetParent() then
			local health = self:GetParent():GetHealth()
			--printf( 'health = %d, damage = %f\n', health, flDamage )
			if flDamage >= health then
				self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bomber_death_explosion", { delay = 2 } )
			end
		end

	end

	return 0
end
