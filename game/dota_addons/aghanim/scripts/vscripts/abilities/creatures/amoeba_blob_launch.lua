amoeba_blob_launch = class({})
amoeba_blob_launch_boss = amoeba_blob_launch
amoeba_blob_launch_large = amoeba_blob_launch
amoeba_blob_launch_medium = amoeba_blob_launch
amoeba_blob_launch_small = amoeba_blob_launch

LinkLuaModifier( "modifier_amoeba_blob_launch_thinker", "modifiers/creatures/modifier_amoeba_blob_launch_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amoeba_boss_ink", "modifiers/creatures/modifier_amoeba_boss_ink", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function amoeba_blob_launch:Precache( context )
	PrecacheResource( "particle", "particles/act_2/ice_boss_channel.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/amoeba_small_blob_launch.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/blob_launch_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/amoeba_marker_small.vpcf", context )
	PrecacheResource( "model", "models/creeps/darkreef/blob/darkreef_blob_02_small.vmdl", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
end

--------------------------------------------------------------------------------

function amoeba_blob_launch:OnAbilityPhaseStart()
	if IsServer() then
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
		self.blobs_to_launch = self:GetSpecialValueFor( "blobs_to_launch" )
		self.blob_duration = self:GetSpecialValueFor( "blob_duration" )

		self.Thinkers = {}
		self.vCenterPos = self:GetCursorPosition()

		self.nAccumulatedThinks = 0
		local nTotalThinks = math.floor( self:GetChannelTime() / 0.03 ) 
		self.nThinksPerLaunch = math.ceil( nTotalThinks / self.blobs_to_launch )
	end
end

-----------------------------------------------------------------------------

function amoeba_blob_launch:OnChannelThink( flInterval )
	if IsServer() then
		self.nAccumulatedThinks = self.nAccumulatedThinks + 1
		if self.nAccumulatedThinks == self.nThinksPerLaunch then
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vCenterPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
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

				local vecToTarget = self.vCenterPos - self:GetCaster():GetAbsOrigin()
				local fDistance = vecToTarget:Length2D()
				local fTravelTime = fDistance / self.projectile_speed
				--print( 'TRAVEL TIME FOR BLOB LAUNCH = ' .. fTravelTime )

				local strEffectName = "particles/act_2/amoeba_marker_small.vpcf"
				local nTargetFX = ParticleManager:CreateParticle( strEffectName, PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControl( nTargetFX, 0, self.vCenterPos )
				ParticleManager:SetParticleControl( nTargetFX, 1, Vector( self.land_radius, -self.land_radius, -self.land_radius ) )
				ParticleManager:SetParticleControl( nTargetFX, 2, Vector( fTravelTime, 0, 0 ) );
				ParticleManager:ReleaseParticleIndex( nTargetFX )
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
				if hEnemy ~= nil and hEnemy:IsNull() == false and hEnemy:IsAlive() == true and hEnemy:IsInvulnerable() == false then
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

			local hAmoeba = CreateUnitByName( "npc_dota_creature_amoeba_baby", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			hAmoeba:AddNewModifier( self:GetCaster(), self, "modifier_kill", { duration = self.blob_duration } )
		end	
	end
	return true
end