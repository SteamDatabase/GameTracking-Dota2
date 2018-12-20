modifier_rubick_boss_telekinesis_land_damage = class({})

--------------------------------------------------------------------------------

function modifier_rubick_boss_telekinesis_land_damage:OnCreated( kv )
	if IsServer() then
		self.vDamageCenter = kv.vDamageCenter
		self.telekinesis_land_damage_radius = self:GetAbility():GetSpecialValueFor( "telekinesis_land_damage_radius" )
		self.telekinesis_land_damage = self:GetAbility():GetSpecialValueFor( "telekinesis_land_damage" )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_telekinesis_land_damage:OnDestroy()
	if IsServer() then
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.vDamageCenter, self:GetCaster(), self.telekinesis_land_damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil then
				local damageInfo =
				{
					victim = Hero,
					attacker = self:GetCaster(),
					damage = self.telekinesis_land_damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
			end
		end
	end
end