ice_boss_shatter_projectile = class({})

--------------------------------------------------------------------------------

function ice_boss_shatter_projectile:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_shatter_projectile:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function ice_boss_shatter_projectile:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function ice_boss_shatter_projectile:GetPlaybackRateOverride()
	return 1
end

--------------------------------------------------------------------

function ice_boss_shatter_projectile:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Cast", self:GetCaster() )
		self.initial_projectile_speed = self:GetSpecialValueFor( "initial_projectile_speed" )
		self.initial_projectile_radius = self:GetSpecialValueFor( "initial_projectile_radius" )
		self.burst_distance = self:GetSpecialValueFor( "burst_distance" )
		self.shatter_damage = self:GetSpecialValueFor( "shatter_damage" )
		self.shatter_num_projectiles = self:GetSpecialValueFor( "shatter_num_projectiles" )
		self.shatter_speed = self:GetSpecialValueFor( "shatter_speed" )
		self.shatter_distance = self:GetSpecialValueFor( "shatter_distance" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )
		
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local nAttachmentID = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )

		local info = {
			EffectName = "particles/units/heroes/hero_puck/puck_illusory_orb.vpcf", 
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( nAttachmentID ), 
			fStartRadius = self.initial_projectile_radius,
			fEndRadius = self.initial_projectile_radius,
			vVelocity = vDirection * self.initial_projectile_speed,
			fDistance = self.burst_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		self.nInitialProjHandle = ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Projectile", self:GetCaster() )
	end
end


--------------------------------------------------------------------------------

function ice_boss_shatter_projectile:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if nProjectileHandle == self.nInitialProjHandle then
			local angle = QAngle( 0, 0, 0 )
			for i=1,self.shatter_num_projectiles do 
				local info = 
				{
					EffectName = "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf",
					Ability = self,
					vSpawnOrigin = vLocation,
					fDistance = self.shatter_distance,
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
