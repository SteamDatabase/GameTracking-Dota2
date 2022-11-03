
penguin_passive = class({})

--------------------------------------------------------------------------------
function penguin_passive:GetIntrinsicModifierName()
	return "modifier_mount_passive"
end

--------------------------------------------------------------------------------
function penguin_passive:GetMovementModifierName()
	return "modifier_mount_movement"
end

--------------------------------------------------------------------------------
-- Events

--------------------------------------------------------------------------------
function penguin_passive:OnSummon()
	self.bHit = false
	self.bHitHero = false
	self.flMoveSoundTimer = GameRules:GetDOTATime(false, true) + RandomFloat(5, 10)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.IceShards.Penguin", self:GetCaster() )
	
	-- Play FX here
	
	self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/mount_summon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )

	-- Kinda hacky. This isn't the usual ACT_DOTA_SUMMON so it gets overridden by the movement anim. We delay starting the movement anim to avoid this issue
	self:GetCaster():StartGesture(ACT_DOTA_SLIDE)
	self.flAnimDelay = GameRules:GetDOTATime(false, true) + 3.8
	self.bPlayingMovementAnim = false
end

--------------------------------------------------------------------------------
function penguin_passive:OnDismount()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Dismount", self:GetCaster() )
end

--------------------------------------------------------------------------------
function penguin_passive:OnDespawn()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.IceShards.Penguin", self:GetCaster() )
	self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/mount_summon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
end

--------------------------------------------------------------------------------
function penguin_passive:OnMovementStart()
end

--------------------------------------------------------------------------------
function penguin_passive:OnMaxSpeed()
	self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/mount_max_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
end

--------------------------------------------------------------------------------
function penguin_passive:OnMovementThink()
	if self.bPlayingMovementAnim ~= true then
		if GameRules:GetDOTATime(false, true) >= self.flAnimDelay then
			self:GetCaster():StartGesture(ACT_DOTA_SLIDE_LOOP)
			self.bPlayingMovementAnim = true
		end
	end

	-- Hit Sounds
	if self.bHitHero then
		EmitSoundOn("Mount.Impact_Hero", self:GetCaster() )
	elseif self.bHit then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Impact_Creep", self:GetCaster() )
	end

	-- Movement Sounds
	-- TODO: Play on Order instead
	if self.bHit then
		if GameRules:GetDOTATime(false, true) >= self.flMoveSoundTimer then
			EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.IceShards.Penguin", self:GetCaster() )
			self.flMoveSoundTimer = GameRules:GetDOTATime(false, true) + RandomFloat(5, 10)
		end
	end

	self.bHit = false
	self.bHitHero = false
end

--------------------------------------------------------------------------------
function penguin_passive:OnMovementEnd()
end

--------------------------------------------------------------------------------
function penguin_passive:OnImpact( hOtherUnit )
	if hOtherUnit:IsHero() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/mounts/mount_penguin_impact.vpcf", PATTACH_ABSORIGIN, hOtherUnit )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hOtherUnit, PATTACH_ABSORIGIN, nil, hOtherUnit:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	self.bHit = true
	self.bHitHero = self.bHitHero or hOtherUnit:IsHero()
end

--------------------------------------------------------------------------------
function penguin_passive:OnCrash( bHitTree )
	-- HACK: SLIDE_LOOP overrides the crash anim if it is left playing, so we restart it here instead. It will continue playing after crash anim
	self:GetCaster():RemoveGesture(ACT_DOTA_SLIDE_LOOP)
	self:GetCaster():StartGesture(ACT_DOTA_SLIDE_LOOP)
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	self.bPlayingMovementAnim = true
	
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "SledPenguin.Crash.Impact", self:GetCaster() )
	if not bHitTree then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "SledPenguin.Crash.Ow", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Animations

--------------------------------------------------------------------------------
function penguin_passive:GetAnimation_Summon()
	return nil
end

--------------------------------------------------------------------------------
function penguin_passive:GetAnimation_Movement()
	return nil
end

--------------------------------------------------------------------------------
-- Misc

--------------------------------------------------------------------------------
function penguin_passive:GetRiderVerticalOffset()
	return 40
end