
jungle_spirit_team_heal = class({})

--------------------------------------------------------------------------------

function jungle_spirit_team_heal:OnAbilityPhaseStart()
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

function jungle_spirit_team_heal:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_team_heal:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_team_heal:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		local nHealAmount = self:GetSpecialValueFor( "heal_amount" )

		local hAllHeroes = HeroList:GetAllHeroes()
		for _, hHero in ipairs( hAllHeroes ) do
			if hHero ~= nil and hHero:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				hHero:Heal( nHealAmount, self )

				local hPlayer = hHero:GetPlayerOwner()
				if hPlayer ~= nil then
					SendOverheadEventMessage( hHero:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hHero, nHealAmount, nil )
				end

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
		end

		EmitSoundOn( "JungleSpirit.TeamHeal", self:GetCaster() )

		local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_cast_4.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndexB, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndexB )
	end
end

--------------------------------------------------------------------------------
