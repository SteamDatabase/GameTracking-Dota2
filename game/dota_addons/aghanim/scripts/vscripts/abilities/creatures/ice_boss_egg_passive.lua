ice_boss_egg_passive = class({})
LinkLuaModifier( "modifier_ice_boss_egg_passive", "modifiers/creatures/modifier_ice_boss_egg_passive", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ice_boss_egg_passive:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_iceblast_half.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_overhead.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf", context )

	PrecacheUnitByNameSync( "npc_dota_creature_baby_ice_dragon", context, -1 )
end

--------------------------------------------------------------------------------

function ice_boss_egg_passive:GetIntrinsicModifierName()
	return "modifier_ice_boss_egg_passive"
end

--------------------------------------------------------------------------------

function ice_boss_egg_passive:LaunchHatchProjectile( caster )
	if IsServer() then

		local info = {
			Target = self:GetCaster(),
			Source = caster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc = caster:GetOrigin(),
			bDodgeable = false,
			bProvidesVision = false,
		}

		ProjectileManager:CreateTrackingProjectile( info )
	end
end

--------------------------------------------------------------------------------

function ice_boss_egg_passive:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			if hTarget == self:GetCaster() then
				local hatch_time = self:GetSpecialValueFor( "hatch_time" )
				local hBuff = self:GetCaster():FindModifierByName( "modifier_ice_boss_egg_passive" )
				if hBuff ~= nil and hBuff.bHatching == false then
					hBuff:StartIntervalThink( hatch_time )

					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
					ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true )
					hBuff:AddParticle( nFXIndex, false, false, -1, false, false )
				end
			else
				hTarget:AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_egg_curse_marker", { duration = 15 } )
			end
		end
	end
	return true
end