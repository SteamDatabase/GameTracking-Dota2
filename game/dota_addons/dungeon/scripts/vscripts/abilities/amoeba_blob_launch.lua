amoeba_blob_launch = class({})
LinkLuaModifier( "modifier_amoeba_blob_launch_thinker", "modifiers/modifier_amoeba_blob_launch_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function amoeba_blob_launch:OnAbilityPhaseStart()
	if IsServer() then
		self.nStackCount = 0
		local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
		if hBuff ~= nil then
			self.nStackCount = hBuff:GetStackCount()
		end

		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/ice_boss_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function amoeba_blob_launch:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end 
end

-----------------------------------------------------------------------------

function amoeba_blob_launch:GetPlaybackRateOverride()
	return 1.0
end

-----------------------------------------------------------------------------

function amoeba_blob_launch:OnSpellStart()
	if IsServer() then
		self.land_radius = self:GetSpecialValueFor( "land_radius" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.splatter_damage = self:GetSpecialValueFor( "splatter_damage" )
		self.Thinkers = {}
		self.vCenterPos = self:GetCursorPosition()

		self.nStackCount = 0
		local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
		if hBuff ~= nil then
			self.nStackCount = hBuff:GetStackCount()
			self.nStacksToLaunch = 2 * math.min( 10, math.floor( self.nStackCount / 2 ) )
			if self.nStacksToLaunch <= 0 then
				return
			end
		else
			self:GetCaster():Interrupt()
			return
		end

		self.nAccumulatedThinks = 0
		local nTotalThinks = math.floor( self:GetChannelTime() / 0.03 ) 
		self.nThinksPerLaunch = math.ceil( nTotalThinks / self.nStacksToLaunch )
	end
end

-----------------------------------------------------------------------------

function amoeba_blob_launch:OnChannelThink( flInterval )
	if IsServer() then
		self.nAccumulatedThinks = self.nAccumulatedThinks + 1
		if self.nAccumulatedThinks == self.nThinksPerLaunch then
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vCenterPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			if #enemies > 0 then
				if enemies[1]:IsMoving() then
					self.vCenterPos = enemies[1]:GetOrigin() + enemies[1]:GetForwardVector() * enemies[1]:GetIdealSpeed()
				else
					self.vCenterPos = enemies[1]:GetOrigin() + RandomVector( 50 )
				end		
			end
			self.nAccumulatedThinks = 0

			local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_amoeba_blob_launch_thinker", { duration = -1 }, self.vCenterPos, self:GetCaster():GetTeamNumber(), false )
			if hThinker ~= nil then
				table.insert( self.Thinkers, hThinker )

				EmitSoundOn( "Hero_Bristleback.ViscousGoo.Target", self:GetCaster() )

				local info = 
				{
					Target = hThinker,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/act_2/amoeba_small_blob_launch.vpcf",
					iMoveSpeed = self.projectile_speed,
					vSourceLoc = self:GetCaster():GetOrigin(),
					bDodgeable = false,
					bProvidesVision = false,
				}

				ProjectileManager:CreateTrackingProjectile( info )
				local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_boss_passive" )
				if hBuff ~= nil then
			--		hBuff:DecrementStackCount()
				end
			end
		end
	end
end

-----------------------------------------------------------------------------

function amoeba_blob_launch:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-----------------------------------------------------------------------------------------

function amoeba_blob_launch:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			for i=1,#self.Thinkers do
				local hThinker = self.Thinkers[i]
				if hThinker ~= nil and hThinker == hTarget then
					table.remove( self.Thinkers, i )
					UTIL_Remove( hThinker )
				end
			end

			EmitSoundOnLocationWithCaster( vLocation, "Hero_Batrider.StickyNapalm.Impact", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/blob_launch_impact.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation );
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.land_radius, self.land_radius, self.land_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.land_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,hEnemy in pairs( enemies ) do
				if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControl( nFXIndex, 0, vLocation )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 50, 50, 50  ) )
					ParticleManager:SetParticleControlEnt( nFXIndex, 2, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					local damageInfo = 
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self.splatter_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}

					ApplyDamage( damageInfo )

					local hStickyDebuff = hEnemy:FindModifierByName( "modifier_amoeba_boss_ink" )
					if hStickyDebuff == nil then
						hStickyDebuff = hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_amoeba_boss_ink", { duration = self:GetSpecialValueFor( "slow_duration" ) } )
						if hStickyDebuff ~= nil then
							hStickyDebuff:SetStackCount( 1 )
						end
					else
						hStickyDebuff:SetStackCount( hStickyDebuff:GetStackCount() + 1)
						hStickyDebuff:SetDuration( self:GetSpecialValueFor( "slow_duration" ), true )
					end
				end
			end

			local hAmoeba = CreateUnitByName( "npc_dota_creature_sub_amoeba_boss", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hAmoeba ~= nil then
				if self:GetCaster().zone ~= nil then
					self:GetCaster().zone:AddEnemyToZone( hAmoeba )
				end	
				local hBuff = hAmoeba:FindModifierByName( "modifier_amoeba_boss_passive" )
				if hBuff ~= nil then
					hBuff:SetStackCount( 1 )
				end
			end
		end	
	end
	return true
end