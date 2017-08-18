
siltbreaker_go_phase_three = class({})
LinkLuaModifier( "modifier_siltbreaker_phase_three", "modifiers/modifier_siltbreaker_phase_three", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_go_phase_three:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier( "modifier_siltbreaker_phase_one" ) then -- note: only possible in dev
			self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_phase_one" )
		end

		if self:GetCaster():HasModifier( "modifier_siltbreaker_phase_two" ) then
			self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_phase_two" )
		end

		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_siltbreaker_phase_three", { duration = -1 } )

		EmitSoundOn( "Siltbreaker.GoPhaseThree", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

