
siltbreaker_teleport = class({})
LinkLuaModifier( "modifier_siltbreaker_teleport_thinker", "modifiers/modifier_siltbreaker_teleport_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_guardian_immunity", "modifiers/modifier_temple_guardian_immunity", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_teleport:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_teleport:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_6
end

--------------------------------------------------------------------------------

function siltbreaker_teleport:OnAbilityPhaseStart()
	if IsServer() then
		local fImmuneDuration = self:GetCastPoint()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_teleport:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

-----------------------------------------------------------------------------

function siltbreaker_teleport:OnSpellStart()
	if IsServer() then	
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.delay = self:GetSpecialValueFor( "delay" )

		local vPos = self:GetCursorPosition()
		CreateModifierThinker( self:GetCaster(), self, "modifier_siltbreaker_teleport_thinker", { duration = self.delay }, vPos, self:GetCaster():GetTeamNumber(), false )

		EmitSoundOn( "Siltbreaker.Teleport.Channel", self:GetCaster() )
	end
end

-----------------------------------------------------------------------------

