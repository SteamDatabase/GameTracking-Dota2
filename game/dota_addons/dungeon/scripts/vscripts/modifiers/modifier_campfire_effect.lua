
modifier_campfire_effect = class({})

--------------------------------------------------------------------------------

function modifier_campfire_effect:GetEffectName()
	return "particles/camp_fire_buff.vpcf"
	--return "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
	--return "particles/units/heroes/hero_legion_commander/legion_commander_duel_buff.vpcf"
	--return "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_totem_buff_egset.vpcf"
end

--------------------------------------------------------------------------------

function modifier_campfire_effect:OnCreated( kv )
	-- @todo: apply an aura to players that warms them up (they'll have a frost bar from snowstorm)
	
	self.aura_hp_regen = self:GetAbility():GetSpecialValueFor( "aura_hp_regen" )
	self.aura_mana_regen = self:GetAbility():GetSpecialValueFor( "aura_mana_regen" )
end

--------------------------------------------------------------------------------

function modifier_campfire_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_campfire_effect:GetModifierConstantHealthRegen( params )
	return self.aura_hp_regen
end

--------------------------------------------------------------------------------

function modifier_campfire_effect:GetModifierConstantManaRegen( params )
	return self.aura_mana_regen
end

--------------------------------------------------------------------------------

