
ice_giant_explode_yak = class({})

--------------------------------------------------------------------------------

function ice_giant_explode_yak:OnSpellStart()
	if IsServer() then
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.aoe_damage = self:GetSpecialValueFor( "aoe_damage" )
		self.aoe_radius = self:GetSpecialValueFor( "aoe_radius" )

		local projectile =
		{
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
			iMoveSpeed = self.projectile_speed,
			vSourceLoc = self:GetCaster():GetOrigin(),
			bDodgeable = false,
			bProvidesVision = false,
		}

		ProjectileManager:CreateTrackingProjectile( projectile )
		EmitSoundOn( "hero_Crystal.frostbite", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function ice_giant_explode_yak:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		-- print( "ice_giant_explode_yak projectile hit" )
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
			
			local yakPosition = hTarget:GetOrigin()
			--kill the yak
			if hTarget:IsAlive() then
				hTarget:ForceKill(false)
			end

			local splatDirection = hTarget:GetOrigin() - self:GetCaster():GetOrigin()

			-- play the splat particle
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin() )
			ParticleManager:SetParticleControlForward( nFXIndex, 1, splatDirection )
			ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			-- play the aoe damage particle
			local nSprayIndex = ParticleManager:CreateParticle( "particles/act_2/ice_giant_yak_explosion.vcpf", PATTACH_CUSTOMORIGIN, hTarget )
			ParticleManager:SetParticleControlEnt( nSprayIndex, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nSprayIndex )


			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), yakPosition, nil, self.aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			-- print( "ice_giant_explode_yak aoe splat enemy count " .. #hEnemies .. " with radius " .. self.aoe_radius)
			for _,Enemy in pairs( hEnemies ) do
				if Enemy ~= nil then
					--add damage to enemy
					-- print( "ice_giant_explode_yak aoe splat " .. self.aoe_damage )
					local damage = 
					{
						victim = Enemy,
						attacker = self:GetCaster(),
						damage = self.aoe_damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self
					}
					ApplyDamage( damage )
				end
			end
		end

		return true
	end
end

--------------------------------------------------------------------------------

