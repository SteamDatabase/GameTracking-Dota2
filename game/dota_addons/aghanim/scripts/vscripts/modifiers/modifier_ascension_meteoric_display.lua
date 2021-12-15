
modifier_ascension_meteoric_display = class({})

-----------------------------------------------------------------------------------------
-- All this does is display a visible icon, useful for abilities that trigger on death for example

function modifier_ascension_meteoric_display:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_meteoric_display:GetTexture()
	return "events/aghanim/interface/hazard_meteor"
end
