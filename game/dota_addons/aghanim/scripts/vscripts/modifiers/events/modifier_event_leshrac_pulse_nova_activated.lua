
modifier_event_leshrac_pulse_nova_activated = class( {} )

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_activated:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_activated:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_activated:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.int_mult_for_damage = self:GetAbility():GetSpecialValueFor( "int_mult_for_damage" )

		self.nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

		EmitSoundOn( "Event_Leshrac.Pulse_Nova", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_event_leshrac_pulse_nova_activated:OnDestroy()
	if not IsServer() then
		return
	end

	local enemies = Util_FindEnemiesAroundUnit( self:GetParent(), self.radius, true )

	for _, enemy in pairs( enemies ) do
		if enemy ~= nil and enemy:IsMagicImmune() == false and enemy:IsInvulnerable() == false then
			local fDamage = self.int_mult_for_damage * self:GetParent():GetIntellect()
			local damageInfo = 
			{
				victim = enemy,
				attacker = self:GetParent(),
				damage = fDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			}
			ApplyDamage( damageInfo )

			local nStrikeFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
			ParticleManager:ReleaseParticleIndex( nStrikeFX )

			EmitSoundOn( "Event_Leshrac.Pulse_Nova_Strike", enemy )
		end
	end

	ParticleManager:DestroyParticle( self.nCasterFX, false )

	StopSoundOn( "Event_Leshrac.Pulse_Nova", self:GetParent() )
end

--------------------------------------------------------------------------------
