
modifier_ascension_extra_fast = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_extra_fast:GetTexture()
	return "events/aghanim/interface/hazard_speed"
end

-----------------------------------------------------------------------------------------


function modifier_ascension_extra_fast:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_ascension_extra_fast:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_extra_fast:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_extra_fast:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
end

--------------------------------------------------------------------------------

function modifier_ascension_extra_fast:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_ascension_extra_fast:CheckState()
	local state =
	{
		[MODIFIER_STATE_UNSLOWABLE] = false,
	}
	return state
end


--------------------------------------------------------------------------------

function modifier_ascension_extra_fast:GetEffectName()
	return "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
end

-----------------------------------------------------------------------------

function modifier_ascension_extra_fast:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_move_speed
end

