
modifier_earth_spirit_statue_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:OnCreated( kv )
	if IsServer() then
		local kv = { duration = -1 }
		self:GetParent():AddNewModifier( self:GetParent(), self, "modifier_earth_spirit_statue_stoneform", kv )
	end
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:GetModifierProvidesFOWVision( params )
	return 1
end

-----------------------------------------------------------------------------------------

function modifier_earth_spirit_statue_passive:CheckState()
	local state =
	{
		[ MODIFIER_STATE_ATTACK_IMMUNE ] = true,
		[ MODIFIER_STATE_OUT_OF_GAME ] = true,
		[ MODIFIER_STATE_INVULNERABLE ] = true,
		[ MODIFIER_STATE_MAGIC_IMMUNE ] = true,
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_NO_HEALTH_BAR ] = true,
		[ MODIFIER_STATE_NOT_ON_MINIMAP ] = true,
	}

	return state
end

-------------------------------------------------------------------------------
