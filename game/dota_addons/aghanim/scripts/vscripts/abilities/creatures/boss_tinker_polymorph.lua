
boss_tinker_polymorph = class({})

LinkLuaModifier( "modifier_boss_tinker_polymorph_launch_thinker", "modifiers/creatures/modifier_boss_tinker_polymorph_launch_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_polymorph", "modifiers/creatures/modifier_boss_tinker_polymorph", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_amoeba_boss_ink", "modifiers/creatures/modifier_amoeba_boss_ink", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_polymorph:Precache( context )
	PrecacheUnitByNameSync( "npc_dota_creature_keen_minion", context, -1 )

	PrecacheResource( "particle", "particles/act_2/ice_boss_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_polymorph_launch.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/blob_launch_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )

	PrecacheResource( "model", "models/items/hex/sheep_hex/sheep_hex.vmdl", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
end

--------------------------------------------------------------------------------

function boss_tinker_polymorph:GetPlaybackRateOverride()
	return 0.25
end

--------------------------------------------------------------------------------

function boss_tinker_polymorph:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/ice_boss_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

		EmitSoundOn( "Boss_Tinker.Polymorph.Cast", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_tinker_polymorph:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		StopSoundOn( "Boss_Tinker.Polymorph.Cast", self:GetCaster() )
	end 
end

-----------------------------------------------------------------------------

function boss_tinker_polymorph:GetPlaybackRateOverride()
	return 1.0
end

-----------------------------------------------------------------------------

function boss_tinker_polymorph:OnSpellStart()
	if IsServer() then
		self.land_radius = self:GetSpecialValueFor( "land_radius" )
		self.slow_duration = self:GetSpecialValueFor( "slow_duration" )
		self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
		self.splatter_damage = self:GetSpecialValueFor( "splatter_damage" )
		--self.blobs_to_launch = self:GetSpecialValueFor( "blobs_to_launch" )
		self.blob_duration = self:GetSpecialValueFor( "blob_duration" )
		self.launch_interval = self:GetSpecialValueFor( "launch_interval" )
		self.random_offset_max = self:GetSpecialValueFor( "random_offset_max" )
		self.transform_duration = self:GetSpecialValueFor( "transform_duration" )

		self.Thinkers = {}
		self.vCenterPos = self:GetCursorPosition()

		self.fNextLaunchTime = GameRules:GetGameTime()

	end
end

-----------------------------------------------------------------------------

function boss_tinker_polymorph:OnChannelThink( flInterval )
	if IsServer() then
		if GameRules:GetGameTime() < self.fNextLaunchTime then
			return
		end

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vCenterPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies > 0 then
			local nRandomIndex = RandomInt( 1, #enemies )
			local hRandomEnemy = enemies[ nRandomIndex ]
			if hRandomEnemy:IsMoving() then
				local fRandomOffsetMult = RandomFloat( 0.5, 1.0 )
				self.vCenterPos = hRandomEnemy:GetOrigin() + ( hRandomEnemy:GetForwardVector() * ( hRandomEnemy:GetIdealSpeed() * fRandomOffsetMult ) )
			else
				self.vCenterPos = hRandomEnemy:GetOrigin() + RandomVector( self.random_offset_max )
			end
		end

		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_tinker_polymorph_launch_thinker", { duration = -1 }, self.vCenterPos, self:GetCaster():GetTeamNumber(), false )
		if hThinker ~= nil then
			table.insert( self.Thinkers, hThinker )

			EmitSoundOn( "Boss_Tinker.Polymorph.Launch", self:GetCaster() )

			local info = 
			{
				Target = hThinker,
				Source = self:GetCaster(),
				--vSourceLoc = self:GetCaster():GetOrigin(),
				--vSourceLoc = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack2" ) ), 
				Ability = self,
				EffectName = "particles/creatures/boss_tinker/boss_tinker_polymorph_launch.vpcf",
				iMoveSpeed = self.projectile_speed,
				bDodgeable = false,
				bProvidesVision = false,
			}

			ProjectileManager:CreateTrackingProjectile( info )

			local vecToTarget = self.vCenterPos - self:GetCaster():GetAbsOrigin()
			local fDistance = vecToTarget:Length2D()
			local fTravelTime = fDistance / self.projectile_speed
			--print( 'TRAVEL TIME FOR BLOB LAUNCH = ' .. fTravelTime )

			local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( self.vCenterPos, self:GetCaster() ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.land_radius, 2, 1 ) )
			ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 200, 30, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

		self.fNextLaunchTime = GameRules:GetGameTime() + self.launch_interval
	end
end

-----------------------------------------------------------------------------

function boss_tinker_polymorph:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		StopSoundOn( "Boss_Tinker.Polymorph.Cast", self:GetCaster() )
	end
end

-----------------------------------------------------------------------------------------

function boss_tinker_polymorph:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if not self:GetCaster() or self:GetCaster():IsNull() or self:GetCaster():IsAlive() == false then
			return true
		end

		if hTarget ~= nil then
			for i = 1, #self.Thinkers do
				local hThinker = self.Thinkers[ i ]
				if hThinker ~= nil and hThinker == hTarget then
					table.remove( self.Thinkers, i )
					UTIL_Remove( hThinker )
				end
			end

			EmitSoundOnLocationWithCaster( vLocation, "Boss_Tinker.Polymorph.Impact.Target", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/blob_launch_impact.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation );
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.land_radius, self.land_radius, self.land_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.land_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,hEnemy in pairs( enemies ) do
				if hEnemy ~= nil and hEnemy:IsNull() == false and hEnemy:IsAlive() == true and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
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

					hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_boss_tinker_polymorph", { duration = self.transform_duration } )
				end
			end
		else
			EmitSoundOnLocationWithCaster( vLocation, "Boss_Tinker.Polymorph.Impact.NoTarget", self:GetCaster() )
		end

		local TinkerAI = self:GetCaster().AI

		if TinkerAI and TinkerAI.KeenMinions and ( ( #TinkerAI.KeenMinions + 1 ) <= TinkerAI.nMaxKeenSpawns ) then
	 		local hKeenMinion = CreateUnitByName( "npc_dota_creature_keen_minion", vLocation, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	 		if hKeenMinion then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hKeenMinion )
				ParticleManager:SetParticleControl( nFXIndex, 0, hKeenMinion:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Boss_Tinker.March.SpawnMinion", hKeenMinion )

				table.insert( TinkerAI.KeenMinions, hKeenMinion )
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------
