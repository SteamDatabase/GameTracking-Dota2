modifier_spider_web = class({})

--------------------------------------------------------------------------

function modifier_spider_web:IsHidden()
	return true
end

--------------------------------------------------------------------------

function modifier_spider_web:IsAura()
	if ( not self:GetParent():GetUnitName() == "npc_dota_creature_kidnap_spider" ) then
		return true
	else
		return false
	end
end

--------------------------------------------------------------------------

function modifier_spider_web:GetModifierAura()
	return "modifier_spider_web_effect"
end

--------------------------------------------------------------------------

function modifier_spider_web:GetAuraRadius()
	return 900
end

--------------------------------------------------------------------------

function modifier_spider_web:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		EmitSoundOn( "SpiderRavine.WebLoop", self:GetParent() )
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 900, 0, 0 ) )
	--ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 5528, 5000, 256 ) ) --Bad Ancient
	--ParticleManager:SetParticleControlEnt( nFXIndex, 3, GetOwnerEntity(), PATTACH_POINT_FOLLOW, "attach_hitloc", GetAbsOrigin() );
	--ParticleManager:SetParticleShouldCheckFoW( nFXIndex, !( IsLocalPlayerSpectating() || GetLocalPlayerTeam() == GetTeamNumber() ) );
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------

function modifier_spider_web:OnDestroy()
	if IsServer() then
		StopSoundOn( "SpiderRavine.WebLoop", self:GetParent() )	
	end

end

--------------------------------------------------------------------------

function modifier_spider_web:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------

function modifier_spider_web:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------

function modifier_spider_web:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_NONE
end

--------------------------------------------------------------------------

function modifier_spider_web:GetAuraDuration()
	return 0.2
end

--------------------------------------------------------------------------

function modifier_spider_web:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end