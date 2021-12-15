
modifier_event_leshrac_spell_lifesteal = class( {} )

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:OnCreated( kv )
	if IsServer() then
		self.spell_lifesteal = self:GetAbility():GetSpecialValueFor( "spell_lifesteal" )
		self.spell_lifesteal_captains = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_captains" )
		self.spell_lifesteal_bosses = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_bosses" )

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:OnRefresh( kv )
    if IsServer() then
    	self.spell_lifesteal = self:GetAbility():GetSpecialValueFor( "spell_lifesteal" )
    	self.spell_lifesteal_captains = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_captains" )
    	self.spell_lifesteal_bosses = self:GetAbility():GetSpecialValueFor( "spell_lifesteal_bosses" )
    	
        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:AddCustomTransmitterData( )
	return
	{
		spell_lifesteal = self.spell_lifesteal,
		spell_lifesteal_captains = self.spell_lifesteal_captains,
		spell_lifesteal_bosses = self.spell_lifesteal_bosses,
	}
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:HandleCustomTransmitterData( data )
	self.spell_lifesteal = data.spell_lifesteal
	self.spell_lifesteal_captains = data.spell_lifesteal_captains
	self.spell_lifesteal_bosses = data.spell_lifesteal_bosses
end


--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:OnTakeDamage( params )
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

		local fSpellLifestealPct = self.spell_lifesteal
		if Target:IsBossCreature() then
			fSpellLifestealPct = self.spell_lifesteal_bosses
		elseif Target:IsBossCreature() == false and Target:IsConsideredHero() then
			fSpellLifestealPct = self.spell_lifesteal_captains
		end

		local flLifesteal = flDamage * fSpellLifestealPct / 100
		Attacker:HealWithParams( flLifesteal, self:GetAbility(), false, true, self:GetCaster(), true )
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_spell_lifesteal:OnTooltip( params )
	return self.spell_lifesteal
end

----------------------------------------------------------------------------------------
