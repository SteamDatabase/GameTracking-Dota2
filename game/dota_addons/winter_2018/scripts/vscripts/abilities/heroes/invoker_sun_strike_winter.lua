
invoker_sun_strike_winter = class({})

--------------------------------------------------------------------------------

function invoker_sun_strike_winter:OnSpellStart()
	if IsServer() then
		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_quadruple_tap_bonuses", { duration = self:GetSpecialValueFor( "max_duration" ) } )
	end
end

--------------------------------------------------------------------------------

