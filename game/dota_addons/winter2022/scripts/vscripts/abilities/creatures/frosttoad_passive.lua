frosttoad_passive = class({})
 
--------------------------------------------------------------------------------

function frosttoad_passive:GetIntrinsicModifierName()
	return "modifier_mount_passive"
end

--------------------------------------------------------------------------------
function frosttoad_passive:GetMovementModifierName()
	return "modifier_mount_hop_movement"
end

--------------------------------------------------------------------------------
-- Events

--------------------------------------------------------------------------------
function frosttoad_passive:OnSummon()
	self.bHit = false
	self.bHitHero = false
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Frog.Ribbit", self:GetCaster() )
	self.nPreviewFX = ParticleManager:CreateParticle( "particles/units/mounts/mount_frosttoad_summon.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnDismount()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Dismount", self:GetCaster() )
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnDespawn()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Frog.Croak", self:GetCaster() )
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnMovementStart()
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnHopStart()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Frog.Hop", self:GetCaster() )
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnHopEnd()
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
function frosttoad_passive:OnMovementEnd()
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnImpact( hOtherUnit )
	if hOtherUnit:IsHero() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/mounts/mount_frosttoad_impact.vpcf", PATTACH_ABSORIGIN, hOtherUnit )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hOtherUnit, PATTACH_ABSORIGIN, nil, hOtherUnit:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	self.bHit = true
	self.bHitHero = self.bHitHero or hOtherUnit:IsHero()
end

--------------------------------------------------------------------------------
function frosttoad_passive:OnCrash( bHitTree )
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "SledPenguin.Crash.Impact", self:GetCaster() )
	if not bHitTree then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Frog.Croak", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Animations

--------------------------------------------------------------------------------
function frosttoad_passive:GetAnimation_Summon()
	return nil
end

--------------------------------------------------------------------------------
function frosttoad_passive:GetAnimation_Movement()
	return ACT_DOTA_CAST_ABILITY_1
end

--------------------------------------------------------------------------------
-- Misc

--------------------------------------------------------------------------------
function frosttoad_passive:GetRiderVerticalOffset()
	local flOffset = 50
	local hModifier = self:GetCaster():FindModifierByName("modifier_mount_hop_movement")
	if hModifier ~= nil then
		local flHopHeightScalar = 250
		local flArcHeightPct = hModifier.flArcHeightPct

		if hModifier.bGoingUp then
			-- HACKY: The animation of the frog arc isn't a true parabola. It goes up faster than down. So let's modify the hero arc in a similar way
			flArcHeightPct = math.min(1.0, flArcHeightPct * 1.25 + 0.3)
		end
		
		flOffset = flOffset + flArcHeightPct * flHopHeightScalar
	end
	return flOffset
end
