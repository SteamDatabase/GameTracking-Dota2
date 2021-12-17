amoeba_blob_suck = class({})
amoeba_blob_suck_boss = amoeba_blob_suck
amoeba_blob_suck_large = amoeba_blob_suck
amoeba_blob_suck_medium = amoeba_blob_suck
amoeba_blob_suck_small = amoeba_blob_suck

LinkLuaModifier( "modifier_amoeba_suck_aura", "modifiers/creatures/modifier_amoeba_suck_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_amoeba_suck_debuff", "modifiers/creatures/modifier_amoeba_suck_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function amoeba_blob_suck:Precache( context )
	PrecacheResource( "particle", "particles/act_2/ice_boss_channel.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/amoeba_small_blob_launch.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/blob_launch_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_black_hole_scepter_pull_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/amoeba_explosion.vpcf", context )	
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )	
	PrecacheResource( "particle", "particles/act_2/amoeba_blackhole.vpcf", context )	
	
	PrecacheResource( "model", "models/creeps/darkreef/blob/darkreef_blob_02_small.vmdl", context )
	
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context )
end

--------------------------------------------------------------------------------

function amoeba_blob_suck:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/ice_boss_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function amoeba_blob_suck:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end 
end

-----------------------------------------------------------------------------

function amoeba_blob_suck:GetPlaybackRateOverride()
	return 1.0
end

-----------------------------------------------------------------------------

function amoeba_blob_suck:OnSpellStart()
	if IsServer() then
		print( 'ADDING SUCK AURA' )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_amoeba_suck_aura", nil )

		EmitSoundOn( "AmoebaBoss.SuckStart", self:GetCaster() )
		EmitSoundOn( "AmoebaBoss.SuckLoop", self:GetCaster() )

		self.explosion_radius = self:GetSpecialValueFor( "explosion_radius" )
		self.explosion_damage = self:GetSpecialValueFor( "explosion_damage" )
		self.explosion_stun_duration = self:GetSpecialValueFor( "explosion_stun_duration" )
		self.knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
		self.knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetSpecialValueFor( "knockback_height" )
		self.explosion_radius_per_stack = self:GetSpecialValueFor( "explosion_radius_per_stack" )
		self.burn_interval = self:GetSpecialValueFor( "burn_interval" )
		self.burn_damage = self:GetSpecialValueFor( "burn_damage" )

		self.fLastThinkTime = GameRules:GetGameTime()

		self.fChannelTime = self:GetChannelTime()

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.explosion_radius, self.explosion_radius, self.explosion_radius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( self.fChannelTime, self.fChannelTime, self.fChannelTime ) )

		local vecLocation = self:GetCaster():GetAbsOrigin() + Vector( 0, 0, 64 );
		self.nBlackHoleFX = ParticleManager:CreateParticle( "particles/act_2/amoeba_blackhole.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nBlackHoleFX, 0, vecLocation )
		ParticleManager:SetParticleControl( self.nBlackHoleFX, 1, Vector( 200, self.explosion_radius, self.explosion_radius ) )

		self.nRadius = self.explosion_radius
	end
end

-----------------------------------------------------------------------------

function amoeba_blob_suck:OnChannelThink( flInterval )
	if IsServer() then
		if self.nPreviewFX ~= nil then
			local nStacks = 0			
			local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_suck_aura" )
			if hBuff ~= nil then
				nStacks = hBuff:GetBabiesConsumed()
			end

			local nNewRadius = self.explosion_radius + self.explosion_radius_per_stack * nStacks
			if nNewRadius ~= self.nRadius then
				self.nRadius = nNewRadius
				print( 'MAKING NEW FX WITH A LARGER RADIUS = ' .. self.nRadius )
				
				ParticleManager:DestroyParticle( self.nPreviewFX, true )
				self.nPreviewFX = nil

				self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.nRadius, self.nRadius, self.nRadius ) )
				ParticleManager:SetParticleControl( self.nPreviewFX, 2, Vector( self.fChannelTime, self.fChannelTime, self.fChannelTime ) )
			end
		end

		-- burn enemies
		if self.fLastDamageTime == nil or ( GameRules:GetGameTime() - self.fLastDamageTime > self.burn_interval ) then
			local hCaster = self:GetCaster()
			if hCaster ~= nil and hCaster:IsNull() == false and hCaster:IsAlive() == true then
				local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false then
						local damage = {
							victim = enemy,
							attacker = hCaster,
							damage = self.burn_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self
						}
						ApplyDamage( damage )
					end
				end
			end

			self.fLastDamageTime = GameRules:GetGameTime()
		end
	end
end

-----------------------------------------------------------------------------

function amoeba_blob_suck:OnChannelFinish( bInterrupted )
	if IsServer() then
		print( 'REMOVING SUCK AURA' )
		ParticleManager:DestroyParticle( self.nChannelFX, false )

		if self.nPreviewFX ~= nil then
			ParticleManager:DestroyParticle( self.nPreviewFX, true )
			self.nPreviewFX = nil
		end

		if self.nBlackHoleFX ~= nil then
			ParticleManager:DestroyParticle( self.nBlackHoleFX, true )
			self.nBlackHoleFX = nil
		end

		StopSoundOn( "AmoebaBoss.SuckLoop", self:GetCaster() )

		local hBuff = self:GetCaster():FindModifierByName( "modifier_amoeba_suck_aura" )
		if hBuff ~= nil then
			local nBabiesConsumed = hBuff:GetBabiesConsumed()
			print( 'WE ATE ' .. nBabiesConsumed .. ' BABIES DURING THE SUCK!' )
		end

		self:GetCaster():RemoveModifierByName( "modifier_amoeba_suck_aura" )

		EmitSoundOn( "AmoebaBoss.Explosion", self:GetCaster() )

		local vCasterPos = self:GetCaster():GetAbsOrigin()

		local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/amoeba_explosion.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.nRadius, self.nRadius, self.nRadius ) )		
		ParticleManager:SetParticleControl( nFXIndex, 3, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local damage = 
		{
			victim = nil,
			attacker = self:GetCaster(),
			damage = self.explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		}
		local heroes = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self:GetCaster():GetAbsOrigin(), nil, self.nRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
		print( 'FOUND ' .. #heroes .. ' HEROES')
		for _, hero in pairs( heroes ) do
			print( 'hero to damage = ' .. hero:GetUnitName() )
			damage.victim = hero
			ApplyDamage( damage )
			hero:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.explosion_stun_duration } )

			local kv_knockback =
			{
				center_x = vCasterPos.x,
				center_y = vCasterPos.y,
				center_z = vCasterPos.z,
				should_stun = false, 
				duration = self.knockback_duration,
				knockback_duration = self.knockback_duration,
				knockback_distance = self.knockback_distance,
				knockback_height = self.knockback_height,
			}
			hero:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv_knockback )
		end
	end
end

