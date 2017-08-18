
modifier_siltbreaker_mind_control_marked = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control_marked:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control_marked:OnCreated( kv )
	if IsServer() then
		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddParticle( nFXIndex1, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

