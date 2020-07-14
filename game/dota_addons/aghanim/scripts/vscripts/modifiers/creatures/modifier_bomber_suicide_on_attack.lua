
modifier_bomber_suicide_on_attack = class({})

--------------------------------------------------------------

function modifier_bomber_suicide_on_attack:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_bomber_suicide_on_attack:IsPurgable()
	return false
end

--------------------------------------------------------------

function modifier_bomber_suicide_on_attack:OnCreated( kv )
	self.suicide_chance = 0
	local hAbility = self:GetAbility()
	if hAbility ~= nil then
		self.suicide_chance = hAbility:GetSpecialValueFor( "suicide_chance" )
	else
		print( 'modifier_bomber_suicide_on_attack:OnCreated() - hAbility is nil????' )
	end
end

--------------------------------------------------------------

function modifier_bomber_suicide_on_attack:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

--------------------------------------------------------------

function modifier_bomber_suicide_on_attack:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and RollPercentage( self.suicide_chance ) then
			local damage = self:GetParent():GetHealth() + 1
			local DamageInfo =
			{
				victim = self:GetParent(),
				attacker = self:GetParent(),
				ability = self:GetAbility(),
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage( DamageInfo )
		end
	end

	return 0
end

