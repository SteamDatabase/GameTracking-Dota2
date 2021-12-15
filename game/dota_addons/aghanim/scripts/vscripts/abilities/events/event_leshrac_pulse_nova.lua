
event_leshrac_pulse_nova = class( {} )

LinkLuaModifier( "modifier_event_leshrac_pulse_nova", "modifiers/events/modifier_event_leshrac_pulse_nova", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_pulse_nova_recreate", "modifiers/events/modifier_event_leshrac_pulse_nova_recreate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_event_leshrac_pulse_nova_activated", "modifiers/events/modifier_event_leshrac_pulse_nova_activated", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function event_leshrac_pulse_nova:GetIntrinsicModifierName()
	return "modifier_event_leshrac_pulse_nova"
end

--------------------------------------------------------------------------------
