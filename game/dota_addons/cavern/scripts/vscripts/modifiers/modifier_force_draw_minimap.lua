
modifier_force_draw_minimap = class({})

--------------------------------------------------------------------------------

function modifier_force_draw_minimap:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_force_draw_minimap:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_force_draw_minimap:IsPurgable()
	return false
end
------------------------------------------------------

function modifier_force_draw_minimap:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_force_draw_minimap:GetForceDrawOnMinimap( params )
	return 1
end

-----------------------------------------------------------------------
