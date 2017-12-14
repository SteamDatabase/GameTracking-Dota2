
weather_snowstorm = class({})

LinkLuaModifier( "modifier_weather_snowstorm", "heroes/weather_snowstorm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_weather_snowstorm_cold", "heroes/weather_snowstorm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_weather_snowstorm_effect", "heroes/weather_snowstorm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

modifier_weather_snowstorm = class({})

function modifier_weather_snowstorm:IsHidden()
	return true
end

function modifier_weather_snowstorm:RemoveOnDeath()
	return false
end

function modifier_weather_snowstorm:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf"
end

function modifier_weather_snowstorm:OnCreated( kv )
	if IsServer() then
		self.delay_before_frosty = 3
		self:StartIntervalThink( 0.2 )

		self:GetParent():AddNewModifier( self:GetCaster(), nil, "modifier_weather_snowstorm_cold", { duration = self.delay_before_frosty } )
	end
end

function modifier_weather_snowstorm:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:FindModifierByName( "modifier_campfire_effect" ) ~= nil or hParent:FindModifierByName( "modifier_pocket_campfire_effect" ) ~= nil then
			hParent:RemoveModifierByName( "modifier_weather_snowstorm_cold" )
			hParent:RemoveModifierByName( "modifier_weather_snowstorm_effect" )
		elseif hParent:HasModifier( "modifier_weather_snowstorm_cold" ) == false and hParent:HasModifier( "modifier_weather_snowstorm_effect" ) == false then
			hParent:AddNewModifier( self:GetCaster(), nil, "modifier_weather_snowstorm_cold", { duration = self.delay_before_frosty } )
		end
	end
end

--------------------------------------------------------------------------------


modifier_weather_snowstorm_cold = class({})

function modifier_weather_snowstorm_cold:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf"
end

function modifier_weather_snowstorm_cold:GetTexture()
	return "ancient_apparition_chilling_touch"
end

function modifier_weather_snowstorm_cold:OnCreated( kv )
	if IsServer() then
		--[[
		local hPlayer = self:GetParent():GetPlayerOwner()
		EmitSoundOnClient( "Snowstorm.Cold.Loop", hPlayer )
		]]
	end
end

function modifier_weather_snowstorm_cold:OnDestroy()
	if IsServer() then
		if self:GetParent():FindModifierByName( "modifier_campfire_effect" ) == nil and self:GetParent():FindModifierByName( "modifier_pocket_campfire_effect" ) == nil then
			self:GetParent():AddNewModifier( self:GetCaster(), nil, "modifier_weather_snowstorm_effect", { duration = -1 } )
		end

		--[[
		local hPlayer = self:GetParent():GetPlayerOwner()
		StopSoundOn( "Snowstorm.Cold.Loop", hPlayer )
		]]
	end
end

--------------------------------------------------------------------------------


modifier_weather_snowstorm_effect = class({})

function modifier_weather_snowstorm_effect:IsPurgable()
	return false
end

function modifier_weather_snowstorm_effect:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_weather_snowstorm_effect:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf"
end

function modifier_weather_snowstorm_effect:GetTexture()
	return "crystal_maiden_frostbite"
end

function modifier_weather_snowstorm_effect:OnCreated( kv )
	if IsServer() then
		self.frosty_damage = 1.5
		self.tick_rate = .03
		self.damage_per_tick = self.frosty_damage * self.tick_rate
		self.tick_count = 0

		EmitSoundOn( "Snowstorm.Bonefrost.Start", self:GetParent() )
		EmitSoundOn( "Snowstorm.Effect.Tick", self:GetParent() )

		self:StartIntervalThink(self.tick_rate)
	end
end

function modifier_weather_snowstorm_effect:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent ~= nil and ( not hParent:IsMagicImmune() ) and ( not hParent:IsInvulnerable() ) then
			self.tick_count = self.tick_count + 1
			local appliedDamage = self.damage_per_tick

			local damage = {
				victim = hParent,
				attacker = self:GetCaster(),
				damage = appliedDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damage )

			if self.tick_count >= 30 then
				EmitSoundOn( "Snowstorm.Effect.Tick", hParent )
				self.tick_count = 0
			end
		end
	end
end
