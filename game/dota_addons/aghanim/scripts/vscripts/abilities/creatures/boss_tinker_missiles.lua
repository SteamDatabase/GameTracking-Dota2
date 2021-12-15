
boss_tinker_missiles = class({})

LinkLuaModifier( "modifier_boss_tinker_missiles",
	"modifiers/creatures/modifier_boss_tinker_missiles", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_boss_tinker_missiles_thinker",
	"modifiers/creatures/modifier_boss_tinker_missiles_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_tinker_missiles:Precache( context )
	PrecacheResource( "particle", "particles/creatures/creature_spell_marker.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_missile.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/boss_tinker/boss_tinker_impact.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_tinker_missiles:OnSpellStart()
	self.search_radius = self:GetSpecialValueFor( "search_radius" )
	self.missiles_per_hero = self:GetSpecialValueFor( "missiles_per_hero" )
	self.projectile_speed = self:GetSpecialValueFor( "projectile_speed" )
	self.projectile_radius = self:GetSpecialValueFor( "projectile_radius" )
	self.ground_radius = self:GetSpecialValueFor( "ground_radius" )
	self.damage = self:GetSpecialValueFor( "damage" )
	self.min_range = self:GetSpecialValueFor( "min_range" )
	self.min_range_speed_pct = self:GetSpecialValueFor( "min_range_speed_pct" )
	self.offset_pct_of_radius = self:GetSpecialValueFor( "offset_pct_of_radius" )
	self.stun_duration = self:GetSpecialValueFor( "stun_duration" )
	self.min_speed_mult = self:GetSpecialValueFor( "min_speed_mult" )
	self.max_speed_mult = self:GetSpecialValueFor( "max_speed_mult" )
	self.min_speed_distance = self:GetSpecialValueFor( "min_speed_distance" )
	self.max_speed_distance = self:GetSpecialValueFor( "max_speed_distance" )

	if IsServer() then
		self.Projectiles = {}

		local enemies = Util_FindEnemiesAroundUnit( self:GetCaster(), FIND_UNITS_EVERYWHERE, true )
		for _, enemy in pairs( enemies ) do
			local fDistanceToEnemy = ( enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin() ):Length2D()
			self:LaunchMissiles( enemy:GetAbsOrigin() )
		end
	end
end

--------------------------------------------------------------------------------

function boss_tinker_missiles:LaunchMissiles( vPos )
	if not IsServer() then
		return
	end

	local fOffset = self.ground_radius * ( self.offset_pct_of_radius / 100.0 )
	local vRandomOffset = RandomVector( RandomFloat( fOffset, fOffset ) )

	for i = 1, self.missiles_per_hero do
		if i == 2 then
			vRandomOffset = -vRandomOffset
		end
		local vPosWithRandomOffset = vPos + vRandomOffset
		local vDirection = vPosWithRandomOffset - self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) )
		local flDist2d = vDirection:Length2D()
		local flDist = vDirection:Length()
		vDirection = vDirection:Normalized()
		vDirection.z = 0.0

		local fProjSpeed = self.projectile_speed
		--printf( "-------" )
		--printf( "fProjSpeed: %.1f", fProjSpeed )
		local fSpeedMult = RemapValClamped( flDist, self.min_speed_distance, self.max_speed_distance, self.min_speed_mult, self.max_speed_mult )
		--printf( "flDist: %.1f, self.min_speed_distance: %d, self.max_speed_distance: %d, self.min_speed_mult: %.1f, self.max_speed_mult: %.1f", flDist, self.min_speed_distance, self.max_speed_distance, self.min_speed_mult, self.max_speed_mult )
		fProjSpeed = fProjSpeed * fSpeedMult
		--printf( "fSpeedMult: %.2f", fSpeedMult )
		--printf( "fProjSpeed: %.1f", fProjSpeed )
		--printf( "-------" )

		local fTravelTime = flDist / fProjSpeed

		local info = 
		{
			EffectName = "particles/creatures/boss_tinker/boss_tinker_missile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) ), 
			fStartRadius = self.projectile_radius,
			fEndRadius = self.projectile_radius,
			vVelocity = vDirection * fProjSpeed,
			fDistance = flDist2d,
			Source = self:GetCaster(),
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		}

		local vDestination = self:GetCaster():GetAbsOrigin() + ( vDirection * flDist2d )

		local nProjID = ProjectileManager:CreateLinearProjectile( info )
		info.nHandle = nProjID

		info.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/creature_spell_marker.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( info.nPreviewFX, 0, vDestination )
		ParticleManager:SetParticleControl( info.nPreviewFX, 1, Vector( self.ground_radius, -self.ground_radius, -self.ground_radius ) )
		ParticleManager:SetParticleControl( info.nPreviewFX, 2, Vector( fTravelTime, 0, 0 ) );
		ParticleManager:ReleaseParticleIndex( info.nPreviewFX )

		table.insert( self.Projectiles, info )

		EmitSoundOn( "Boss_Tinker.Missile.Launch", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function boss_tinker_missiles:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget ~= nil then
			return false
		end

		local projInfo = nil
		for _, v in pairs ( self.Projectiles ) do
			if v.nHandle == nProjectileHandle then
				projInfo = v
				break
			end
		end

		if projInfo then
			ParticleManager:DestroyParticle( projInfo.nPreviewFX, true )
		end

		local vPosOnGround = GetGroundPosition( vLocation, self:GetCaster() )

		EmitSoundOnLocationWithCaster( vPosOnGround, "Boss_Tinker.Missile.Impact", self:GetCaster() )

		local nDetonationFX = ParticleManager:CreateParticle( "particles/creatures/boss_tinker/boss_tinker_impact.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nDetonationFX, 0, vPosOnGround )
		ParticleManager:SetParticleControl( nDetonationFX, 1, Vector( self.ground_radius, self.ground_radius, self.ground_radius ) )
		ParticleManager:ReleaseParticleIndex( nDetonationFX )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vPosOnGround, nil, self.ground_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local kv_stun =
				{
					duration = self.stun_duration,
				}
				
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", kv_stun )

				local damage = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = self:GetAbilityDamageType(),
					ability = self
				}
		
				ApplyDamage( damage )
			end
		end
	end

	return true	
end

--------------------------------------------------------------------------------
