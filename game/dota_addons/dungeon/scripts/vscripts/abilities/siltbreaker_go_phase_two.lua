
siltbreaker_go_phase_two = class({})
LinkLuaModifier( "modifier_siltbreaker_phase_two", "modifiers/modifier_siltbreaker_phase_two", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_go_phase_two:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_go_phase_two:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier( "modifier_siltbreaker_phase_one" ) then
			self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_phase_one" )
		end

		if self:GetCaster():HasModifier( "modifier_siltbreaker_phase_three" ) then -- note: only possible in dev
			self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_phase_three" )
		end

		self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_siltbreaker_phase_two", { duration = -1 } )

		EmitSoundOn( "Siltbreaker.GoPhaseTwo", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

