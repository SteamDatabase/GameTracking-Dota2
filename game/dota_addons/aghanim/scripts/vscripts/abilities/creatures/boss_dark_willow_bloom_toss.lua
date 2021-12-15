boss_dark_willow_bloom_toss = class({})
LinkLuaModifier( "modifier_boss_dark_willow_bloom_toss_thinker", "modifiers/creatures/modifier_boss_dark_willow_bloom_toss_thinker", LUA_MODIFIER_MOTION_NONE )



----------------------------------------------------

function boss_dark_willow_bloom_toss:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
	PrecacheResource( "particle", "particles/creatures/boss_dark_willow/bramble_toss.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble_precast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_ley_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker_helper.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_marker.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
end

----------------------------------------------------

function boss_dark_willow_bloom_toss:OnAbilityPhaseStart()
	if IsServer() == false then 
		return true
	end
	return true
end

----------------------------------------------------

function boss_dark_willow_bloom_toss:OnAbilityPhaseInterrupted()
	if IsServer() == false then 
		return
	end
end

----------------------------------------------------

function boss_dark_willow_bloom_toss:OnSpellStart()
	if IsServer() == false then 
		return
	end
	
	self.bloom_count = self:GetSpecialValueFor( "bloom_count" )
	self.nRemainingBlooms  = self.bloom_count
	self.bloom_offset = self:GetSpecialValueFor( "bloom_offset" ) 
	self.bloom_setup_delay = self:GetSpecialValueFor( "bloom_setup_delay" )
	self.bloom_setup_interval = self:GetSpecialValueFor( "bloom_setup_interval" )
	self.latch_range = self:GetSpecialValueFor( "latch_range" )

	self.vInitialTargetPosition = self:GetCursorPosition()
	self.nOrientation = RandomInt( 0, 1 )

	self.flNextBloomTime = GameRules:GetGameTime()
end

----------------------------------------------------

function boss_dark_willow_bloom_toss:OnChannelThink( flInterval )
	if IsServer() == false then 
		return
	end

	if GameRules:GetGameTime() < self.flNextBloomTime then 
		return 
	end

	self.flNextBloomTime = GameRules:GetGameTime() + self.bloom_setup_interval
	self:TossBloom()
end

----------------------------------------------------

function boss_dark_willow_bloom_toss:TossBloom()
	if IsServer() == false then 
		return
	end

	if self.nRemainingBlooms <= 0 then 
		return 
	end

	local vTowardsTarget = self.vInitialTargetPosition - self:GetCaster():GetAbsOrigin()
	vTowardsTarget = vTowardsTarget:Normalized()
	vTowardsTarget.z = 0.0

	local vTargetPosition = nil

	if self.nRemainingBlooms == self.bloom_count - 3 then 
		vTargetPosition = self.vInitialTargetPosition + vTowardsTarget * self.bloom_offset 
	end

	if self.nRemainingBlooms == self.bloom_count - 2 then 
		local vDirection = CrossVectors( vTowardsTarget, Vector( 0, 0, 1 ) )
		if self.nOrientation == 1 then 
			vDirection = vDirection * -1 
		end
		vDirection = vDirection + vTowardsTarget 
		vDirection = vDirection:Normalized()
		vTargetPosition = self.vInitialTargetPosition + vDirection * self.bloom_offset 
	end

	if self.nRemainingBlooms == self.bloom_count - 1 then 
		local vDirection = CrossVectors( vTowardsTarget, Vector( 0, 0, 1 ) )
		if self.nOrientation == 1 then 
			vDirection = vDirection * -1 
		end
		vTargetPosition = self.vInitialTargetPosition + vDirection * self.bloom_offset 
	end

	if self.nRemainingBlooms == self.bloom_count then 
		vTargetPosition = self.vInitialTargetPosition
	end

	if vTargetPosition == nil then
		vTargetPosition = self.vInitialTargetPosition + vTowardsTarget * self.bloom_offset 
	end

	local flDist = ( self:GetCaster():GetAbsOrigin() - vTargetPosition ):Length2D()
	local flSpeed = flDist / self.bloom_setup_delay

	local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_dark_willow_bloom_toss_thinker", { duration = self.bloom_setup_delay }, vTargetPosition, self:GetCaster():GetTeamNumber(), false )
	local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( vTargetPosition, hThinker ) )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.latch_range, 2, 1 ) )
	ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 184, 107, 119 ) )
	ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )


	local projectile =
	{
		Target = hThinker,
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf",
		iMoveSpeed = flSpeed,
		vSourceLoc = self:GetCaster():GetOrigin(),
		bDodgeable = false,
		bProvidesVision = false,
	}

	ProjectileManager:CreateTrackingProjectile( projectile )
	EmitSoundOn( "Hero_DarkWillow.Brambles.Cast", self:GetCaster() )
	self.nRemainingBlooms = self.nRemainingBlooms - 1
end

----------------------------------------------------
