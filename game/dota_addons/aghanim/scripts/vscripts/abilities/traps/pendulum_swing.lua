
pendulum_swing = class({})

--------------------------------------------------------------------------------

function pendulum_swing:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
	PrecacheResource( "particle", "particles/econ/courier/courier_mechjaw/mechjaw_death_sparks.vpcf", context )

	self.HitEntsThisSwing = {}
	self.bDamagePathOutgoing = false
	self.bDamagePathReturning = false
end

--------------------------------------------------------------------------------

function pendulum_swing:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function pendulum_swing:OnChannelThink( flInterval )
	if IsServer() then
		if self.max_hp_pct_damage == nil then
			self.max_hp_pct_damage = self:GetLevelSpecialValueFor( "max_hp_pct_damage", GameRules.Aghanim:GetAscensionLevel() )
			--printf( "ascension level: %d; percent damage: %d", GameRules.Aghanim:GetAscensionLevel(), self.max_hp_pct_damage )
			self.radius = self:GetSpecialValueFor( "radius" )
			self.attachHitloc = self:GetCaster():ScriptLookupAttachment( "attach_hitloc" )
			self.attachLeftBlade = self:GetCaster():ScriptLookupAttachment( "attach_leftblade" )
			self.attachRightBlade = self:GetCaster():ScriptLookupAttachment( "attach_rightblade" )
			self.attachFrontBlade = self:GetCaster():ScriptLookupAttachment( "attach_frontblade" )
			self.attachBackBlade = self:GetCaster():ScriptLookupAttachment( "attach_backblade" )
		end

		-- We're checking which part of the pendulum_swing_loop animation we're in.
		local flCycle = self:GetCaster():GetCycle()
		local bDamagePathOutgoing = ( flCycle > 0.19 and flCycle < 0.26 )
		local bDamagePathReturning = ( flCycle > 0.69 and flCycle < 0.76 )
		if self.bDamagePathOutgoing ~= bDamagePathOutgoing then
			self.bDamagePathOutgoing = bDamagePathOutgoing
			self.HitEntsThisSwing = {}
		end
		if self.bDamagePathReturning ~= bDamagePathReturning then
			self.bDamagePathReturning = bDamagePathReturning
			self.HitEntsThisSwing = {}
		end

		if bDamagePathOutgoing or bDamagePathReturning then
			if ( flCycle > 0.15 and flCycle < 0.16 ) or ( flCycle > 0.70 and flCycle < 0.71 ) then
				-- Ugly: we're relying on the speed of the pendulum and the length of our channelthink interval in order to not play this sound more than once per outgoing or returning swing
				EmitSoundOn( "Pendulum.Swing", self:GetCaster() )
			end

			local Locations = {
				self:GetCaster():GetAttachmentOrigin( self.attachHitloc ),
				self:GetCaster():GetAttachmentOrigin( self.attachLeftBlade ),
				self:GetCaster():GetAttachmentOrigin( self.attachRightBlade ),
				self:GetCaster():GetAttachmentOrigin( self.attachFrontBlade ),
				self:GetCaster():GetAttachmentOrigin( self.attachBackBlade ),
			}

			

			for i = 1, #Locations do 
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), Locations[i], self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				--DebugDrawCircle( Locations[i], Vector( 0, 255, 0 ), 255, self.radius, false, 0.1 )
				for _,enemy in pairs( enemies ) do
					local bAlreadyHit = false
					for _,HitEnt in pairs ( self.HitEntsThisSwing ) do
						if HitEnt == enemy then
							bAlreadyHit = true
							break
						end
					end

					if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsInvulnerable() == false and not bAlreadyHit then
						local fMaxHealth = enemy:GetMaxHealth()
						local fDamage = math.ceil( fMaxHealth * ( self.max_hp_pct_damage / 100.0 ) )
						--printf( "pendulum_swing:OnChannelThink - applying %.2f damage to target with %.2f max health", fDamage, fMaxHealth )

						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetCaster(),
							damage = fDamage,
							damage_type = DAMAGE_TYPE_PURE,
							ability = self,
						}

						table.insert( self.HitEntsThisSwing, enemy )

						ApplyDamage( damageInfo )
						if not ( enemy:IsNull() ) and enemy ~= nil then
							local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
							ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
							ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
							ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )

							EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
						end
					end
				end


			end

			local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/courier/courier_mechjaw/mechjaw_death_sparks.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_leftblade", self:GetCaster():GetOrigin(), true )

			local nFXIndex3 = ParticleManager:CreateParticle( "particles/econ/courier/courier_mechjaw/mechjaw_death_sparks.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex3, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_rightblade", self:GetCaster():GetOrigin(), true )
		end
	end
end

--------------------------------------------------------------------------------
