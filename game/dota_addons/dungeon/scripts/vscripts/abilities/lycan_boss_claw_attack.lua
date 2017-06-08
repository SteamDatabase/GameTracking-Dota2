lycan_boss_claw_attack = class({})
LinkLuaModifier( "modifier_lycan_boss_claw_attack", "modifiers/modifier_lycan_boss_claw_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor( "animation_time" )
		self.initial_delay = self:GetSpecialValueFor( "initial_delay" )
		self.shapeshift_animation_time = self:GetSpecialValueFor( "shapeshift_animation_time" )
		self.shapeshift_initial_delay = self:GetSpecialValueFor( "shapeshift_initial_delay" )

		
		local bShapeshift = self:GetCaster():FindModifierByName( "modifier_lycan_boss_shapeshift" ) ~= nil
		if RandomInt( 0, 2 ) == 1 then
			self:PlayClawAttackSpeech( bShapeshift )
		end

		local kv = {}
		if bShapeshift then
			kv["duration"] = self.shapeshift_animation_time
			kv["initial_delay"] = self.shapeshift_initial_delay
		else
			kv["duration"] = self.animation_time
			kv["initial_delay"] = self.initial_delay
		end
	
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_lycan_boss_claw_attack", kv )
	end
	return true
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_lycan_boss_claw_attack" )
	end
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:GetPlaybackRateOverride()
	return 0.4
end

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_lycan_boss_claw_attack" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 

--------------------------------------------------------------------------------

function lycan_boss_claw_attack:PlayClawAttackSpeech( bShapeshift )
	if IsServer() then
		if self:GetCaster().nLastClawSound == nil then
			self:GetCaster().nLastClawSound = 0
		end
		local nSound = RandomInt( 0, 3 )
		while nSound == self:GetCaster().nLastClawSound do 
			nSound = RandomInt( 0, 3 )
		end
		if nSound == 1 then
				EmitSoundOn( "lycan_lycan_pain_01", self:GetCaster() )
		end
		if nSound == 2 then
			EmitSoundOn( "lycan_lycan_pain_08", self:GetCaster() )
		end
		if bShapeshift then
			if nSound == 0 then
				EmitSoundOn( "lycan_lycan_wolf_attack_01", self:GetCaster() )
			end
			if nSound == 3 then
				EmitSoundOn( "lycan_lycan_wolf_attack_10", self:GetCaster() )
			end
		else
			if nSound == 0 then
				EmitSoundOn( "lycan_lycan_attack_01", self:GetCaster() )
			end
			if nSound == 3 then
				EmitSoundOn( "lycan_lycan_pain_09", self:GetCaster() )
			end
		end
		self:GetCaster().nLastClawSound = nSound
	end
end
