
aghsfort_obsidian_destroyer_arcane_orb_linear = class( {} )
LinkLuaModifier( "modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker", "modifiers/creatures/modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_damage.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_pre.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/storegga_channel.vpcf", context )
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:OnAbilityPhaseStart()
	if IsServer() then
	
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/storegga_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", self:GetCaster() )

		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.step_delay = self:GetSpecialValueFor( "step_delay" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.radius_step = self:GetSpecialValueFor( "radius_step" )
		self.range = self:GetSpecialValueFor( "range" )

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local nSteps = 0
		local flAccumDist = 0
		while flAccumDist < self.range do 
			flAccumDist = flAccumDist + self.radius + ( self.radius_step * nSteps )
			nSteps = nSteps + 1
		end

		local vStaffPos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) )
		local vLastStepPos = self:GetCaster():GetAbsOrigin()
		for i = 1, nSteps do
			local nBonusRadius = self.radius_step * i 
			local flDist = self.radius + nBonusRadius
			local vStepPos = vLastStepPos + ( vDirection * flDist )
			vLastStepPos = vStepPos
			local flStepDelay = self.step_delay * i + 1
			local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker", { duration = flStepDelay, bonus_radius = nBonusRadius }, vStepPos, self:GetCaster():GetTeamNumber(), false )
			if hThinker then 
				local flProjDistance = ( vStaffPos - vStepPos ):Length()
				print( flProjDistance )
				local nSpeed = math.ceil( flProjDistance / flStepDelay )
				print( nSpeed )
				local projectile =
				{
					Target = hThinker,
					Source = self:GetCaster(),
					Ability = self,
					EffectName = "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
					iMoveSpeed = nSpeed,
					vSourceLoc = vStaffPos,
					bDodgeable = false,
					bProvidesVision = false,
				}

				ProjectileManager:CreateTrackingProjectile( projectile )
			end
		end

	end
end

--------------------------------------------------------------------------------

function aghsfort_obsidian_destroyer_arcane_orb_linear:OnProjectileHit( hTarget, vLocation )
	return true 
end