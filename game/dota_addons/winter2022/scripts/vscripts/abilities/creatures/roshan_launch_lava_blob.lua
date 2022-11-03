require( "winter2022_utility_functions" )

roshan_launch_lava_blob = class({})
LinkLuaModifier( "modifier_roshan_launch_lava_blob_ground_thinker", "modifiers/creatures/modifier_roshan_launch_lava_blob_ground_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_roshan_launch_lava_blob_slow", "modifiers/creatures/modifier_roshan_launch_lava_blob_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/greevil_orange_lava_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/greevil_orange_lava_calldown_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_magma.vpcf", context )
	PrecacheResource( "particle", "particles/hw_fx/greevil_orange_lava_puddle.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/tower_launch_mortar.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/tower_mortar_marker.vpcf", context )
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:GetAOERadius()
	if self.impact_radius == nil then
		self.impact_radius = self:GetSpecialValueFor( "impact_radius" )
	end
	return self.impact_radius
end 

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:RequiresFacing()
	return false
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:OnSpellStart()
	if IsServer() == false then
		return
	end

	self.impact_radius = self:GetSpecialValueFor( "impact_radius" )
	self.impact_damage = self:GetSpecialValueFor( "impact_damage" ) 
	self.magma_duration = self:GetSpecialValueFor( "magma_duration" )
	self.damage_mult_per_min = self:GetSpecialValueFor( "damage_mult_per_min" )

	local vTargetPos = self:GetCursorPosition()
	local vDirection = vTargetPos - self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) )
	--local vDirection = vTargetPos - self:GetCaster():GetAbsOrigin()
	local flDist2d = vDirection:Length2D()
	vDirection = vDirection:Normalized()
	vDirection.z = 0.0

	local min_air_time = self:GetSpecialValueFor( "min_air_time" )
	local max_air_time = self:GetSpecialValueFor( "max_air_time" ) 
	local flMinDist = 0
	local flMaxDist = 5000
	local flAirTime = RemapValClamped( flDist2d, flMinDist, flMaxDist, min_air_time, max_air_time )

	local flSpeed = flDist2d / flAirTime

	local nFXIndex = ParticleManager:CreateParticle( "particles/hw_fx/greevil_orange_lava_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false )
	ParticleManager:SetParticleControl( nFXIndex, 1, vTargetPos );
	ParticleManager:SetParticleControl( nFXIndex, 2, Vector( flSpeed, 0, 0 ) )
	ParticleManager:SetParticleControlEnt( nFXIndex, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetAbsOrigin(), false )

	local nMarkerFX = ParticleManager:CreateParticle( "particles/hw_fx/greevil_orange_lava_calldown_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nMarkerFX, 0, self:GetCursorPosition() )
	ParticleManager:SetParticleControl( nMarkerFX, 1, Vector( self.impact_radius, -self.impact_radius, -self.impact_radius ) )
	ParticleManager:SetParticleControl( nMarkerFX, 2, Vector( flAirTime, 0, 0 ) )
	ParticleManager:SetParticleControl( nMarkerFX, 3, Vector( 1.0, 0.3, 0.2 ) )
	--ParticleManager:ReleaseParticleIndex( nMarkerFX )

	local info = 
	{
		EffectName = nil,
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAttachmentOrigin( self:GetCaster():ScriptLookupAttachment( "attach_hitloc" ) ), 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * flSpeed,
		fDistance = flDist2d,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
		iUnitTargetType = DOTA_UNIT_TYPE_NONE,
        ExtraData = { fx_index = nFXIndex, marker_fx_index = nMarkerFX },
	}

	ProjectileManager:CreateLinearProjectile( info )

	EmitSoundOn( "Hero_Snapfire.MortimerBlob.Launch", self:GetCaster() )
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:OnProjectileHit_ExtraData( hTarget, vLocation, kv )
	if IsServer() then
		if hTarget == nil then
			ParticleManager:DestroyParticle( kv.fx_index, false )
			ParticleManager:DestroyParticle( kv.marker_fx_index, false )

			local fDamage = self.impact_damage * ( 1.0 + ( (GameRules:GetGameTime() / 60) * self.damage_mult_per_min ) )
			--printf( 'DAMAGE = %f, DAMAGE WITH TIME MULT = %f', self.impact_damage, fDamage )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy:IsMagicImmune() == false and IsGreevil( enemy ) == false then

					local damage = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = fDamage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self
					}
			
					ApplyDamage( damage )

				end
			end

			local vGroundPos = GetGroundPosition( vLocation, self:GetCaster() )
			local kv = {}
			kv[ "duration" ] = self.magma_duration
			CreateModifierThinker( self:GetCaster(), self, "modifier_roshan_launch_lava_blob_ground_thinker", kv, vGroundPos, self:GetCaster():GetTeamNumber(), false )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 3, vGroundPos )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			--local nFXIndex2 = ParticleManager:CreateParticle( "particles/neutral_fx/tower_launch_mortar.vpcf", PATTACH_WORLDORIGIN, nil )
			--ParticleManager:SetParticleControl( nFXIndex2, 0, vGroundPos )
			--ParticleManager:SetParticleControl( nFXIndex2, 1, vGroundPos )
			--ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( self.magma_duration, 0, 0 ) )
			--ParticleManager:ReleaseParticleIndex( nFXIndex2 )

			--AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, self.impact_radius, self.magma_duration, false )
		end
	end

	return true
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:GetUpgradeBuildingName()
	return "npc_dota_spring2021_ability_building"
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:GetBuildingType()
	return "mortar"
end

--------------------------------------------------------------------------------

function roshan_launch_lava_blob:CreateAbilityReadyParticle( hBuilding )
	local nFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced_model.vpcf", PATTACH_CUSTOMORIGIN, hBuilding )
	ParticleManager:SetParticleControlEnt( nFX, 3, hBuilding, PATTACH_POINT, "attach_hitloc", hBuilding:GetAbsOrigin(), false )
	return nFX
end
