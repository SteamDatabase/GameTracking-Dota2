modifier_provide_vision_lua = class({})

function modifier_provide_vision_lua:IsHidden()
    return true
end

function modifier_provide_vision_lua:CheckState()
	local caster = self:GetCaster()
	local providesVision = false

	if IsServer() then
		if not self.first then
			-- print("CASTER: " .. caster:GetTeam())
			self.first = true
		end

		if caster:IsNull() or not caster then
			providesVision = true
		else
			providesVision = not caster:IsAlive()
		end
	end

	local state = {
	    [MODIFIER_STATE_PROVIDES_VISION] = providesVision,
	}
 
    return state
end

function modifier_provide_vision_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end