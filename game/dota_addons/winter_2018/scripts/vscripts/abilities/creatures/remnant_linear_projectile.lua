
remnant_linear_projectile = class({})

--------------------------------------------------------------------------------

function remnant_linear_projectile:OnSpellStart()
	if IsServer() then
		self.attack_speed = self:GetSpecialValueFor( "attack_speed" )
		self.attack_width_initial = self:GetSpecialValueFor( "attack_width_initial" )
		self.attack_width_end = self:GetSpecialValueFor( "attack_width_end" )
		self.attack_distance = self:GetSpecialValueFor( "attack_distance" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" )
		self.num_spawns = self:GetSpecialValueFor( "num_spawns" )
		self.max_spawns = self:GetSpecialValueFor( "max_spawns" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		if self:GetCaster().hSpawnedUnits == nil then
			self:GetCaster().hSpawnedUnits = { }
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		self.attack_speed = self.attack_speed * ( self.attack_distance / ( self.attack_distance - self.attack_width_initial ) )

		local info = {
			EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
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

		EmitSoundOn( "Hound.QuillAttack.Cast", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function remnant_linear_projectile:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsBuilding() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.attack_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self
			}

			ApplyDamage( damage )

			-- Create some units where the projectile hits
			for i = 1, self.num_spawns do
				if #self:GetCaster().hSpawnedUnits + 1 > self.max_spawns then
					break
				end

				local hSpawnedUnit = CreateUnitByName( "npc_dota_creature_medium_spectre", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hSpawnedUnit ~= nil then
					table.insert( self:GetCaster().hSpawnedUnits, hSpawnedUnit )

					hSpawnedUnit:SetInitialGoalEntity( hTarget )

					local vRandomOffset = Vector( RandomInt( -20, 20 ), RandomInt( -20, 20 ), 0 )
					local vSpawnPoint = hTarget:GetAbsOrigin() + vRandomOffset
					FindClearSpaceForUnit( hSpawnedUnit, vSpawnPoint, true )
				end
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget );
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true  );
			ParticleManager:ReleaseParticleIndex( nFXIndex );

			EmitSoundOn( "Hound.QuillAttack.Target", hTarget );
		end

		return true
	end
end

--------------------------------------------------------------------------------

