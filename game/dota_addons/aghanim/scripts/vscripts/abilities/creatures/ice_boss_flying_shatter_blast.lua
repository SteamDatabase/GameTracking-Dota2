ice_boss_flying_shatter_blast = class ({})
LinkLuaModifier( "modifier_ice_boss_flying_shatter_blast_thinker", "modifiers/creatures/modifier_ice_boss_flying_shatter_blast_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ice_boss_flying_shatter_blast:Precache( context )
	PrecacheResource( "particle", "particles/act_2/flying_shatter_blast.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
end

----------------------------------------------------------------------------------------

function ice_boss_flying_shatter_blast:ProcsMagicStick()
	return false
end

----------------------------------------------------------------------------------------

function ice_boss_flying_shatter_blast:OnSpellStart()
	if IsServer() then
		local vInitialPos = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector() * 450
		local vTargetPositions = { }
		vTargetPositions[ 1 ] = vInitialPos
		--vTargetPositions[ 2 ] = vInitialPos + RandomVector( RandomFloat( 500, 600 ) )
		--vTargetPositions[ 3 ] = vInitialPos + RandomVector( RandomFloat( 500, 600 ) )

		EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Cast", self:GetCaster() )

		self.initial_projectile_speed = self:GetSpecialValueFor( "initial_projectile_speed" )
		self.initial_projectile_radius = self:GetSpecialValueFor( "initial_projectile_radius" )
		self.burst_distance = self:GetSpecialValueFor( "burst_distance" )
		self.shatter_damage = self:GetSpecialValueFor( "shatter_damage" )
		self.shatter_num_projectiles = self:GetSpecialValueFor( "shatter_num_projectiles" )
		self.shatter_speed = self:GetSpecialValueFor( "shatter_speed" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )

		if self.hThinkers == nil then
			self.hThinkers = { }
		end
		
		for i, vTargetPos in ipairs( vTargetPositions ) do
			local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ice_boss_flying_shatter_blast_thinker", { duration = -1 }, vTargetPos, self:GetCaster():GetTeamNumber(), false )
			if hThinker ~= nil then
				local vDirection = vTargetPos - self:GetCaster():GetOrigin()
				vDirection.z = 0.0
				vDirection = vDirection:Normalized()

				local info = {
					Target = hThinker,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/act_2/flying_shatter_blast.vpcf",
					iMoveSpeed = self.initial_projectile_speed,
					vSourceLoc = self:GetCaster():GetOrigin(),
					bDodgeable = false,
					bProvidesVision = false,
				}

				ProjectileManager:CreateTrackingProjectile( info )
				EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Projectile", self:GetCaster() )
				table.insert( self.hThinkers, hThinker )

				local flDist = (vInitialPos - self:GetCaster():GetOrigin()):Length2D()
				local flTimeToImpact = flDist / self.initial_projectile_speed


				local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( vTargetPos, hThinker ) )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.burst_distance, 2, 1 ) )
				ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 255, 0, 0 ) )
				ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				--DebugDrawCircle( GetGroundPosition( vTargetPos, hThinker ), Vector( 0, 0, 255 ), 255, self.burst_distance, false, 1.0 )
			end
		end

		
	end
end

--------------------------------------------------------------------------------

function ice_boss_flying_shatter_blast:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local bInitialProjectile = false
		for i=1,#self.hThinkers do
			local hThinker = self.hThinkers[i]
			if hThinker ~= nil and hThinker == hTarget then
				table.remove( self.hThinkers, i )
				UTIL_Remove( hThinker )
				bInitialProjectile = true
			end
		end
		if bInitialProjectile then
			local angle = QAngle( 0, 0, 0 )
			for i=1,self.shatter_num_projectiles do 
				local info = 
				{
					EffectName = "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf",
					Ability = self,
					vSpawnOrigin = vLocation,
					fDistance = self.burst_distance,
					fStartRadius = 100,
					fEndRadius = 100,
					Source = self:GetCaster(),
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO,
				}

				info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.shatter_speed

				ProjectileManager:CreateLinearProjectile( info )
				self.last_y = angle.y
				angle.y = self.last_y + ( 360 / self.shatter_num_projectiles )
			end

			self.last_y = 0
			EmitSoundOnLocationWithCaster( vLocation, "Hero_Winter_Wyvern.SplinterBlast.Target", self:GetCaster() )
		else
			if hTarget ~= nil and hTarget:IsMagicImmune() == false and hTarget:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self:GetSpecialValueFor( "shatter_damage" ),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_splinter_blast_slow", { duration = self.slow_duration })
				EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Splinter", hTarget )
			end
		end

		return true
	end
end

--------------------------------------------------------------------------------

