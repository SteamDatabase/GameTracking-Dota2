
modifier_aghsfort_pugna_grandmaster_netherblast_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_aghsfort_pugna_grandmaster_netherblast_thinker:OnCreated( kv )
	if IsServer() then
		self.bProcessDestruction = true
		self.max_rings = kv.max_rings
		self.preview_duration = kv.preview_duration
		self.current_ring = kv.ring_count
		self.ring_step = kv.ring_step
		self.ring_width = kv.ring_width
		self.damage = kv.damage
		self.ring_radius = self.ring_step * self.current_ring
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast_preview.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( self.ring_radius, self.ring_width, self.preview_duration ) )

		EmitSoundOn( "Hero_Pugna.NetherBlastPreCast", self:GetCaster() )
	end
end



--------------------------------------------------------------------------------

function modifier_aghsfort_pugna_grandmaster_netherblast_thinker:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end


----------------------------------------------------------------------------------------

function modifier_aghsfort_pugna_grandmaster_netherblast_thinker:OnDestroy()
	if IsServer() then
		if self:GetParent() ~= nil and self:GetCaster() ~= nil then
			if self.bProcessDestruction == true then
				ParticleManager:DestroyParticle( self.nPreviewFX, false )

				local nDamageFX = ParticleManager:CreateParticle( "particles/creatures/pugna_grandmaster/pugna_grandmaster_netherblast.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
				ParticleManager:SetParticleControl( nDamageFX, 0, self:GetParent():GetOrigin() )
				ParticleManager:SetParticleControl( nDamageFX, 1, Vector( self.ring_radius, self.ring_width, 0) )

				EmitSoundOn( "Hero_Pugna.NetherBlast", self:GetCaster() )


				local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.ring_radius + self.ring_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil then
						if (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length() >= self.ring_radius - self.ring_width then
							local damage = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = self.damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = self:GetAbility(),
							}
							ApplyDamage( damage )
						end
					end
				end


				if self.current_ring <= self.max_rings then
					local kv = {}
					kv[ "duration" ] = self.preview_duration
					kv[ "ring_count" ] = self.current_ring + 1
					kv[ "preview_duration" ] = self.preview_duration
					kv[ "max_rings" ] = self.max_rings
					kv[ "ring_step" ] = self.ring_step
					kv[ "ring_width" ] = self.ring_width
					kv[ "damage" ] = self.damage

					self.hThinker = CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_aghsfort_pugna_grandmaster_netherblast_thinker", kv, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_aghsfort_pugna_grandmaster_netherblast_thinker:OnDeath( params )
	if IsServer() then
		if params.unit ~= nil and params.unit == self:GetCaster() then
			self.bProcessDestruction = false
		end
	end
end

--------------------------------------------------------------------------------
