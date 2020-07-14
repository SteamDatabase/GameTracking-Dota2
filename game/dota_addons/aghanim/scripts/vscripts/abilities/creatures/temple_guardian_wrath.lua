
require( "utility_functions" )

temple_guardian_wrath = class({})
LinkLuaModifier( "modifier_temple_guardian_wrath_thinker", "modifiers/creatures/modifier_temple_guardian_wrath_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_guardian_immunity", "modifiers/creatures/modifier_temple_guardian_immunity", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function temple_guardian_wrath:Precache( context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_wings_buff.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_guardian_angel.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast.vpcf", context )

	self.nNumCasts = 0
end

--------------------------------------------------------------------------------

function temple_guardian_wrath:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

--------------------------------------------------------------------------------

function temple_guardian_wrath:OnAbilityPhaseStart()
	if IsServer() and IsGlobalAscensionCaster( self:GetCaster() ) == false then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function temple_guardian_wrath:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end
	end 
end

-----------------------------------------------------------------------------

function temple_guardian_wrath:OnSpellStart()
	if IsServer() then
		if self.nPreviewFX ~= nil then	
			ParticleManager:DestroyParticle( self.nPreviewFX, false )
		end

		self.effect_radius = self:GetSpecialValueFor( "effect_radius" )
		self.interval = self:GetSpecialValueFor( "interval" )
		self.flNextCast = 0.0

		EmitSoundOn( "TempleGuardian.Wrath.Cast", self:GetCaster() )

		if IsGlobalAscensionCaster( self:GetCaster() ) == false then
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )
		end
	end
end

-----------------------------------------------------------------------------

function temple_guardian_wrath:OnChannelThink( flInterval )
	if IsServer() then

		self.flNextCast = self.flNextCast + flInterval
		if self.flNextCast >= self.interval  then

			-- Try not to overlap wrath_thinker locations, but use the last position attempted if we spend too long in the loop
			local nMaxAttempts = 14
			local nAttempts = 0
			local vPos = nil

			repeat
				vPos = self:GetCaster():GetOrigin() + RandomVector( RandomInt( 50, self.effect_radius ) )
				vPos.z = GetGroundHeight( vPos, self:GetCaster() )
				local hThinkersNearby = Entities:FindAllByClassnameWithin( "npc_dota_thinker", vPos, 600 )
				local hOverlappingWrathThinkers = {}

				for _, hThinker in pairs( hThinkersNearby ) do
					if ( hThinker:HasModifier( "modifier_temple_guardian_wrath_thinker" ) ) then
						table.insert( hOverlappingWrathThinkers, hThinker )
					end
				end

				nAttempts = nAttempts + 1
				if nAttempts >= nMaxAttempts then
					break
				end
			until ( #hOverlappingWrathThinkers == 0 )

			local kv =
			{
				extra_radius = 0
			}
			if IsGlobalAscensionCaster( self:GetCaster() ) == false then
				kv.extra_radius = self.nNumCasts * 40
			end
			CreateModifierThinker( self:GetCaster(), self, "modifier_temple_guardian_wrath_thinker", kv, vPos, self:GetCaster():GetTeamNumber(), false )
			self.flNextCast = self.flNextCast - self.interval
		end
		
	end
end

-----------------------------------------------------------------------------

function temple_guardian_wrath:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
		self.nNumCasts = self.nNumCasts + 1
	end
end

-----------------------------------------------------------------------------

ascension_temple_guardian_wrath = temple_guardian_wrath
