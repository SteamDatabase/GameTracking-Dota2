
modifier_sled_penguin_crash = class({})

----------------------------------------------------------------------------------

function modifier_sled_penguin_crash:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_sled_penguin_crash:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_crash:OnCreated( kv )
	if IsServer() then
		self.reset_pos_offset = self:GetAbility():GetSpecialValueFor( "reset_pos_offset" )

		local vForward = self:GetCaster():GetForwardVector()
		self.vResetPos = self:GetCaster():GetAbsOrigin() - ( vForward * self.reset_pos_offset )

		self:GetCaster():RemoveGesture( ACT_DOTA_IDLE )
		self:GetCaster():RemoveGesture( ACT_DOTA_SLIDE_LOOP )
		self:GetCaster():StartGesture( ACT_DOTA_DIE )

		EmitSoundOn( "SledPenguin.Crash.Impact", self:GetParent() )
		EmitSoundOn( "SledPenguin.Crash.Ow", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_crash:OnDestroy()
	if IsServer() then
		self:GetCaster():SetForwardVector( self:GetCaster():GetForwardVector() * -1 )

		self:GetCaster():SetAbsOrigin( self.vResetPos )

		--self:GetCaster():StartGesture( ACT_DOTA_IDLE )
	end
end

--------------------------------------------------------------------------------

function modifier_sled_penguin_crash:CheckState()
	local state =
	{
		[ MODIFIER_STATE_STUNNED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
