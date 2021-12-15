
golem_tower_boulder_toss = class ({})
LinkLuaModifier( "modifier_golem_tower_boulder_toss_thinker", "modifiers/creatures/modifier_golem_tower_boulder_toss_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function golem_tower_boulder_toss:Precache( context )

	PrecacheResource( "particle", "particles/neutral_fx/mud_golem_hurl_boulder.vpcf", context )
	PrecacheResource( "particle", "particles/neutral_fx/black_dragon_fireball.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/golem_tower/boulder_toss_ground_preview.vpcf", context )

end

----------------------------------------------------------------------------------------

function golem_tower_boulder_toss:OnSpellStart()
	if IsServer() then
		self.vTargetLoc = self:GetCursorPosition()
		local flGroundHeight = GetGroundHeight( self.vTargetLoc, nil )
		self.vTargetLoc.z = flGroundHeight + 50
		local nRadius = 275
		local nDestinationRadius = nRadius / 2
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/golem_tower/boulder_toss_ground_preview.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self.vTargetLoc )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( nDestinationRadius, nDestinationRadius, nDestinationRadius ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 190, 6, 215 ) )

		self.hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_golem_tower_boulder_toss_thinker", { duration = -1 }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
		if self.hThinker ~= nil then
			local projectile =
			{
				Target = self.hThinker,
				Source = self:GetCaster(),
				Ability = self,
				EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
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

function golem_tower_boulder_toss:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if self.hThinker ~= nil then
			local hBuff = self.hThinker:FindModifierByName( "modifier_golem_tower_boulder_toss_thinker" )
			if hBuff ~= nil then
				hBuff:OnIntervalThink()
			end
			self.hThinker = nil;
		end
	end

	return true
end

----------------------------------------------------------------------------------------