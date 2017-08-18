
modifier_siltbreaker_clone = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:OnCreated( kv )
	if IsServer() then
		self.clone_incoming_dmg_perc = self:GetAbility():GetSpecialValueFor( "clone_incoming_dmg_perc" )

		self:GetParent():SetHealth( self:GetCaster():GetHealth() )

		self.nImmuneToPhysical = kv[ "immune_physical" ]
		if self.nImmuneToPhysical == 0 then
			self.nImmuneToMagical = 1
		else
			self.nImmuneToMagical = 0
		end

		print( string.format( "Clone immune to physical?: %d, clone immune to magical?: %d", self.nImmuneToPhysical, self.nImmuneToMagical ) )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:GetModifierIncomingDamage_Percentage( params )
	return self.clone_incoming_dmg_perc
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:GetAbsoluteNoDamagePhysical( params )
	return self.nImmuneToPhysical
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_clone:GetAbsoluteNoDamageMagical( params )
	return self.nImmuneToMagical
end

--------------------------------------------------------------------------------

