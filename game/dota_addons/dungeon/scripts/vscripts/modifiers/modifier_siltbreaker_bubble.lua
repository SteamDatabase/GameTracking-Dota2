
modifier_siltbreaker_bubble = class({})

-----------------------------------------------------------------------------

function modifier_siltbreaker_bubble:GetStatusEffectName()
	return "particles/econ/events/ti7/fountain_regen_ti7_bubbles.vpcf"
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_bubble:OnCreated( kv )
	if not IsServer() then
		return
	end

	self.bubble_tick = self:GetAbility():GetSpecialValueFor( "bubble_tick" )
	self.bubble_damage = self:GetAbility():GetSpecialValueFor( "bubble_damage" )

	self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )

	self.hBubble = CreateUnitByName( "npc_dota_creature_siltbreaker_bubble", self:GetParent():GetAbsOrigin(), false, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber() )

	self:StartIntervalThink( self.bubble_tick )
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_bubble:OnIntervalThink( )
	local damageInfo = 
	{
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.bubble_damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self,
	}

	ApplyDamage( damageInfo )
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_bubble:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_STUNNED]  = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_DISARMED] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		--state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	end

	return state
end

-----------------------------------------------------------------------------

function modifier_siltbreaker_bubble:OnDestroy()
	if self:GetParent() and self:GetParent():HasModifier( "modifier_disable_aggro" ) then
		self:GetParent():RemoveModifierByName( "modifier_disable_aggro" )
	end

	if self.hBubble and self.hBubble:IsAlive() then
		self.hBubble:ForceKill( false )
	end
end

-----------------------------------------------------------------------------

