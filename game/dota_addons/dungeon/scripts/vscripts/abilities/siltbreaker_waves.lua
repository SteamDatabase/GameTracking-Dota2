
siltbreaker_waves = class({})
LinkLuaModifier( "modifier_siltbreaker_waves", "modifiers/modifier_siltbreaker_waves", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_waves:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_waves:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle( "particles/act_2/siltbreaker_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		--EmitSoundOn( "SandKingBoss.Epicenter.spell", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_waves:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

--------------------------------------------------------------------------------

function siltbreaker_waves:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end

--------------------------------------------------------------------------------

function siltbreaker_waves:OnSpellStart()
	if IsServer() then
		self.Projectiles = {}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_waves", {} )
	end
end

-------------------------------------------------------------------------------

function siltbreaker_waves:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_waves" )

		ParticleManager:DestroyParticle( self.nChannelFX, false )
	end
end

-------------------------------------------------------------------------------

function siltbreaker_waves:OnProjectileThinkHandle( nProjectileHandle )
	if IsServer() then
		local projectile = nil
		for _, proj in pairs( self.Projectiles ) do
			if proj ~= nil and proj.handle == nProjectileHandle then
				projectile = proj
			end
		end

		--[[
		if projectile ~= nil then
			local flRadius = ProjectileManager:GetLinearProjectileRadius( nProjectileHandle )
			ParticleManager:SetParticleControl( projectile.nFXIndex, 2, Vector( flRadius, flRadius, 0 ) )
		end	
		]]
	end
end

--------------------------------------------------------------------------------

function siltbreaker_waves:OnProjectileHitHandle( hTarget, vLocation, nProjectileHandle )
	if IsServer() then
		if hTarget ~= nil and hTarget ~= self:GetCaster() then
			local projectile_radius = self:GetSpecialValueFor( "projectile_radius" )

			local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self:GetCaster(), projectile_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy ~= nil and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
					local kv =
					{
						center_x = vLocation.x,
						center_y = vLocation.y,
						center_z = vLocation.z,
						should_stun = true, 
						duration = 0.25,
						knockback_duration = 0.25,
						knockback_distance = 250,
						knockback_height = 125,
					}
					hEnemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", kv )

					local damageInfo =
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						damage = self:GetSpecialValueFor( "damage" ),
						damage_type = self:GetAbilityDamageType(),
						ability = self,
					}
					ApplyDamage( damageInfo )
				end
			end

			EmitSoundOn( "Siltbreaker.Waves.Impact", hTarget )
		end

		local projectile = nil
		for _, proj in pairs( self.Projectiles ) do
			if proj ~= nil and proj.handle == nProjectileHandle then
				projectile = proj
			end
		end

		--[[
		if projectile ~= nil then
			ParticleManager:DestroyParticle( projectile.nFXIndex, false )
		end	
		]]
	end

	return false
end

--------------------------------------------------------------------------------

