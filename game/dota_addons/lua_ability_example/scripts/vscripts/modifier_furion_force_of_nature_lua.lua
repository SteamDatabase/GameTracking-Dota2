modifier_furion_force_of_nature_lua = class({})

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_furion_force_of_nature_lua:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
