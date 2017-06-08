hellbear_smash = class({})

--------------------------------------------------------------------------------

function hellbear_smash:OnAbilityPhaseStart()
	if IsServer() then
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.damage = self:GetSpecialValueFor( "damage" )
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 26, 26 ) )

		EmitSoundOn( "n_creep_Ursa.Clap", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function hellbear_smash:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function hellbear_smash:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function hellbear_smash:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		local nFXIndex = ParticleManager:CreateParticle( "particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hellbear.Smash", self:GetCaster() )

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