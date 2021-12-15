
weaver_bug_bomb = class({})
LinkLuaModifier( "modifier_weaver_bug_bomb", "modifiers/creatures/modifier_weaver_bug_bomb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_weaver_bug_bomb_thinker", "modifiers/creatures/modifier_weaver_bug_bomb_thinker", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function weaver_bug_bomb:Precache( context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_wyvern_cold_embrace.vpcf", context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/weaver/weaver_bug_bomb_detonation.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )

	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )
end

--------------------------------------------------------------------------------

function weaver_bug_bomb:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "Hero_Weaver.Swarm.Cast", self:GetCaster() )
		CreateModifierThinker( self:GetCaster(), self, "modifier_weaver_bug_bomb_thinker", {}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------
