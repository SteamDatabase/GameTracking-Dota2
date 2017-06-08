spider_web = class({})
LinkLuaModifier( "modifier_spider_web", "modifiers/modifier_spider_web", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_web_effect", "modifiers/modifier_spider_web_effect", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------

function spider_web:GetIntrinsicModifierName()
	return "modifier_spider_web"
end

-------------------------------------------------------------------------
