
modifier_weather_snowstorm_cold = class({})

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:GetTexture()
	return "ancient_apparition_chilling_touch"
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:OnCreated( kv )
	if IsServer() then
		--[[
		local hPlayer = self:GetParent():GetPlayerOwner()
		EmitSoundOnClient( "Snowstorm.Cold.Loop", hPlayer )
		]]
	end
end

--------------------------------------------------------------------------------

function modifier_weather_snowstorm_cold:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

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

