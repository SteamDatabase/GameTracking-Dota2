if grant_candy_shield == nil then
	grant_candy_shield = class({})
end

LinkLuaModifier( "modifier_grant_candy_shield", "modifiers/gameplay/modifier_grant_candy_shield", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function grant_candy_shield:GetIntrinsicModifierName()
	return "modifier_grant_candy_shield"
end