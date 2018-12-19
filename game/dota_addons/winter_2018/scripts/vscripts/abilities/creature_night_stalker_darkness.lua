creature_night_stalker_darkness = class({})
LinkLuaModifier( "modifier_creature_night_stalker_darkness_thinker", "modifiers/modifier_creature_night_stalker_darkness_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creature_night_stalker_darkness_blind", "modifiers/modifier_creature_night_stalker_darkness_blind", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function creature_night_stalker_darkness:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )

	GameRules:BeginNightstalkerNight( self.duration )

	if IsServer() then
		print( "creating Darkness_Thinker, there should only be one of these" )
		Darkness_Thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_creature_night_stalker_darkness_thinker", { duration = self.duration }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
	end

	ParticleManager:CreateParticle( "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	EmitSoundOn( "Hero_Nightstalker.Darkness", self:GetCaster() )
end

--------------------------------------------------------------------------------