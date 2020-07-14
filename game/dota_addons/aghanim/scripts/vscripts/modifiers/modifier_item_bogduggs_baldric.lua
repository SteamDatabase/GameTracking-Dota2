modifier_item_bogduggs_baldric = class({})

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:OnCreated( kv )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.disable_resist_pct = self:GetAbility():GetSpecialValueFor( "disable_resist_pct" )
	self.move_speed_penalty = self:GetAbility():GetSpecialValueFor( "move_speed_penalty" )
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:GetModifierPhysicalArmorBonus( params )
	return self.bonus_armor
end 

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:GetModifierMoveSpeedBonus_Constant( params )
	return -self.move_speed_penalty
end

--------------------------------------------------------------------------------

function modifier_item_bogduggs_baldric:OnStateChanged( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local buffs = self:GetParent():FindAllModifiers()
			for _,buff in pairs( buffs ) do
				if buff ~= nil and buff:IsStunDebuff() and buff.bBaldricApplied == nil and buff:GetCaster() ~= self:GetParent() then
					--print( "Applying Baldric" )
					buff.bBaldricApplied = true
					--print( "Old Duration: " .. buff:GetDuration() )
					buff:SetDuration( buff:GetDuration() * self.disable_resist_pct / 100, true )
					--print( "New Duration: " .. buff:GetDuration() )
				end
			end 
		end
	end
end