
boss_visage_familiar_stone_form = class({})
LinkLuaModifier( "modifier_boss_visage_familiar_stone_form_buff", "modifiers/creatures/modifier_boss_visage_familiar_stone_form_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_visage_familiar_statue_stone_form", "modifiers/creatures/modifier_boss_visage_familiar_statue_stone_form", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_visage_familiar_passive", "modifiers/creatures/modifier_boss_visage_familiar_passive", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function boss_visage_familiar_stone_form:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_visage/visage_stone_form.vpcf", context )
	PrecacheResource( "particle", "particles/status_fx/status_effect_earth_spirit_petrify.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context )
end

-----------------------------------------------------------------------------

function boss_visage_familiar_stone_form:GetIntrinsicModifierName()
	return "modifier_boss_visage_familiar_passive"
end

-----------------------------------------------------------------------------

function boss_visage_familiar_stone_form:OnSpellStart()
	if IsServer() then
		local szBuffName = "modifier_boss_visage_familiar_stone_form_buff"
		if self:GetCaster():GetUnitName() == "npc_dota_boss_visage_familiar_statue" then
			szBuffName = "modifier_boss_visage_familiar_statue_stone_form"
		end
		self:GetCaster():AddNewModifier( self:GetCaster(), self, szBuffName, {} )
		self:GetCaster():StartGesture( ACT_DOTA_CAST_ABILITY_1 )
	end
end

-----------------------------------------------------------------------------
