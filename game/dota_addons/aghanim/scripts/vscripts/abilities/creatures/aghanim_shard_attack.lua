aghanim_shard_attack = class( {} )

LinkLuaModifier( "modifier_aghanim_shard_attack", "modifiers/creatures/modifier_aghanim_shard_attack", LUA_MODIFIER_MOTION_NONE )

_G.PATTERN_SPIRAL = 0
_G.PATTERN_REBOUND = 1
_G.PATTERN_JITTER = 2
_G.CAST_ESCLATION_PCT = 17

_G.FAST_COLOR = Vector( 0, 0, 255 )
_G.SLOW_COLOR = Vector( 350, 0, 0 ) -- looks weird, but it's because it can't go to 0 speed
_G.HEAL_COLOR = Vector( 0, 255, 0 )

----------------------------------------------------------------------------------------

function aghanim_shard_attack:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_shard_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_shard_proj.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_willow.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context )

	self.nPattern = PATTERN_SPIRAL
	self.nCastCount = 0
	self.Projectiles = {}
end

----------------------------------------------------------------------------------------

function aghanim_shard_attack:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghanim_shard_attack:OnAbilityPhaseStart()
	if IsServer() then
		StartSoundEventFromPositionReliable( "Aghanim.ShardAttack.Channel", self:GetCaster():GetAbsOrigin() )
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_shard_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:OnChannelThink( flInterval )
	if IsServer() then
		if self.nPattern == PATTERN_SPIRAL then
			self:ThinkSpirals( flInterval )
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:OnChannelFinish( bInterrupted )
	if IsServer() then
		StopSoundOn( "Aghanim.ShardAttack.Loop", self:GetCaster() )
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		self.nCastCount = self.nCastCount + 1
	end
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Aghanim.ShardAttack.Loop", self:GetCaster() )
		if self.nPattern == PATTERN_SPIRAL then
			self:BeginSpirals()
		end
		if self.nPattern == PATTERN_REBOUND then
			self:BeginRebound()
		end
		if self.nPattern == PATTERN_JITTER then
			self:BeginJitter()
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:BeginSpirals()
	self.Projectiles = {}

	self.spiral_projectiles = self:GetSpecialValueFor( "spiral_projectiles" )
	self.spiral_projectile_waves = self:GetSpecialValueFor( "spiral_projectile_waves" )
	self.spiral_projectile_speed = self:GetSpecialValueFor( "spiral_projectile_speed" )

	self.spiral_projectiles = math.min( self.spiral_projectiles * 2, math.floor( self.spiral_projectiles + ( self.spiral_projectiles * CAST_ESCLATION_PCT * self.nCastCount / 100 ) ) )
	self.spiral_projectile_waves = math.min( self.spiral_projectile_waves * 2, math.floor( self.spiral_projectile_waves + ( self.spiral_projectile_waves * CAST_ESCLATION_PCT * self.nCastCount / 100 ) ) )
	self.spiral_projectile_speed = math.min( self.spiral_projectile_speed * 2, math.floor( self.spiral_projectile_speed + ( self.spiral_projectile_speed * CAST_ESCLATION_PCT * self.nCastCount / 100 ) ) )

	self.spiral_projectile_rotation_speed = self:GetSpecialValueFor( "spiral_projectile_rotation_speed" )
	self.spiral_projectile_width = self:GetSpecialValueFor( "spiral_projectile_width" )
	self.spiral_projectile_damage = self:GetSpecialValueFor( "spiral_projectile_damage" ) 	
	self.spiral_projectile_speed_change_interval = self:GetSpecialValueFor( "spiral_projectile_speed_change_interval" )

	self.flSpiralYaw = RandomInt( 0, 360 )
	self.flSpiralWaveInterval = self:GetChannelTime() / self.spiral_projectile_waves
	self.flSpiralNextWaveTime = GameRules:GetGameTime()
	self.flSpiralYawStep = 360 / self.spiral_projectiles
	self.bReverse = false

	if RandomInt( 0, 1 ) == 1 then
		self.bReverse = true
	end

	self.flSpiralSpeedToggleTime = GameRules:GetGameTime() + self.spiral_projectile_speed_change_interval
	self.bSpiralSpeedingUp = true
	self.flCurSpeed = self.spiral_projectile_speed 
	self.nToggleCount = 0
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkSpirals( flInterval )
	local flNow = GameRules:GetGameTime()
	if flNow > self.flSpiralSpeedToggleTime then
		self.flSpiralSpeedToggleTime = flNow + self.spiral_projectile_speed_change_interval
		self.bSpiralSpeedingUp = not self.bSpiralSpeedingUp
		self.nToggleCount = self.nToggleCount + 1
		if self.nToggleCount == 2 then
			self.bReverse = not self.bReverse
			self.nToggleCount = 0
		end
	end

	local flRate = ( self.spiral_projectile_speed / self.spiral_projectile_speed_change_interval ) * flInterval
	if self.bSpiralSpeedingUp then
		self.flCurSpeed = math.min( self.spiral_projectile_speed, self.flCurSpeed + flRate )
	else
		self.flCurSpeed = math.max( 100, self.flCurSpeed - flRate )
	end

	if self.flSpiralNextWaveTime > flNow then
		return
	end

	self.flSpiralNextWaveTime = flNow + self.flSpiralWaveInterval
	EmitSoundOn( "Aghanim.ShardAttack.Wave", self:GetCaster() )

	for i=1,self.spiral_projectiles do
		local Angle = QAngle( 0, self.flSpiralYaw, 0 )
		local vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) ) ) * self.flCurSpeed
		local nProjectileHandle = self:LaunchCrystals( vVelocity, 5000, self.spiral_projectile_width )
		
		local ProjectileInfo = {}
		ProjectileInfo.nHandle = nProjectileHandle
		ProjectileInfo.flYaw = self.flSpiralYaw
		ProjectileInfo.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_shard_proj.vpcf", PATTACH_CUSTOMORIGIN, nil )

		local vLoc = self:GetCaster():GetAbsOrigin() 
		vLoc.z = GetGroundHeight( vLoc, self:GetCaster() ) + 50
		ProjectileInfo.attachEnt = CreateUnitByName( "npc_dota_wisp_spirit", vLoc, false, self:GetCaster(), self:GetCaster(), DOTA_TEAM_GOODGUYS )
		if ProjectileInfo.attachEnt ~= nil then 
			ProjectileInfo.attachEnt:AddNewModifier( self:GetCaster(), self, "modifier_wisp_spirit_invulnerable", {} )
		end
		ParticleManager:SetParticleControlEnt( ProjectileInfo.nFXIndex, 0, ProjectileInfo.attachEnt, PATTACH_ABSORIGIN_FOLLOW, nil, vLoc, false )
		ParticleManager:SetParticleControl( ProjectileInfo.nFXIndex, 1, Vector( self.spiral_projectile_width, self.spiral_projectile_width, self.spiral_projectile_width ) )
		ParticleManager:SetParticleControl( ProjectileInfo.nFXIndex, 2, Vector( 6, 6, 6 ) )

		--local flSpeedColorFactor = self.flCurSpeed / self.spiral_projectile_speed
		--local vColor = LerpVectors( SLOW_COLOR, FAST_COLOR, flSpeedColorFactor )
		--ParticleManager:SetParticleControl( ProjectileInfo.nFXIndex, 15, vColor )

		table.insert( self.Projectiles, ProjectileInfo )

		if self.bReverse then
			self.flSpiralYaw = self.flSpiralYaw - self.flSpiralYawStep
		else
			self.flSpiralYaw = self.flSpiralYaw + self.flSpiralYawStep
		end	
	end

	self.flSpiralYaw = self.flSpiralYaw + self.flSpiralYawStep * 0.5
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkSpiralProjectile( info )
	if self:IsChanneling() then
		local flNewYaw = 0
		if self.bReverse then
			flNewYaw = info.flYaw - self.spiral_projectile_rotation_speed
		else
			flNewYaw = info.flYaw + self.spiral_projectile_rotation_speed
		end

		info.flYaw = flNewYaw

		local Angle = QAngle( 0, flNewYaw, 0 )
		local vNewVelocity = ( RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) ) ) * self.flCurSpeed
		ProjectileManager:UpdateLinearProjectileDirection( info.nHandle, vNewVelocity, 5000 )
	end


	local vLoc = ProjectileManager:GetLinearProjectileLocation( info.nHandle ) 
	vLoc.z = GetGroundHeight( vLoc, self:GetCaster() ) + 50
	info.attachEnt:SetAbsOrigin( vLoc )
	--ParticleManager:SetParticleControl( info.nFXIndex, 0, vLoc )

	--local flSpeedColorFactor = self.flCurSpeed / self.spiral_projectile_speed
--local vColor = LerpVectors( SLOW_COLOR, FAST_COLOR, flSpeedColorFactor )
	--ParticleManager:SetParticleControl( info.nFXIndex, 15, vColor )

	--rint( "setting new velocity on spiral projectile" )
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:BeginRebound()
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkRebound( flInterval )
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkReboundProjectile( info )
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:BeginJitter()
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkJitter( flInterval )
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:ThinkJitterProjectile( info )
end

--------------------------------------------------------------------------------

function aghanim_shard_attack:LaunchCrystals( vVel, flDist, flRadius )
	local info = 
	{
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(), 
		fStartRadius = flRadius,
		fEndRadius = flRadius,
		vVelocity = vVel,
		fDistance = flDist,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 10.0,
	}

	return ProjectileManager:CreateLinearProjectile( info )
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:OnProjectileThinkHandle( iProjectileHandle )
	if IsServer() then
		local info = nil
		for _,v in pairs ( self.Projectiles ) do
			if v.nHandle == iProjectileHandle then
				info = v
				break
			end
		end

		if info == nil then
			return
		end

		if self.nPattern == PATTERN_SPIRAL then
			self:ThinkSpiralProjectile( info )
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_shard_attack:OnProjectileHitHandle( hTarget, vLocation, iProjectileHandle )
	if IsServer() then
		local info = nil
		for _,v in pairs ( self.Projectiles ) do
			if v.nHandle == iProjectileHandle then
				info = v
				break
			end
		end

		if info == nil then
			return false
		end

		if hTarget and hTarget:IsZombie() then
			return false
		end

		if self.nPattern == PATTERN_SPIRAL then
			ParticleManager:DestroyParticle( info.nFXIndex, false )
			UTIL_Remove( info.attachEnt )
			info.attachEnt = nil
		end

		if hTarget and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
			local damage = 
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.spiral_projectile_damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self,
			}
		
			ApplyDamage( damage )

			EmitSoundOn( "Hero_Silencer.LastWord.Damage", hTarget )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, hTarget:GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.spiral_projectile_width, self.spiral_projectile_width, self.spiral_projectile_width ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end

	return true
end