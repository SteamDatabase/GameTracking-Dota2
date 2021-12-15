arc_warden_boss_ranged_attack = class({})

----------------------------------------------------------------------------------------

function arc_warden_boss_ranged_attack:Precache( context )
	PrecacheResource( "particle", "particles/arc_warden_boss/ranged_attack.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )

	self.Projectiles = {}
end

function arc_warden_boss_ranged_attack:OnAbilityPhaseStart()
	if IsServer() then
		print( '***arc_warden_boss_ranged_attack:OnAbilityPhaseStart()' )
	end

	return true
end

--------------------------------------------------------------------------------

function arc_warden_boss_ranged_attack:OnSpellStart()
	if IsServer() then
		print( '***RANGED ATTACK GO arc_warden_boss_ranged_attack:OnSpellStart()' )

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
			EffectName = "particles/arc_warden_boss/ranged_attack.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ),
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "n_creep_SatyrHellcaller.Shockwave", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function arc_warden_boss_ranged_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self
			}

			ApplyDamage( damage )

			--hTarget:AddNewModifier( self:GetCaster(), self, "modifier_aghsfort_arc_warden_boss_flux", { duration = self.duration } )

			EmitSoundOn( "n_creep_SatyrHellcaller.Shockwave.Damage", hTarget )

			-- just pass through zombies
			if hTarget:IsZombie() == true then
				return false
			end

			return true
		end

		return false
	end
end

--------------------------------------------------------------------------------