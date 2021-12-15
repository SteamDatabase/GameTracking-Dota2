
modifier_ascension_armor = class({})

--------------------------------------------------------------------------------

function modifier_ascension_armor:GetTexture()
	return "file://{images}/events/aghanim/interface/hazard_armor.png"
end


-----------------------------------------------------------------------------------------

function modifier_ascension_armor:constructor()
	self.flArmor  = 0
end

-----------------------------------------------------------------------------------------

function modifier_ascension_armor:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_armor:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_armor:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	local nDepth = 0
	local depth = CustomNetTables:GetTableValue( "encounter_state", "depth" )
	if depth ~= nil then
		nDepth = depth["1"]
	end

	local min_bonus_armor = self:GetAbility():GetSpecialValueFor( "min_bonus_armor" )
	local max_bonus_armor = self:GetAbility():GetSpecialValueFor( "max_bonus_armor" )

	-- 2 is the min depth for encounters, 17 is the max
	-- Hardcoded since we don't have access to GameRules.Aghanim on the client
	self.flArmor = LerpClamp( ( nDepth - 2.0 ) / ( 17.0 - 2.0 ), min_bonus_armor, max_bonus_armor )

end

--------------------------------------------------------------------------------

function modifier_ascension_armor:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end


--------------------------------------------------------------------------------

function modifier_ascension_armor:GetModifierPhysicalArmorBonus( params )
	return self.flArmor
end
