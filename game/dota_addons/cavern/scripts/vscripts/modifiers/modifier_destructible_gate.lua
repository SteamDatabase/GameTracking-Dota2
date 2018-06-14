
modifier_destructible_gate = class({})

--------------------------------------------------------------------------------

function modifier_destructible_gate:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_destructible_gate:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_destructible_gate:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

--------------------------------------------------------------------------------

function modifier_destructible_gate:OnCreated( kv )
	if IsServer() then
		self.hGate = self:GetParent().hGate

		if self:GetParent():GetUnitName() == "npc_dota_cavern_gate_destructible_tier1" then
			self.szDamageSound = "Gate.Tier1.Damage"
			self.szDestroySound = "Gate.Tier1.Destroy"
		elseif self:GetParent():GetUnitName() == "npc_dota_cavern_gate_destructible_tier2" then
			self.szDamageSound = "Gate.Tier2.Damage"
			self.szDestroySound = "Gate.Tier2.Destroy"
		elseif self:GetParent():GetUnitName() == "npc_dota_cavern_gate_destructible_tier3" then
			self.szDamageSound = "Gate.Tier3.Damage"
			self.szDestroySound = "Gate.Tier3.Destroy"
		end
	end
end

--------------------------------------------------------------------------------

function modifier_destructible_gate:CheckState()
	local state = {}
	state[MODIFIER_STATE_ROOTED] = true
	state[MODIFIER_STATE_BLIND] = true
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true

	return state
end

--------------------------------------------------------------------------------

function modifier_destructible_gate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_destructible_gate:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			assert ( self.szDestroySound ~= nil, "ERROR: modifier_destructible_gate - self.szDestroySound is nil" )

			if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
				EmitSoundOn( self.szDestroySound, self:GetParent() )
			end

			local radius = 400
			self:PlayDustParticle( radius )

			-- Scale the ScreenShake amplitude and duration based on the level of the gate
			local nLevel = self:GetParent():GetLevel()
			local fShakeAmt = 15 * nLevel
			local fShakeDuration = 0.75 * nLevel

			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( self:GetParent():GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 1300.0, 0, true )

			self.hGate:SetObstructions( false ) -- change this to setpath open?

			local szGateWithAnim = self:GetParent():GetUnitName() .. "_anim"
			local hAnimGate = CreateUnitByName( szGateWithAnim, self:GetParent():GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
			local vGateAngles = self:GetParent():GetAnglesAsVector()
			if hAnimGate == nil then
				printf( "ERROR: modifier_destructible_gate:OnDeath -- hAnimGate is nil." )
				return
			end
			hAnimGate:SetAngles( vGateAngles.x, vGateAngles.y, vGateAngles.z )
			hAnimGate.hGate = self.hGate
			hAnimGate:AddNewModifier( hAnimGate, nil, "modifier_destructible_gate_anim", {} )

			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------

function modifier_destructible_gate:GetModifierProvidesFOWVision( params )
	return 1
end

------------------------------------------------------------

function modifier_destructible_gate:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_destructible_gate:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

function modifier_destructible_gate:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			assert ( self.szDamageSound ~= nil, "ERROR: modifier_destructible_gate - self.szDamageSound is nil" )

			EmitSoundOn( self.szDamageSound, self:GetParent() )

			-- The base_dust_hit particle we're currently using doesn't scale itself based on passed radius, so this scaling isn't doing anything
			local fHealthPct = self:GetParent():GetHealthPercent()
			local fRadiusMultiplier = ( 100 - fHealthPct ) / 100
			local radius = 300 * fRadiusMultiplier

			self:PlayDustParticle( radius )
		end
	end

	return 1
end

------------------------------------------------------------

function modifier_destructible_gate:PlayDustParticle( radius )
	local vPos = self:GetParent():GetOrigin()
	vPos.z = vPos.z + 100

	local nFXIndex = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

------------------------------------------------------------
