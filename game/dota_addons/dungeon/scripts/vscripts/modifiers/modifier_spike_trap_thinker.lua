
modifier_spike_trap_thinker = class({})

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker:OnCreated( kv )
	self.trap_radius = self:GetAbility():GetSpecialValueFor( "trap_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.stun_duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	self.delay_time = self:GetAbility():GetSpecialValueFor( "delay_time" )

	if IsServer() then
		self:StartIntervalThink( self.delay_time )

		EmitSoundOn( "SpikeTrap.PreActivate", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function modifier_spike_trap_thinker:OnIntervalThink()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.trap_radius, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.trap_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_spike_trap", { duration = self.stun_duration } )
				end
			end
		end

		EmitSoundOn( "SpikeTrap.Activate", self:GetCaster() )
		
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

