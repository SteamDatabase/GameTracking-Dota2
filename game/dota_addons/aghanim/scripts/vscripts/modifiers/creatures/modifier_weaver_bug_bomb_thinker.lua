modifier_weaver_bug_bomb_thinker = class({})

------------------------------------------------------------------

function modifier_weaver_bug_bomb_thinker:IsHidden()
	return true
end

------------------------------------------------------------------

function modifier_weaver_bug_bomb_thinker:IsPurgable() 
	return false
end

------------------------------------------------------------------

function modifier_weaver_bug_bomb_thinker:OnCreated( kv )
	if IsServer() and self:GetAbility() == nil then
		self:Destroy()
		UTIL_Remove( self:GetParent() )
		return
	end

	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.delay, self.delay, self.delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:StartIntervalThink( self.delay )
	end
end

------------------------------------------------------------------

function modifier_weaver_bug_bomb_thinker:OnIntervalThink()
	if IsServer() then
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Pugna.NetherBlast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/weaver/weaver_bug_bomb_detonation.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() + Vector( 0, 0, 40 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster() or self:GetParent(), -- caster might be dead, but parent thinker probably can't be
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}

				ApplyDamage( damageInfo )
				enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_weaver_bug_bomb", { duration = self.stun_duration } )
			end
		end

		self:Destroy()
		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------