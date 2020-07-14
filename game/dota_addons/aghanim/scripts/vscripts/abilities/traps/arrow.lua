
--[[ abilities/traps/arrow.lua ]]

arrow = class({})

----------------------------------------------------------------------------------------

function arrow:Precache( context )

	PrecacheResource( "particle", "particles/traps/temple_trap_arrow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )

end

--------------------------------------------------------------------------------

function arrow:OnSpellStart()
	self.start_radius = self:GetSpecialValueFor( "start_radius" )
	self.end_radius = self:GetSpecialValueFor( "end_radius" )
	self.speed = self:GetLevelSpecialValueFor( "speed", GameRules.Aghanim:GetAscensionLevel() )
	self.max_hp_pct_damage = self:GetLevelSpecialValueFor( "max_hp_pct_damage", GameRules.Aghanim:GetAscensionLevel() )
	--printf( "ascension level: %d; speed: %d; percent damage: %d", GameRules.Aghanim:GetAscensionLevel(), self.speed, self.max_hp_pct_damage )

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
		EffectName = "particles/traps/temple_trap_arrow.vpcf",
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

function arrow:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		if hTarget:HasModifier( "modifier_treasure_chest" ) then
			return false
		end

		--[[
		local modifierKnockback =
		{
			center_x = vLocation.x,
			center_y = vLocation.y,
			center_z = vLocation.z,
			duration = 0.3,
			knockback_duration = 0.3,
			knockback_distance = 450,
			knockback_height = 50,
		}
		hTarget:AddNewModifier( hTarget, nil, "modifier_knockback", modifierKnockback )
		]]

		local fMaxHealth = hTarget:GetMaxHealth()
		local fDamage = math.ceil( fMaxHealth * ( self.max_hp_pct_damage / 100.0 ) )
		--printf( "arrow:OnProjectileHit - applying %.2f damage to target with %.2f max health", fDamage, fMaxHealth )

		local damageSource = self:GetCaster()
		local damage = {
			victim = hTarget,
			attacker = damageSource,
			damage = fDamage,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self
		}
		ApplyDamage( damage )

		if not ( hTarget:IsNull() ) and hTarget ~= nil then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin() )
			ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
			ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Dungeon.BloodSplatterImpact", hTarget )
		end

		return true
	end

	return false
end

--------------------------------------------------------------------------------
