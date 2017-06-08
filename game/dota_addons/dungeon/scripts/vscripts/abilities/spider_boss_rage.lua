
--------------------------------------------------------------------------------

spider_boss_rage = class({})
LinkLuaModifier( "modifier_spider_boss_rage", "modifiers/modifier_spider_boss_rage", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function spider_boss_rage:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_spider_boss_rage", { duration = self:GetSpecialValueFor( "duration" ) } )
	end
end

--------------------------------------------------------------------------------
