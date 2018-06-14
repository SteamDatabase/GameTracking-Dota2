
modifier_beastmaster_statue = class({})

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:OnCreated( kv )
	if IsServer() then
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_beastmaster_statue_activatable", { duration = -1 } )
	end
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:GetModifierProvidesFOWVision( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_beastmaster_statue:CheckState()
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
