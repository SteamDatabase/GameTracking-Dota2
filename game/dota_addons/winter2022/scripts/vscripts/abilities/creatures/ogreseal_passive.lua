ogreseal_passive = class({})
 
--------------------------------------------------------------------------------

function ogreseal_passive:GetIntrinsicModifierName()
	return "modifier_mount_passive"
end

--------------------------------------------------------------------------------
function ogreseal_passive:GetMovementModifierName()
	return "modifier_mount_hop_movement"
end

--------------------------------------------------------------------------------
-- Events

--------------------------------------------------------------------------------
function ogreseal_passive:OnSummon()
	self.bHit = false
	self.bHitHero = false
	self.nSoundCounter = RandomInt(1,5)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "OgreTank.Grunt", self:GetCaster() )
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnDismount()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Dismount", self:GetCaster() )
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnDespawn()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "OgreTank.Grunt", self:GetCaster() )
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnMovementStart()
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnHopStart()
	self.nSoundCounter = self.nSoundCounter - 1
	if self.nSoundCounter <= 0 then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "OgreTank.Grunt", self:GetCaster() )
		self.nSoundCounter = RandomInt(2,5)
	end
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnHopEnd()
	-- Hit Sounds
	if self.bHitHero then
		EmitSoundOn("Mount.Impact_Hero", self:GetCaster() )
	elseif self.bHit then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Impact_Creep", self:GetCaster() )
	end

	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Land", self:GetCaster() )

	self.bHit = false
	self.bHitHero = false
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnMovementEnd()
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnImpact( hOtherUnit )
	if hOtherUnit:IsHero() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/mounts/mount_ogreseal_impact.vpcf", PATTACH_ABSORIGIN, hOtherUnit )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hOtherUnit, PATTACH_ABSORIGIN, nil, hOtherUnit:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	self.bHit = true
	self.bHitHero = self.bHitHero or hOtherUnit:IsHero()
end

--------------------------------------------------------------------------------
function ogreseal_passive:OnCrash( bHitTree )
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(),"SledPenguin.Crash.Impact", self:GetCaster() )
	if not bHitTree then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "OgreTank.Grunt", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Animations

--------------------------------------------------------------------------------
function ogreseal_passive:GetAnimation_Summon()
	return nil
end

--------------------------------------------------------------------------------
function ogreseal_passive:GetAnimation_Movement()
	return ACT_DOTA_RUN
end

--------------------------------------------------------------------------------
-- Misc

--------------------------------------------------------------------------------
function ogreseal_passive:GetRiderVerticalOffset()
	return 50
end
