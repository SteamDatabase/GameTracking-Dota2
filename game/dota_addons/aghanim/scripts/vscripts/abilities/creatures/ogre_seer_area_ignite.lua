
ogre_seer_area_ignite = class ({})
LinkLuaModifier( "modifier_ogre_seer_area_ignite_thinker", "modifiers/creatures/modifier_ogre_seer_area_ignite_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ogre_seer_area_ignite:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/black_dragon_fireball.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
end

----------------------------------------------------------------------------------------

function ogre_seer_area_ignite:OnSpellStart()
	if IsServer() then
		local vTargetPositions = { }
		vTargetPositions[ 1 ] = self:GetCursorPosition()
		vTargetPositions[ 2 ] = self:GetCursorPosition() + RandomVector( RandomFloat( 250, 300 ) )
		vTargetPositions[ 3 ] = self:GetCursorPosition() + RandomVector( RandomFloat( 250, 300 ) )

		self.hThinkers = { }

		for i, vTargetPos in ipairs( vTargetPositions ) do
			self.hThinkers[ i ] = CreateModifierThinker( self:GetCaster(), self, "modifier_ogre_seer_area_ignite_thinker", { duration = -1 }, vTargetPos, self:GetCaster():GetTeamNumber(), false )
			if self.hThinkers[ i ] ~= nil then
				local projectile =
				{
					Target = self.hThinkers[ i ],
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
end

----------------------------------------------------------------------------------------

function ogre_seer_area_ignite:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		for i, hThinker in pairs( self.hThinkers ) do
			if hThinker ~= nil then
				local hBuff = hThinker:FindModifierByName( "modifier_ogre_seer_area_ignite_thinker" )
				if hBuff ~= nil then
					hBuff:OnIntervalThink()
				end
				hThinker = nil;
			end
		end
	end

	return true
end

----------------------------------------------------------------------------------------
