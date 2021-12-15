ice_boss_land = class({})
LinkLuaModifier( "modifier_ice_boss_land", "modifiers/creatures/modifier_ice_boss_land", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function ice_boss_land:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function ice_boss_land:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ice_boss_land", {} )
		self:GetCaster():RemoveModifierByName( "modifier_ice_boss_take_flight" )
	end
	return true
end

--------------------------------------------------------------------------------

function ice_boss_land:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_ice_boss_land" )
	end
end


-----------------------------------------------------------------------

function ice_boss_land:OnSpellStart()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_ice_boss_land" )
	end
end

--------------------------------------------------------------------------------

function ice_boss_land:GetPlaybackRateOverride()
	return 0.33
end