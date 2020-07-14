
modifier_baby_broodmother_passive = class({})

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.landing_damage = self:GetAbility():GetSpecialValueFor( "landing_damage" )
		self.launch_duration = self:GetAbility():GetSpecialValueFor( "launch_duration" )
		self.knockback_duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
		self.knockback_distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
		self.knockback_height = self:GetAbility():GetSpecialValueFor( "knockback_height" )

		self:StartIntervalThink( self.launch_duration ) -- this is hacky: launch duration (0.75) matches the enchant totem leap duration; ideally we'd create the thinker using OnModifierAdded or similar
	end
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:OnIntervalThink()
	if IsServer() then
		self:DamageEnemiesOnLanding()

		self:StartIntervalThink( -1 )

		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:DamageEnemiesOnLanding()
	if IsServer() then
		local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
		if #hEnemies > 0 then
			for _, hEnemy in pairs( hEnemies ) do
				if hEnemy ~= nil and ( not hEnemy:IsMagicImmune() ) and ( not hEnemy:IsInvulnerable() ) then
					local DamageInfo =
					{
						victim = hEnemy,
						attacker = self:GetCaster(),
						ability = self:GetAbility(),
						damage = self.landing_damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
					}
					ApplyDamage( DamageInfo )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_baby_broodmother_passive:CheckState()
	local state =
	{
		[ MODIFIER_STATE_UNSELECTABLE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
	}

	return state
end

--------------------------------------------------------------------------------
