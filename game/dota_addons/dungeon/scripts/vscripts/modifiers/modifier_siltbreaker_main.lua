
modifier_siltbreaker_main = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:OnCreated( kv )
	if IsServer() then
		self.nImmuneToPhysical = kv[ "immune_physical" ]
		if self.nImmuneToPhysical == 0 then
			self.nImmuneToMagical = 1
		else
			self.nImmuneToMagical = 0
		end

		print( string.format( "Main immune to physical?: %d, main immune to magical?: %d", self.nImmuneToPhysical, self.nImmuneToMagical ) )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:GetAbsoluteNoDamagePhysical( params )
	return self.nImmuneToPhysical
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_main:GetAbsoluteNoDamageMagical( params )
	return self.nImmuneToMagical
end

--------------------------------------------------------------------------------

