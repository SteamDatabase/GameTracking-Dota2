
modifier_event_leshrac_no_heal = class( {} )

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:GetTexture()
	return "leshrac_greater_lightning_storm"
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:IsPermanent()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:OnCreated( kv )
	if IsServer() then
		self.heal_suppression_pct = kv[ "heal_suppression_pct" ]
		self.spell_lifesteal = kv[ "spell_lifesteal" ]
		self.spell_lifesteal_captains = kv[ "spell_lifesteal_captains" ]
		self.spell_lifesteal_bosses = kv[ "spell_lifesteal_bosses" ]
		self.encounters_remaining = kv[ "encounters_remaining" ]

		self:SetStackCount( self.encounters_remaining )

		self:SetHasCustomTransmitterData( true )
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:OnRefresh( kv )
    if IsServer() then
		self.heal_suppression_pct = kv.heal_suppression_pct
    	self.spell_lifesteal = kv.spell_lifesteal
    	self.spell_lifesteal_captains = kv.spell_lifesteal_captains
    	self.spell_lifesteal_bosses = kv.spell_lifesteal_bosses
    	self.encounters_remaining = kv.encounters_remaining
    	
    	self:SetStackCount( self.encounters_remaining )

        self:SendBuffRefreshToClients()
    end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:AddCustomTransmitterData( )
	return
	{
		heal_suppression_pct = self.heal_suppression_pct,
		spell_lifesteal = self.spell_lifesteal,
		spell_lifesteal_captains = self.spell_lifesteal_captains,
		spell_lifesteal_bosses = self.spell_lifesteal_bosses,
	}
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:HandleCustomTransmitterData( data )
	self.heal_suppression_pct = data.heal_suppression_pct
	self.spell_lifesteal = data.spell_lifesteal
	self.spell_lifesteal_captains = data.spell_lifesteal_captains
	self.spell_lifesteal_bosses = data.spell_lifesteal_bosses
end


--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:GetModifierHealAmplify_PercentageTarget( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:GetModifierHPRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:GetModifierLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:GetModifierSpellLifestealRegenAmplify_Percentage( params )
	return -self.heal_suppression_pct
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:OnTooltip( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:OnTooltip2( params )
	return self.spell_lifesteal
end

----------------------------------------------------------------------------------------

function modifier_event_leshrac_no_heal:OnDestroy()
	if IsServer() then
		if not self:GetParent():HasAbility( "event_leshrac_spell_lifesteal" ) then
			local hSpellLifestealAbility = self:GetParent():AddAbility( "event_leshrac_spell_lifesteal" )
			if hSpellLifestealAbility then
				-- Grants and upgrades the ability
				hSpellLifestealAbility:UpgradeAbility( false )
			end
		end
	end
end

--------------------------------------------------------------------------------
