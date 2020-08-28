
aghanim_staff_beams = class({})

LinkLuaModifier( "modifier_aghanim_staff_beams_thinker", "modifiers/creatures/modifier_aghanim_staff_beams_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_staff_beams_linger_thinker", "modifiers/creatures/modifier_aghanim_staff_beams_linger_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_staff_beams_debuff", "modifiers/creatures/modifier_aghanim_staff_beams_debuff", LUA_MODIFIER_MOTION_NONE )


----------------------------------------------------------------------------------------

function aghanim_staff_beams:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_linger.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_tgt_ring.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_debug_ring.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
end

--------------------------------------------------------------------------------

function aghanim_staff_beams:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghanim_staff_beams:OnAbilityPhaseStart()
	if IsServer() then
		StartSoundEventFromPositionReliable( "Aghanim.StaffBeams.WindUp", self:GetCaster():GetAbsOrigin() )
		self.nChannelFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_beam_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		self.vecTargets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )
		for k,enemy in pairs ( self.vecTargets ) do
			if enemy ~= nil then
				enemy.nWarningFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_debug_ring.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControl( enemy.nWarningFXIndex, 0, enemy:GetAbsOrigin() )
				enemy.vSourceLoc = enemy:GetAbsOrigin()
			end
		end
	end
	return true
end

--------------------------------------------------------------------------------

function aghanim_staff_beams:OnSpellStart()
	if IsServer() then
		--EmitSoundOn( "Aghanim.ShardAttack.Channel", self:GetCaster() )
		EmitSoundOn( "Hero_Phoenix.SunRay.Cast", self:GetCaster() )
		EmitSoundOn( "Hero_Phoenix.SunRay.Loop", self:GetCaster() )

		self.Projectiles = {}

		for k,enemy in pairs ( self.vecTargets ) do
			if enemy ~= nil then
				local hBeamThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_aghanim_staff_beams_thinker", { duration = self:GetChannelTime() }, enemy.vSourceLoc, self:GetCaster():GetTeamNumber(), false )
				ParticleManager:DestroyParticle( enemy.nWarningFXIndex, false )
				local projectile =
				{
					Target = enemy,
					Source = hBeamThinker,
					Ability = self,
					EffectName = "",
					iMoveSpeed = self:GetSpecialValueFor( "beam_speed" ),
					vSourceLoc = enemy.vSourceLoc,
					bDodgeable = false,
					bProvidesVision = false,
					flExpireTime = GameRules:GetGameTime() + self:GetChannelTime(),
					bIgnoreObstructions = true,
					bSuppressTargetCheck = true,
				}

				projectile.hThinker = hBeamThinker

				local nProjectileHandle = ProjectileManager:CreateTrackingProjectile( projectile )
				projectile.nProjectileHandle = nProjectileHandle

				local nBeamFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/staff_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
				ParticleManager:SetParticleControlEnt( nBeamFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff_fx", self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControlEnt( nBeamFXIndex, 1, projectile.hThinker, PATTACH_ABSORIGIN_FOLLOW, nil, projectile.hThinker:GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( nBeamFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, projectile.hThinker:GetOrigin(), true )
				ParticleManager:SetParticleControlEnt( nBeamFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
				projectile.nFXIndex = nBeamFXIndex

				table.insert( self.Projectiles, projectile )
			end
		end
		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_aghanim_staff_beams", kv )
	end
end

-------------------------------------------------------------------------------

function aghanim_staff_beams:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() then
		local Projectile = nil
		for k,v in pairs( self.Projectiles ) do
			if v.nProjectileHandle == nProjectileHandle then
				Projectile = v 
				break
			end
		end

		if Projectile == nil then
			return
		end

		local vLocation = ProjectileManager:GetTrackingProjectileLocation( nProjectileHandle )
		if Projectile.hThinker ~= nil and not Projectile.hThinker:IsNull() then
			vLocation = GetGroundPosition( vLocation, Projectile.hThinker )
			Projectile.hThinker:SetOrigin( vLocation )

			ParticleManager:SetParticleControlFallback( Projectile.nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
			ParticleManager:SetParticleControlFallback( Projectile.nFXIndex, 1, vLocation )
			ParticleManager:SetParticleControlFallback( Projectile.nFXIndex, 9, self:GetCaster():GetAbsOrigin() )
		end
	end
end

-------------------------------------------------------------------------------

function aghanim_staff_beams:OnChannelThink( flInterval )
	if IsServer() then
	end
end

-------------------------------------------------------------------------------

function aghanim_staff_beams:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		StopSoundOn( "Hero_Phoenix.SunRay.Cast", self:GetCaster() )
		StopSoundOn( "Hero_Phoenix.SunRay.Loop", self:GetCaster() )
		EmitSoundOn( "Hero_Phoenix.SunRay.Stop", self:GetCaster() )

		for _,v in pairs ( self.Projectiles ) do
			ParticleManager:DestroyParticle( v.nFXIndex, false )
			if v.hThinker and v.hThinker:IsNull() == false then
				UTIL_Remove( v.hThinker )
			end
		end
		--self:GetCaster():RemoveModifierByName( "modifier_aghanim_staff_beams" )
	end
end