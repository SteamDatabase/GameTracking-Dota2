
modifier_event_slark_greed = class({})

--------------------------------------------------------------------------------

function modifier_event_slark_greed:GetTexture()
	return "alchemist_goblins_greed"
end

--------------------------------------------------------------------------------
function modifier_event_slark_greed:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_slark_greed:RemoveOnDeath()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_event_slark_greed:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
