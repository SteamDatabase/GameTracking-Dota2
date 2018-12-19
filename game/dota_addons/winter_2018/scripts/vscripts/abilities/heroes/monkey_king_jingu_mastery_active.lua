
monkey_king_jingu_mastery_active = class({})

--------------------------------------------------------------------------------

function monkey_king_jingu_mastery_active:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_quadruple_tap_bonuses", { duration = self:GetSpecialValueFor( "max_duration" ) } )
	end
end

--------------------------------------------------------------------------------
