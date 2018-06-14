modifier_potion_of_cowardice_buff = class({})

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:IsInvisibilityBuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:GetTexture()
	return "bounty_hunter_wind_walk"
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:CheckState()
	local state = {}
	state[ MODIFIER_STATE_INVISIBLE ] = true
	state[ MODIFIER_STATE_NO_UNIT_COLLISION ] = true

	return state
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACKED,
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:GetModifierInvisibilityLevel( params )
	return 1.0
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return 50
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:OnAttacked( params )
	if IsServer() then
		if params.attacker ~= self:GetCaster() then
			return
		end

		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_potion_of_cowardice_buff:OnAbilityExecuted( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end

		self:Destroy()
	end
end

--------------------------------------------------------------------------------
