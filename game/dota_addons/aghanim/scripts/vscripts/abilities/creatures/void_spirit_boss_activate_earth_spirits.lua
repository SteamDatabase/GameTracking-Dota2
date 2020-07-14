
require( "utility_functions" )

void_spirit_boss_activate_earth_spirits = class({})
LinkLuaModifier( "modifier_void_spirit_boss_immunity", "modifiers/creatures/modifier_void_spirit_boss_immunity", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_guardian_angel.vpcf", context )

	self.nNumCasts = 0
end

--------------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

--------------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:OnAbilityPhaseStart()
	if IsServer() and IsGlobalAscensionCaster( self:GetCaster() ) == false then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_void_spirit_boss_immunity", { duration = fImmuneDuration } )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end
	end 
end

-----------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:OnSpellStart()
	if IsServer() then
		--printf( "void_spirit_boss_activate_earth_spirits:OnSpellStart" )

		if self.nPreviewFX ~= nil then	
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end

		self.flNextCast = 0.0

		--EmitSoundOn( "TempleGuardian.Wrath.Cast", self:GetCaster() )

		if IsGlobalAscensionCaster( self:GetCaster() ) == false then
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )
		end

		--[[
		local nFlags = DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
		self.hEarthSpiritStatues = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, nFlags, FIND_CLOSEST, false )
		--printf( "self.hEarthSpiritStatues:" )
		--PrintTable( self.hEarthSpiritStatues, " -- " )
		printf( "#self.hEarthSpiritStatues == %d", #self.hEarthSpiritStatues )
		]]
		local hEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()
		local hEarthSpirits = hEncounter.hEarthSpirits
		local kv = { duration = -1 }
		for _, hEarthSpirit in pairs( hEarthSpirits ) do
			if hEarthSpirit ~= nil and hEarthSpirit:IsNull() == false then
				--printf( "OnSpellStart - found an earth spirit, removing stoneform" )
				hEarthSpirit:RemoveModifierByName( "modifier_earth_spirit_statue_stoneform" )
			end
		end
	end
end

-----------------------------------------------------------------------------

function void_spirit_boss_activate_earth_spirits:OnChannelFinish( bInterrupted )
	if IsServer() then
		--printf( "void_spirit_boss_activate_earth_spirits:OnChannelFinish" )

		self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )

		local hEncounter = GameRules.Aghanim:GetCurrentRoom():GetEncounter()
		local hEarthSpirits = hEncounter.hEarthSpirits
		local kv = { duration = -1 }
		for _, hEarthSpirit in pairs ( hEarthSpirits ) do
			if hEarthSpirit ~= nil and hEarthSpirit:IsNull() == false and hEarthSpirit:IsAlive() then
				--printf( "OnChannelFinish - found an earth spirit, adding stoneform" )
				hEarthSpirit:AddNewModifier( hEarthSpirit, hEarthSpirit, "modifier_earth_spirit_statue_stoneform", kv )
			end
		end

		self.nNumCasts = self.nNumCasts + 1
	end
end

-----------------------------------------------------------------------------

--ascension_void_spirit_boss_activate_earth_spirits = void_spirit_boss_activate_earth_spirits
