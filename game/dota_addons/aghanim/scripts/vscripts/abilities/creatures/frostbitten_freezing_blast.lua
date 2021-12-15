
frostbitten_freezing_blast = class({})
LinkLuaModifier( "modifier_frostbitten_freezing_blast", "modifiers/creatures/modifier_frostbitten_freezing_blast", LUA_MODIFIER_MOTION_NONE )


----------------------------------------------------------------------------------------

function frostbitten_freezing_blast:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/troll_projectile_gale.vpcf", context )
	
end

--------------------------------------------------------------------------------

function frostbitten_freezing_blast:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function frostbitten_freezing_blast:OnAbilityPhaseStart()
	if IsServer() then
		--EmitSoundOn( "lycan_lycan_attack_09", self:GetCaster() )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 50, 50, 50 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 25, 150, 255 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function frostbitten_freezing_blast:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function frostbitten_freezing_blast:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.attack_radius = self:GetSpecialValueFor( "projectile_radius" )
		self.projectile_distance = self:GetSpecialValueFor( "projectile_distance" )
		self.impact_damage = self:GetSpecialValueFor( "impact_damage" )
		self.movespeed_slow = self:GetSpecialValueFor( "movespeed_slow" )
		self.attackspeed_slow = self:GetSpecialValueFor( "attackspeed_slow" )
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

		--print( " frostbitten - projectile speed: " .. vDirection.x .. " y " .. vDirection.y )

		local info = {
			EffectName = "particles/act_2/troll_projectile_gale.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.attack_radius,
			fEndRadius = self.attack_radius,
			vVelocity = vDirection * self.projectile_speed,
			fDistance = self.projectile_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		ProjectileManager:CreateLinearProjectile( info )

		EmitSoundOn( "FrostbittenShaman.FreezingBlast.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function frostbitten_freezing_blast:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		--print( "frostbitten projectile hit" )
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			local damage =
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.impact_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self
			}
			ApplyDamage( damage )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_frostbitten_freezing_blast", { duration = self.slow_duration } )

			EmitSoundOn( "FrostbittenShaman.FreezingBlast.Impact", self:GetCaster() )
		end

		return true
	end
end

--------------------------------------------------------------------------------

