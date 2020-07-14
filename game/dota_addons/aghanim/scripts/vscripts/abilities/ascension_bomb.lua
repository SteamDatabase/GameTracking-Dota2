
ascension_bomb = class({})
LinkLuaModifier( "modifier_bomber_death_explosion", "modifiers/creatures/modifier_bomber_death_explosion", LUA_MODIFIER_MOTION_NONE )

-----------------------------------------------------------------------------------------

function ascension_bomb:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", context )
	PrecacheResource( "particle", "particles/dark_moon/darkmoon_calldown_marker_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", context )
end

--------------------------------------------------------------------------------

function ascension_bomb:OnSpellStart()

	if not IsServer() then
		return
	end

	local hTarget = self:GetCursorTarget()
	if hTarget == nil then
		return
	end

	hTarget:AddNewModifier( hTarget, self, "modifier_bomber_death_explosion", {} )

end
