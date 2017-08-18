
modifier_siltbreaker_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:OnCreated( kv )
	if IsServer() then
		self:GetCaster().bInTorrents = false
	end
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:CheckState()
	local state =
	{
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	if IsServer() then
		state[MODIFIER_STATE_CANNOT_MISS] = self.bCannotMiss
		state[MODIFIER_STATE_INVISIBLE] = false
		state[MODIFIER_STATE_UNSELECTABLE] = self:GetCaster().bInTorrents
	end

	return state
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:GetModifierFixedAttackRate( params )
	return self:GetAbility():GetSpecialValueFor( "fixed_attack_rate" )
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:GetModifierAttackRangeBonus( params )
	if IsServer() then
		if self.bInAttack == true then
			return self:GetAbility():GetSpecialValueFor( "extended_range" )
		else
			return 0
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		local hSprintBuff = self:GetParent():FindModifierByName( "modifier_siltbreaker_sprint" )
		if hSprintBuff then
			return self:GetAbility():GetSpecialValueFor( "sprint_speed" )
		end
	end

	return self:GetAbility():GetSpecialValueFor( "normal_speed" )
end


-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:OnAttackStart( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self.bInAttack = true
			if RollPercentage( self:GetAbility():GetSpecialValueFor( "accuracy_pct" ) ) then
				self.bCannotMiss = true
			else
				self.bCannotMiss = false
			end
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self.bInAttack = false

			local Target = params.target
			if Target ~= nil then
				local caustic_duration = self:GetAbility():GetSpecialValueFor( "caustic_duration" )
				local hAttackBuff = Target:FindModifierByName( "modifier_siltbreaker_attack" )
				if hAttackBuff == nil then
					hAttackBuff = Target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_siltbreaker_attack", { duration = caustic_duration } )
					if hAttackBuff ~= nil then
						hAttackBuff:SetStackCount( 0 )
					end	
				end
				if hAttackBuff ~= nil then
					hAttackBuff:SetStackCount( hAttackBuff:GetStackCount() + 1 )  
					hAttackBuff:SetDuration( caustic_duration, true )
				end		
			end
		end
	end

	return 0 
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:GetModifierEvasion_Constant( params )
	return self:GetAbility():GetSpecialValueFor( "evasion_pct" )
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_passive:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hVictim = params.unit
		if hAttacker ~= nil and hVictim ~= nil and hVictim == self:GetParent() then
			if hVictim:FindModifierByName( "modifier_provide_vision" ) == nil then
				hVictim:AddNewModifier( hAttacker, self:GetAbility(), "modifier_provide_vision", { duration = -1 } ) 
			end
		end
	end

	return 0
end

-----------------------------------------------------------------------------------------

