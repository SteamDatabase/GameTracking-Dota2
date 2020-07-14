
nyx_suicide_heal = class({})
LinkLuaModifier( "modifier_nyx_suicide_heal", "modifiers/creatures/modifier_nyx_suicide_heal", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function nyx_suicide_heal:Precache( context )

	PrecacheResource( "particle", "particles/items3_fx/fish_bones_active.vpcf", context )
	PrecacheResource( "particle", "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", context )

end

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
