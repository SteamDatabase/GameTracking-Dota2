
storegga_avalanche = class({})
LinkLuaModifier( "modifier_storegga_avalanche_thinker", "modifiers/creatures/modifier_storegga_avalanche_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function storegga_avalanche:Precache( context )

	PrecacheResource( "particle", "particles/act_2/storegga_channel.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/storegga/storegga_avalanche.vpcf", context )

end

-----------------------------------------------------------------------

function storegga_avalanche:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_avalanche:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function storegga_avalanche:GetPlaybackRateOverride()
	return 1
end

--------------------------------------------------------------------------------

function storegga_avalanche:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end

	return true
end

-----------------------------------------------------------------------

function storegga_avalanche:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-----------------------------------------------------------------------

function storegga_avalanche:OnSpellStart()
	if IsServer() then
		self.flChannelTime = 0.0
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_storegga_avalanche_thinker", { duration = self:GetChannelTime() }, self:GetCaster():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------

function storegga_avalanche:OnChannelThink( flInterval )
	if IsServer() then
		self.flChannelTime = self.flChannelTime + flInterval
		if self.flChannelTime > 9.2 and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2_END )
		end
	end
end

-----------------------------------------------------------------------

function storegga_avalanche:OnChannelFinish( bInterrpted )
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
		end

	end
end
