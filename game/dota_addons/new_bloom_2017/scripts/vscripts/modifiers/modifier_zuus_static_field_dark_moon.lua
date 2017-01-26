modifier_zuus_static_field_dark_moon = class({})

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage_health_pct = self:GetAbility():GetSpecialValueFor( "damage_health_pct" )
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage_health_pct = self:GetAbility():GetSpecialValueFor( "damage_health_pct" )
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,

	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_zuus_static_field_dark_moon:OnAbilityExecuted( params )
	if IsServer() then
		local hAbility = params.ability
		if hAbility == nil or not ( hAbility:GetCaster() == self:GetParent() ) then
			return 0
		end

		if hAbility:IsToggle() or hAbility:IsItem() then
			return 0
		end

		local flDamagePct = self.damage_health_pct
		local hTalent = self:GetParent():FindAbilityByName( "special_bonus_unique_zeus" )
		if hTalent and hTalent:GetLevel() > 0 then
			flDamagePct = flDamagePct + hTalent:GetSpecialValueFor( "value" )
		end

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and not enemy:IsAncient() then
					local damage =
					{
						victim = enemy,
						attacker = self:GetParent(),
						damage = ( ( enemy:GetHealth() * flDamagePct ) / 100 ),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
						damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
					}
					ApplyDamage( damage )
					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy ) )

				end
			end
		end
	end

	return 0
end
