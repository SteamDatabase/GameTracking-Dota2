
siltbreaker_tail_spin_ccw = class({})
LinkLuaModifier( "modifier_siltbreaker_tail_spin", "modifiers/modifier_siltbreaker_tail_spin", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_tail_spin_ccw:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function siltbreaker_tail_spin_ccw:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )

		local kv = {}
		kv[ "duration" ] = self.animation_time
		kv[ "initial_delay" ] = self.initial_delay
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_tail_spin", kv )

		EmitSoundOn( "Siltbreaker.TailSpin.Windup", self:GetCaster() ) -- mk spring_channel
	end

	return true
end

--------------------------------------------------------------------------------

function siltbreaker_tail_spin_ccw:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_siltbreaker_tail_spin" )
	end
end

--------------------------------------------------------------------------------

function siltbreaker_tail_spin_ccw:OnSpellStart()
	StopSoundOn( "Siltbreaker.TailSpin.Windup", self:GetCaster() )
	EmitSoundOn( "Siltbreaker.TailSpin.Swipe", self:GetCaster() )
end

--------------------------------------------------------------------------------

function siltbreaker_tail_spin_ccw:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_siltbreaker_tail_spin" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 

--------------------------------------------------------------------------------

