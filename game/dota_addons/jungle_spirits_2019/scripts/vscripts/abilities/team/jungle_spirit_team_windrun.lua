
jungle_spirit_team_windrun = class({})

--------------------------------------------------------------------------------

function jungle_spirit_team_windrun:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/jungle_spirit/jungle_warning_tier_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 77, 166, 255 ) )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStart", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function jungle_spirit_team_windrun:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_team_windrun:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_team_windrun:OnSpellStart()	
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		local hAllHeroes = HeroList:GetAllHeroes()
		for _, hHero in ipairs( hAllHeroes ) do
			if hHero ~= nil and hHero:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				if hHero:IsRealHero() and hHero:IsOwnedByAnyPlayer() and hHero:IsClone() == false and hHero:IsTempestDouble() == false then
					hHero:AddNewModifier( self:GetCaster(), self, "modifier_windrunner_windrun", { duration = self:GetDuration() } )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
