
require( "utility_functions" )
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

boss_tinker_mega_laser = class({})

LinkLuaModifier( "modifier_boss_tinker_laser_dummy", "modifiers/creatures/modifier_boss_tinker_laser_dummy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_tinker_laser_debuff", "modifiers/creatures/modifier_boss_tinker_laser_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:Precache( context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_laser_preview.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_sunray_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_mega_laser.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_laser_enemy.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_structure_channel_preview.vpcf", context )

	--PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_laser_secondary.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_beam_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/staff_beam_linger.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:OnAbilityPhaseStart()
	self.radius = self:GetSpecialValueFor( "radius" )
	self.distance_past_target = self:GetSpecialValueFor( "distance_past_target" )
	self.damage_interval = self:GetSpecialValueFor( "damage_interval" )
	self.nodes_to_use = self:GetSpecialValueFor( "nodes_to_use" )

	if IsServer() then
		local nNodesUsed = 0

		local nFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD

		local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(),
			self:GetCaster(), FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, nFlags, FIND_CLOSEST, false
		)

		self.TinkerStructures = {}

		self:GetCaster().hNearestStructure = nil

		for _, ally in pairs( allies ) do
			if ally ~= nil and ally:GetUnitName() == "npc_dota_boss_tinker_structure" then
				table.insert( self.TinkerStructures, ally )

				if self:GetCaster().hNearestStructure == nil then
					-- We used FIND_CLOSEST, so the first one is the nearest structure
					self:GetCaster().hNearestStructure = ally
				end
			end
		end

		if #self.TinkerStructures <= 0 then
			return
		end

		local hAvailableHeroTargets = {}

		local enemies = Util_FindEnemiesAroundUnit( self:GetCaster(), FIND_UNITS_EVERYWHERE, true )
		for _, enemy in pairs( enemies ) do
			if enemy and enemy:IsAlive() and enemy:IsRealHero() then
				table.insert( hAvailableHeroTargets, enemy )
			end
		end

		self.LaserSources = {}

		-- Tinker targets nearest structure
		self:SetupAndPreviewLaserBeamFromTo( self:GetCaster(), self:GetCaster().hNearestStructure )

		-- Some of the structures target one player each
		for _, structure in pairs( self.TinkerStructures ) do
			if nNodesUsed >= self.nodes_to_use then
				break
			end

			local nRandomIndex = RandomInt( 1, #hAvailableHeroTargets )
			local hRandomTarget = hAvailableHeroTargets[ nRandomIndex ]
			self:SetupAndPreviewLaserBeamFromTo( structure, hRandomTarget )

			nNodesUsed = nNodesUsed + 1

			-- If there are enough players for remaining beams, then remove target from list
			if #hAvailableHeroTargets > ( self.nodes_to_use - nNodesUsed ) then
				table.remove( hAvailableHeroTargets, nRandomIndex )
			end
		end

		EmitSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:OnAbilityPhaseInterrupted()
	if IsServer() then
		StopSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )

		ParticleManager:DestroyParticle( self.GetCaster().nPreviewFX, false )

		for _, hSource in pairs( self.LaserSources ) do
			ParticleManager:DestroyParticle( hSource.nPreviewFX, false )

			StopSoundOn( "Boss_Tinker.LaserCharge", hSource )
		end
	end
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:SetupAndPreviewLaserBeamFromTo( hSource, hTarget )
	if IsServer() then
		if hTarget == nil or hTarget:IsNull() then
			return
		end

		local fDistancePastTarget = self.distance_past_target
		local szAttachment = "attach_hitloc"
		local vStartPos = hSource:GetAbsOrigin()

		if hSource == self:GetCaster() then
			szAttachment = "attach_attack2"
			fDistancePastTarget = 0
			vStartPos = hSource:GetAttachmentOrigin( hSource:ScriptLookupAttachment( "attach_attack2" ) )
		else
			hSource.nPreviewOverheadFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_structure_channel_preview.vpcf", PATTACH_ABSORIGIN_FOLLOW, hSource )
		end

		hSource.target = hTarget

		local vTargetPos = hTarget:GetAbsOrigin()

		hSource.vDir = vTargetPos - vStartPos
		hSource.vDir.z = 0
		hSource.vDir = hSource.vDir:Normalized()

		hSource.vBeamEnd = vTargetPos + hSource.vDir * fDistancePastTarget

 		local hDummy = CreateUnitByName( "npc_dota_invisible_vision_source", hSource.vBeamEnd, true, hSource, hSource, hSource:GetTeamNumber() )
 		if hDummy then
			local fDuration = self:GetChannelTime()
			hDummy:AddNewModifier( hSource, self, "modifier_boss_tinker_laser_dummy", { duration = fDuration } )
 		end

 		DoScriptAssert( hDummy ~= nil, "hDummy not found" )

 		hSource.dummy = hDummy

		hSource.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_laser_preview.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( hSource.nPreviewFX, 0, hSource, PATTACH_POINT_FOLLOW, "attach_attack2", vStartPos, true )
		ParticleManager:SetParticleControlEnt( hSource.nPreviewFX, 1, hSource.hBeamEnd, PATTACH_ABSORIGIN_FOLLOW, nil, hSource.dummy:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( hSource.nPreviewFX, 2, hSource, PATTACH_ABSORIGIN_FOLLOW, nil, vStartPos, true )
		ParticleManager:SetParticleFoWProperties( hSource.nPreviewFX, 0, 1, self.radius * 1.5 )

		EmitSoundOn( "Boss_Tinker.LaserCharge", hSource )

		table.insert( self.LaserSources, hSource )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:OnSpellStart()
	self.damage_per_second = self:GetSpecialValueFor( "damage_per_second" )
	self.miss_duration = self:GetSpecialValueFor( "miss_duration" )

	if IsServer() then
		--StopSoundOn( "Boss_Tinker.LaserCharge", self:GetCaster() )

		--ParticleManager:DestroyParticle( self:GetCaster().nPreviewFX, false )

		for _, hSource in pairs( self.LaserSources ) do
			ParticleManager:DestroyParticle( hSource.nPreviewFX, false )

			StopSoundOn( "Boss_Tinker.LaserCharge", hSource )
		end

		-- Tinker targets nearest structure
		--self:CreateLaserBeamFromTo( self:GetCaster(), self:GetCaster().hNearestStructure )

		-- The ents that were put in LaserSources make their real laser beam
		-- This includes Tinker himself, though he has some behavioral differences in the funcs
		for _, hSource in pairs( self.LaserSources ) do
			if hSource.target ~= nil then
				self:CreateLaserBeamFromTo( hSource, hSource.target )
			end
		end

		EmitSoundOnLocationWithCaster( self:GetCaster():GetCursorPosition(), "Boss_Tinker.Laser.Loop", self:GetCaster() )

		self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 )

		self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
	end
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:CreateLaserBeamFromTo( hSource, hTarget )
	if IsServer() then
		if hTarget == nil or hTarget:IsNull() then
			return
		end

		if hSource.dummy == nil or hSource.dummy:IsNull() then
			printf( "ERROR - boss_tinker_mega_laser:CreateLaserBeamFromTo: hSource.dummy is nil" )
			return
		end

		local szAttachment = "attach_hitloc"
		local vStartPos = hSource:GetAbsOrigin()

		if hSource == self:GetCaster() then
			szAttachment = "attach_attack2"
			vStartPos = hSource:GetAttachmentOrigin( hSource:ScriptLookupAttachment( "attach_attack2" ) )
		end

		-- Calculate this after cast point completes because our attach_attack2 moves a lot during
		-- cast point. This all relies heavily on how precise our castpoint and playback rate are in
		-- terms of the attach_attack2's position when the spell actually starts.
		hSource.nBeamRange = ( hSource.vBeamEnd - vStartPos ):Length2D()
		local nExtraBitAtEnd = self.radius * 0.3
		hSource.nBeamRange = hSource.nBeamRange - self.radius + nExtraBitAtEnd

		EmitSoundOn( "Boss_Tinker.Laser", hSource )

		hSource.nBeamFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_mega_laser.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( hSource.nBeamFX, 0, hSource, PATTACH_POINT_FOLLOW, szAttachment, vStartPos, true )
		ParticleManager:SetParticleControlEnt( hSource.nBeamFX, 1, hSource.dummy, PATTACH_ABSORIGIN_FOLLOW, nil, hSource.dummy:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( hSource.nBeamFX, 2, hSource, PATTACH_ABSORIGIN_FOLLOW, nil, vStartPos, true )
		ParticleManager:SetParticleFoWProperties( hSource.nBeamFX, 0, 1, self.radius * 1.5 )
		ParticleManager:SetParticleControlEnt( hSource.nBeamFX, 9, hSource, PATTACH_POINT_FOLLOW, "attach_hitloc", vStartPos, true )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_mega_laser:OnChannelThink( flInterval )
	if IsServer() then
		if self.fNextBurnTime ~= nil and GameRules:GetGameTime() >= self.fNextBurnTime then
			local hHitEnemies = {} -- use this to avoid hitting same enemy more than once on this frame

			for _, hSource in pairs ( self.LaserSources ) do
				if hSource ~= nil and hSource:IsNull() == false and hSource.target ~= nil then
					local nDiameter = self.radius * 2

					for fDist = 0, hSource.nBeamRange do
						local vPos = hSource:GetAbsOrigin() + ( hSource.vDir * fDist )
						local enemies = FindUnitsInRadius( hSource:GetTeamNumber(), vPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false )
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
				end
			end

			self.fNextBurnTime = GameRules:GetGameTime() + self.damage_interval
		end
	end
end

-------------------------------------------------------------------------------

function boss_tinker_mega_laser:OnChannelFinish( bInterrupted )
	if IsServer() then
		--StopSoundOn( "Boss_Tinker.Laser", self:GetCaster() )

		--ParticleManager:DestroyParticle( self:GetCaster().nBeamFX, false )

		for _, hSource in pairs( self.LaserSources ) do
			if hSource.nPreviewOverheadFX ~= nil then
				ParticleManager:DestroyParticle( hSource.nPreviewOverheadFX, false )
			end

			ParticleManager:DestroyParticle( hSource.nBeamFX, false )

			StopSoundOn( "Boss_Tinker.Laser", hSource )
		end

		self:GetCaster():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )

		--StopSoundOn( "Boss_Tinker.Laser.Loop", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
