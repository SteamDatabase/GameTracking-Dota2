
trap_room_invuln = class({})
LinkLuaModifier( "modifier_trap_room_invuln", "modifiers/traps/heroes/modifier_trap_room_invuln", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function trap_room_invuln:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()
		if not hTarget then
			return
		end

		local fDuration = self:GetSpecialValueFor( "duration" )
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_trap_room_invuln", { duration = fDuration } )
	end
end

-----------------------------------------------------------------------------
