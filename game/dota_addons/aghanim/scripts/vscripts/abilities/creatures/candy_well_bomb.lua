
candy_well_bomb = class({})
LinkLuaModifier( "modifier_candy_well_bomb_thinker", "modifiers/creatures/modifier_candy_well_bomb_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bucket_soldier_passive", "modifiers/creatures/modifier_bucket_soldier_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function candy_well_bomb:Precache( context )
	PrecacheResource( "particle", "particles/test_particle/dungeon_generic_blast_ovr_pre.vpcf", context )
	PrecacheResource( "particle", "particles/creatures/candy_well/candy_well_bomb_ground_preview.vpcf", context )
end

--------------------------------------------------------------------------------

function candy_well_bomb:OnSpellStart()
	if IsServer() then
		EmitSoundOn( "CandyBucket.BombBuildup", self:GetCaster() )
		CreateModifierThinker( self:GetCaster(), self, "modifier_candy_well_bomb_thinker", {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------
