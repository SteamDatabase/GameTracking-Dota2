ogre_magi_area_ignite = class ({})
LinkLuaModifier( "modifier_ogre_magi_area_ignite_thinker", "modifiers/modifier_ogre_magi_area_ignite_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ogre_magi_area_ignite:OnSpellStart()
	if IsServer() then
		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_magi_area_ignite_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
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
			EmitSoundOn( "OgreMagi.Ignite.Cast", self:GetCaster() )
		end
	end
end

----------------------------------------------------------------------------------------

function ogre_magi_area_ignite:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.hThinker ~= nil then
			local hBuff = self.hThinker:FindModifierByName( "modifier_ogre_magi_area_ignite_thinker" )
			if hBuff ~= nil then
				hBuff:OnIntervalThink()
			end
			self.hThinker = nil;
		end
	end

	return true
end

----------------------------------------------------------------------------------------