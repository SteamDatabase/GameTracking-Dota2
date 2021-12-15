
modifier_aghslab_centaur_double_edge_thinker = class({})

--------------------------------------------------------------------------------

function modifier_aghslab_centaur_double_edge_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_aghslab_centaur_double_edge_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
	if IsServer() then
		self:StartIntervalThink( self.delay )

		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Hero_Centaur.DoubleEdge.Precast.TI9", self:GetCaster() )

	end
end

--------------------------------------------------------------------------------

function modifier_aghslab_centaur_double_edge_thinker:OnIntervalThink()
	if IsServer() then
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_2 )
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
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/centaur/centaur_ti9/centaur_double_edge_ti9.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, 1, 1 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Centaur.DoubleEdge", self:GetCaster() )

		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

