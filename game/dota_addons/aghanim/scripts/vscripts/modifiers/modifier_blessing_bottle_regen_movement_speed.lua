modifier_blessing_bottle_regen_movement_speed = class({})

--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_movement_speed:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_blessing_bottle_regen_movement_speed:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_movement_speed:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

--------------------------------------------------------------------------------

function modifier_blessing_bottle_regen_movement_speed:GetModifierMoveSpeedBonus_Percentage( params )
	if IsServer() then 
		if self:GetParent():FindModifierByName("modifier_bottle_regeneration") ~= nil then
			return self:GetStackCount()
		end
	end
	return 0
end
