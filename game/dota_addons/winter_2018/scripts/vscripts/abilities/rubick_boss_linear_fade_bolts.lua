rubick_boss_linear_fade_bolts = class({})
LinkLuaModifier( "modifier_rubick_boss_linear_fade_bolts", "modifiers/modifier_rubick_boss_linear_fade_bolts", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_boss_linear_fade_bolts_debuff", "modifiers/modifier_rubick_boss_linear_fade_bolts_debuff", LUA_MODIFIER_MOTION_NONE )


-----------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():RemoveGesture( ACT_DOTA_IDLE )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_rubick_boss_linear_fade_bolts", {} )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetCaster():GetOrigin() )
	end
	return true
end

-----------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end



-----------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnSpellStart()
	if IsServer() then
		self.fade_bolt_width = self:GetSpecialValueFor( "fade_bolt_width" )
		self.fade_bolt_speed = self:GetSpecialValueFor( "fade_bolt_speed" )
		self.fade_bolt_bounces = self:GetSpecialValueFor( "fade_bolt_bounces" )
		self.fade_bolt_damage = self:GetSpecialValueFor( "fade_bolt_damage" )
		self.num_projectiles = self:GetSpecialValueFor( "num_projectiles" )
		self.angle_span = self:GetSpecialValueFor( "angle_span" )
		self.repeats = self:GetSpecialValueFor( "repeats" )

		self.vDirection = ( self:GetCursorPosition() + RandomVector( 1 ) * 50 ) - self:GetCaster():GetOrigin()
		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()

		self.flProjectileInterval = self:GetChannelTime() / ( self.num_projectiles * self.repeats )
		self.flAngleStep = self.angle_span / self.num_projectiles
		self.AngleY = ( self.angle_span / 2 ) * -1
		self.flNextProjectileTime = GameRules:GetGameTime() + self.flProjectileInterval

		self.nProjectilesBeforeRepeat = self.num_projectiles
		self.nRepeatsLeft = self.repeats

		self:FireFadeBolt()
	end
end

-----------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnChannelThink( flThink )
	if IsServer() then
		if GameRules:GetGameTime() > self.flNextProjectileTime then
			self:FireFadeBolt()
		end
	end
end

-----------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		self:GetCaster():RemoveModifierByName( "modifier_rubick_boss_linear_fade_bolts" )
		if self:GetCaster():FindModifierByName( "modifier_rubick_boss_flying" ) ~= nil then
			self:GetCaster():StartGesture( ACT_DOTA_IDLE )
		end
	end
end

--------------------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:FireFadeBolt()
	if IsServer() then
		local angle = VectorToAngles( self.vDirection ) 
		angle.y = angle.y + self.AngleY

		local info = 
		{
			EffectName = "particles/rubick/rubick_frosthaven_cube_projectile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.fade_bolt_width,
			fEndRadius = self.fade_bolt_width,
			vVelocity = RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) * self.fade_bolt_speed,
			fDistance = 99999,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

 		ProjectileManager:CreateLinearProjectile( info )
 		EmitSoundOn( "Hero_Rubick.FadeBolt.Target", self:GetCaster() )

 		self.nProjectilesBeforeRepeat = self.nProjectilesBeforeRepeat - 1
 		if self.nProjectilesBeforeRepeat == 0 then
 			self.nRepeatsLeft = self.nRepeatsLeft - 1
 			if self.nRepeatsLeft > 0 then
 				self.AngleY = self.AngleY + ( self.flAngleStep / 2 )
 				self.flAngleStep = self.flAngleStep * -1
 				self.nProjectilesBeforeRepeat = self.num_projectiles
 			else
 				return
 			end
 		end
 		self.AngleY = self.AngleY + self.flAngleStep
 		self.flNextProjectileTime = GameRules:GetGameTime() + self.flProjectileInterval
	end
end

--------------------------------------------------------------------------------

function rubick_boss_linear_fade_bolts:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsNull() == false then
			local damageInfo =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self:GetSpecialValueFor( "fade_bolt_damage" ),
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damageInfo )

			EmitSoundOn( "Hero_Rubick.FadeBolt.Target", hTarget )
			if hTarget ~= nil and hTarget:IsNull() == false then
				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_rubick_boss_linear_fade_bolts_debuff", { duration = self:GetSpecialValueFor( "slow_duration" ) } )
			end

			-- local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD, 0, false )
			-- for _,enemy in pairs( enemies ) do
			-- 	if enemy ~= nil and enemy ~= hTarget then
			-- 		local vDirection = ( enemy:GetOrigin() + RandomVector( 1 ) * 50 ) - hTarget:GetOrigin()
			-- 		vDirection.z = 0.0
			-- 		vDirection = vDirection:Normalized()

			-- 		local info = 
			-- 		{
			-- 			EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
			-- 			Ability = self,
			-- 			vSpawnOrigin = hTarget:GetOrigin() + vDirection * 200, 
			-- 			fStartRadius = self.fade_bolt_width,
			-- 			fEndRadius = self.fade_bolt_width,
			-- 			vVelocity = vDirection * self.fade_bolt_speed,
			-- 			fDistance = 99999,
			-- 			Source = self:GetCaster(),
			-- 			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			-- 			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			-- 		}

			-- 		ProjectileManager:CreateLinearProjectile( info )
			-- 		EmitSoundOn( "Hero_Rubick.FadeBolt.Cast", self:GetCaster() )
			-- 		return true
			-- 	end
			-- end

			
		end
	end

	return true
end