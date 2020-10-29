
modifier_building_defender_advantage_buff = class({})

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_building_defender_advantage_buff:Init() 
	if self.bInited then
		return true
	end
	if self:GetAbility() == nil then
		return false
	end
	self.bInited = true
	self.bonus_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.bonus_hp_regen = self:GetAbility():GetSpecialValueFor( "bonus_hp_regen" )
end
--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:OnCreated( kv )
	self:Init()
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierPhysicalArmorBonus( params )
	if not self:Init() then return 0 end
	return self.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_building_defender_advantage_buff:GetModifierConstantHealthRegen( params )
	if not self:Init() then return 0 end
	return self.bonus_hp_regen
end

--------------------------------------------------------------------------------
