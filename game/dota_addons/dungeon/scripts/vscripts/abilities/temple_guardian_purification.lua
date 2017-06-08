temple_guardian_purification = class({})

--------------------------------------------------------------------------------

function temple_guardian_purification:OnAbilityPhaseStart()
	if IsServer() then
		local radius = self:GetSpecialValueFor( "radius" )
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_charge.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 215, 0 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )
	end

	return true
end

--------------------------------------------------------------------------------

function temple_guardian_purification:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

--------------------------------------------------------------------------------

function temple_guardian_purification:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------
function temple_guardian_purification:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		local hTarget = self:GetCursorTarget()
		if hTarget == nil or hTarget:IsInvulnerable() or hTarget:IsMagicImmune() then
			return
		end

		local radius = self:GetSpecialValueFor( "radius" )
		local heal = self:GetSpecialValueFor( "heal" )

		hTarget:Heal( heal, self )

		local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex1, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true  );
		ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( radius, radius, radius ) );
		ParticleManager:ReleaseParticleIndex( nFXIndex1 );

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex2, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true );
		ParticleManager:ReleaseParticleIndex( nFXIndex2 );
	
		EmitSoundOn( "TempleGuardian.Purification", hTarget )
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = heal,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self,
				}
				ApplyDamage( damageInfo )

				local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy );
				ParticleManager:SetParticleControlEnt( nFXIndex3, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true );
				ParticleManager:ReleaseParticleIndex( nFXIndex3 );
			end
		end
	end
end