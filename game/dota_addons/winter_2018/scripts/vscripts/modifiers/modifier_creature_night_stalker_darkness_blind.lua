modifier_creature_night_stalker_darkness_blind = class({})

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:OnCreated( kv )
	--self.fixed_vision = self:GetAbility():GetSpecialValueFor( "fixed_vision" )
	if IsServer() then
		GameRules:SetTimeOfDay( 0.751 )
	end
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:GetFixedDayVision( params )
	return 1 --self.fixed_vision
end

--------------------------------------------------------------------------------

function modifier_creature_night_stalker_darkness_blind:GetFixedNightVision( params )
	return 1 --self.fixed_vision
end

--------------------------------------------------------------------------------
