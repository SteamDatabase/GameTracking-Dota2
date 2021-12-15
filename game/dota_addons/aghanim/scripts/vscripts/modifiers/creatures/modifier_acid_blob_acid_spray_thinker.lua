modifier_acid_blob_acid_spray_thinker = class({})

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:OnCreated( kv )
	self:OnRefresh( kv )

	if IsServer() then
		EmitSoundOn( "Hero_Alchemist.AcidSpray", self:GetParent() )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/slime_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( self.radius, 1, 1 ) )
	end
end

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:OnRefresh( kv )
	if IsServer() then
		self.radius = self:GetParent().radius

		--self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )

		--print( 'modifier_acid_blob_acid_spray_thinker:OnRefresh( kv ) - tick_rate = ' .. self.tick_rate .. ', damage = ' .. self.damage .. ', radius = ' .. self.radius )

		--self:SetDuration( self.duration, true )
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
				end
			end

			EmitSoundOn( "Hero_Alchemist.AcidSpray.Damage", self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_acid_blob_acid_spray_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
		StopSoundOn( "Hero_Alchemist.AcidSpray", self:GetCaster() )

		self:GetParent():ForceKill( false )
		UTIL_Remove( self:GetParent() )
	end
end

