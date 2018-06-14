
modifier_troll_camp = class({})

--------------------------------------------------------------------------------

function modifier_troll_camp:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_troll_camp:CanParentBeAutoAttacked()
	return false
end

--------------------------------------------------------------------------------

function modifier_troll_camp:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

--------------------------------------------------------------------------------

function modifier_troll_camp:CheckState()
	local state = {}
	state[MODIFIER_STATE_ROOTED] = true
	state[MODIFIER_STATE_BLIND] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true

	return state
end

--------------------------------------------------------------------------------

function modifier_troll_camp:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

-----------------------------------------------------------------------

function modifier_troll_camp:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			EmitSoundOn( "TrollCamp.Destroy", self:GetParent() )

			local radius = 400
			self:PlayDustParticle( radius )

			local fShakeAmt = 10
			local fShakeDuration = 0.50

			--"Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake"
			ScreenShake( self:GetParent():GetOrigin(), fShakeAmt, 100.0, fShakeDuration, 1300.0, 0, true )

			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------

function modifier_troll_camp:GetModifierProvidesFOWVision( params )
	return 1
end

------------------------------------------------------------

function modifier_troll_camp:GetAbsoluteNoDamageMagical( params )
	return 1
end

------------------------------------------------------------

function modifier_troll_camp:GetAbsoluteNoDamagePure( params )
	return 1
end

------------------------------------------------------------

function modifier_troll_camp:GetFixedDayVision( params )
	return 1
end

------------------------------------------------------------

function modifier_troll_camp:GetFixedNightVision( params )
	return 1
end

------------------------------------------------------------

function modifier_troll_camp:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() then
			EmitSoundOn( "TrollCamp.Damage", self:GetParent() )

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

function modifier_troll_camp:PlayDustParticle( radius )
	local vPos = self:GetParent():GetOrigin()
	vPos.z = vPos.z + 100

	local nFXIndex = ParticleManager:CreateParticle( "particles/dev/library/base_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

------------------------------------------------------------
