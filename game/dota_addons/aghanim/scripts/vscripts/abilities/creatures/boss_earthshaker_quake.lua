
boss_earthshaker_quake = class({})

LinkLuaModifier( "modifier_boss_earthshaker_quake", "modifiers/creatures/modifier_boss_earthshaker_quake", LUA_MODIFIER_MOTION_BOTH )
--LinkLuaModifier( "modifier_temple_guardian_immunity", "modifiers/creatures/modifier_temple_guardian_immunity", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_earthshaker_quake:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/wyvern_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", context )

	self.nNumFullChannels = 0
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )

		--local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end
	end 
end

-----------------------------------------------------------------------------

function boss_earthshaker_quake:GetChannelTime()
	if IsServer() then
		local flChannelTime = self.BaseClass.GetChannelTime( self )


		return flChannelTime
	end

	return self.BaseClass.GetChannelTime( self )
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:OnSpellStart()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end

		--self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )

		EmitSoundOn( "Boss_Earthshaker.Quake.Cast", self:GetCaster() )

		self.blast_count = self:GetSpecialValueFor( "blast_count" )
		self.blast_count_add_per_ascension = self:GetSpecialValueFor( "blast_count_add_per_ascension" )
		self.blast_count_add_fully_enraged = self:GetSpecialValueFor( "blast_count_add_fully_enraged" )

		local nAscLevel = GameRules.Aghanim:GetAscensionLevel()
		self.blast_count = self.blast_count + ( self.blast_count_add_per_ascension * nAscLevel )

		if self:GetCaster().AI and self:GetCaster().AI.bFullyEnraged then
			self.blast_count = self.blast_count + self.blast_count_add_fully_enraged
		end

		self.mounds_to_burst_per_cluster = self:GetSpecialValueFor( "mounds_to_burst_per_cluster" )

		self.delay = self:GetSpecialValueFor( "delay" )
		self.extra_delay_per_blast = self:GetSpecialValueFor( "extra_delay_per_blast" )
		self.quake_cluster_interval_buffer = self:GetSpecialValueFor( "quake_cluster_interval_buffer" )

		self.min_random_offset = self:GetSpecialValueFor( "min_random_offset" )
		self.max_random_offset = self:GetSpecialValueFor( "max_random_offset" )
		self.backup_muddite_spawn_count = self:GetSpecialValueFor( "backup_muddite_spawn_count" )

		self.fQuakeClusterInterval = self.delay + ( self.blast_count * self.extra_delay_per_blast ) + self.quake_cluster_interval_buffer

		--printf( "self.delay: %.2f, self.blast_count: %d, self.extra_delay_per_blast: %.2f, self.quake_cluster_interval_buffer: %.2f", self.delay, self.blast_count, self.extra_delay_per_blast, self.quake_cluster_interval_buffer )

		-- Want to end our channel after two sets of quake clusters, but don't double count the buffer time between
		local fManualChannelDuration = ( 2 * ( self.delay + ( self.blast_count * self.extra_delay_per_blast ) ) ) + self.quake_cluster_interval_buffer
		self.fTimeToEndChannel = GameRules:GetGameTime() + fManualChannelDuration

		--printf( "gametime: %.2f, fManualChannelDuration: %.2f, self.fTimeToEndChannel: %.2f", GameRules:GetGameTime(), fManualChannelDuration, self.fTimeToEndChannel )

		self.flNextCast = 0.0
	end
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:OnChannelThink( flInterval )
	if IsServer() then
		if GameRules:GetGameTime() >= self.fTimeToEndChannel then
			self:EndChannel( false )
		end

		if GameRules:GetGameTime() < self.flNextCast then
			return
		end

		-- example numbers on asc 0:
		-- the first quake cluster happens at 0.0 and ends at 1.5 + 4*0.2 = 2.3
		-- the second cluster happens at 2.3 + 1.5 = 3.8
		-- channel time is set to end at 2.3 + 2.3 + 1.5 = 6.1

		self.flNextCast = GameRules:GetGameTime() + self.fQuakeClusterInterval

		local nSearchRadius = 10000

		-- Burst a few dirt mounds (nearest first)
		local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(),
				self:GetCaster(), nSearchRadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false
		)

		local nMoundsToBurst = self.mounds_to_burst_per_cluster
		local nMoundsBursted = 0

		for _, ally in pairs( allies ) do
			if ally ~= nil and ally:GetUnitName() == "npc_dota_earthshaker_dirt_mound" then
				local hBurstBuff = ally:FindModifierByName( "modifier_earthshaker_dirt_mound" )
				if hBurstBuff ~= nil then
					hBurstBuff:Burst()

					nMoundsBursted = nMoundsBursted + 1
				end
			end

			if nMoundsBursted >= nMoundsToBurst then
				break
			end
		end

		-- If we didn't burst any mounds nearby, then spawn muddites
		if nMoundsBursted == 0 then
			for i = 0, self.backup_muddite_spawn_count do
				local nMaxDistance = 25
				local vSpawnLoc = nil

				local nMaxAttempts = 3
				local nAttempts = 0

				repeat
					if nAttempts > nMaxAttempts then
						vSpawnLoc = nil
						printf( "WARNING - boss_earthshaker_quake:OnChannelThink - failed to find valid spawn loc for muddite" )
						break
					end

					local vPos = self:GetCaster():GetAbsOrigin() + RandomVector( nMaxDistance )
					vSpawnLoc = FindPathablePositionNearby( vPos, 0, 50 )
					nAttempts = nAttempts + 1
				until ( GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vSpawnLoc ) )

				if vSpawnLoc == nil then
					vSpawnLoc = self:GetCaster():GetOrigin()
				end

				if vSpawnLoc ~= nil then
					local hMinion = CreateUnitByName( "npc_dota_creature_earthshaker_minion", vSpawnLoc, true, nil, nil, DOTA_TEAM_BADGUYS )
					if hMinion ~= nil and hMinion:IsNull() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, hMinion )
						ParticleManager:SetParticleControl( nFXIndex, 0, hMinion:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( nFXIndex )
					end
				else
					printf( "WARNING - boss_earthshaker_quake:OnChannelThink - failed to spawn muddite" )
				end
			end
		end

		-- Get all the player heroes
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(),
				self:GetCaster(), nSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false
		)

		if #enemies <= 0 then
			return
		end

		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsRealHero() then
				for i = 1, self.blast_count do
					local vOffset = 0

					if i == 1 then
						-- leave vOffset unchanged for first quake
					elseif i == 2 then
						vOffset = enemy:GetForwardVector() * 300
					else
						vOffset = RandomVector( RandomFloat( self.min_random_offset, self.max_random_offset ) )
					end

					local vPos = enemy:GetOrigin() + vOffset

					local fStartDelay = self.extra_delay_per_blast * i
					local fDelay = self.delay + fStartDelay
					local kv = {
						duration = fDelay,
						num_full_channels = self.nNumFullChannels,
						start_delay = fStartDelay,
					}
					CreateModifierThinker( self:GetCaster(), self, "modifier_boss_earthshaker_quake", kv, vPos, self:GetCaster():GetTeamNumber(), false )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function boss_earthshaker_quake:OnChannelFinish( bInterrupted )
	if IsServer() then
		--self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
		--self:GetCaster():RemoveModifierByName( "modifier_temple_guardian_immunity" )

		self.nNumFullChannels = self.nNumFullChannels + 1
	end
end

--------------------------------------------------------------------------------
