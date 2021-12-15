
trap_room_sprint = class({})
LinkLuaModifier( "modifier_trap_room_sprint", "modifiers/traps/heroes/modifier_trap_room_sprint", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------

function trap_room_sprint:OnSpellStart()
	if IsServer() then
		local fDuration = self:GetSpecialValueFor( "duration" )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_trap_room_sprint", { duration = fDuration } )
	end
end

-----------------------------------------------------------------------------
