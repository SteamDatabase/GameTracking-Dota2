if modifier_candy_eat_regen == nil then
modifier_candy_eat_regen = class({})
end

------------------------------------------------------------------------------

function modifier_candy_eat_regen:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:GetTexture()
	return "candy_eat_regen"
end

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:OnCreated( kv )
	self.eat_health_restore = self:GetAbility():GetSpecialValueFor( "eat_health_restore" )
	self.eat_mana_restore = self:GetAbility():GetSpecialValueFor( "eat_mana_restore" )

	self.eat_health_restore_pct = self:GetAbility():GetSpecialValueFor( "eat_health_restore_pct" )
	self.eat_mana_restore_pct = self:GetAbility():GetSpecialValueFor( "eat_mana_restore_pct" )

	if IsServer() then
		local nFX = ParticleManager:CreateParticle( "particles/items_fx/bottle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		--iIndex, bDestroyImmediatly, bStatusEffect, iPriority, bHeroEffect, bOverheadEffect )
		self:AddParticle( nFX, false, false, -1, true, false )
	end
end

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:GetModifierConstantHealthRegen( params )
	return ( self.eat_health_restore + ( self.eat_health_restore_pct * self:GetParent():GetMaxHealth() / 100 ) ) / self:GetDuration();
end 

--------------------------------------------------------------------------------

function modifier_candy_eat_regen:GetModifierConstantManaRegen( params )
	return ( self.eat_mana_restore + ( self.eat_mana_restore_pct * self:GetParent():GetMaxMana() / 100 ) ) / self:GetDuration();
end 
