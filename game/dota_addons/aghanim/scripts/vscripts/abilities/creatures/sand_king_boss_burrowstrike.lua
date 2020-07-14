
sand_king_boss_burrowstrike = class({})
LinkLuaModifier( "modifier_sand_king_boss_burrowstrike", "modifiers/creatures/modifier_sand_king_boss_burrowstrike", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_sand_king_boss_burrowstrike_end", "modifiers/creatures/modifier_sand_king_boss_burrowstrike_end", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------

function sand_king_boss_burrowstrike:Precache( context )

	PrecacheResource( "particle", "particles/test_particle/sandking_burrowstrike_no_models.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_physical.vpcf", context )

end

--------------------------------------------------------------------------------

function sand_king_boss_burrowstrike:OnAbilityPhaseStart()
	if IsServer() then
	end

	return true
end

--------------------------------------------------------------------------------

function sand_king_boss_burrowstrike:OnAbilityPhaseInterrupted()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function sand_king_boss_burrowstrike:GetCastPoint()
	return 1.0625 - ( 0.53125 * ( 1 - ( self:GetCaster():GetHealthPercent() / 100 ) ) )
end

--------------------------------------------------------------------------------

function sand_king_boss_burrowstrike:GetPlaybackRateOverride()
	return 0.3045 + ( 0.3045 * ( 1 - ( self:GetCaster():GetHealthPercent() / 100 ) ) )
end

--------------------------------------------------------------------------------

function sand_king_boss_burrowstrike:OnSpellStart()
	if IsServer() then
		local vToTarget = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		local flDist = RandomFloat( 1000.0, 2000.0 )
		local vDir = vToTarget:Normalized()
		vDir.z = 0.0

		local vTarget = self:GetCaster():GetOrigin() + vDir * flDist

		local flHealthPct = self:GetCaster():GetHealthPercent() / 100
		local kv =
		{
			x = vTarget.x,
			y = vTarget.y,
			z = vTarget.z,
			duration = flDist / ( self:GetSpecialValueFor( "speed" ) + ( self:GetSpecialValueFor( "scaling_speed" ) * ( 1 - flHealthPct ) ) )
		}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_boss_burrowstrike", kv )
		EmitSoundOn( "SandKingBoss.BurrowStrike", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sandking_burrowstrike_no_models.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 225  )
		ParticleManager:SetParticleControl( nFXIndex, 1, self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 225  )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------
