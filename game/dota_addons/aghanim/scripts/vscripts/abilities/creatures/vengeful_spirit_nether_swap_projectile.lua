vengeful_spirit_nether_swap_projectile = class({})

----------------------------------------------------------------------------------------

function vengeful_spirit_nether_swap_projectile:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf", context )	
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )

	self.Projectiles = {}
end

--------------------------------------------------------------------------------

function vengeful_spirit_nether_swap_projectile:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.duration = self:GetSpecialValueFor( "duration" )
		
		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local info = {
			EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Hero_VengefulSpirit.WaveOfTerror", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function vengeful_spirit_nether_swap_projectile:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		local hCaster = self:GetCaster()
		if 	hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = hCaster,
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}
			ApplyDamage( damage )

			-- kill and pass through zombies
			if hTarget:IsZombie() == true then
				return false
			end

			if hCaster ~= nil and hCaster:IsNull() == false and hCaster:IsAlive() == true then
				local vTargetPos = hTarget:GetAbsOrigin()
				local vCasterPos = hCaster:GetAbsOrigin()

				hTarget:SetAbsOrigin( vCasterPos )
				hCaster:SetAbsOrigin( vTargetPos )

				FindClearSpaceForUnit( hTarget, vCasterPos, true )
				FindClearSpaceForUnit( hCaster, vTargetPos, true )

				-- kind of hacky but when we get a solid connection with this ability we need to nuke out the destination that the venge is running to
				hCaster.vSwapDestination = nil

				hTarget:Interrupt()

				EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
				EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hTarget )

				local nCasterEffect = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
				ParticleManager:SetParticleControlEnt( nCasterEffect, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nCasterEffect )

				local nTargetEffect = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
				ParticleManager:SetParticleControlEnt( nTargetEffect, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nTargetEffect )
			end

			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------