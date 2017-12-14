weather_dummy_passive = class({})

LinkLuaModifier( "modifier_weather_dummy_passive", "heroes/weather_dummy_passive", LUA_MODIFIER_MOTION_NONE )

function weather_dummy_passive:GetIntrinsicModifierName()
	return "modifier_weather_dummy_passive"
end

--------------------------------------------------------------------------------


modifier_weather_dummy_passive = class({})

function modifier_weather_dummy_passive:IsHidden()
	return true
end

function modifier_weather_dummy_passive:OnCreated( kv )
	if IsServer() then
		if ( self:GetParent():GetUnitName() == "npc_dota_holdout_truesight_dummy" ) then
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_truesight_aura", { duration = -1, radius = 160 } )
		end

		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
	end
end

function modifier_weather_dummy_passive:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_DISARMED] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		state[MODIFIER_STATE_UNSELECTABLE] = true
	end

	return state
end