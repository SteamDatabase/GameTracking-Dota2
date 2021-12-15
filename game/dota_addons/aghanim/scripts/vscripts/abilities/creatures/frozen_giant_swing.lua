frozen_giant_swing = class( {} )
LinkLuaModifier( "modifier_frozen_giant_swing", "modifiers/creatures/modifier_frozen_giant_swing", LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------------------

function frozen_giant_swing:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
end

-----------------------------------------------------------------------------

function frozen_giant_swing:GetPlaybackRateOverride()
	return 1
end

---------------------------------------------------------------

function frozen_giant_swing:OnAbilityPhaseStart()
	return true
end

---------------------------------------------------------------

function frozen_giant_swing:OnAbilityPhaseInterrupted()
end

---------------------------------------------------------------

function frozen_giant_swing:OnSpellStart()
	if IsServer() == false then 
		return 
	end

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_frozen_giant_swing", { duration = 0.1 } )
end

---------------------------------------------------------------



