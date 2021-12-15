
modifier_trap_room_invuln = class({})

--------------------------------------------------------------------------------

function modifier_trap_room_invuln:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_trap_room_invuln:GetStatusEffectName()
	return "particles/status_fx/status_effect_repel.vpcf"
end

--------------------------------------------------------------------------------

function modifier_trap_room_invuln:OnCreated( kv )
	self.bonus_movespeed_pct = self:GetAbility():GetSpecialValueFor( "bonus_movespeed_pct" )

	if IsServer() then
		EmitSoundOn( "TrapRoomInvuln.Cast", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_trap_room_invuln:CheckState()
	local state =
	{
		[ MODIFIER_STATE_INVULNERABLE ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
