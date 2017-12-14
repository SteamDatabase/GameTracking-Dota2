
breathe_fire = class({})

function breathe_fire:OnSpellStart()
	local caster = self:GetCaster()
	local casterPosition = caster:GetAbsOrigin()
	local ability = self
	local particle = "particles/fire_trap/trap_breathe_fire.vpcf"
	local sound = "Dungeon.FireTrap"

	local start_radius = ability:GetSpecialValueFor( "start_radius" )
	local end_radius = ability:GetSpecialValueFor( "end_radius" )
	local speed = ability:GetSpecialValueFor( "speed" )
	
	--self.range = self:GetSpecialValueFor( "range" )

	EmitGlobalSound(sound)
	EmitSoundOn(sound, caster)

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local fRangeToTarget =  ( casterPosition - vPos ):Length2D()

	local vDirection = vPos - casterPosition
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	speed = speed * ( ( fRangeToTarget ) / ( fRangeToTarget - start_radius ) )

	local info = {
		EffectName = particle,
		Ability = ability,
		vSpawnOrigin = casterPosition, 
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		vVelocity = vDirection * speed,
		fDistance = fRangeToTarget,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )
end

function breathe_fire:OnProjectileHit( hTarget, vLocation )
	local fire_damage = self:GetSpecialValueFor( "fire_damage" ) 
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damageSource = self:GetCaster()
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = fire_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end

breathe_fire_trap_game = class({})

function breathe_fire_trap_game:OnSpellStart()
	local caster = self:GetCaster()
	local casterPosition = caster:GetAbsOrigin()
	local ability = self
	local particle = "particles/fire_trap/trap_breathe_fire.vpcf"
	local sound = "Dungeon.FireTrap"

	local start_radius = ability:GetSpecialValueFor( "start_radius" )
	local end_radius = ability:GetSpecialValueFor( "end_radius" )
	local speed = ability:GetSpecialValueFor( "speed" )
	
	--self.range = self:GetSpecialValueFor( "range" )

	EmitGlobalSound(sound)
	EmitSoundOn(sound, caster)

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local fRangeToTarget =  ( casterPosition - vPos ):Length2D()

	local vDirection = vPos - casterPosition
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	speed = speed * ( ( fRangeToTarget ) / ( fRangeToTarget - start_radius ) )

	local info = {
		EffectName = particle,
		Ability = ability,
		vSpawnOrigin = casterPosition, 
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		vVelocity = vDirection * speed,
		fDistance = fRangeToTarget,
		Source = caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}
	ProjectileManager:CreateLinearProjectile( info )
end

function breathe_fire_trap_game:OnProjectileHit( hTarget, vLocation )
	local fire_damage = self:GetSpecialValueFor( "fire_damage" ) 
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damageSource = self:GetCaster()
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = fire_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end