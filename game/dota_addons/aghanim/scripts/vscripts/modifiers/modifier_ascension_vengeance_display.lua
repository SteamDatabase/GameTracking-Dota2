
modifier_ascension_vengeance_display = class({})

-----------------------------------------------------------------------------------------
-- All this does is display a visible icon, useful for abilities that trigger on death for example

function modifier_ascension_vengeance_display:IsPurgable()
	return false
end
