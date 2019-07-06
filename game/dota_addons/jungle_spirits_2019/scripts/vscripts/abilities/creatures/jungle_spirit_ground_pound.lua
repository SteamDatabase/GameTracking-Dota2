
jungle_spirit_ground_pound = class({})
LinkLuaModifier( "modifier_jungle_spirit_ground_pound_thinker", "modifiers/creatures/modifier_jungle_spirit_ground_pound_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:OnAbilityPhaseStart()
	if IsServer() then
		local hArm = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )
		local vArmPos = self:GetCaster():GetAttachmentOrigin( hArm )
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, vArmPos )
	end

	return true
end

-----------------------------------------------------------------------

function jungle_spirit_ground_pound:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.fChannelTime = 0.0

		local hArm = self:GetCaster():ScriptLookupAttachment( "attach_attack1" )
		local vArmPos = self:GetCaster():GetAttachmentOrigin( hArm )
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_jungle_spirit_ground_pound_thinker", { duration = self:GetChannelTime() }, vArmPos, self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:OnChannelThink( flInterval )
	if IsServer() then
		self.fChannelTime = self.fChannelTime + flInterval
		if self.fChannelTime > 9.2 and self.bStartedGesture ~= true then
			self.bStartedGesture = true
			self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2_END )
		end
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_ground_pound:OnChannelFinish( bInterrpted )
	if IsServer() then
		if self.hThinker ~= nil and self.hThinker:IsNull() == false then
			self.hThinker:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------
