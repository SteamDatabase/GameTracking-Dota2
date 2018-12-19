modifier_rubick_boss_spell_steal_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:SetSpell( szSpellName )
	if IsServer() then
		self.szSpellName = szSpellName
		self.nWarningFX = -1
		self:CreateWarning()
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateWarning()
	if IsServer() then
		if self.szSpellName == "rubick_chaos_meteor" then
			self:WarnChaosMeteor()
		end
		if self.szSpellName == "rubick_boss_freezing_field" then
			self:WarnFreezingField()
		end
		if self.szSpellName == "rubick_boss_ghostship" then
			self:WarnGhostship()
		end
		if self.szSpellName == "rubick_boss_mystic_flare" then
			self:WarnMysticFlare()
		end
		if self.szSpellName == "rubick_boss_black_hole" then
			self:WarnChaosMeteor()
		end
		if self.szSpellName == "create_rubick_minions" then
			self:WarnCreateMinions()
		end

		
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:Activate()
	if IsServer() then
		if self.nWarningFX ~= -1 then
			ParticleManager:DestroyParticle( self.nWarningFX, true )
		end

		if self.szSpellName == "rubick_chaos_meteor" then
			self:CreateChaosMeteor()
		end
		if self.szSpellName == "rubick_boss_freezing_field" then
			self:CreateFreezingField()
		end
		if self.szSpellName == "rubick_boss_ghostship" then
			self:CreateGhostship()
		end
		if self.szSpellName == "rubick_boss_mystic_flare" then
			self:CreateMysticFlare()
		end
		if self.szSpellName == "rubick_boss_black_hole" then
			self:CreateBlackhole()
		end
		if self.szSpellName == "create_rubick_minions" then
			self:CreateRubickMinions()
		end
	end
end


-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:WarnChaosMeteor()
	if IsServer() then
		self:WarnMysticFlare()
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:WarnFreezingField()
	if IsServer() then
		self:WarnMysticFlare()
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:WarnGhostship()
	if IsServer() then
		self:WarnMysticFlare()
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:WarnMysticFlare()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.5 , 0, 0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetOrigin()  )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:WarnCreateMinions()
	if IsServer() then
		local AngleY = 0
		for i=1,8 do
			local vDirection = self:GetParent():GetOrigin() - self:GetCaster():GetOrigin()
			local angle = VectorToAngles( vDirection ) 
			angle.y = AngleY
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/rubick/rubick_force_ambient/rubick_telekinesis_marker_force.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() + RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) * 200 )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.5 , 0, 0 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, self:GetParent():GetOrigin() + RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) * 200   )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			AngleY = AngleY + 45
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateChaosMeteor()
	if IsServer() then
		local hMeteor = self:GetCaster():FindAbilityByName( "rubick_chaos_meteor" )
		if hMeteor then
			if hMeteor.precache == nil then
		--		local hExort = self:GetCaster():FindAbilityByName( "invoker_exort" )
				hMeteor:UpgradeAbility( true )
				hMeteor:OnSpellStart()
				hMeteor.precache = true
			end
			hMeteor:SetStolen( true )
			local vRandom = RandomVector( 700.0 )
			local vDir = self:GetParent():GetOrigin() - ( self:GetParent():GetOrigin() + vRandom )
			vDir = vDir:Normalized()
			vDir.z = 0.0
			local kv = 
			{
				duration = hMeteor:GetSpecialValueFor( "land_time" ),
				travel_speed = hMeteor:GetSpecialValueFor( "travel_speed" ),
				vision_distance = hMeteor:GetSpecialValueFor( "vision_distance" ),
			 	travel_distance = 700,
				dir_x = vDir.x,
				dir_y = vDir.y,
			}

			CreateModifierThinker( self:GetCaster(), hMeteor, "modifier_invoker_chaos_meteor_land", kv, self:GetParent():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
			EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Hero_Invoker.ChaosMeteor.Cast", self:GetCaster() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_rubick/rubick_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, ( self:GetParent():GetOrigin() + vRandom ) + Vector( 0, 0, 1100 ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 90 ) )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.4, 0, 0 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			hMeteor:SetStolen( false ) 
		end
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateBlackhole()
	if IsServer() then
		local hBlackhole = self:GetCaster():FindAbilityByName( "rubick_boss_black_hole" )
		if hBlackhole then
			local kv =
			{
				aura = true,
				aura_apply_modifier = "modifier_enigma_black_hole_pull",
				aura_radius = hBlackhole:GetSpecialValueFor( "pull_radius" ),
				aura_search_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
				aura_search_type = DOTA_UNIT_TARGET_HERO,
				aura_search_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			}
			hBlackhole:SetStolen( true )
			self.hThinker = CreateModifierThinker( self:GetCaster(), hBlackhole, "modifier_enigma_black_hole_thinker", kv, self:GetParent():GetOrigin(), self:GetCaster():GetTeamNumber(), false )
			hBlackhole:SetStolen( false )
			self.flExpireTime = GameRules:GetGameTime() + 3.0 
			self:StartIntervalThink( 3.0 )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateFreezingField()
	if IsServer() then
		local hFreezingField = self:GetCaster():FindAbilityByName( "rubick_boss_freezing_field" )
		if hFreezingField then
			local kv = 
			{
				duration = hFreezingField:GetChannelTime(),
			}	
			self:GetParent():AddNewModifier( self:GetCaster(), hFreezingField, "modifier_crystal_maiden_freezing_field", kv )
		end

		local radius = hFreezingField:GetSpecialValueFor( "radius" )

		self.nContinuousFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_rubick/rubick_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nContinuousFX, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nContinuousFX, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleFoWProperties( self.nContinuousFX, 0, -1, radius )
		self:AddParticle( self.nContinuousFX , true, false, -1, false, false )

		StopSoundOn( "hero_Crystal.freezingField.wind", self:GetCaster() )
		EmitSoundOn( "hero_Crystal.freezingField.wind", self:GetParent() )
		self.flExpireTime = GameRules:GetGameTime() + hFreezingField:GetChannelTime()
		self:StartIntervalThink( 0.25 )
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateGhostship()
	if IsServer() then
		local hGhostship = self:GetCaster():FindAbilityByName( "rubick_boss_ghostship" )
		if hGhostship then
			self:GetCaster():SetCursorPosition( self:GetParent():GetOrigin() )
			hGhostship:SetStolen( true )
			hGhostship:OnSpellStart()
			hGhostship:SetStolen( false )
		end
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateMysticFlare()
	if IsServer() then
		local hMysticFlare = self:GetCaster():FindAbilityByName( "rubick_boss_mystic_flare" )
		if hMysticFlare then
			self:GetCaster():SetCursorPosition( self:GetParent():GetOrigin() )
			hMysticFlare:SetStolen( true )
			hMysticFlare:OnSpellStart()
			hMysticFlare:SetStolen( false )
		end
	end
end


-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:CreateRubickMinions()
	if IsServer() then
		local hBuff = self:GetCaster():FindModifierByName( "modifier_rubick_boss_passive" )
		if hBuff then
			hBuff:CreateMinions( self:GetParent():GetOrigin() )
		end
	
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_thinker:OnIntervalThink()
	if IsServer() then
		if GameRules:GetGameTime() > self.flExpireTime then
			StopSoundOn( "hero_Crystal.freezingField.wind", self:GetParent() )
			if self.hThinker ~= nil then
				UTIL_Remove( self.hThinker )
			end
			UTIL_Remove( self:GetParent() )
		end
		if self.szSpellName == "rubick_boss_freezing_field" then
			local hFreezingField = self:GetCaster():FindAbilityByName( "rubick_boss_freezing_field" )
			if hFreezingField then
				local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), hFreezingField:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
				for _,Hero in pairs( Heroes ) do
					if Hero ~= nil and Hero:IsMagicImmune() == false then
						Hero:AddNewModifier( self:GetCaster(), hFreezingField, "modifier_crystal_maiden_freezing_field_slow", { duration = hFreezingField:GetSpecialValueFor( "slow_duration" ) } )
					end
				end
			end
		end
	end
end
