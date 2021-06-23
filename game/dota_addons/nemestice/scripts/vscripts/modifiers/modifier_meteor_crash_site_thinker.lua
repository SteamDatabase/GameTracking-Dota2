
if modifier_meteor_crash_site_thinker == nil then
	modifier_meteor_crash_site_thinker = class( {} )
end

-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker:IsPurgable()
	return false
end

-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.nCreateItemTeam = kv[ "create_item_team" ]
	self.nMeteorSize = kv[ "meteor_size" ]
	self.bFakeCinemticCrash = kv[ "fake_cinematic_crash" ]

	--print( '^^^self.bFakeCinemticCrash = ' .. self.bFakeCinemticCrash )
	--PrintTable( kv )

	if self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
		-- self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_meteor_crash_site_thinker_sound", kv )
		GameRules.Nemestice.m_nLargeMeteorState = NEMESTICE_METEOR_STATE_WARNING
	end

	--print( "meteor thinker created for meteor size" .. self.nMeteorSize )
	self.bWarning = false
	self:StartIntervalThink( self:GetRemainingTime() - 3.0 )


	self.total_radius = self:GetAbility():GetSpecialValueFor( "big_radius" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if self.nMeteorSize ~= NEMESTICE_METEOR_SIZE_LARGE then
		self.damage = self.damage * 0.75
		self.stun_duration = self.stun_duration * 0.5
		self.total_radius = self:GetAbility():GetSpecialValueFor( "small_radius" )
	end

	-- Ping once for medium meteors, and for the first time for large meteors
	local flPingTime = ( self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE and self:GetRemainingTime() - 3.0 ) or 5.0
	if self.nMeteorSize ~= NEMESTICE_METEOR_SIZE_SMALL then
		if self.bFakeCinemticCrash == 0 then
			MinimapEvent( DOTA_TEAM_GOODGUYS, self:GetParent(), self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, flPingTime )
			MinimapEvent( DOTA_TEAM_BADGUYS, self:GetParent(), self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, flPingTime )
		end
	end
end


-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker:OnIntervalThink()
	if self.bWarning == false then
		self.bWarning = true 
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/neutral_fx/tower_mortar_marker.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.total_radius, -self.total_radius, -self.total_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 3, Vector( 1.0, 0.4, 0.8 ) )
		ParticleManager:ReleaseParticleIndex( self.nPreviewFX )
		self:StartIntervalThink( self:GetRemainingTime() - 1.3 )
		
		-- Ping again
		if self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
			if self.bFakeCinemticCrash == 0 then
				MinimapEvent( DOTA_TEAM_GOODGUYS, self:GetParent(), self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, self:GetRemainingTime() )
				MinimapEvent( DOTA_TEAM_BADGUYS, self:GetParent(), self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, self:GetRemainingTime() )
			end
			GameRules.Nemestice.m_nLargeMeteorState = NEMESTICE_METEOR_STATE_MARKING
		end
		
		return	
	end

	local vRandomOffset = self:GetParent():GetAbsOrigin() + RandomVector( 1000 )
	if self.bFakeCinemticCrash == 1 then
		print( '^^^Forcing random offset for the cinematic meteor' )
		vRandomOffset.x = 460
		vRandomOffset.y = -950
	end

	local szParticleName = "particles/gameplay/spring_meteor_crash/spring_meteor_crash.vpcf"
	if self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
		szParticleName = "particles/gameplay/spring_meteor_crash/spring_neutral_meteor_crash.vpcf"
	end
	if self.nMeteorSize == NEMESTICE_METEOR_SIZE_SMALL then
		szParticleName = "particles/gameplay/spring_meteor_crash/spring_small_meteor_crash.vpcf"
	end
	local nFXIndex = ParticleManager:CreateParticle( szParticleName, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vRandomOffset + Vector( 0, 0, 2000 ) )
	ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetAbsOrigin() + Vector( 0, 0, 90 ) )
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Invoker.ChaosMeteor.Cast", self:GetParent() )
	
	if self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
		GameRules.Nemestice.m_nLargeMeteorState = NEMESTICE_METEOR_STATE_FALLING
	end

	self:StartIntervalThink( -1 )
end

-----------------------------------------------------------------------------

function modifier_meteor_crash_site_thinker:OnDestroy()
	if IsServer() == false then
		return
	end

	if self.nPreviewFX then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end
	
	EmitSoundOn( "Hero_Warlock.RainOfChaos", self:GetParent() )

 	if self.nMeteorSize ~= NEMESTICE_METEOR_SIZE_SMALL then
		local nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/spring_meteor_explosion_start/spring_meteor_explosion_start.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleFoWProperties( nFXIndex, 0, -1, self.total_radius )
		ParticleManager:ReleaseParticleIndex( nFXIndex );

		local nFXIndex2 = ParticleManager:CreateParticle( "particles/gameplay/spring_meteor_explosion/spring_meteor_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( self.total_radius, 1, 1 ) )
		ParticleManager:SetParticleFoWProperties( nFXIndex2, 0, -1, self.total_radius )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 );

		local szMeteorName = "npc_dota_crash_site_meteor"
		if self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
			szMeteorName = "npc_dota_crash_site_meteor_medium"
		end

		local hMeteor = CreateUnitByName( szMeteorName, self:GetParent():GetAbsOrigin(), true, nil, nil, DOTA_TEAM_CUSTOM_1 )
		if hMeteor then

			hMeteor.nMeteorSize = self.nMeteorSize
			hMeteor.bDropNeutralItem = self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM

			if self.bFakeCinemticCrash == 1 then
				GameRules.Nemestice.hFakeCinematicMeteor = hMeteor

			elseif self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
				if GameRules.Nemestice.hBigMeteor ~= nil and GameRules.Nemestice.hBigMeteor:IsNull() == false then
					local hShardAbility = GameRules.Nemestice.hBigMeteor:FindAbilityByName( "hero_meteor_shard_pouch" )
					if hShardAbility and hShardAbility:GetShardCount() > 0 then
						for nShard = 1, hShardAbility:GetShardCount() do
							local hMeteorShard = GameRules.Nemestice:CreateMeteorShard( "crash_site_meteor_replaced", self:GetParent():GetAbsOrigin(), 1 )
							hMeteorShard:LaunchLootInitialHeight( true, 300, 300, 0.75, self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( 250, 600 ) ) )
							hShardAbility:RemoveShard()
						end
					end
				end

				GameRules.Nemestice.hBigMeteor = hMeteor
			elseif self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
				print( "Crashing a medium meteor" )
				local tCrashSites = Entities:FindAllByName( "medium_meteor_spawner" )
				hCrashSite = nil
				if #tCrashSites > 0 then
					for i=1,#tCrashSites do
						local hNextCrashSite = tCrashSites[ i ]
						local flDist = ( hNextCrashSite:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Length2D()
						if flDist < 100 then
							hCrashSite = hNextCrashSite
							break
						end
					end
				end
				if hCrashSite ~= nil then
					if hCrashSite.hMeteor ~= nil and hCrashSite.hMeteor:IsNull() == false then
						local hShardAbility = hCrashSite.hMeteor:FindAbilityByName( "hero_meteor_shard_pouch" )
						if hShardAbility and hShardAbility:GetShardCount() > 0 then
							for nShard = 1, hShardAbility:GetShardCount() do
								local hMeteorShard = GameRules.Nemestice:CreateMeteorShard( "item_meteor_shard", self:GetParent():GetAbsOrigin(), 1 )
								hMeteorShard:LaunchLootInitialHeight( true, 300, 300, 0.75, self:GetParent():GetAbsOrigin() + RandomVector( RandomFloat( 150, 300 ) ) )
								hShardAbility:RemoveShard()
							end
						end
					end
					hCrashSite.hMeteor = hMeteor
				end
			end

			hMeteor:SetAbsOrigin( self:GetParent():GetAbsOrigin() )

			for i = 0,DOTA_MAX_ABILITIES-1 do
				local hAbility = hMeteor:GetAbilityByIndex( i )
				if hAbility then
					hAbility:UpgradeAbility( true )
					if hAbility:GetAbilityName() == "hero_meteor_shard_pouch" then
						local nNumShards = 0
						if self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
							nNumShards = _G.NEMESTICE_METEOR_MEDIUM_ENERGY_VALUE + math.floor( GameRules.Nemestice:GetRoundNumber() / 3 )
						else
							nNumShards = NEMESTICE_METEOR_CRASH_SITE_ENERGY_VALUE - 1 + GameRules.Nemestice:GetRoundNumber()
						end

						for i = 1, nNumShards do
							hAbility:AddShard( nil )
						end
						hAbility.nStartingShards = nNumShards
					end
				end
			end
		end
	else
		local nFXIndex2 = ParticleManager:CreateParticle( "particles/gameplay/spring_meteor_explosion/spring_meteor_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex2, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex2, 1, Vector( self.total_radius, 1, 1 ) )
		ParticleManager:SetParticleFoWProperties( nFXIndex2, 0, -1, self.total_radius )
		ParticleManager:ReleaseParticleIndex( nFXIndex2 );

		if RandomInt( 0, 99 ) < _G.NEMESTICE_METEOR_SMALL_SHARD_CHANCE then
			local hSmallMeteorShard = GameRules.Nemestice:CreateMeteorShard( "small_meteor", self:GetParent():GetAbsOrigin(), 1 )
			hSmallMeteorShard:LaunchLoot( true, 400, 3.0, self:GetParent():GetAbsOrigin() + RandomVector( self.total_radius + RandomFloat( 50, 150 ) ) )
		end
	end

	local tStunTeams = {}

	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), self.total_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )		
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsNull() == false and enemy:IsBuilding() == false and enemy.hBuildingAbility == nil and enemy:IsCourier() == false then
			if enemy:IsOther() and enemy:IsInvulnerable() == false and self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
				enemy:ForceKill( false )
			else
				if enemy:IsInvulnerable() == false then
					local flDamage = self.damage * GameRules.Nemestice:GetRoundNumber() / 2
					if self.hBigMeteor then
						flDamage = flDamage * 20
						if enemy:IsCreep() or enemy:IsSummoned() then
							flDamage = flDamage * 1000
						end
					end

					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = flDamage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility(),
					}

					if enemy:IsRealHero() then
						local bStunned = enemy:IsStunned()
						local bRooted = enemy:IsRooted()
						local bHexed = enemy:IsHexed()
						local bFrozen = enemy:IsFrozen()
						for _,hModifier in pairs( enemy:FindAllModifiers() ) do
							local tState = {}
							if hModifier ~= nil and hModifier:IsNull() == false then
								hModifier:CheckStateToTable( tState )
								if ( bStunned and tState[tostring(MODIFIER_STATE_STUNNED)] == true )
									or ( bRooted and tState[tostring(MODIFIER_STATE_ROOTED)] == true )
									or ( bHexed and tState[tostring(MODIFIER_STATE_HEXED)] == true )
									or ( bFrozen and tState[tostring(MODIFIER_STATE_FROZEN)] == true )
								then
									local hStunCaster = hModifier:GetCaster()
									if hStunCaster ~= nil and hStunCaster:IsNull() == false and hStunCaster:GetTeamNumber() ~= enemy:GetTeamNumber() and hStunCaster:IsOwnedByAnyPlayer() then
										--printf( "Hero %s is CC'd by hero %s!!!", enemy:GetUnitName(), hStunCaster:GetUnitName() )
										tStunTeams[ hStunCaster:GetTeamNumber() ] = 1
									end
								end
							end
						end
					end

					ApplyDamage( damageInfo )
					if enemy:IsMagicImmune() == false or self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
						--enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = self.stun_duration } )
						if enemy:FindModifierByName( "modifier_pangolier_gyroshell_timeout" ) == nil then	
							local vToEnemy = enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
							vToEnemy.z = 0
							local nDist = 270
							local flAirtime = 0.5
							local flStunTime = 0.5
							if self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
								nDist = 350
								flAirtime = 0.75
								flStunTime = 2.0
							elseif self.nMeteorSize == NEMESTICE_METEOR_SIZE_MEDIUM then
								nDist = 300
								flAirtime = 0.5
								flStunTime = 1.0
							end
							local vLoc = enemy:GetAbsOrigin() + ( nDist * vToEnemy:Normalized() )
							vLoc.z = GetGroundHeight( vLoc, enemy )

							local kv = {
								vLocX = vLoc.x,
								vLocY = vLoc.y,
								vLocZ = vLoc.z,
								bounce_duration = flAirtime,
							}
							enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_bounce", kv )

							local kv2 = {
								duration = flAirtime + flStunTime,
							}
							enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_timeout", kv2 )
						end
					end
					--FindClearSpaceForUnit( enemy, enemy:GetAbsOrigin(), true )
				end
			end
		end
	end

	for k,v in pairs( tStunTeams ) do
		GameRules.Nemestice:GrantTeamBattlePoints( k, _G.BATTLE_POINT_DROP_METEOR_STUN, "meteor_stun" )
	end
	
	if self.nMeteorSize == NEMESTICE_METEOR_SIZE_LARGE then
		GameRules.Nemestice.m_nLargeMeteorState = NEMESTICE_METEOR_STATE_WAITING
	end

	ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )
	UTIL_Remove( self:GetParent() )
end