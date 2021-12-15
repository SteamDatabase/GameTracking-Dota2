
require( "utility_functions" )
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

boss_tinker_laser = class({})

--LinkLuaModifier( "modifier_boss_tinker_laser", "modifiers/creatures/modifier_boss_tinker_laser", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_laser_dummy", "modifiers/creatures/modifier_boss_tinker_laser_dummy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_laser_debuff", "modifiers/creatures/modifier_boss_tinker_laser_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_laser:Precache( context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_laser_preview.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_laser.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_laser_enemy.vpcf", context )

	--PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_laser_secondary.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_linger.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_tinker_laser:OnAbilityPhaseStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.distance_past_target = self:GetSpecialValueFor( "distance_past_target" )
	self.damage_interval = self:GetSpecialValueFor( "damage_interval" )

	if IsServer() then
		EmitSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )

		local vTargetPos = self:GetCursorPosition()

		local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack2" ) )

		self.vDir = vTargetPos - vAttachmentSourcePos
		self.vDir.z = 0
		self.vDir = self.vDir:Normalized()

		self.vBeamEnd = vTargetPos + self.vDir * self.distance_past_target

 		local hDummy = CreateUnitByName( "npc_dota_invisible_vision_source", self.vBeamEnd, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
 		if hDummy then
			local fDuration = self:GetChannelTime()
			hDummy:AddNewModifier( self:GetCaster(), self, "modifier_boss_tinker_laser_dummy", { duration = fDuration } )

			self.hBeamEnd = hDummy
 		end

 		DoScriptAssert( hDummy ~= nil, "hDummy not found" )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_laser_preview.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", vAttachmentSourcePos, true )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 1, self.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeamEnd:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, vAttachmentSourcePos, true )
		ParticleManager:SetParticleFoWProperties( self.nPreviewFX, 0, 1, self.radius * 1.5 )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_tinker_laser:OnAbilityPhaseInterrupted()
	if IsServer() then
		StopSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_laser:OnSpellStart()
	self.damage_per_second = self:GetSpecialValueFor( "damage_per_second" )
	self.miss_duration = self:GetSpecialValueFor( "miss_duration" )

	if IsServer() then
		-- Calculate this after cast point completes because our attach_attack2 moves a lot during
		-- cast point. This all relies heavily on how precise our castpoint and playback rate are in
		-- terms of the attach_attack2's position when the spell actually starts.
		local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack2" ) )
		self.nBeamRange = ( self.vBeamEnd - vAttachmentSourcePos ):Length2D()
		local nExtraBitAtEnd = self.radius * 0.3
		self.nBeamRange = self.nBeamRange - self.radius + nExtraBitAtEnd

		StopSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )
		EmitSoundOn( "Boss_Tinker.Laser", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.nBeamFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 1, self.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, self.hBeamEnd:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 2, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleFoWProperties( self.nBeamFX, 0, 1, self.radius * 1.5 )
		ParticleManager:SetParticleControlEnt( self.nBeamFX, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )

		EmitSoundOnLocationWithCaster( self:GetCaster():GetCursorPosition(), "Boss_Tinker.Laser.Loop", self:GetCaster() )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 )

		self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
	end
end

--------------------------------------------------------------------------------

function boss_tinker_laser:OnChannelThink( flInterval )
	if IsServer() then
		if self.fNextBurnTime ~= nil and GameRules:GetGameTime() >= self.fNextBurnTime then
			local hHitEnemies = {} -- use this to avoid hitting same enemy more than once on this frame

			local nDiameter = self.radius * 2
			local vAttachmentSourcePos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack2" ) )
			--printf( "vAttachmentSourcePos: %s", vAttachmentSourcePos )

			for fDist = 0, self.nBeamRange do
				local vPos = vAttachmentSourcePos + ( self.vDir * fDist )
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false )
				for _, enemy in pairs( enemies ) do
					if enemy and enemy:IsAlive() and not TableContainsValue( hHitEnemies, enemy ) then
						if enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
							table.insert( hHitEnemies, enemy )
						end
					end
				end

				fDist = fDist + nDiameter
			end

			for _, hitEnemy in pairs( hHitEnemies ) do
				local fDamage = self.damage_per_second * self.damage_interval

				local damage =
				{
					victim = hitEnemy,
					attacker = self:GetCaster(),
					damage = fDamage,
					damage_type = self:GetAbilityDamageType(),
					ability = self,
				}
				ApplyDamage( damage )

				local kv_debuff =
				{
					duration = self.miss_duration,
				}
				hitEnemy:AddNewModifier( self:GetCaster(), self, "modifier_boss_tinker_laser_debuff", kv_debuff )

				local nDamageFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_laser_enemy.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nDamageFX, 1, hitEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hitEnemy:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nDamageFX )
			end

			self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
		end
	end
end

-------------------------------------------------------------------------------

function boss_tinker_laser:OnChannelFinish( bInterrupted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nBeamFX, false )

		self:GetCaster():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )

		--StopSoundOn( "Boss_Tinker.Laser.Loop", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
