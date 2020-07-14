
bandit_stifling_dagger = class({})
LinkLuaModifier( "modifier_phantom_assassin_stiflingdagger_caster", "modifiers/creatures/modifier_phantom_assassin_stiflingdagger_caster", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_stiflingdagger", "modifiers/creatures/modifier_phantom_assassin_stiflingdagger", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bandit_stifling_dagger:Precache( context )
	PrecacheResource( "particle", "particles/creatures/bandit_captain/phantom_assassin_linear_dagger.vpcf", context )
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:OnAbilityPhaseStart()
	if IsServer() then
		local nRadius = 100
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( nRadius, nRadius, nRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "Creature.StartCast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		StopSoundOn( "Creature.StartCast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		StopSoundOn( "Creature.StartCast", self:GetCaster() )
	end

	self.duration = self:GetSpecialValueFor( "duration" )
	self.dagger_speed = self:GetSpecialValueFor( "dagger_speed" )
	self.dagger_offset = self:GetSpecialValueFor( "dagger_offset" )
	self.dagger_count = self:GetSpecialValueFor( "dagger_count" )
	self.dagger_rate = self:GetSpecialValueFor( "dagger_rate" )
	self.dagger_range = self:GetSpecialValueFor( "dagger_range" )

	self.vTargetLocation = self:GetCursorPosition()
	self.flAccumulatedTime = 0.0
	self.vDirection = self.vTargetLocation - self:GetCaster():GetOrigin() 
	self.nDaggersThrown = 0

	local vDirection = self.vTargetLocation  - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()
	
	self:ThrowDagger( vDirection )
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:OnChannelThink( flInterval )
	self.flAccumulatedTime = self.flAccumulatedTime + flInterval 
	if self.flAccumulatedTime >= self.dagger_rate then
		self.flAccumulatedTime = self.flAccumulatedTime - self.dagger_rate

		local vOffset = RandomVector( self.dagger_offset )
		vOffset.z = 0.0
		
		local vDirection = ( self.vTargetLocation + vOffset ) - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self:ThrowDagger( vDirection )
	end
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
		local kv = {}
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_phantom_assassin_stiflingdagger_caster", kv )
		self:GetCaster():PerformAttack( hTarget, false, true, true, true, true, false, true )
		self:GetCaster():RemoveModifierByName( "modifier_phantom_assassin_stiflingdagger_caster" )

		local kv =
		{
			duration = self.duration,
		}

		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_phantom_assassin_stiflingdagger", kv)
		EmitSoundOn( "Dungeon.BanditDagger.Target", hTarget )
	end

	return true
end

--------------------------------------------------------------------------------

function bandit_stifling_dagger:ThrowDagger( vDirection )
	local info = 
	{
		EffectName = "particles/creatures/bandit_captain/phantom_assassin_linear_dagger.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = 50.0,
		fEndRadius = 50.0,
		vVelocity = vDirection * self.dagger_speed,
		fDistance = self.dagger_range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	
	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Dungeon.BanditDagger.Cast", self:GetCaster() )

	self.nDaggersThrown = self.nDaggersThrown + 1
	if self.nDaggersThrown >= self.dagger_count then
		self:EndChannel( false )
	else
		self:GetCaster():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_1, 1.33 )
	end
end

--------------------------------------------------------------------------------