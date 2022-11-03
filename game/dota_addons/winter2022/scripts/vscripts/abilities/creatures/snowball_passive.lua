
snowball_passive = class({})
 
--------------------------------------------------------------------------------

function snowball_passive:GetIntrinsicModifierName()
	return "modifier_mount_passive"
end

--------------------------------------------------------------------------------
function snowball_passive:GetMovementModifierName()
	return "modifier_mount_movement"
end

--------------------------------------------------------------------------------
-- Events

--------------------------------------------------------------------------------
function snowball_passive:OnSummon()
	self.bHit = false
	self.bHitHero = false
	self.flMoveSoundTimer = GameRules:GetDOTATime(false, true) + RandomFloat(5, 10)

	local hHero = self:GetCaster():GetOwnerEntity()
	local flStunDuration = self:GetSpecialValueFor("stun_duration")
	local nStunRadius = self:GetSpecialValueFor("stun_radius")
	local nDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage_per_level") * hHero:GetLevel()

	local nTargetType = DOTA_UNIT_TARGET_HERO
	local nTargetFlags = DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local hStunUnits = FindUnitsInRadius( hHero:GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), nStunRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, nTargetType, nTargetFlags, 0, false )
	for _, hUnit in pairs( hStunUnits ) do
		hUnit:AddNewModifier( hHero, self, "modifier_stunned", { duration = flStunDuration } )

		local DamageInfo =
		{
			victim = hUnit,
			attacker = self:GetCaster(),
			ability = self,
			damage = nDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		local nDamageDealt = ApplyDamage( DamageInfo )
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/snowball_summon_aoe_snow.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( nStunRadius, nStunRadius, nStunRadius ) )
	ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_ABSORIGIN, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.Snowball.Ally", self:GetCaster() )
end

--------------------------------------------------------------------------------
function snowball_passive:OnDismount()
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Dismount", self:GetCaster() )

	-- calc animation rate for slowdown
	local hBuff = self:GetCaster():FindModifierByName("modifier_mount_movement")
	if hBuff then
		local flSlowdownTime = hBuff.flCurrentSpeed / hBuff.deceleration
		local flAnimationTime = 1.7
		local flAnimationRate = flSlowdownTime > 0.75 and flAnimationTime / flSlowdownTime or 0
		self:GetCaster():StartGestureWithFadeAndPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 0, 0, flAnimationRate)
	else
		-- We aren't moving yet
		self:GetCaster():StartGestureWithFadeAndPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 0, 0, 0)
	end
end

--------------------------------------------------------------------------------
function snowball_passive:OnDespawn()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.Snowball.ProjectileHit", self:GetCaster() )
	
end

--------------------------------------------------------------------------------
function snowball_passive:OnMovementStart()
end

--------------------------------------------------------------------------------
function snowball_passive:OnMaxSpeed()
	self.nPreviewFX = ParticleManager:CreateParticle( "particles/hw_fx/mount_max_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )

end

--------------------------------------------------------------------------------
function snowball_passive:OnMovementThink()
	-- Hit Sounds
	if self.bHitHero then
		EmitSoundOn("Mount.Impact_Hero", self:GetCaster() )
	elseif self.bHit then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Mount.Impact_Creep", self:GetCaster() )
	end

	-- TODO: Movement Sounds. What sound does a snowball make?
	--[[
	if self.bHit then
		if GameRules:GetDOTATime(false, true) >= self.flMoveSoundTimer then
			EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.IceShards.Penguin", self:GetCaster() )
			self.flMoveSoundTimer = GameRules:GetDOTATime(false, true) + RandomFloat(5, 10)
		end
	end
	--]]

	self.bHit = false
	self.bHitHero = false
end

--------------------------------------------------------------------------------
function snowball_passive:OnMovementEnd()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end

--------------------------------------------------------------------------------
function snowball_passive:OnImpact( hOtherUnit )
	if hOtherUnit:IsHero() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/mount_snowball_impact.vpcf", PATTACH_ABSORIGIN, hOtherUnit )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, hOtherUnit, PATTACH_ABSORIGIN, nil, hOtherUnit:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end

	self.bHit = true
	self.bHitHero = self.bHitHero or hOtherUnit:IsHero()
end

--------------------------------------------------------------------------------
function snowball_passive:OnCrash( bHitTree )
	self:GetCaster():StartGestureWithFade(ACT_DOTA_CAST_ABILITY_1, 0, 0)
	EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "SledPenguin.Crash.Impact", self:GetCaster() )
	if not bHitTree then
		EmitSoundOnLocationWithCaster(self:GetCaster():GetOrigin(), "Hero_Tusk.Snowball.ProjectileHit", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
-- Animations

--------------------------------------------------------------------------------
function snowball_passive:GetAnimation_Summon()
	return nil
end

--------------------------------------------------------------------------------
function snowball_passive:GetAnimation_Movement()
	return ACT_DOTA_RUN
end

--------------------------------------------------------------------------------
-- Misc

--------------------------------------------------------------------------------
function snowball_passive:GetRiderVerticalOffset()
	return 100
end
