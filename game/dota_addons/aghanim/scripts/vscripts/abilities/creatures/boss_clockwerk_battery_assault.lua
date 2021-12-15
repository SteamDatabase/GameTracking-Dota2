
boss_clockwerk_battery_assault = class({})

LinkLuaModifier( "modifier_boss_clockwerk_battery_assault",
	"modifiers/creatures/modifier_boss_clockwerk_battery_assault", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_boss_clockwerk_battery_assault_thinker",
	"modifiers/creatures/modifier_boss_clockwerk_battery_assault_thinker", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_clockwerk_battery_assault:Precache( context )
	PrecacheResource( "particle", "particles/creatures/boss_earthshaker/quake_marker.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context )
end

--------------------------------------------------------------------------------

function boss_clockwerk_battery_assault:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )

	if IsServer() then
		local kv = { duration = self.duration }
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_clockwerk_battery_assault", kv )
	end
end

--------------------------------------------------------------------------------
