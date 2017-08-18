
ice_boss_shriek = class({})

--------------------------------------------------------------------------------

function ice_boss_shriek:OnSpellStart()
	if IsServer() then
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.start_radius = self:GetSpecialValueFor( "start_radius" )
		self.end_radius = self:GetSpecialValueFor( "end_radius" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "damage" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		print( " ice_boss_shriek - projectile speed: " .. vDirection.x .. " y " .. vDirection.y )

		local info = {
			EffectName = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
			-- EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(), 
			fStartRadius = self.start_radius,
			fEndRadius = self.end_radius,
			vVelocity = vDirection * self.projectile_speed,
			fDistance = self.attack_distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
		}

		ProjectileManager:CreateLinearProjectile( info )
	end
end



--------------------------------------------------------------------------------

function ice_boss_shriek:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		print( "ice_boss_shriek projectile hit" )
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			
			-- add damage
			local damage = 
			{
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self
			}
			ApplyDamage( damage )

		end

		return true
	end
end

--------------------------------------------------------------------------------
