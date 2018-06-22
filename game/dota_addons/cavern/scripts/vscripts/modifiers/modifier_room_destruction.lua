
modifier_room_destruction = class({})

------------------------------------------------------------------------------

function modifier_room_destruction:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_infernal_blade_debuff.vpcf"
end

------------------------------------------------------------------------------

function modifier_room_destruction:GetStatusEffectName()  
	return "particles/status_fx/status_effect_burn.vpcf"
end

--------------------------------------------------------------------------------

 function modifier_room_destruction:GetTexture()
	return "tiny_avalanche"
 end

--------------------------------------------------------------------------------

function modifier_room_destruction:StatusEffectPriority()
	return 14
end

------------------------------------------------------------------------------

function modifier_room_destruction:IsHidden() 
	return false
end

--------------------------------------------------------------------------------

function modifier_room_destruction:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_room_destruction:OnCreated()
	if IsServer() then
		self.fTickRate = 0.5
		self.fPct = 0.04
		self.fScalingBonusDmgPct = 0.0
		self.fShakeAmt = 12
		self.fShakeDuration = self.fTickRate
		self.fShakeInterval = self.fTickRate
		self.fLastShakeTime = nil

		self:StartIntervalThink( 0 )
	end
end

--------------------------------------------------------------------------------

function modifier_room_destruction:OnIntervalThink()
	if IsServer() then
		local damage =
		{
			victim = self:GetParent(),
			attacker = GameRules.Cavern.Roshan.hRoshan or nil,
			damage = ( self:GetParent():GetMaxHealth() * self.fPct ) + self.fScalingBonusDmgPct,
			damage_type = DAMAGE_TYPE_PURE,
		}
		ApplyDamage( damage )

		self.fScalingBonusDmgPct = self.fScalingBonusDmgPct + 2

		--[[
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin() + Vector( 0, 50, 0 ), true )
		]]

		if self.fLastShakeTime == nil or ( GameRules:GetGameTime() > ( self.fLastShakeTime + self.fShakeInterval ) ) then
			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( self:GetParent():GetOrigin(), self.fShakeAmt, 100.0, self.fShakeDuration, 1300.0, 0, true )

			-- Scale the screenshake amplitude and duration based on how long the player has been in the room
			--self.fShakeAmt = math.min( self.fShakeAmt + 10, 90 )
			--self.fShakeDuration = math.min( self.fShakeDuration + 0.25, self.fShakeInterval )

			self.fLastShakeTime = GameRules:GetGameTime()
		end

		EmitSoundOn( "DestroyedRoom.DamageImpact", self:GetParent() )

		self:StartIntervalThink( self.fTickRate )
	end
end

--------------------------------------------------------------------------------
