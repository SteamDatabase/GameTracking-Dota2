
storegga_throw_rock = class({})

LinkLuaModifier( "modifier_storegga_thrown", "modifiers/creatures/modifier_storegga_thrown", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function storegga_throw_rock:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_throw_rock:OnAbilityPhaseStart()
	if IsServer() then
		-- Cast Preview
		self.nCastPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nCastPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nCastPreviewFX, 1, Vector( 50, 50, 50 ) )
		ParticleManager:SetParticleControl( self.nCastPreviewFX, 15, Vector( 25, 150, 255 ) )

		self.hRockUnit = CreateUnitByName( "npc_dota_storegga_rock", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if self.hRockUnit ~= nil then
			-- Note: modifier_storegga_thrown keeps the rock attached to storegga's hand if the projectile doesn't exist, and otherwise
			-- 	moves itself to the projectile's position
			self.hRockUnit:SetOwner( self:GetCaster() )
			--self.hRockUnit:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
			self.hRockUnit:SetInitialGoalEntity( self:GetCaster():GetInitialGoalEntity() )
			self.hRockUnit:SetDeathXP( 0 )
			self.hRockUnit:SetMinimumGoldBounty( 0 )
			self.hRockUnit:SetMaximumGoldBounty( 0 )

			self.hRockUnit:AddNewModifier( self:GetCaster(), self, "modifier_storegga_thrown", { duration = -1 } )
			self.hThrownBuff = self.hRockUnit:FindModifierByName( "modifier_storegga_thrown" )
		end
	end

	return true
end

--------------------------------------------------------------------------------

function storegga_throw_rock:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nCastPreviewFX, false )

		UTIL_Remove( self.hRockUnit )
	end
end

--------------------------------------------------------------------------------

function storegga_throw_rock:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nCastPreviewFX, false )

		self.throw_speed = self:GetSpecialValueFor( "throw_speed" )
		self.impact_radius = self:GetSpecialValueFor( "impact_radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
		self.knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
		self.knockback_damage = self:GetSpecialValueFor( "knockback_damage" )
		self.knockback_height = self:GetSpecialValueFor( "knockback_height" )
		self.children_to_spawn = self:GetSpecialValueFor( "children_to_spawn" )
		self.max_children = self:GetSpecialValueFor( "max_children" )
		self.building_dmg_multiplier = self:GetSpecialValueFor( "building_dmg_multiplier" )

		if GameRules.holdOut.hFort then
			self.hFort = GameRules.holdOut.hFort
		else
			local hFort = GameRules.holdOut.FindAndGetFort()
			if hFort then
				self.hFort = hFort
			else
				print( "ERROR - storegga_throw_rock: Could not set initial goal entity" )
				self:Destroy()
				return
			end
		end

		if not self.hChildren then
			self.hChildren = { }
		end

		self.vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
		self.flDist = self.vDirection:Length2D() - 300 -- the direction is offset due to the attachment point
		self.vDirection.z = 0.0
		self.vDirection = self.vDirection:Normalized()

		self.attach = self:GetCaster():ScriptLookupAttachment( "attach_attack2" )
		self.vSpawnLocation = self:GetCaster():GetAttachmentOrigin( self.attach )
		self.vEndPos = self.vSpawnLocation + self.vDirection * self.flDist

		local info = {
			EffectName = "",
			Ability = self,
			vSpawnOrigin = self.vSpawnLocation, 
			fStartRadius = self.impact_radius,
			fEndRadius = self.impact_radius,
			vVelocity = self.vDirection * self.throw_speed,
			fDistance = self.flDist,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		}

		self.hThrownBuff.nProjHandle = ProjectileManager:CreateLinearProjectile( info )
		self.hThrownBuff.flHeight = self.vSpawnLocation.z - GetGroundHeight( self:GetCaster():GetOrigin(), self:GetCaster() )
		self.hThrownBuff.vEndPos = self.vEndPos
		self.hThrownBuff.flTime = self.flDist / self.throw_speed

		EmitSoundOn( "Storegga.ThrowRock.Launch", self:GetCaster() )

		EmitSoundOn( "Storegga.ThrowRock.ProjectileLoop", self.hRockUnit )

		-- Impact Position Preview
		-- @fixme: this particle does not render if the caster is not visible
		self.nTargetPreviewFX = ParticleManager:CreateParticle( "particles/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nTargetPreviewFX, 0, self:GetCursorPosition() )
		ParticleManager:SetParticleControl( self.nTargetPreviewFX, 1, Vector( self.impact_radius, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nTargetPreviewFX, 2, Vector( 99, 0, 1 ) )
		ParticleManager:SetParticleControl( self.nTargetPreviewFX, 3, Vector( 200, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nTargetPreviewFX, 4, Vector( 0, 0, 0 ) )
		--ParticleManager:SetParticleShouldCheckFoW( self.nTargetPreviewFX, false )
		--ParticleManager:SetParticleFoWProperties( self.nTargetPreviewFX, 0, -1, self.impact_radius )
	end
end

--------------------------------------------------------------------------------

function storegga_throw_rock:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			return
		end

		if self:GetCaster() == nil or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			self:DestroyRock()
			return
		end

		EmitSoundOnLocationWithCaster( vLocation, "Storegga.ThrowRock.Impact", self:GetCaster() )

		if self.hRockUnit and not self.hRockUnit:IsNull() and self.hThrownBuff and not self.hThrownBuff:IsNull() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( vLocation, self.hRockUnit ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self:DestroyRock()
		end

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsNull() == false and enemy:IsInvulnerable() == false then
				local fDmg = self.knockback_damage
				if enemy:IsBuilding() then
					fDmg = fDmg * self.building_dmg_multiplier
				end

				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = fDmg,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}
				ApplyDamage( damageInfo )

				if enemy:IsBuilding() == false then
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
					else
						local kv =
						{
							center_x = vLocation.x,
							center_y = vLocation.y,
							center_z = vLocation.z,
							should_stun = true,
							duration = self.knockback_duration,
							knockback_duration = self.knockback_duration,
							knockback_distance = self.knockback_distance,
							knockback_height = self.knockback_height,
						}
						enemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv )
					end
				end
			end
		end

		local vSpawnPos = vLocation + RandomVector( 150 )

		-- Prune the dead from my table of units
		for index, hChild in pairs( self.hChildren ) do
			if hChild == nil or hChild:IsNull() or hChild:IsAlive() == false then
				table.remove( self.hChildren, index )
			end
		end

		for i = 1, self.children_to_spawn do
			if #self.hChildren < self.max_children then
				local hChild = CreateUnitByName( "npc_dota_creature_small_storegga", vSpawnPos, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
				if hChild ~= nil and hChild:IsNull() == false then
					table.insert( self.hChildren, hChild )
					hChild:SetOwner( self:GetCaster() )
					--hChild:SetControllableByPlayer( self:GetCaster():GetPlayerOwnerID(), false )
					hChild:SetInitialGoalEntity( self.hFort )
					hChild:SetDeathXP( 0 )
					hChild:SetMinimumGoldBounty( 0 )
					hChild:SetMaximumGoldBounty( 0 )
				end
			end
		end

		self:DestroyRock()

		return false
	end
end

-----------------------------------------------------------------------

function storegga_throw_rock:DestroyRock()
	if IsServer() then
		if self.hRockUnit == nil or self.hRockUnit:IsNull() then
			return
		end

		StopSoundOn( "Storegga.ThrowRock.ProjectileLoop", self.hRockUnit )

		ParticleManager:DestroyParticle( self.nTargetPreviewFX, true )

		if self.hThrownBuff ~= nil and self.hThrownBuff:IsNull() == false then
			self.hThrownBuff:Destroy()
		end

		--print( "storegga_throw_rock - Destroying rock" )

		if self.hRockUnit ~= nil and self.hRockUnit:IsNull() == false then
			self.hRockUnit:AddEffects( EF_NODRAW )
			self.hRockUnit:ForceKill( false )

			UTIL_Remove( self.hRockUnit )
		end
	end
end

-----------------------------------------------------------------------
