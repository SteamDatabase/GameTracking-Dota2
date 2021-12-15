large_frostbitten_icicle = class({})
LinkLuaModifier( "modifier_large_frostbitten_icicle", "modifiers/creatures/modifier_large_frostbitten_icicle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_large_frostbitten_icicle_thinker", "modifiers/creatures/modifier_large_frostbitten_icicle_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function large_frostbitten_icicle:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", context )
	PrecacheResource( "particle", "particles/act_2/frostbitten_icicle.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context )
end


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
