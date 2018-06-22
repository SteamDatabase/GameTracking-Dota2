modifier_creature_techies_land_mine = class({})

--------------------------------------------------------------------------------

function modifier_creature_techies_land_mine:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.activation_delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		--self.proximity_threshold = self:GetAbility():GetSpecialValueFor( "proximity_threshold" )

		self:StartIntervalThink( self.activation_delay )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_techies_land_mine:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_creature_techies_land_mine:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 0, false )
		if #enemies > 0 then
			for _, enemy in pairs( enemies ) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
					local DamageInfo =
					{
						victim = enemy,
						attacker = self:GetParent(),
						ability = self:GetAbility(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
					ApplyDamage( DamageInfo )
				end
			end
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		--EmitSoundOn( "TreasureChest.MineTrap.Detonate", self:GetParent() )
		self:GetParent():ForceKill( false )
	end
end