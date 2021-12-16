ice_boss_take_flight = class({})
LinkLuaModifier( "modifier_ice_boss_take_flight", "modifiers/creatures/modifier_ice_boss_take_flight", LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------------

function ice_boss_take_flight:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_hero_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_slow.vpcf", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_winter_wyvern.vsndevts", context )
end


-----------------------------------------------------------------------

function ice_boss_take_flight:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_take_flight:OnSpellStart()
	if IsServer() then
		self:GetCaster():Purge( false, true, false, true, false )

		EmitSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", self:GetCaster() )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_take_flight", {} )
	end
end

-----------------------------------------------------------------------