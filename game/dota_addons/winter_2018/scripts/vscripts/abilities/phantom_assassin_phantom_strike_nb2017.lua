phantom_assassin_phantom_strike_nb2017 = class({})
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_nb2017", "modifiers/modifier_phantom_assassin_phantom_strike_nb2017", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function phantom_assassin_phantom_strike_nb2017:OnSpellStart()
	local hTarget = self:GetCursorTarget()
	if hTarget == nil or hTarget:IsInvulnerable() then
		return
	end

	local vForward = self:GetCaster():GetForwardVector()
	vForward = vForward:Normalized()

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( nFXIndex, 0, vForward )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	local vStartLocation = self:GetCaster():GetOrigin()
	local vDestination = hTarget:GetOrigin() - vForward * ( hTarget:GetPaddedCollisionRadius() + self:GetCaster():GetPaddedCollisionRadius() + 2.0 )
	FindClearSpaceForUnit( self:GetCaster(), vDestination, true )
	EmitSoundOnLocationWithCaster( vStartLocation, "Hero_PhantomAssassin.Strike.Start", self:GetCaster() )

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_nb2017", { duration = self:GetSpecialValueFor( "duration" ) } )
	EmitSoundOn( "Hero_PhantomAssassin.Strike.End", self:GetCaster() )
	local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( nFXIndex2)
end

--------------------------------------------------------------------------------

function phantom_assassin_phantom_strike_nb2017:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end

	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

--------------------------------------------------------------------------------

function phantom_assassin_phantom_strike_nb2017:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

