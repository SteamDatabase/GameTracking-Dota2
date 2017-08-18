
siltbreaker_mind_control = class({})
LinkLuaModifier( "modifier_siltbreaker_mind_control", "modifiers/modifier_siltbreaker_mind_control", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_mind_control_marked", "modifiers/modifier_siltbreaker_mind_control_marked", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_mind_control:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Siltbreaker.MindControl.PreCast", self:GetCaster() )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 70, 36, 247 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_mind_control:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		StopSoundOn( "Siltbreaker.MindControl.PreCast", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function siltbreaker_mind_control:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.attack_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.charm_duration = self:GetSpecialValueFor( "charm_duration" )
		self.projectile_expire_time = self:GetSpecialValueFor( "projectile_expire_time" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local info = {
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/act_2/siltbreaker_mind_control_shot.vpcf",
			iMoveSpeed = self.projectile_speed,
			vSourceLoc = self:GetCaster():GetOrigin(),
			bDodgeable = false,
			bProvidesVision = false,
			flExpireTime = GameRules:GetGameTime() + self.projectile_expire_time,
		}

		ProjectileManager:CreateTrackingProjectile( info )

		StopSoundOn( "Siltbreaker.MindControl.PreCast", self:GetCaster() )
		EmitSoundOn( "Siltbreaker.MindControl.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function siltbreaker_mind_control:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_mind_control", { duration = self.charm_duration } )
		end

		return true
	end
end

--------------------------------------------------------------------------------

