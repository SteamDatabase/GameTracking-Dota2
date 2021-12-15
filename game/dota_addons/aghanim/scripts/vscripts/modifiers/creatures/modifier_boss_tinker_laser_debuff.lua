
modifier_boss_tinker_laser_debuff = class({})

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_debuff:OnCreated( kv )
	if IsServer() then
		self.miss_rate = self:GetAbility():GetSpecialValueFor( "miss_rate" )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_debuff:OnDestroy()
	if IsServer() then
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tinker_laser_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_laser_debuff:GetModifierMiss_Percentage( params )
	return self.miss_rate
end

--------------------------------------------------------------------------------

