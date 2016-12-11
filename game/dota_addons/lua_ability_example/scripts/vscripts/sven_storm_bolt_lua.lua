sven_storm_bolt_lua = class({})
LinkLuaModifier( "modifier_sven_storm_bolt_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sven_storm_bolt_lua:GetAOERadius()
	return self:GetSpecialValueFor( "bolt_aoe" )
end

--------------------------------------------------------------------------------

function sven_storm_bolt_lua:OnAbilityPhaseStart()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetOrigin(), true )

	local vLightningOffset = self:GetCaster():GetOrigin() + Vector( 0, 0, 1600 )
	ParticleManager:SetParticleControl( nFXIndex, 1, vLightningOffset )

	ParticleManager:ReleaseParticleIndex( nFXIndex )

	return true
end

--------------------------------------------------------------------------------

function sven_storm_bolt_lua:OnSpellStart()
	local vision_radius = self:GetSpecialValueFor( "vision_radius" )
	local bolt_speed = self:GetSpecialValueFor( "bolt_speed" )

	local info = {
			EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
			Ability = self,
			iMoveSpeed = bolt_speed,
			Source = self:GetCaster(),
			Target = self:GetCursorTarget(),
			bDodgeable = true,
			bProvidesVision = true,
			iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			iVisionRadius = vision_radius,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, 
		}

	ProjectileManager:CreateTrackingProjectile( info )
	EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
end

--------------------------------------------------------------------------------

function sven_storm_bolt_lua:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) and ( not hTarget:TriggerSpellAbsorb( self ) ) then
		EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
		local bolt_aoe = self:GetSpecialValueFor( "bolt_aoe" )
		local bolt_damage = self:GetSpecialValueFor( "bolt_damage" )
		local bolt_stun_duration = self:GetSpecialValueFor( "bolt_stun_duration" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), hTarget, bolt_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = bolt_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self, "modifier_sven_storm_bolt_lua", { duration = bolt_stun_duration } )
				end
			end
		end
	end

	return true
end
--------------------------------------------------------------------------------
