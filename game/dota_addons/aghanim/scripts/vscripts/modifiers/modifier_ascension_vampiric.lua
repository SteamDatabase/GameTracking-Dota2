
modifier_ascension_vampiric = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_vampiric:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_vampiric:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ascension_vampiric:GetTexture()
	return "events/aghanim/interface/hazard_vampiric"
end

-----------------------------------------------------------------------------------------

function modifier_ascension_vampiric:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_ascension_vampiric:GetStatusEffectName() 
	return "particles/status_fx/status_effect_life_stealer_rage.vpcf"
end

----------------------------------------

function modifier_ascension_vampiric:OnCreated( kv )
	self:OnRefresh( kv )

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_life_stealer/life_stealer_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt(nFXIndex, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

----------------------------------------

function modifier_ascension_vampiric:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )
end

--------------------------------------------------------------------------------

function modifier_ascension_vampiric:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_vampiric:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		local flLifesteal = flDamage * self.lifesteal_pct / 100
		Attacker:HealWithParams( flLifesteal, self:GetAbility(), Ability == nil, true, nil, Ability ~= nil )
	end

	return 0.0

end

-----------------------------------------------------------------------

function modifier_ascension_vampiric:OnTooltip( params )
	return self.lifesteal_pct
end
