sand_king_tail_swipe_left = class({})
LinkLuaModifier( "modifier_sand_king_tail_swipe", "modifiers/modifier_sand_king_tail_swipe", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sand_king_tail_swipe_left:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_tail_swipe", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_left:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_sand_king_tail_swipe" )
	end
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_left:GetPlaybackRateOverride()
	return 0.75
end

--------------------------------------------------------------------------------

function sand_king_tail_swipe_left:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_sand_king_tail_swipe" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 