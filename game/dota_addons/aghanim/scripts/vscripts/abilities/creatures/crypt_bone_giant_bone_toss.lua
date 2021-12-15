crypt_bone_giant_bone_toss = class({})

LinkLuaModifier( "modifier_crypt_bone_giant_bone_toss", "modifiers/creatures/modifier_crypt_bone_giant_bone_toss", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tiny/tiny_tree_channel.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:GetIntrinsicModifierName()
	return "modifier_crypt_bone_giant_bone_toss"
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:GetAOERadius()
	if self.radius == nil then 
		self.radius = self:GetSpecialValueFor( "radius" )
	end
	return self.radius
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:OnAbilityPhaseStart()
	if IsServer() then 
		if self.radius == nil then 
			self.radius = self:GetSpecialValueFor( "radius" )
		end

		self.nWarnFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tiny/tiny_tree_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nWarnFXIndex1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( self.nWarnFXIndex1, 2, Vector( self.radius, self.radius, 1 ) );

		self.vTargetPos = self:GetCursorTarget():GetAbsOrigin()

		self.bone_speed = self:GetSpecialValueFor( "bone_speed" )

		local flDist = ( self.vTargetPos - self:GetCaster():GetAbsOrigin() ):Length2D()
		local flTime = ( flDist / self.bone_speed ) + self:GetCastPoint()

		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/darkmoon_2017/darkmoon_generic_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self.vTargetPos )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, Vector( 6, 0, 1 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 3, Vector( 255, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector( 0, 0, 0 ) )
	end

	return true
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:OnAbilityPhaseInterrupted()
	if IsServer() then 
		ParticleManager:DestroyParticle( self.nWarnFXIndex1, false )
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:OnSpellStart()
	if IsServer() == false then 
		return
	end

	ParticleManager:DestroyParticle( self.nWarnFXIndex1, false )

	self.bone_speed = self:GetSpecialValueFor( "bone_speed" )

	local vStartPos = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_attack1" ) )
	local vPos = self.vTargetPos
	local vDirection = vPos - vStartPos 
	local flDist2d = vDirection:Length2D()
	local flDist = vDirection:Length()
	vDirection = vDirection:Normalized()
	vDirection.z = 0.0


	local info = 
	{
		EffectName = "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf",
		Ability = self,
		vSpawnOrigin = vStartPos, 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * self.bone_speed,
		fDistance = flDist2d,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Tiny.Tree.Throw", self:GetCaster() )
end

--------------------------------------------------------------------------------

function crypt_bone_giant_bone_toss:OnProjectileHit( hTarget, vLocation )
	if IsServer() == false then 
		return true 
	end

	self.radius = self:GetSpecialValueFor( "radius" )
	self.bone_damage = self:GetSpecialValueFor( "bone_damage" )
	self.bone_stun_duration = self:GetSpecialValueFor( "bone_stun_duration" )

	ParticleManager:DestroyParticle( self.nFXIndex, true )

	EmitSoundOnLocationWithCaster( vLocation, "OgreTank.GroundSmash", self:GetCaster() )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _,enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsAttackImmune() == false then
			local damage = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = self.bone_damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self,
			}

			EmitSoundOn( "Hero_Tiny.Tree.Target", enemy )
	
			ApplyDamage( damage )
			if enemy:IsAlive() == false then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
			else
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.bone_stun_duration } )
			end
		end
	end

	return true
end

--------------------------------------------------------------------------------