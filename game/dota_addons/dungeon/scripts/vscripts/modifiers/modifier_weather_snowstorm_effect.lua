
modifier_weather_snowstorm_effect = class({})

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:GetTexture()
	return "crystal_maiden_frostbite"
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:OnCreated( kv )
	if IsServer() then
		self.frosty_damage = 60

		EmitSoundOn( "Snowstorm.Bonefrost.Start", self:GetParent() )
		EmitSoundOn( "Snowstorm.Effect.Tick", self:GetParent() )

		self:StartIntervalThink( 1.0 )
	end
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_effect:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent ~= nil and ( not hParent:IsMagicImmune() ) and ( not hParent:IsInvulnerable() ) then

			local appliedDamage = self.frosty_damage

			local damage = {
				victim = hParent,
				attacker = self:GetCaster(),
				damage = appliedDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damage )

			EmitSoundOn( "Snowstorm.Effect.Tick", hParent )
		end
	end
end

--------------------------------------------------------------------------------

