
modifier_storegga_ground_pound_thinker = class({})

--------------------------------------------------------------------------------

function modifier_storegga_ground_pound_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_storegga_ground_pound_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_storegga_ground_pound_thinker:OnCreated( kv )
	if IsServer() then
		self.pound_interval = self:GetAbility():GetSpecialValueFor( "pound_interval" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.movespeed_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )

		self.fTimeStarted = GameRules:GetGameTime()

		self:OnIntervalThink()
		self:StartIntervalThink( self.pound_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_storegga_ground_pound_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			self:Destroy()
			return
		end

		--print( string.format( "OnIntervalThink - time is: %.2f", GameRules:GetGameTime() ) )

		local vThinkerPos = self:GetParent():GetAbsOrigin()
		local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vThinkerPos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, hEnemy in pairs( hEnemies ) do
			if hEnemy ~= nil and hEnemy:IsInvulnerable() == false and hEnemy:IsMagicImmune() == false then
				local damageInfo =
				{
					victim = hEnemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )

				if hEnemy:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, hEnemy:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, hEnemy, PATTACH_ABSORIGIN_FOLLOW, nil, hEnemy:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "BloodSplatterImpact", hEnemy )
				else
					local kv = {
						movespeed_slow = self.movespeed_slow,
						duration = self.slow_duration,
					}
					hEnemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", kv )
				end
			end
		end

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "OgreTank.GroundSmash", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster()  )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleFoWProperties( nFXIndex, 0, -1, self.radius )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )

		for i=1,2 do 
			local hTiny = CreateUnitByName( "npc_dota_creature_small_storegga", vThinkerPos, true, self:GetParent(), self:GetParent():GetOwner(), self:GetParent():GetTeamNumber() )
			if hTiny ~= nil then
				hTiny:SetControllableByPlayer( self:GetParent():GetPlayerOwnerID(), false )
				hTiny:SetOwner( self:GetParent() )
				hTiny.bBossMinion = true
				if self:GetParent().Encounter then
					self:GetParent().Encounter:SuppressRewardsOnDeath( hTiny )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
