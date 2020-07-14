modifier_creature_pudge_miniboss_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:IsHidden()
	return true;
end

--------------------------------------------------------------------------------
function modifier_creature_pudge_miniboss_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_REDUCTION_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end



function modifier_creature_pudge_miniboss_passive:OnAttackLanded( params )
	if IsServer() then
		if params.target ~= self:GetParent() then
			return
		end
		self:GetParent().hAttacker = params.attacker
	end
end


--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:GetModifierStatusResistanceStacking( params )
	return 75 
end

function modifier_creature_pudge_miniboss_passive:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_CANNOT_MISS] = true
		state[MODIFIER_STATE_INVISIBLE] = false
	end
	return state
end

--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:OnCreated( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:GetModifierAttackSpeedReductionPercentage( params )
	return 0
end

--------------------------------------------------------------------------------

function modifier_creature_pudge_miniboss_passive:GetModifierMoveSpeedReductionPercentage( params )
	return 20
end
