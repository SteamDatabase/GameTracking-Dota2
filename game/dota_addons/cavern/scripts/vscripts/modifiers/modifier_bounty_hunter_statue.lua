
modifier_bounty_hunter_statue = class({})

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:GetStatusEffectName()  
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:StatusEffectPriority()
	return 20010
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bounty_hunter_statue_activatable", { duration = -1 } )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		--ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() + Vector( 0, 100, 0 ) )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:GetModifierProvidesFOWVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_bounty_hunter_statue:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
		state[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_BLIND ] = true
		state[ MODIFIER_STATE_DISARMED ] = true
	end
	
	return state
end

--------------------------------------------------------------------------------
