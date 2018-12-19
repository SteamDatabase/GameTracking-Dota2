
modifier_pugna_ward_winter_effect = class({})

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter_effect:OnCreated( kv )	
	self.aura_mana_regen = self:GetAbility():GetSpecialValueFor( "aura_mana_regen" )
	self.mana_multiplier = self:GetAbility():GetSpecialValueFor( "mana_multiplier" )
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_SPENT_MANA
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter_effect:GetModifierConstantManaRegen( params )
	return self.aura_mana_regen
end

--------------------------------------------------------------------------------

function modifier_pugna_ward_winter_effect:OnSpentMana( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end

		if params.cost == nil or params.cost == 0 then
			return 0
		end

		local sZapParticle = "particles/units/heroes/hero_pugna/pugna_ward_attack_heavy.vpcf"

		if params.cost < 250 then 
			sZapParticle = "particles/units/heroes/hero_pugna/pugna_ward_attack_medium.vpcf"
		end

		if params.cost < 100 then 
			sZapParticle = "particles/units/heroes/hero_pugna/pugna_ward_attack_light.vpcf"
		end

		local nFXIndex = ParticleManager:CreateParticle( sZapParticle, PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster().hWard, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster().hWard:GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex , true, false, 0, false, false )	
		EmitSoundOn( "Hero_Pugna.NetherWard.Attack", self:GetCaster().hWard )

		local hSpecialBonus = self:GetCaster():FindAbilityByName("special_bonus_unique_pugna_3")
		if hSpecialBonus and hSpecialBonus:GetLevel() > 0 then
	       self.mana_multiplier = self.mana_multiplier + hSpecialBonus:GetLevelSpecialValueFor( "value", 1 )
		end


		local iZapHeal = params.cost * self.mana_multiplier
        self:GetParent():Heal( iZapHeal , self )
	end
end

