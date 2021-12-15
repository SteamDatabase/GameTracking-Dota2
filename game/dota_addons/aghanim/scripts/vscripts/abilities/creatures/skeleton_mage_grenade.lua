
skeleton_mage_grenade = class ({})
LinkLuaModifier( "modifier_skeleton_mage_grenade", "modifiers/creatures/modifier_skeleton_mage_grenade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_mage_grenade_thinker", "modifiers/creatures/modifier_skeleton_mage_grenade_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function skeleton_mage_grenade:Precache( context )
	PrecacheResource( "particle", "particles/creatures/creature_spell_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/black_dragon_fireball.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
end

----------------------------------------------------------------------------------------

function skeleton_mage_grenade:OnSpellStart()
	if IsServer() then
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_skeleton_mage_grenade_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
		if self.hThinker ~= nil then
			local projectile =
			{
				Target = self.hThinker,
				Source = self:GetCaster(),
				Ability = self,
				EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf",
				iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
				vSourceLoc = self:GetCaster():GetOrigin(),
				bDodgeable = false,
				bProvidesVision = false,
			}

			ProjectileManager:CreateTrackingProjectile( projectile )

			EmitSoundOn( "SkeletonMage.Grenade.Cast", self:GetCaster() )
		end
	end
end

----------------------------------------------------------------------------------------

function skeleton_mage_grenade:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.hThinker ~= nil then
			local hBuff = self.hThinker:FindModifierByName( "modifier_skeleton_mage_grenade_thinker" )
			if hBuff ~= nil then
				hBuff:OnIntervalThink()
			end
			self.hThinker = nil;
		end
	end

	return true
end

----------------------------------------------------------------------------------------
