modifier_boss_visage_familiar_statue_stone_form = class({})

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:GetPriority( )
	return MODIFIER_PRIORITY_HIGH + 6
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:GetStatusEffectName() 
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf"; 
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:AddCustomTransmitterData()
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:HandleCustomTransmitterData( entry )
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:OnCreated( kv )
	if IsServer() then
		self:SetStackCount( 0 )
		self:StartIntervalThink( 0.77 )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()
		if self:GetStackCount() > 5 then
			self:StartIntervalThink( -1 )
		end
	end
end

-- --------------------------------------------------------------------------------

-- function modifier_boss_visage_familiar_stone_form_buff:DeclareFunctions()
-- 	local funcs = 
-- 	{
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,
-- 	}
-- 	return funcs
-- end

-- --------------------------------------------------------------------------------

-- function modifier_boss_visage_familiar_stone_form_buff

--------------------------------------------------------------------------------

function modifier_boss_visage_familiar_statue_stone_form:CheckState()
	local bOnGround = self:GetStackCount() > 1
	local state = {}
	state[MODIFIER_STATE_FROZEN] = self:GetStackCount() > 5
	state[MODIFIER_STATE_STUNNED] = false
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_FLYING] = false
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_ROOTED] = true
	state[MODIFIER_STATE_DISARMED] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	state[MODIFIER_STATE_PROVIDES_VISION] = true
	return state
end
