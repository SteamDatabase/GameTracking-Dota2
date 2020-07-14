
-- 

bomb_squad_self_cast = class({})
LinkLuaModifier( "modifier_bomb_squad_self_cast", "modifiers/creatures/modifier_bomb_squad_self_cast", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function bomb_squad_self_cast:OnSpellStart()
	if IsServer() then
		local kv
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_bomb_squad_self_cast", kv )
	end
end

-----------------------------------------------------------------------------