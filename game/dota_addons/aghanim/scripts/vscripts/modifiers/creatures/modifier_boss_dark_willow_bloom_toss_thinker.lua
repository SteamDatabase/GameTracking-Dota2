
modifier_boss_dark_willow_bloom_toss_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_bloom_toss_thinker:OnCreated( kv )
	if IsServer() then
		self.bloom_duration = self:GetAbility():GetSpecialValueFor( "bloom_duration" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/boss_dark_willow/bramble_toss.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 90, self.bloom_duration, 1 ) );
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

----------------------------------------------------------------------------------------

function modifier_boss_dark_willow_bloom_toss_thinker:OnDestroy()
	if IsServer() then
		CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_dark_willow_bramble_maze_thinker", { duration = self.bloom_duration }, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
		UTIL_Remove( self:GetParent() )
	end
end

----------------------------------------------------------------------------------------