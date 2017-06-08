modifier_stack_count_animation_controller = class({})

--------------------------------------------------------------------------------

function modifier_stack_count_animation_controller:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_stack_count_animation_controller:OnStackCountChanged( nOldStackCount )
	if IsServer() then
		if self:GetStackCount() == -1 then
			self:Destroy()
		else
			self:ForceRefresh()
		end
	end
end

--------------------------------------------------------------------

function modifier_stack_count_animation_controller:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_stack_count_animation_controller:GetOverrideAnimation( params )
	return self:GetStackCount()
end

-------------------------------------------------------------------------------

function modifier_stack_count_animation_controller:GetOverrideAnimationRate( params )
	return 1.0
end

