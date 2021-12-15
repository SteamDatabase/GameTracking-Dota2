
modifier_primal_beast_boss_vo_controller = class({})

--------------------------------------------------------------------------------

function modifier_primal_beast_boss_vo_controller:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primal_beast_boss_vo_controller:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_primal_beast_boss_vo_controller:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_primal_beast_boss_vo_controller:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end
		local Ability = params.ability
		if Ability == nil then
			return 0
		end

		if self:GetParent().AI == nil then
			return 0
		end

		self:GetParent().AI:Speak( 0.0, true, {
			beast_event = "ability_executed",
			ability_name = Ability:GetAbilityName(),
		})

	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_primal_beast_boss_vo_controller:OnDeath( params )
	if IsServer() ~= true then
		return
	end

	if self:GetParent():IsAlive() ~= true or params.unit == nil or params.unit:IsNull() or params.unit:IsRealHero() ~= true or params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end

	self:GetParent().AI:Speak( 2.0, true, {
		beast_event = "kill",
	})
end
