
modifier_blocked_gate = class({})

--------------------------------------------------------------------------------

function modifier_blocked_gate:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_blocked_gate:OnCreated( kv )
	if IsServer() then
		self.hGate = self:GetParent().hGate
		--self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function modifier_blocked_gate:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_blocked_gate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end


--------------------------------------------------------------------------------

function modifier_blocked_gate:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------

function modifier_blocked_gate:OnDeath( params )
	if IsServer() then
		if ( params.unit == self:GetParent() ) then
			
			if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
				EmitSoundOn( "Gate.Tier2.Destroy", self:GetParent() )
			end
			
			local vPos = self:GetParent():GetAbsOrigin()
			vPos.z = vPos.z + 100

			local nFXIndex = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 400, 400, 400 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			

			local nLevel = 1
			local fShakeAmt = 15 * nLevel
			local fShakeDuration = 0.75 * nLevel

			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( vPos, fShakeAmt, 100.0, fShakeDuration, 1300.0, 0, true )

			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------

function modifier_blocked_gate:GetAbsoluteNoDamagePhysical( params )
	return 1
end

------------------------------------------------------------

function modifier_blocked_gate:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_blocked_gate:GetAbsoluteNoDamagePure( params )
	return 1
end


--------------------------------------------------------------------------------