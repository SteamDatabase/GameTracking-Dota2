
modifier_weather_snowstorm = class({})

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm:OnCreated( kv )
	if IsServer() then
		self.delay_before_frosty = 25
		self:StartIntervalThink( 0.2 )

		self:GetParent():AddNewModifier( self:GetCaster(), nil, "modifier_weather_snowstorm_cold", { duration = self.delay_before_frosty } )
	end
end

--------------------------------------------------------------------------------

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

