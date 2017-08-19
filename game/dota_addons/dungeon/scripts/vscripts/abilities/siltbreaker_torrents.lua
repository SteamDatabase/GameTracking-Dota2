
siltbreaker_torrents = class({})
LinkLuaModifier( "modifier_siltbreaker_torrents_thinker", "modifiers/modifier_siltbreaker_torrents_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_torrents:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

--[[
function siltbreaker_torrents:GetChannelAnimation()
	return ACT_DOTA_SWIM_IDLE
end
]]

--------------------------------------------------------------------------------

function siltbreaker_torrents:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )

		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		self:GetCaster().bInTorrents = true

		--self:GetCaster():StartGesture( ACT_DOTA_SWIM )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_torrents:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		self:GetCaster().bInTorrents = false

		--self:GetCaster():RemoveGesture( ACT_DOTA_SWIM )
	end 
end

--------------------------------------------------------------------------------

function siltbreaker_torrents:OnSpellStart()
	if IsServer() then
		--self:GetCaster():RemoveGesture( ACT_DOTA_SWIM )
		--self:GetCaster():StartGesture( ACT_DOTA_SWIM_IDLE )

		self.effect_radius = self:GetSpecialValueFor( "effect_radius" )
		self.interval = self:GetSpecialValueFor( "interval" )

		self.flNextCast = 0.0

	end
end

-----------------------------------------------------------------------------

function siltbreaker_torrents:OnChannelThink( flInterval )
	if IsServer() then
		self.flNextCast = self.flNextCast + flInterval
		if self.flNextCast >= self.interval  then

			-- Try not to overlap thinker locations, but use the last position attempted if we spend too long in the loop
			local nMaxAttempts = 10
			local nAttempts = 0
			local vPos = nil

			repeat
				vPos = self:GetCaster():GetOrigin() + RandomVector( RandomInt( 50, self.effect_radius ) )
				local hThinkersNearby = Entities:FindAllByClassnameWithin( "npc_dota_thinker", vPos, 550 )
				local hOverlappingThinkers = {}

				for _, hThinker in pairs( hThinkersNearby ) do
					if ( hThinker:HasModifier( "modifier_siltbreaker_torrents_thinker" ) ) then
						table.insert( hOverlappingThinkers, hThinker )
					end
				end
				nAttempts = nAttempts + 1
				if nAttempts >= nMaxAttempts then
					break
				end
			until ( #hOverlappingThinkers == 0 )

			CreateModifierThinker( self:GetCaster(), self, "modifier_siltbreaker_torrents_thinker", {}, vPos, self:GetCaster():GetTeamNumber(), false )
			self.flNextCast = self.flNextCast - self.interval
		end
		
	end
end

-----------------------------------------------------------------------------

function siltbreaker_torrents:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		self:GetCaster().bInTorrents = false

		--self:GetCaster():RemoveGesture( ACT_DOTA_SWIM_IDLE )
	end
end

-----------------------------------------------------------------------------

