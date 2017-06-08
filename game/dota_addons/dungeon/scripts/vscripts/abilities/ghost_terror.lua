
ghost_terror = class({})

--------------------------------------------------------------------------------

function ghost_terror:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 60, 60, 60 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 60, 0, 100 ) )

		self:GetCaster():SetSequence( "hit" )
	end

	return true
end

--------------------------------------------------------------------------------

function ghost_terror:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		--self:GetCaster():SetSequence( "idle" )
	end 
end

-----------------------------------------------------------------------------

function  ghost_terror:GetPlaybackRateOverride()
	return 1.0
end

--------------------------------------------------------------------------------

function ghost_terror:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		
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
			EffectName = "particles/units/heroes/hero_shadow_demon/shadow_demon_shadow_poison_projectile.vpcf", --"particles/lycanboss_ruptureball_gale.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOn( "Dungeon.GhostTerror.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ghost_terror:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			EmitSoundOn( "Dungeon.GhostTerror.Grip", hTarget );

			self.duration = self:GetSpecialValueFor( "fiend_grip_duration" )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_bane_fiends_grip", { duration = self.duration } )
		end

		return true
	end
end

--------------------------------------------------------------------------------

