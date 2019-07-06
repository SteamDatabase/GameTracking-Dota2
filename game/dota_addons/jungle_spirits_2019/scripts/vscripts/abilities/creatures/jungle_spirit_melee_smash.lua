
jungle_spirit_melee_smash = class({})

-----------------------------------------------------------------------------

function jungle_spirit_melee_smash:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function jungle_spirit_melee_smash:GetCastAnimation()
	if IsServer() then
		if self:GetSpecialValueFor( "animation_change_level" ) > 0 and self:GetCaster():GetLevel() >= self:GetSpecialValueFor( "animation_change_level" ) then
			return ACT_DOTA_OVERRIDE_ABILITY_4
		else
			return ACT_DOTA_CAST_ABILITY_4
		end
	end
end

--------------------------------------------------------------------------------

function jungle_spirit_melee_smash:OnAbilityPhaseStart()
	if IsServer() then
		self.impact_radius = self:GetSpecialValueFor( "impact_radius" )
		self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
		self.damage_mult_vs_buildings = self:GetSpecialValueFor( "damage_mult_vs_buildings" )
		self.damage = self:GetCaster():GetAttackDamage()

		self.vImpactPos = self:GetCursorPosition()

		local hTalent = self:GetCaster():FindAbilityByName( "special_bonus_unique_jungle_spirit_melee_stun_duration" )
		if hTalent and hTalent:GetLevel() > 0 then
			self.stun_duration = self.stun_duration + hTalent:GetSpecialValueFor( "value" )
		end

		local fParticleRadius = self.impact_radius * 0.9

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self.vImpactPos )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( fParticleRadius, fParticleRadius, fParticleRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( 6, 0, 1 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 3, Vector( 255, 0, 0, 0.5 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 4, Vector( 0, 0, 0 ) )

		EmitSoundOn( "JungleSpirit.Storegga.Grunt", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function jungle_spirit_melee_smash:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		StopSoundOn( "JungleSpirit.Storegga.Grunt", self:GetCaster() )
	end 
end

-----------------------------------------------------------------------------

function jungle_spirit_melee_smash:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )
		StopSoundOn( "JungleSpirit.Storegga.Grunt", self:GetCaster() )

		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self.vImpactPos, "OgreTank.GroundSmash", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self.vImpactPos )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vImpactPos, self:GetCaster(), self.impact_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false
			)

			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and not ( enemy:IsRealHero() and enemy:IsMagicImmune() ) then
					local fDmg = self.damage

					if enemy:IsBuilding() then
						fDmg = fDmg * self.damage_mult_vs_buildings
					end

					local damageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = fDmg,
						damage_type = self:GetAbilityDamageType(),
						ability = self,
					}

					ApplyDamage( damageInfo )

					if enemy:IsAlive() == false and enemy:IsBuilding() == false and enemy:IsOther() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "BloodSplatterImpact", enemy )
					else
						enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
					end

					if enemy:GetUnitName() == "npc_dota_weaver_swarm" then
						enemy:ForceKill( false )
					end
				end
			end
		end

		ScreenShake( self.vImpactPos, 10.0, 100.0, 0.5, 1300.0, 0, true )
	end
end

-----------------------------------------------------------------------------
