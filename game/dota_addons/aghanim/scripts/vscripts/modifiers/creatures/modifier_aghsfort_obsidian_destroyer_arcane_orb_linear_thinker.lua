
modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker = class({})

----------------------------------------------------------------------------------------

function modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + kv[ "bonus_radius" ]
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self:GetRemainingTime(), 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		
	end
end

----------------------------------------------------------------------------------------

function modifier_aghsfort_obsidian_destroyer_arcane_orb_linear_thinker:OnDestroy()
	if IsServer() then
		EmitSoundOn( "Hero_ObsidianDestroyer.ArcaneOrb.Impact", self:GetParent() )
		
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.radius, 1 ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

		if #entities > 0 then
			for _,entity in pairs(entities) do
				if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and ( not entity:IsMagicImmune() ) and ( not entity:IsInvulnerable() ) then
					local DamageInfo =
					{
						victim = entity,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PURE,
					}
					ApplyDamage( DamageInfo )

					local nFXIndexDamage = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, entity )
					ParticleManager:SetParticleControl( nFXIndexDamage, 1, self:GetParent():GetAbsOrigin() );
					ParticleManager:ReleaseParticleIndex( nFXIndexDamage );
				end
			end
		end

		UTIL_Remove( self:GetParent() )
	end
end

----------------------------------------------------------------------------------------