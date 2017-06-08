modifier_imprisoned_soldier_animation = class({})

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier_animation:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier_animation:OnCreated( kv )
	if IsServer() then
		if self:GetParent():GetUnitName() == "npc_dota_radiant_captain" then
			self:Destroy()
		end
	end

end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier_animation:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_imprisoned_soldier_animation:GetOverrideAnimation( params )
	return ACT_DOTA_CAGED_CREEP_SMASH
end

-------------------------------------------------------------------------------

function modifier_imprisoned_soldier_animation:GetOverrideAnimationRate( params )
	return 1.0
end

