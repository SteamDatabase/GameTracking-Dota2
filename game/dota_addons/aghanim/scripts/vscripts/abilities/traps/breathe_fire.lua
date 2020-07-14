
breathe_fire = class({})

----------------------------------------------------------------------------------------

function breathe_fire:Precache( context )

	PrecacheResource( "particle", "particles/fire_trap/trap_breathe_fire.vpcf", context )

end

--------------------------------------------------------------------------------

function breathe_fire:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function breathe_fire:OnSpellStart()
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.speed = self:GetSpecialValueFor( "speed" )
	self.max_hp_pct_damage = self:GetLevelSpecialValueFor( "max_hp_pct_damage", GameRules.Aghanim:GetAscensionLevel() )
	--printf( "ascension level: %d; percent damage: %d", GameRules.Aghanim:GetAscensionLevel(), self.max_hp_pct_damage )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local fRangeToTarget =  ( self:GetCaster():GetOrigin() - vPos ):Length2D()

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( ( fRangeToTarget ) / ( fRangeToTarget -self.start_radius ) )

	local info = {
		EffectName = "particles/fire_trap/trap_breathe_fire.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.speed,
		fDistance = fRangeToTarget,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )

	EmitSoundOn( "AghanimsFortress.FireTrap", self:GetCaster() )
end

--------------------------------------------------------------------------------

function breathe_fire:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local fMaxHealth = hTarget:GetMaxHealth()
		local fDamage = math.ceil( fMaxHealth * ( self.max_hp_pct_damage / 100.0 ) )
		--printf( "breathe_fire:OnProjectileHit - applying %.2f damage to target with %.2f max health", fDamage, fMaxHealth )

		local damageSource = self:GetCaster()
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = fDamage,
			damage_type = self:GetAbilityDamageType(),
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end

--------------------------------------------------------------------------------
