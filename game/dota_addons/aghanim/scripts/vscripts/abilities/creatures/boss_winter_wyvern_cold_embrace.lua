boss_winter_wyvern_cold_embrace = class({})
-- Modifiers done in C++ now
--[[LinkLuaModifier( "modifier_boss_winter_wyvern_cold_embrace_debuff", "modifiers/creatures/modifier_boss_winter_wyvern_cold_embrace_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_winter_wyvern_cold_embrace_thinker", "modifiers/creatures/modifier_boss_winter_wyvern_cold_embrace_thinker", LUA_MODIFIER_MOTION_NONE )--]]

-------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_sand_king_channel.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/frostbitten_icicle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystal_maiden.vsndevts", context )
end

-------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/test_particle/dungeon_sand_king_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end
	return true
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.nChannelFX ~= nil then
			ParticleManager:DestroyParticle( self.nChannelFX, false )
		end
	end
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:GetPlaybackRateOverride()
	return 1
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:OnSpellStart()
	if IsServer() then
		self.flYaw = RandomInt( 0, 360 )
		self.nChains = 0
		self.num_chains_per_cast = self:GetSpecialValueFor( "num_chains_per_cast" )
		self.linger_duration = self:GetSpecialValueFor( "linger_duration" )
		
		self.initial_chain_count = self:GetSpecialValueFor( "initial_chain_count" )
		self.freeze_delay = self:GetSpecialValueFor( "freeze_delay" )
		self.flOffset = self:GetSpecialValueFor( "freeze_radius" ) * 1.5
		self.flChainInterval = self:GetChannelTime() / self.num_chains_per_cast

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_winter_wyvern_cold_embrace", { duration = self:GetChannelTime() } )

		self.vecThinkerPositions = {}
		self.vecThinkerPositions = self:CreateThinkerChain( self:GetCaster():GetAbsOrigin() )
		EmitSoundOn( "Hero_Winter_Wyvern.ColdEmbrace.Cast", self:GetCaster() )
		self.flNextChainTime = GameRules:GetGameTime() + self.flChainInterval
		self.nChains = self.nChains + 1
	end
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:OnChannelFinish( bInterrupted )
	if IsServer() then
		if self.nChannelFX ~= nil then
			ParticleManager:DestroyParticle( self.nChannelFX, false )
		end
	end
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:OnChannelThink( flInterval )
	if IsServer() then 
		if GameRules:GetGameTime() > self.flNextChainTime then 
			local vecPositions = deepcopy( self.vecThinkerPositions )
			self.vecThinkerPositions = {}

			for _,vPos in pairs ( vecPositions ) do 
				local vecNewPositions = self:CreateThinkerChain( vPos )
				for _,vNewPos in pairs( vecNewPositions ) do
					table.insert( self.vecThinkerPositions, vNewPos )
				end
			end

			for nPlayerID = 0, AGHANIM_PLAYERS - 1 do
				local hPlayerHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) 
				if hPlayerHero and hPlayerHero:IsAlive() and RandomInt( 0, 1 ) == 1 then 
					CreateModifierThinker( self:GetCaster(), self, "modifier_boss_winter_wyvern_cold_embrace_thinker", { duration = self.freeze_delay + 0.05 }, hPlayerHero:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
					table.insert( self.vecThinkerPositions, hPlayerHero:GetAbsOrigin() )
				end
			end

			EmitSoundOn( "Hero_Winter_Wyvern.ColdEmbrace.Cast", self:GetCaster() )
			self.flNextChainTime = GameRules:GetGameTime() + self.flChainInterval
			self.nChains = self.nChains + 1
		end
	end
end

--------------------------------------------------------------------------------

function boss_winter_wyvern_cold_embrace:CreateThinkerChain( vPos )
	local vecNewPositions = {}
	local flYaw = RandomInt( 0, 360 )
	local Angle = QAngle( 0, flYaw, 0 )
	local nThinkerCount = math.max( 1, self.initial_chain_count - self.nChains )
	if #self.vecThinkerPositions + nThinkerCount > 30 then 
		nThinkerCount = 1 
		print( "trying to create more than the maximal amount of chains, clamping" ) 
	end

	local flYawStep = 360 / nThinkerCount 
	local flOffset = self.flOffset

	local vCasterPos = self:GetCaster():GetAbsOrigin()

	for i = 1, nThinkerCount do 
		--print( self.nChains .. " chain count, yaw is: " ..  Angle.y )
		local vOffset = ( RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) ) ) * flOffset
		local vThinkerPos = vPos + vOffset 
		local flDistToCaster = ( vCasterPos - vThinkerPos ):Length2D()

		-- Rotate the chain until it's not within wyvern's immediate position
		if flDistToCaster < self.flOffset then 
			flYaw = flYaw - 180
			Angle = QAngle( 0, flYaw, 0 )
			vOffset = ( RotatePosition( Vector( 0, 0, 0 ), Angle, Vector( 1, 0, 0 ) ) ) * flOffset
			vThinkerPos = vPos + vOffset 
			flDistToCaster = ( vCasterPos - vThinkerPos ):Length2D()
		end

		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_winter_wyvern_cold_embrace_thinker", { duration = self.freeze_delay + self.linger_duration }, vThinkerPos, self:GetCaster():GetTeamNumber(), false )
		table.insert( vecNewPositions, vThinkerPos )

		flYaw = flYaw + flYawStep
		
		Angle = QAngle( 0, flYaw, 0 )
	end

	return vecNewPositions
end

--------------------------------------------------------------------------------