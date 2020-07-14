
sand_king_boss_sandstorm = class({})

--------------------------------------------------------------------

function sand_king_boss_sandstorm:Precache( context )

	PrecacheResource( "particle", "particles/dark_moon/darkmoon_creep_warning.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/sand_king_cyclone.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_sand_king_sandstorm", context, -1 )

end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:OnAbilityPhaseStart()
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 325, 325, 325 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 255, 140, 0 ) )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:GetChannelAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_2
end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:GetPlaybackRateOverride()
	return 0.5
end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self:GetCaster().bInSandStorm = true

		if self.nCastCount == nil then
			self.nCastCount = 0
		else
			self.nCastCount = self.nCastCount + 1
		end

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sandking_sand_storm", { duration = self:GetSpecialValueFor( "channel_time" ) } )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sandking_sand_storm_invis", { duration = self:GetSpecialValueFor( "channel_time" ) } )
		self.storm_count_per_player = self:GetSpecialValueFor( "storm_count_per_player" )
		self.storm_angle_step = self:GetSpecialValueFor( "storm_angle_step" )
		self.storm_speed = self:GetSpecialValueFor( "storm_speed" ) + self:GetSpecialValueFor( "storm_speed_step" ) * self.nCastCount
		self.spiral_storm_count = self:GetSpecialValueFor( "spiral_storm_count" )
		
		local bReverse = RandomInt( 0, 1 )
		if bReverse == 1 then
			self.storm_angle_step = self.storm_angle_step * -1
		end

		self.Storms = {}
		
		local angle = QAngle( 0, 0, 0 )
		
		local Heroes = HeroList:GetAllHeroes()
		for _,Hero in pairs( Heroes ) do
			if Hero ~= nil then
				for i=1,self.storm_count_per_player do
					local hStorm = CreateUnitByName( "npc_dota_sand_king_sandstorm", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
					if hStorm ~= nil then
						if self:GetCaster().zone ~= nil then
							self:GetCaster().zone:AddEnemyToZone( hStorm )
						end
						hStorm.hParent = self:GetCaster()
						
						hStorm:AddNewModifier( Hero, nil, "modifier_provides_vision", {} )
						hStorm.nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sand_king_cyclone.vpcf", PATTACH_ABSORIGIN_FOLLOW, hStorm )
						
						hStorm:SetForceAttackTarget( Hero )
						hStorm.Target = Hero
						hStorm.storm_speed = self.storm_speed
						local vSpawnPoint = Hero:GetOrigin() + RandomVector( 1 ) * 2000
						FindClearSpaceForUnit( hStorm, vSpawnPoint, true )
				
				

						hStorm:AddNewModifier( hStorm, hStorm:FindAbilityByName( "sand_king_boss_sandstorm_storm_passive" ), "modifier_sand_king_boss_sandstorm", {} )
						
						table.insert( self.Storms, hStorm )
					end
				end
			end
		end

		for i=1, self.spiral_storm_count do
			local hStorm = CreateUnitByName( "npc_dota_sand_king_sandstorm", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
			if hStorm ~= nil then
				if self:GetCaster().zone ~= nil then
					self:GetCaster().zone:AddEnemyToZone( hStorm )
				end
				hStorm.hParent = self:GetCaster()
				
				hStorm:AddNewModifier( Hero, nil, "modifier_provides_vision", {} )
				hStorm.nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/sand_king_cyclone.vpcf", PATTACH_ABSORIGIN_FOLLOW, hStorm )
				local vSpawnPoint = self:GetCaster():GetOrigin()
				FindClearSpaceForUnit( hStorm, vSpawnPoint, true )

				local info = 
				{
					EffectName = "",
					Ability = self,
					vSpawnOrigin = vSpawnPoint,
					fDistance = 5000,
					fStartRadius = 50,
					fEndRadius = 50,
					Source = self:GetCaster(),
				}

				info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.storm_speed

				hStorm.nProjHandle = ProjectileManager:CreateLinearProjectile( info )
				hStorm.y = angle.y
				angle.y = angle.y + self.storm_angle_step

				hStorm.flAngleUpdate = 3.0 
				if bReverse then
					hStorm.flAngleUpdate = hStorm.flAngleUpdate * -1
					hStorm.bReverse = bReverse
				end
				hStorm:AddNewModifier( hStorm, hStorm:FindAbilityByName( "sand_king_boss_sandstorm_storm_passive" ), "modifier_sand_king_boss_sandstorm", {} )	
				table.insert( self.Storms, hStorm )
			end
		end
	end
end

-------------------------------------------------------------------------------

function sand_king_boss_sandstorm:OnProjectileThinkHandle( iProjectileHandle )
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsChanneling() == false then
			return
		end

		for _,Storm in pairs( self.Storms ) do
			if Storm ~= nil and Storm.nProjHandle == iProjectileHandle then
				Storm.y = Storm.y + Storm.flAngleUpdate
				if Storm.bReverse then
					Storm.flAngleUpdate = math.min( Storm.flAngleUpdate + 0.03, -1 )
				else
					Storm.flAngleUpdate = math.max( Storm.flAngleUpdate - 0.03, 1 )
				end

				local angle = QAngle( 0, Storm.y, 0 )
				local vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * self.storm_speed
				ProjectileManager:UpdateLinearProjectileDirection( iProjectileHandle, vVelocity, 5000 )
				
			end
		end
	end
end

--------------------------------------------------------------------------------

function sand_king_boss_sandstorm:OnChannelFinish( bInterrupted )
	if IsServer() then
		for _,Storm in pairs( self.Storms ) do
			if Storm ~= nil then
				if Storm.nProjHandle ~= nil then
					ProjectileManager:DestroyLinearProjectile( Storm.nProjHandle )				 
				end

				ParticleManager:DestroyParticle( Storm.nFXIndex, false )
				Storm:ForceKill( false )
			end
		end

		self:GetCaster().bInSandStorm = false
	end
end
