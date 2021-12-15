require( "modifiers/modifier_blessing_base" )

modifier_blessing_spell_life_steal = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_spell_life_steal:GetTexture()
	return "../items/satanic"
end

-------------------------------------------------------------------------------

function modifier_blessing_spell_life_steal:OnBlessingCreated( kv )
	self.spell_lifesteal_pct = kv.spell_life_steal
end

--------------------------------------------------------------------------------

function modifier_blessing_spell_life_steal:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_spell_life_steal:OnTakeDamage( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Ability == nil or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local flLifesteal = flDamage * self.spell_lifesteal_pct / 100
		--print( 'modifier_blessing_spell_life_steal healing for ' .. flLifesteal )
		Attacker:HealWithParams( flLifesteal, self:GetAbility(), false, true, nil, true )
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_blessing_spell_life_steal:OnTooltip( params )
	return self.spell_lifesteal_pct
end
