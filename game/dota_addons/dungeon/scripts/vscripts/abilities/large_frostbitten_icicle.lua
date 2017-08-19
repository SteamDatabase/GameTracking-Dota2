large_frostbitten_icicle = class({})
LinkLuaModifier( "modifier_large_frostbitten_icicle", "modifiers/modifier_large_frostbitten_icicle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_large_frostbitten_icicle_thinker", "modifiers/modifier_large_frostbitten_icicle_thinker", LUA_MODIFIER_MOTION_NONE )

------------------------------------------------------------------

function large_frostbitten_icicle:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function large_frostbitten_icicle:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Tusk.IceShards.Projectile", self:GetCaster() )
		CreateModifierThinker( self:GetCaster(), self, "modifier_large_frostbitten_icicle_thinker", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	end
end

------------------------------------------------------------------
