
trap_room_phase_shift = class({})
LinkLuaModifier( "modifier_trap_room_phase_shift", "modifiers/traps/heroes/modifier_trap_room_phase_shift", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function trap_room_phase_shift:OnSpellStart()
	if IsServer() then
		self:GetCaster():Stop()

		local fDuration = self:GetSpecialValueFor( "duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_trap_room_phase_shift", { duration = fDuration } )

		ProjectileManager:ProjectileDodge( self:GetCaster() )
	end
end

-----------------------------------------------------------------------------
