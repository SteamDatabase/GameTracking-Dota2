
modifier_mini_spider_slow_attack = class({})

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack:IsHidden()
	return true
end

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	if IsServer() then
		-- Give the spider a chance to get aggro on its own; if it doesn't have it after some delay, we'll assign it
		local fDelay = 1.5
		self:StartIntervalThink( fDelay )
	end
end

------------------------------------------------------------------------------------


function modifier_mini_spider_slow_attack:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetInitialGoalEntity() ~= nil then
			return -1
		end

		local hHeroes = FindRealLivingEnemyHeroesInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), FIND_UNITS_EVERYWHERE )
		local hNearestHero = hHeroes[ 1 ]
		if hNearestHero ~= nil then
			self:GetParent():SetInitialGoalEntity( hNearestHero )
		end

		return -1
	end
end

--------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack:CheckState()
	local state =
	{
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = false,
	}

	return state
end

------------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_mini_spider_slow_attack:OnAttacked( params )
	if IsServer() then
		if params.attacker == self:GetParent() then
			local hTarget = params.target 
			if hTarget ~= nil then
				local hDebuff = hTarget:FindModifierByName( "modifier_mini_spider_slow_attack_debuff" )
				if hDebuff ~= nil then
					hDebuff:SetDuration( self.duration, true )
					hDebuff:IncrementStackCount()
				else
					hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mini_spider_slow_attack_debuff", { duration = self.duration } )			
				end
			end
		end
	end
end

------------------------------------------------------------------------------------
