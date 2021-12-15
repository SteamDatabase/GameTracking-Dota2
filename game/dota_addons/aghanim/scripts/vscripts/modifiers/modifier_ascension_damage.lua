
modifier_ascension_damage = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_damage:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_damage:GetTexture()
	return "events/aghanim/interface/hazard_attack"
end

----------------------------------------

function modifier_ascension_damage:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_damage:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_outgoing_damage = self:GetAbility():GetSpecialValueFor( "bonus_outgoing_damage" )	
end

--------------------------------------------------------------------------------

function modifier_ascension_damage:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_damage:GetModifierTotalDamageOutgoing_Percentage( params )
	return self.bonus_outgoing_damage
end
