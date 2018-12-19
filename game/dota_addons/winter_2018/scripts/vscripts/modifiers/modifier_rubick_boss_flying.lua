modifier_rubick_boss_flying = class({})

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:OnCreated( kv )
	self.fade_bolt_flight_speed = self:GetAbility():GetSpecialValueFor( "fade_bolt_flight_speed" )
	
	if IsServer() then
		self:GetParent():StartGesture( ACT_DOTA_IDLE )
	end
end

-----------------------------------------------------------------------

function  modifier_rubick_boss_flying:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture( ACT_DOTA_IDLE )
	end
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:GetModifierMoveSpeed_Absolute( params )
	return self.fade_bolt_flight_speed
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:GetModifierMoveSpeed_Max( params )
	return self.fade_bolt_flight_speed
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:GetVisualZDelta( params )
	return 200
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_flying:GetActivityTranslationModifiers( params )
	return "flying"
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:GetHeroEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_hero_effect.vpcf"
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:CheckState()
	local state = 
	{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

-----------------------------------------------------------------------

function modifier_rubick_boss_flying:GetStatusEffectName( )  
	return "particles/status_fx/status_effect_dark_seer_illusion.vpcf"
end