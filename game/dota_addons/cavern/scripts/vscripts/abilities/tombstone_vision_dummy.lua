
tombstone_vision_dummy = class({})
LinkLuaModifier( "modifier_tombstone_vision_dummy", "modifiers/modifier_tombstone_vision_dummy", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function tombstone_vision_dummy:GetIntrinsicModifierName()
	return "modifier_tombstone_vision_dummy"
end

--------------------------------------------------------------------------------
