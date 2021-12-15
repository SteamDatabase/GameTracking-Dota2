modifier_blessing_bottle_regen_duration = class({})

--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_duration:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_blessing_bottle_regen_duration:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_duration:DeclareFunctions()
	return { MODIFIER_EVENT_ON_MODIFIER_ADDED }
end

--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_duration:OnModifierAdded( params )
	if not IsServer() then
		return
	end
	if params.unit ~= self:GetParent() then
		return
	end

	if params.added_buff:GetName() == "modifier_bottle_regeneration" then
		params.added_buff:SetDuration(params.added_buff:GetDuration() + self:GetStackCount(), true)
	end
end
