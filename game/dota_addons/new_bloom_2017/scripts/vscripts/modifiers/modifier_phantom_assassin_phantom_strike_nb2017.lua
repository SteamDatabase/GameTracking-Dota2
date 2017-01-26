modifier_phantom_assassin_phantom_strike_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:OnCreated( kv )
	self.bonus_evasion = self:GetAbility():GetSpecialValueFor( "bonus_evasion" )
	self.counter_attack_pct = self:GetAbility():GetSpecialValueFor( "counter_attack_pct" )
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:GetModifierEvasion_Constant( params )
	return self.bonus_evasion
end

--------------------------------------------------------------------------------

function modifier_phantom_assassin_phantom_strike_nb2017:OnAttackFail( params )
	if IsServer() then
		local nFailType = params.fail_type
		if nFailType == DOTA_ATTACK_RECORD_FAIL_TARGET_EVADED then
			local hAttacker = params.attacker
			local hTarget = params.target
			if hAttacker ~= nil and hTarget ~= nil and hTarget == self:GetParent() and not hAttacker:IsBuilding() then
				if RollPercentage( self.counter_attack_pct ) == true then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					local flDist = ( self:GetParent():GetOrigin() - hAttacker:GetOrigin() ):Length2D()
					if flDist > 200.0 then
						local hDaggerAbility = self:GetParent():FindAbilityByName( "phantom_assassin_stifling_dagger_nb2017" )
						if hDaggerAbility and hDaggerAbility:IsTrained() then
							self:GetParent():StartGestureWithPlaybackRate( ACT_DOTA_CAST_ABILITY_1, 1.33 )
							EmitSoundOn( "Hero_PhantomAssassin.Dagger.Cast", self:GetParent() )

							local info = 
							{
								EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
								Ability = hDaggerAbility,
								Source = self:GetParent(),
								Target = hAttacker,
								iMoveSpeed = hDaggerAbility:GetSpecialValueFor( "dagger_speed" ), 
								iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
								bProvidesVision = true,
								iVisionRadius = 400,
								iVisionTeamNumber = self:GetParent():GetTeamNumber()
							}
							ProjectileManager:CreateTrackingProjectile( info )
						end
					else
						self:GetParent():StartGestureWithPlaybackRate( ACT_DOTA_ATTACK, 1.33 )
						self:GetParent():PerformAttack( hAttacker, false, true, true, true, true, false, true )
					end
				end
			end
		end	
	end

	return 0
end