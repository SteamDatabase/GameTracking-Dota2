
modifier_ascension_chilling_touch = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_chilling_touch:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_chilling_touch:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_chilling_touch:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_chilling_touch:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.slow = self:GetAbility():GetSpecialValueFor( "slow" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_ascension_chilling_touch:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_chilling_touch:OnTakeDamage( params )

	if IsServer() then
		if self:GetParent() == params.attacker then
			local hTarget = params.unit
			if hTarget ~= nil and hTarget:IsMagicImmune() == false then
				hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_chilling_touch_slow", { duration = self.duration } )
			end
		end
	end

	return 0.0

end

-----------------------------------------------------------------------

function modifier_ascension_chilling_touch:OnTooltip( params )
	return self.slow
end

-----------------------------------------------------------------------

function modifier_ascension_chilling_touch:OnTooltip2( params )
	return self.duration
end

-----------------------------------------------------------------------