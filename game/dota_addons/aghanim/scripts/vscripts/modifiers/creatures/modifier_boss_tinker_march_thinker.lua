
require( "utility_functions" )

modifier_boss_tinker_march_thinker = class({})

---------------------------------------------------------------------------

function modifier_boss_tinker_march_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_march_thinker:OnCreated( kv )
	self.collision_radius = self:GetAbility():GetSpecialValueFor( "collision_radius" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "distance" )
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
	self.machines_per_sec = self:GetAbility():GetSpecialValueFor( "machines_per_sec" )
	self.machines_per_tick = self:GetAbility():GetSpecialValueFor( "machines_per_tick" )

	if IsServer() then
		local bEnraged = self:GetCaster():HasModifier( "modifier_boss_tinker_enraged" )

		if bEnraged then
			local enraged_pct_machines_per_sec = self:GetAbility():GetSpecialValueFor( "enraged_pct_machines_per_sec" )
			self.machines_per_sec = self.machines_per_sec * ( enraged_pct_machines_per_sec / 100.0 )
		else
		end

		self:StartIntervalThink( 1.0 / self.machines_per_sec )

		self.vDirection = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		local fLength = self.vDirection:Length2D()
		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()
		if fLength < 0.01 then
			self.vDirection = self:GetCaster():GetAnglesAsVector()
		end
	else -- IsClient
		local nFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_motm.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFX, 0, self:GetCaster():GetAbsOrigin() )
		ParticleManager:SetParticleControlEnt( nFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFX, 1, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFX, 10, Vector( self.distance * 0.5, -self.distance * 0.5, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFX );
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_march_thinker:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	if not self:GetCaster() then
		return -1
	end

	local projInfo = 
	{
		EffectName = "particles/creatures/boss_tinker/tinker_marching_machine.vpcf",
		Ability = self:GetAbility(),
		fStartRadius = self.collision_radius,
		fEndRadius = self.collision_radius,
		vVelocity = self.vDirection * self.speed,
		fDistance = self.distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = self:GetAbility():GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbility():GetAbilityTargetType(),
	}

	for i = 1, self.machines_per_tick do
		local vSpawnPos = self:GetParent():GetAbsOrigin() - ( self.vDirection * self.radius )
		local fRandomWidth = RandomFloat( -self.radius, self.radius )
		vSpawnPos = vSpawnPos + ( fRandomWidth * Vector( -self.vDirection.y, self.vDirection.x, 0 ) )
		projInfo.vSpawnOrigin = vSpawnPos
		ProjectileManager:CreateLinearProjectile( projInfo )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tinker_march_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	else
		StopSoundOn( "Boss_Tinker.March_of_the_Machines", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
