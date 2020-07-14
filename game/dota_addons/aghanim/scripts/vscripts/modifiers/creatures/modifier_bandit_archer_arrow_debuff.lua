
modifier_bandit_archer_arrow_debuff = class({})

--------------------------------------------------------------------------------

function modifier_bandit_archer_arrow_debuff:OnCreated( kv )
	if IsServer() then
		self.nBreakFX = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_bandit_archer_arrow_debuff:OnDestroy()
	if IsServer() then
		if self.nBreakFX ~= nil then
			ParticleManager:DestroyParticle( self.nBreakFX, false )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bandit_archer_arrow_debuff:CheckState()
	local state =
	{
		[ MODIFIER_STATE_PASSIVES_DISABLED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
