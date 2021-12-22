
modifier_boss_earthshaker_quake = class({})

--------------------------------------------------------------------------------

function modifier_boss_earthshaker_quake:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_earthshaker_quake:OnCreated( kv )
	if IsServer() then
		self.area_of_effect = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
		self.num_full_channels = kv[ "num_full_channels" ]
		local nExtraRadiusPerCast = self:GetAbility():GetSpecialValueFor( "extra_radius_per_cast" )
		self.area_of_effect = self.area_of_effect + ( self.num_full_channels * nExtraRadiusPerCast )

		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
		self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )

		self.start_delay = kv[ "start_delay" ]

		--printf( "self.start_delay: %.2f", self.start_delay )

		if IsServer() then
			self:StartIntervalThink( self.start_delay )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_earthshaker_quake:OnIntervalThink()
	if IsServer() then
		if not self.bStarted then
			EmitSoundOn( "Boss_Earthshaker.Quake.Warning", self:GetParent() )

			self.nPreviewFX = ParticleManager:CreateParticle( "particles/act_2/wyvern_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( self.nPreviewFX, 0, GetGroundPosition( self:GetParent():GetAbsOrigin(), self:GetParent() ) )
			ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.area_of_effect, 2, 1 ) )
			ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 120, 20 ) )
			ParticleManager:SetParticleControl( self.nPreviewFX, 16, Vector( 1, 0, 0 ) )

			self.bStarted = true

			self:StartIntervalThink( -1 )

			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_earthshaker_quake:OnDestroy()
	if IsServer() then
		if not self:GetCaster() then
			return
		end

		ParticleManager:DestroyParticle( self.nPreviewFX, true )

		StopSoundOn( "Boss_Earthshaker.Quake.Warning", self:GetParent() )

		EmitSoundOn( "Boss_Earthshaker.Quake", self:GetParent() )

		local nQuakeFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( nQuakeFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nQuakeFX, 1, Vector( self.area_of_effect, self.area_of_effect, self.area_of_effect ) )
		ParticleManager:ReleaseParticleIndex( nQuakeFX )

		-- Burst any mounds in radius
		local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(),
				self:GetCaster(), self.area_of_effect, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false
		)

		for _, ally in pairs( allies ) do
			if ally ~= nil and ally:GetUnitName() == "npc_dota_earthshaker_dirt_mound" then
				local hBurstBuff = ally:FindModifierByName( "modifier_earthshaker_dirt_mound" )
				if hBurstBuff ~= nil then
					hBurstBuff:Burst()
				end
			end
		end

		-- @todo: Maybe quake-bursted mounds should send the spawned mudmen flying

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(),
				self:GetCaster(), self.area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false
		)

		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				if ( not enemy:HasModifier( "modifier_knockback" ) ) then
					local kv_knockback =
					{
						center_x = self:GetParent():GetOrigin().x,
						center_y = self:GetParent():GetOrigin().y,
						center_z = self:GetParent():GetOrigin().z,
						should_stun = true, 
						duration = self.knockback_duration,
						knockback_duration = self.knockback_duration,
						knockback_distance = self.knockback_distance,
						knockback_height = self.knockback_height,
					}
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv_knockback )

					local DamageInfo =
					{
						victim = enemy,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = self.damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
					}

					ApplyDamage( DamageInfo )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
