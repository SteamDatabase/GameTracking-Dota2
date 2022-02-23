
dragon_knight_egg_smasher_ground_blast = class({})

LinkLuaModifier( "modifier_dragon_knight_egg_smasher_ground_blast", "modifiers/creatures/modifier_dragon_knight_egg_smasher_ground_blast", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function dragon_knight_egg_smasher_ground_blast:Precache( context )
	PrecacheResource( "particle", "particles/act_2/amoeba_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context )
end

--------------------------------------------------------------------------------

function dragon_knight_egg_smasher_ground_blast:OnSpellStart()
	if IsServer() then
		local delay = self:GetSpecialValueFor( "delay" )
		local min_random_offset = self:GetSpecialValueFor( "min_random_offset" )
		local max_random_offset = self:GetSpecialValueFor( "max_random_offset" )
		local area_of_effect = self:GetSpecialValueFor( "area_of_effect" )

		printf( "dragon knight: ground smash onspellstart" )

		local hTarget = self:GetCursorTarget()
		if hTarget == nil then
			return
		end

		vOffset = RandomVector( RandomFloat( min_random_offset, max_random_offset ) )
		local vPos = hTarget:GetOrigin() + vOffset

		CreateModifierThinker( self:GetCaster(), self, "modifier_dragon_knight_egg_smasher_ground_blast", { duration = delay }, vPos, self:GetCaster():GetTeamNumber(), false )
	end
end

--------------------------------------------------------------------------------
