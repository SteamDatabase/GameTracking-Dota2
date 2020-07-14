
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
	self.fire_damage = self:GetSpecialValueFor( "fire_damage" ) 
	--self.range = self:GetSpecialValueFor( "range" )

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
	local fireDamage = self.fire_damage
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then

		local damageSource = self:GetCaster()
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = fireDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end

--------------------------------------------------------------------------------
