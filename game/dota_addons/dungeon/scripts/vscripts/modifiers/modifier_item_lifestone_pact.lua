
modifier_item_lifestone_pact = class({})

--------------------------------------------------------------------------------

function modifier_item_lifestone_pact:GetTexture()
	return "item_lifestone"
end

--------------------------------------------------------------------------------

function modifier_item_lifestone_pact:OnCreated( kv )
	self.pact_interval = self:GetAbility():GetSpecialValueFor( "pact_interval" )
	self.pact_hp_cost = self:GetAbility():GetSpecialValueFor( "pact_hp_cost" )
	self.pact_mana_gained = self:GetAbility():GetSpecialValueFor( "pact_mana_gained" )

	if IsServer() then
		EmitSoundOn( "Lifestone.Activate", self:GetParent() )

		self:StartIntervalThink( self.pact_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_item_lifestone_pact:OnIntervalThink()
	if IsServer() then
		local damage =
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.pact_hp_cost,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self
		}
		ApplyDamage( damage )

		self:GetParent():GiveMana( self.pact_mana_gained )
		SendOverheadEventMessage( self:GetCaster():GetPlayerOwner(), OVERHEAD_ALERT_MANA_ADD, self:GetParent(), self.pact_mana_gained, nil )
	end
end

--------------------------------------------------------------------------------

function modifier_item_lifestone_pact:OnDestroy()
	if IsServer() then
		StopSoundOn( "Lifestone.Activate", self:GetParent() )
		EmitSoundOn( "Lifestone.Deactivate", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

