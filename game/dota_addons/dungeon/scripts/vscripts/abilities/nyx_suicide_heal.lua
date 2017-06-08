nyx_suicide_heal = class({})
LinkLuaModifier( "modifier_nyx_suicide_heal", "modifiers/modifier_nyx_suicide_heal", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------

function nyx_suicide_heal:GetIntrinsicModifierName()
	return "modifier_nyx_suicide_heal"
end

--------------------------------------------------------------

function nyx_suicide_heal:OnSpellStart()
	if IsServer() then
		self:GetCaster():ForceKill( false )
	end
end

--------------------------------------------------------------