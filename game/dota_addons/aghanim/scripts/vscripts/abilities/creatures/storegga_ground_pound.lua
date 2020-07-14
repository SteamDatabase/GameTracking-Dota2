
storegga_ground_pound = class({})
LinkLuaModifier( "modifier_storegga_ground_pound_thinker", "modifiers/creatures/modifier_storegga_ground_pound_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function storegga_ground_pound:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_sand_king_channel.vpcf", context )
end

--------------------------------------------------------------------------------

function storegga_ground_pound:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function storegga_ground_pound:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function storegga_ground_pound:GetPlaybackRateOverride()
	if IsServer() then
		if self.fChannelTime == nil then
			return self.cast_point_playback_rate
		else
			return self.channel_playback_rate
		end
	end
end

--------------------------------------------------------------------------------

function storegga_ground_pound:OnAbilityPhaseStart()
	if IsServer() then
		self.cast_point_playback_rate = self:GetSpecialValueFor( "cast_point_playback_rate" )
		self.channel_playback_rate = self:GetSpecialValueFor( "channel_playback_rate" )

		local hArm = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )
		local vArmPos = self:GetCaster():GetAttachmentOrigin( hArm )
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/test_particle/dungeon_sand_king_channel.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, vArmPos )
	end

	return true
end

-----------------------------------------------------------------------

function storegga_ground_pound:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function storegga_ground_pound:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.fChannelTime = 0.0

		local hArm = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )
		local vArmPos = self:GetCaster():GetAttachmentOrigin( hArm )
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_storegga_ground_pound_thinker", { duration = self:GetChannelTime() }, vArmPos, self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------

function storegga_ground_pound:OnChannelThink( flInterval )
	if IsServer() then
		self.fChannelTime = self.fChannelTime + flInterval
		local fFirstAnimDuration = 2.2321 --2.5
		if self.fChannelTime > fFirstAnimDuration and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2_END )
		end
	end
end

--------------------------------------------------------------------------------

function storegga_ground_pound:OnChannelFinish( bInterrpted )
	if IsServer() then
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
		end

		self.fChannelTime = nil
	end
end

--------------------------------------------------------------------------------
