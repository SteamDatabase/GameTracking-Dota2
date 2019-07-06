
jungle_spirit_team_gyro_shell = class({})

LinkLuaModifier( "modifier_jungle_spirit_team_gyro_shell", "modifiers/team/modifier_jungle_spirit_team_gyro_shell", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jungle_spirit_team_gyro_shell:OnAbilityPhaseStart()
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

function jungle_spirit_team_gyro_shell:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )
	end 
end

--------------------------------------------------------------------------------

function jungle_spirit_team_gyro_shell:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function jungle_spirit_team_gyro_shell:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "duration" )

		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		EmitSoundOn( "JungleSpirit.Generic.CastPointStop", self:GetCaster() )

		local fSearchRange = self:GetCastRange( self:GetCaster():GetOrigin(), nil ) * 0.8
		local hHeroAllies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, hHeroAlly in pairs( hHeroAllies ) do
			if hHeroAlly ~= nil then
				if hHeroAlly:IsRealHero() and hHeroAlly:IsOwnedByAnyPlayer() and hHeroAlly:IsClone() == false and hHeroAlly:IsTempestDouble() == false then
					self:ApplyGyroShellToUnit( hHeroAlly )
				end
			end
		end

		--EmitSoundOn( "JungleSpirit.TeamHeal", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_team_gyro_shell:ApplyGyroShellToUnit( hUnit )
	if IsServer() then
		local vDir = hUnit:GetForwardVector()
		local vTargetPos = hUnit:GetAbsOrigin() + vDir

		local kv =
		{
			vTargetX = vTargetPos.x,
			vTargetY = vTargetPos.y,
			vTargetZ = vTargetPos.z,
			duration = self.duration,
		}
		hUnit:AddNewModifier( self:GetCaster(), self, "modifier_jungle_spirit_team_gyro_shell", kv )
	end
end

--------------------------------------------------------------------------------
