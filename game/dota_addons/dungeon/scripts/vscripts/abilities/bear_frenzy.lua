
bear_frenzy = class({})

--------------------------------------------------------------------------------

function bear_frenzy:OnSpellStart()
	if IsServer() then
		self.frenzy_duration = self:GetSpecialValueFor( "frenzy_duration" )
		self.frenzy_bonus_speed = self:GetSpecialValueFor("attack_speed_bonus_pct")
		self.max_attacks = self:GetSpecialValueFor("max_attacks")

		local modifier_params = {duration = self.frenzy_duration, attack_speed_bonus_pct = self.frenzy_bonus_speed, max_attacks = self.max_attacks}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ursa_overpower", modifier_params )
	end
end

--------------------------------------------------------------------------------

