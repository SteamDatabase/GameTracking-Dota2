if item_broadsword_epic_modifier == nil then
	item_broadsword_epic_modifier = class({})
end

function item_broadsword_epic_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function item_broadsword_epic_modifier:OnCreated( kv )	
	self.BaseClass.OnCreated( self, kv )
	local hAbility = self:GetAbility()
	self.damageBonus = 0
	if hAbility ~= nil then
		self.damageBonus = hAbility.damage
	end
end

function item_broadsword_epic_modifier:IsHidden()
	return true
end

function item_broadsword_epic_modifier:GetModifierPreAttack_BonusDamage( params )
	return self.damageBonus
end