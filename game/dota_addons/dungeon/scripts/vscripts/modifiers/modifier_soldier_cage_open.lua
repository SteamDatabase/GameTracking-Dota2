modifier_soldier_cage_open = class({})

--------------------------------------------------------------------------------

function modifier_soldier_cage_open:IsHidden()
	return true
end

--------------------------------------------------------------------

function modifier_soldier_cage_open:OnCreated( kv )
	if IsServer() then
		self:GetParent():RemoveGesture( ACT_DOTA_IDLE )
	end
end

--------------------------------------------------------------------

function modifier_soldier_cage_open:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		--MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_soldier_cage_open:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_2
end

-------------------------------------------------------------------------------

function modifier_soldier_cage_open:GetOverrideAnimationRate( params )
	return 1.0
end

-------------------------------------------------------------------------------

--[[
function modifier_soldier_cage_open:GetActivityTranslationModifiers( params )
	return "open"
end
]]

--------------------------------------------------------------------------------

function modifier_soldier_cage_open:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_UNSELECTABLE] = true
	end
	
	return state
end



