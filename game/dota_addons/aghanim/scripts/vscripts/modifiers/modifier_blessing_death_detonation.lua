require( "modifiers/modifier_blessing_base" )

modifier_blessing_death_detonation = class( modifier_blessing_base )

-------------------------------------------------------------------------------

function modifier_blessing_death_detonation:OnBlessingCreated( kv )
	self.detonation_damage_per_level = kv.detonation_damage_per_level
	self.detonation_radius = kv.detonation_radius
end

--------------------------------------------------------------------------------

function modifier_blessing_death_detonation:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_blessing_death_detonation:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.unit ~= nil and params.unit == self:GetParent() then

			local damage = self.detonation_damage_per_level * self:GetParent():GetLevel()
			--print( 'modifier_blessing_death_detonation damage = ' .. damage )

			local nTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
			local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.detonation_radius, nTeam, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

			if #entities > 0 then
				for _,entity in pairs(entities) do
					if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and ( not entity:IsMagicImmune() ) and ( not entity:IsInvulnerable() ) then
						local DamageInfo =
						{
							victim = entity,
							attacker = self:GetCaster(),
							ability = self,
							damage = damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}
						ApplyDamage( DamageInfo )
					end
				end
			end

			--EmitSoundOn( "Ability.Bomber.Detonate", self:GetParent() )

			local nFXIndex = ParticleManager:CreateParticle( "particles/blessings/death_detonation/death_detonation_remote_mines_detonate.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.detonation_radius, self.detonation_radius, self.detonation_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end
