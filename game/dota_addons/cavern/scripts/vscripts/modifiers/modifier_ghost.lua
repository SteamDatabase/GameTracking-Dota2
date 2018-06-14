
modifier_ghost = class({})

--------------------------------------------------------------------------------

function modifier_ghost:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_ghost:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_ghost:OnCreated( kv )
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
		self.max_slow_stacks = self:GetAbility():GetSpecialValueFor( "max_slow_stacks" )

		self.bIsNearEnemy = false
		self:StartIntervalThink( 0.25 )
	end
end

--------------------------------------------------------------------------------

function modifier_ghost:OnIntervalThink()
	if IsServer() then
		local EnemyHeroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

		if #EnemyHeroes > 0 then
			self.bIsNearEnemy = true
		else
			self.bIsNearEnemy = false
		end

		return 0.25
	end
end

--------------------------------------------------------------------------------

function modifier_ghost:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_ghost:OnAttackLanded( params )
	if IsServer() then
		if params.attacker ~= self:GetParent() then
			return
		end

		local hAttacker = params.attacker
		local hTarget = params.target

		if hTarget then
			local hDebuff = hTarget:FindModifierByName( "modifier_ghost_slow" )
			if hDebuff ~= nil then
				if hTarget:GetModifierStackCount( "modifier_ghost_slow", self:GetAbility() ) < self.max_slow_stacks then
					hDebuff:IncrementStackCount()
				end

				hDebuff:SetDuration( self.slow_duration, true )
			else
				hTarget:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_ghost_slow", { duration = self.slow_duration } )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_ghost:CheckState()
	local state = {}
	if IsServer() then
		if self.bIsNearEnemy then
			state[ MODIFIER_STATE_INVISIBLE ] = false
		else
			state[ MODIFIER_STATE_INVISIBLE ] = true
		end
	end
	
	return state
end

--------------------------------------------------------------------------------
