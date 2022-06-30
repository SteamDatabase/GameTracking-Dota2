breathe_fire = class({})

--------------------------------------------------------------------------------

function breathe_fire:OnSpellStart()
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.range = self:GetSpecialValueFor( "range" )
	self.speed = self:GetSpecialValueFor( "speed" )
	self.fire_damage_percent = self:GetSpecialValueFor( "fire_damage_percent" ) 

	

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.speed = self.speed * ( ( self.range ) / ( self.range -self.start_radius ) )

	local effect_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	if self:GetCaster():GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		effect_name = "particles/fire_trap/trap_breathe_fire.vpcf"
		--print("Blue Fire")
	end

	local info = {
		EffectName = effect_name,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.start_radius,
		fEndRadius = self.end_radius,
		vVelocity = vDirection * self.speed,
		fDistance = self.range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	if GetMapName() == "haunted_colosseum" then
		EmitSoundOn( "Conquest.FireTrap", self:GetCaster() )
	else
		EmitSoundOn( "Conquest.FireTrap.Generic", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function breathe_fire:OnProjectileHit( hTarget, vLocation )
	local fireDamagePercent = self.fire_damage_percent / 100.0
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damageSource = self:GetCaster()
		if self:GetCaster() ~= nil and self:GetCaster().KillerToCredit ~= nil then
			damageSource = self:GetCaster().KillerToCredit
		end

		local damageAmount = hTarget:GetMaxHealth() * fireDamagePercent
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = damageAmount,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------