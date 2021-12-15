polarity_spin_attack = class({})
polarity_spin_attack_positive = polarity_spin_attack
polarity_spin_attack_negative = polarity_spin_attack

----------------------------------------------------------------------------------------

function polarity_spin_attack:Precache( context )
	PrecacheResource( "particle", "particles/polarity/polarity_ranged_attack_negative.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_ranged_attack_positive.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_warning_positive.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_warning_negative.vpcf", context )
	PrecacheResource( "particle", "particles/polarity/polarity_absorb_positive.vpcf", context )	
	PrecacheResource( "particle", "particles/polarity/polarity_absorb_negative.vpcf", context )	
		
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
end

----------------------------------------------------------------------------------------

function polarity_spin_attack:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function polarity_spin_attack:SetPolarity( nPolarity )
	if IsServer() then
		--print( '+-+-+- Setting polarity to ' .. nPolarity )
		self.polarity = nPolarity
	end
end

--------------------------------------------------------------------------------

function polarity_spin_attack:OnAbilityPhaseStart()
	if IsServer() then

		self.polarity = self:GetSpecialValueFor( "polarity" )

		StartSoundEventFromPositionReliable( "Aghanim.ShardAttack.Channel", self:GetCaster():GetAbsOrigin() )
		if self.polarity == 1 then
			self.nChannelFX = ParticleManager:CreateParticle( "particles/polarity/polarity_warning_positive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		else
			self.nChannelFX = ParticleManager:CreateParticle( "particles/polarity/polarity_warning_negative.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		end
	end
	return true
end

-------------------------------------------------------------------------------

function polarity_spin_attack:OnChannelThink( flInterval )
	if IsServer() then
		self.nNumThinks = self.nNumThinks + 1

		local flNow = GameRules:GetGameTime()

		if self.flNextProjectileTime > flNow then
			return
		end

		local fDiff = self.flNextProjectileTime - flNow
		--print( 'flInterval = ' .. flInterval .. ', fDiff = ' .. fDiff )

		--self.flNextProjectileTime = flNow + self.flProjectileInterval + fDiff
		self.flNextProjectileTime = flNow + self.projectile_interval + fDiff
		--EmitSoundOn( "Aghanim.ShardAttack.Wave", self:GetCaster() )

		--self:GetCaster():SetAbsAngles( 0, self.flYaw / 360, 0 )

		local Angle = QAngle( 0, self.flYaw, 0 )
		local vDirection = RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) )
		self:FireProjectile( vDirection )

		--self.flYaw = self.flYaw + ( self.flYawStep * self.nRotationDirection )
		self.flYaw = self.flYaw + ( self.degrees_between_projectiles * self.nRotationDirection )
	end
end

-------------------------------------------------------------------------------

function polarity_spin_attack:OnChannelFinish( bInterrupted )
	if IsServer() then
		--print( 'polarity_spin_attack:OnChannelFinish() - shot ' .. self.nNumProjectilesShot .. ', num thinks = ' .. self.nNumThinks )
		StopSoundOn( "Aghanim.ShardAttack.Loop", self:GetCaster() )
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-------------------------------------------------------------------------------

function polarity_spin_attack:OnSpellStart()
	if IsServer() then
		--print( 'polarity_spin_attack:OnSpellStart()' )
		--EmitSoundOn( "Aghanim.ShardAttack.Loop", self:GetCaster() )
		self.Projectiles = {}

		self.degrees_between_projectiles = self:GetSpecialValueFor( "degrees_between_projectiles" )
		self.projectile_interval = self:GetSpecialValueFor( "projectile_interval" )

		self.flYaw = RandomInt( 0, 360 )
		self.flNextProjectileTime = GameRules:GetGameTime()
		--self.flProjectileInterval = self:GetChannelTime() / ( self.projectiles_per_rotation * self.num_full_rotations )
		--self.flYawStep = 360 / self.projectiles_per_rotation
		self.nNumProjectilesShot = 0
		self.nNumThinks = 0

		--print( 'Degrees between projectiles = ' .. self.degrees_between_projectiles )
		--print( 'Projectile Interval = ' .. self.projectile_interval )

		self.nRotationDirection = 1
		if RandomInt( 0, 1 ) == 1 then
			self.nRotationDirection = -1
		end
	end
end

--------------------------------------------------------------------------------

function polarity_spin_attack:FireProjectile( vDirection )
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.duration = self:GetSpecialValueFor( "duration" )
		
		--self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local effect_name
		if self.polarity == 1 then
			effect_name = "particles/polarity/polarity_ranged_attack_positive.vpcf"
		elseif self.polarity == -1 then
			effect_name = "particles/polarity/polarity_ranged_attack_negative.vpcf"
		else
			print( 'ERROR - polarity_spin_attack FireProjectile() without a polarity value! BAILING!!!')
			return
		end

		local info = {
			EffectName = effect_name,
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			--vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			ExtraData = { polarity = self.polarity },
			--bProvidesVision = true,
			--iVisionRadius = 100,
			--iVisionTeamNumber = DOTA_TEAM_GOODGUYS,
		}

		ProjectileManager:CreateLinearProjectile( info )
		info.vVelocity = info.vVelocity * -1
		ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOn( "n_creep_SatyrHellcaller.Shockwave", self:GetCaster() )

		self.nNumProjectilesShot = self.nNumProjectilesShot + 1
	end
end

--------------------------------------------------------------------------------

function polarity_spin_attack:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
			
			local hPolarityBuff = hTarget:FindModifierByName( "modifier_polarity" )
			if hPolarityBuff and hPolarityBuff:GetPolarity() == kv.polarity then
				-- polarity is the same - no damage!
				EmitSoundOn( "Polarity.AbsorbedDamage", hTarget )

				local strEffectName = "particles/polarity/polarity_absorb_positive.vpcf"
				local nPolarity = hPolarityBuff:GetPolarity()
				if nPolarity == -1 then
					strEffectName = "particles/polarity/polarity_absorb_negative.vpcf"
				end

				local nFxIndex = ParticleManager:CreateParticle( strEffectName, PATTACH_ABSORIGIN_FOLLOW, hTarget )
				ParticleManager:SetParticleControlEnt( nFxIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFxIndex )
			else
				-- no polarity on target or polarity is different - damage!
				local damage = {
					victim = hTarget,
					attacker = self:GetCaster(),
					damage = self.attack_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self
				}

				ApplyDamage( damage )

				EmitSoundOn( "Polarity.Damage", hTarget )
			end

			return true
		end

		return false
	end

	return true
end

--------------------------------------------------------------------------------