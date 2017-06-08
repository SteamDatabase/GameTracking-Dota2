spider_poison_spit = class({})

--------------------------------------------------------------------------------

function spider_poison_spit:OnSpellStart()
	if IsServer() then
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
			EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.attack_width_initial,
			fEndRadius = self.attack_width_end,
			vVelocity = vDirection * self.attack_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		}

		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOn( "Spider.PoisonSpit", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function spider_poison_spit:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_venomancer_venomous_gale", { duration = self:GetSpecialValueFor( "duration" ) } )

			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget ) )
			EmitSoundOn( "Spider.PoisonSpit.Impact", hTarget );

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_disarmed", { duration = self:GetSpecialValueFor( "duration" ) } )
		end

		return true
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------