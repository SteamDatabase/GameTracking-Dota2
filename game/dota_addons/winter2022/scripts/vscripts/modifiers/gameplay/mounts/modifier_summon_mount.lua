
modifier_summon_mount = class({})

----------------------------------------------------------------------------------

function modifier_summon_mount:IsHidden()
	return true
end

----------------------------------------------------------------------------------

function modifier_summon_mount:IsPurgable()
	return false
end

----------------------------------------------------------------------------------

function modifier_summon_mount:OnCreated()
	if IsServer() == false then
		return
	end

	self:StartIntervalThink( 0.1 )
end

-----------------------------------------------------------------------------------------

function modifier_summon_mount:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

----------------------------------------------------------------------------------

function modifier_summon_mount:OnIntervalThink()
	if IsServer() == false then
		return
	end

	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false and self:GetParent():FindModifierByName( "modifier_fountain_aura_buff" ) then
		if self:GetAbility():GetCooldownTimeRemaining() > 1.0 and not self:GetParent():HasModifier("modifier_mounted") then
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown( 1.0 )
		end
	end
end

-----------------------------------------------------------------------

function modifier_summon_mount:OnTakeDamage( params )
	if IsServer() == false then
		return
	end

	local hVictim = params.unit
	if hVictim == nil or hVictim:IsNull() or ( hVictim ~= self:GetParent() ) then
		return
	end

	local hAttacker = params.attacker
	if hAttacker == nil or hAttacker:IsNull() or hAttacker == hVictim then
		return
	end

	-- if we're mounted don't put the ability on cd so that we can activate it again to dismount
	if hVictim:FindModifierByName( "modifier_mounted" ) then
		return
	end

	if self:GetAbility() ~= nil and ( IsConsideredHeroDamageSource(hAttacker) or hAttacker == GameRules.Winter2022.hRoshan ) then
		self:GetAbility():StartCooldown( math.max( self:GetAbility():GetCooldownTimeRemaining(), 3 ) )
	end
end

-----------------------------------------------------------------------
