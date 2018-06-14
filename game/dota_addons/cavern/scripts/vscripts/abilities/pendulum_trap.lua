pendulum_trap = class({})

--------------------------------------------------------------------------------

function pendulum_trap:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_1
end

--------------------------------------------------------------------------------

function pendulum_trap:OnChannelThink( flInterval )
	if IsServer() then
		if self.damage == nil then
			self.damage = self:GetSpecialValueFor( "damage" )
			self.radius = self:GetSpecialValueFor( "radius" )
			self.attachAttack1 = self:GetCaster():ScriptLookupAttachment( "attach_hitloc" )
			self.attachAttack2 = self:GetCaster():ScriptLookupAttachment( "attach_leftblade" )
			self.attachAttack3 = self:GetCaster():ScriptLookupAttachment( "attach_rightblade" )
		end

		local flCycle = self:GetCaster():GetCycle()
		if ( flCycle > 0.15 and flCycle < 0.28 ) or ( flCycle > 0.70 and flCycle < 0.83 ) then
			local Locations = {  self:GetCaster():GetAttachmentOrigin( self.attachAttack2 ), self:GetCaster():GetAttachmentOrigin( self.attachAttack3 )}
			for i=1,#Locations do 
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), Locations[i], self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				--DebugDrawCircle( Locations[i], Vector( 0, 255, 0 ), 255, self.radius, false, 0.1 )
				for _,enemy in pairs( enemies ) do
					if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsInvulnerable() == false then
						local damageInfo = 
						{
							victim = enemy,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = self,
						}

						ApplyDamage( damageInfo )
						if not ( enemy:IsNull() ) and enemy ~= nil and enemy:IsAlive() == false then
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
			
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
