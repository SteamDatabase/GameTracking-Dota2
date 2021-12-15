modifier_aghslab_night_stalker_void_thinker = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "ministun" )
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	if IsServer() then
		self:StartIntervalThink( self.delay )

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "n_creep_SatyrHellcaller.Shockwave", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( delay, delay, delay ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_aghslab_night_stalker_void_thinker:OnIntervalThink()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_aghslab_night_stalker_void", { duration = self.stun_duration } )
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/nightstalker/nightstalker_ti10_silence/nightstalker_ti10_aura_burst_ringdark.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Nightstalker.Void", self:GetCaster() )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------