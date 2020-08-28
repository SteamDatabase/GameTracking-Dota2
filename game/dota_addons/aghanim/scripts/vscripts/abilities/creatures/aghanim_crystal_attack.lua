aghanim_crystal_attack = class({})

_G.CRYSTAL_ATTACKS_PHASE = {}
_G.CRYSTAL_ATTACKS_PHASE[1] = 0
_G.CRYSTAL_ATTACKS_PHASE[2] = 1
_G.CRYSTAL_ATTACKS_PHASE[3] = 2
_G.CRYSTAL_ATTACKS_PHASE[4] = 0
_G.CRYSTAL_ATTACKS_PHASE[5] = 1
_G.CRYSTAL_ATTACKS_PHASE[6] = 2


_G.CRYSTAL_ATTACKS_COOLDOWN = 10.0


LinkLuaModifier( "modifier_aghanim_crystal_attack_active", "modifiers/creatures/modifier_aghanim_crystal_attack_active", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aghanim_crystal_attack_debuff", "modifiers/creatures/modifier_aghanim_crystal_attack_debuff", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function aghanim_crystal_attack:Precache( context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_attack.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_attack_telegraph.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_crystal_attack_impact.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_iceblast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mars.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_self_dmg.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_pulse_nova.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/aghanim/aghanim_pulse_ambient.vpcf", context )	
	self.nPhase = 1
end

--------------------------------------------------------------------------------

function aghanim_crystal_attack:OnSpellStart()
	if IsServer() then
		if self.nPhase == 1 then
			self.hActiveBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_aghanim_crystal_attack_active", {} )
		end

		self.attack_time = self:GetSpecialValueFor( "attack_time" )
		self.attack_damage = self:GetSpecialValueFor( "attack_damage" ) 
		self.explosion_radius = self:GetSpecialValueFor( "explosion_radius" ) 
		self.pulse_radius = self:GetSpecialValueFor( "pulse_radius" ) 

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 10000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false )
		
		local nCrystalsLeft = CRYSTAL_ATTACKS_PHASE[ self.nPhase ] + 1
		for _,enemy in pairs( enemies ) do
			local flDist = ( enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin() ):Length2D()
			if flDist > self.pulse_radius then
				self:LaunchCrystals( enemy:GetAbsOrigin() + ( enemy:GetForwardVector() * self.pulse_radius * 0.5 ) )
				nCrystalsLeft = nCrystalsLeft - 1
				if nCrystalsLeft == 0 then
					break
				end
			end
		end

		self.nPhase = self.nPhase + 1
		if self.hActiveBuff then
			self.hActiveBuff:Pulse()
		end
		
		if self.nPhase > 6 then
			self.nPhase = 1
			self:StartCooldown( CRYSTAL_ATTACKS_COOLDOWN )
			self.hActiveBuff:Destroy()
		end	
	end
end

--------------------------------------------------------------------------------

function aghanim_crystal_attack:LaunchCrystals( vPos )
	local vDirection = vPos - self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_staff_fx" ) )
	local flDist2d = vDirection:Length2D()
	local flDist = vDirection:Length()
	vDirection = vDirection:Normalized()
	vDirection.z = 0.0

	local flSpeed = flDist / self.attack_time

	local info = 
	{
		EffectName = "particles/creatures/aghanim/aghanim_crystal_attack.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_staff_fx" ) ), 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * flSpeed,
		fDistance = flDist2d,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn( "Hero_Winter_Wyvern.SplinterBlast.Splinter", self:GetCaster() )

	local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_crystal_attack_telegraph.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.explosion_radius, self.attack_time, self.attack_time ) )
	ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 214, 236, 239 ) )
	ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

--------------------------------------------------------------------------------

function aghanim_crystal_attack:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			return false
		end

		local knockback_duration = self:GetSpecialValueFor( "knockback_duration" )
		local knockback_distance = self:GetSpecialValueFor( "knockback_distance" )
		local knockback_height = self:GetSpecialValueFor( "knockback_height" )
		local debuff_duration = self:GetSpecialValueFor( "debuff_duration" )
	
		local vPosOnGround = GetGroundPosition( vLocation, self:GetCaster() )

		EmitSoundOnLocationWithCaster( vPosOnGround, "Hero_Winter_Wyvern.SplinterBlast.Target", self:GetCaster() )

		local nDetonationFX = ParticleManager:CreateParticle( "particles/creatures/aghanim/aghanim_crystal_attack_impact.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nDetonationFX, 0, vPosOnGround )
		ParticleManager:SetParticleControl( nDetonationFX, 1, Vector( self.explosion_radius, self.explosion_radius, self.explosion_radius ) )
		ParticleManager:ReleaseParticleIndex( nDetonationFX )


		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vPosOnGround, nil, self.explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false then
				local kv =
				{
					center_x = vPosOnGround.x,
					center_y = vPosOnGround.y,
					center_z = vPosOnGround.z,
					should_stun = true, 
					duration = knockback_duration,
					knockback_duration = knockback_duration,
					knockback_distance = knockback_distance,
					knockback_height = knockback_height,
				}
				
				enemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv )
				--enemy:AddNewModifier( self:GetCaster(), self, "modifier_aghanim_crystal_attack_debuff", { duration = debuff_duration } )	

				local damage = {
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.attack_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = self
				}
		
				ApplyDamage( damage )
			end
		end
	end

	return true	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------