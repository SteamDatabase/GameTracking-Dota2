
jungle_spirit_team_shallow_grave = class({})

--LinkLuaModifier( "modifier_lich_frost_armor", "modifier_lich_frost_armor", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_jungle_spirit_team_shallow_grave", "modifiers/team/modifier_jungle_spirit_team_shallow_grave", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_team_shallow_grave:OnAbilityPhaseStart()
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

function jungle_spirit_team_shallow_grave:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_team_shallow_grave:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_team_shallow_grave:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		self.duration = self:GetDuration()
		local fSearchRange = self:GetCastRange( self:GetCaster():GetOrigin(), nil ) * 0.8

		local hAllies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, hAlly in pairs( hAllies ) do
			if hAlly ~= nil then
				local kv = {}
				kv.duration = self.duration
				hAlly:AddNewModifier( self:GetCaster(), self, "modifier_dazzle_shallow_grave", kv )
			end
		end

		EmitSoundOn( "JungleSpirit.TeamShallowGrave", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------
