
jungle_spirit_team_shukuchi = class({})

--------------------------------------------------------------------------------

function jungle_spirit_team_shukuchi:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 100, 100, 100 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 0, 100 ) )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStart", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function jungle_spirit_team_shukuchi:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_team_shukuchi:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_team_shukuchi:OnSpellStart()	
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		local hAllHeroes = HeroList:GetAllHeroes()
		for _, hHero in ipairs( hAllHeroes ) do
			if hHero ~= nil and hHero:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				if hHero:IsRealHero() and hHero:IsOwnedByAnyPlayer() and hHero:IsClone() == false and hHero:IsTempestDouble() == false then
					hHero:AddNewModifier( self:GetCaster(), self, "modifier_weaver_shukuchi", { duration = self:GetDuration() } )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
