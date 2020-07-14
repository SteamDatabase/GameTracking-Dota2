aghsfort_brewmaster_thunderclap = class({})

----------------------------------------------------------------------------------------

function aghsfort_brewmaster_thunderclap:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", context )

end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_thunderclap:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.speed = self:GetSpecialValueFor( "speed" )
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "Hero_Brewmaster.ThunderClap.Target", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_thunderclap:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_thunderclap:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function aghsfort_brewmaster_thunderclap:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo = 
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damageInfo )
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.duration } )
			end
		end
	
	end
end

--------------------------------------------------------------------------------