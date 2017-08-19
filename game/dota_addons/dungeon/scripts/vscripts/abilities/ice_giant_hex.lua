
ice_giant_hex = class({})

LinkLuaModifier( "modifier_ice_giant_hex", "modifiers/modifier_ice_giant_hex", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ice_giant_hex:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_giant_hex:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "lycan_lycan_attack_09", self:GetCaster() )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/ice_giant_hex_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 150, 150, 150 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 26, 125, 250 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function ice_giant_hex:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function ice_giant_hex:OnSpellStart()
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
			EffectName = "particles/act_2/ice_giant_projectile_gale.vpcf",
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

		EmitSoundOn( "IceGiant.Hex.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ice_giant_hex:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			EmitSoundOn( "IceGiant.Hex.Impact", hTarget );

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ice_giant_hex", { duration = self:GetSpecialValueFor( "hex_duration" ) } )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_disarmed", { duration = self:GetSpecialValueFor( "hex_duration" ) } )
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_silence", { duration = self:GetSpecialValueFor( "hex_duration" ) } )
		end

		return false
	end
end

--------------------------------------------------------------------------------

