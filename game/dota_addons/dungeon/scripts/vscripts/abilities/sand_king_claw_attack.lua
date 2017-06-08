sand_king_claw_attack = class({})
LinkLuaModifier( "modifier_sand_king_claw_attack", "modifiers/modifier_sand_king_claw_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function sand_king_claw_attack:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sand_king_claw_attack", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function sand_king_claw_attack:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_sand_king_claw_attack" )
	end
end

--------------------------------------------------------------------------------

function sand_king_claw_attack:GetPlaybackRateOverride()
	return 0.6
end

--------------------------------------------------------------------------------

function sand_king_claw_attack:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_sand_king_claw_attack" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 