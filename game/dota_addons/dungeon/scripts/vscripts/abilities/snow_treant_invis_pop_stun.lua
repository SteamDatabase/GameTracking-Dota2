snow_treant_invis_pop_stun = class({})

--------------------------------------------------------------------------------

function snow_treant_invis_pop_stun:OnSpellStart()
	if IsServer() then
		local modifier_params = {duration = self:GetSpecialValueFor( "root_duration" ), damage = 0}
		self.radius = self:GetSpecialValueFor( "root_radius" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				if enemy:IsAlive() then
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_treant_overgrowth", modifier_params)

					local trailFx = ParticleManager:CreateParticle( "particles/units/heroes/hero_treant/treant_overgrowth_trails.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
					ParticleManager:SetParticleControl( trailFx, 0, self:GetCaster():GetOrigin())
					ParticleManager:SetParticleControl( trailFx, 1, enemy:GetOrigin())
					ParticleManager:ReleaseParticleIndex(trailFx)
				end
			end
		end
	end
end

