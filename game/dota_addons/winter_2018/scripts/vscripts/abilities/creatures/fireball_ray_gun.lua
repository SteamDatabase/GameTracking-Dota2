
fireball_ray_gun = class({})
LinkLuaModifier( "modifier_fireball_ray_gun_thinker", "modifiers/creatures/modifier_fireball_ray_gun_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function fireball_ray_gun:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 75, 75, 75 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 230, 100, 223 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function fireball_ray_gun:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end


function fireball_ray_gun:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_fireball_ray_gun_thinker", {duration = self:GetSpecialValueFor( "duration" )}) 
		self.hit_damage = self:GetSpecialValueFor( "damage" )
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end


function fireball_ray_gun:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) and ( not hTarget:IsBuilding() ) then
			local damage = {
				victim = hTarget,
				attacker = self:GetCaster(),
				damage = self.hit_damage,
				damage_type = self:GetAbilityDamageType(),
				ability = self
			}
			ApplyDamage( damage )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin() )
			if self:GetCaster() then
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
			end
			ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			EmitSoundOn( "Dungeon.BloodSplatterImpact", hTarget )
		end

		return true
	end
end
