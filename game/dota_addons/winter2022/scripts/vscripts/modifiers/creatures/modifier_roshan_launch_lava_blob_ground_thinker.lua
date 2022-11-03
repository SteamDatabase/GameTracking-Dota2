require( "winter2022_utility_functions" )

modifier_roshan_launch_lava_blob_ground_thinker = class({})

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:GetModifierAura()
	return "modifier_roshan_launch_lava_blob_slow"
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:GetAuraRadius()
	return self.impact_radius
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:OnCreated( kv )
	self.impact_radius = self:GetAbility():GetSpecialValueFor( "impact_radius" )

	if IsServer() then
		self.magma_duration = self:GetAbility():GetSpecialValueFor( "magma_duration" )
		self.burn_damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
		self.burn_interval = self:GetAbility():GetSpecialValueFor( "burn_interval" )
		self.burn_linger_duration = self:GetAbility():GetSpecialValueFor( "burn_linger_duration" )
		self.damage_mult_per_min = self:GetAbility():GetSpecialValueFor( "damage_mult_per_min" )

		print( 'MAGMA DURATION = ' .. self.magma_duration )
		self.nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/greevil_orange_lava_puddle.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, self:GetParent():GetAbsOrigin() );
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( self.magma_duration, 0, 0 ) );

		EmitSoundOn( "Hero_Snapfire.MortimerBlob.Impact", self:GetParent() )

		self:StartIntervalThink( self.burn_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() then
			self:Destroy()
			return
		end

		local fDamagePerInterval = self.burn_damage / ( 1.0 / self.burn_interval )

		fDamagePerInterval = fDamagePerInterval * ( 1.0 + ( (GameRules:GetGameTime() / 60) * self.damage_mult_per_min ) )
		--printf( 'BURN DAMAGE WITH TIME MULT = %f', fDamagePerInterval )

		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		if #hEnemies > 0 then
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false and IsGreevil( hEnemy ) == false then
					local damage = {
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = fDamagePerInterval,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self:GetAbility()
					}

					local fActualDamage = ApplyDamage( damage )
					SendOverheadEventMessage( hEnemy:GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE, hEnemy, fActualDamage, nil )
				
					hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_roshan_launch_lava_blob_slow", { duration = self.burn_linger_duration } )
					
					--EmitSoundOn( "Hero_Viper.NetherToxin.Damage", hEnemy )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_roshan_launch_lava_blob_ground_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		--self:GetParent():StopSound( "Hero_Viper.Nethertoxin" )
		UTIL_Remove( self:GetParent() )
	end
end
