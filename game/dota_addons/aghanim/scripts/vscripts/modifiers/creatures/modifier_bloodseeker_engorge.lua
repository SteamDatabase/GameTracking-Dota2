
modifier_bloodseeker_engorge = class({})

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:OnCreated( kv )
	self.model_scale_per_stack = self:GetAbility():GetSpecialValueFor( "model_scale_per_stack" )
	self.attack_speed_per_stack = self:GetAbility():GetSpecialValueFor( "attack_speed_per_stack" )
	self.move_speed_per_stack = self:GetAbility():GetSpecialValueFor( "move_speed_per_stack" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stacks" )
	self.stack_loss_interval = self:GetAbility():GetSpecialValueFor( "stack_loss_interval" )
	self.model_to_healthbar_mult = self:GetAbility():GetSpecialValueFor( "model_to_healthbar_mult" )

	if IsServer() then
		self.fInitialModelScale = self:GetCaster():GetModelScale()
		--printf( "self.fInitialModelScale: %.2f", self.fInitialModelScale )

		local fCoolMultiplier = 1.75
		self.fInitialHealthBarOffset = ( self.fInitialModelScale * 100 ) * fCoolMultiplier
		--printf( "self.fInitialHealthBarOffset: %.2f", self.fInitialHealthBarOffset )

		self:GetCaster():SetHealthBarOffsetOverride( self.fInitialHealthBarOffset )

		self:StartIntervalThink( self.stack_loss_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:OnIntervalThink()
	if not IsServer() then
		return -1
	end

	self:DecrementStackCount()
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:OnStackCountChanged( nOldCount )
	local nNewCount = self:GetStackCount()

	if nNewCount > self.max_stacks then
		self:SetStackCount( self.max_stacks )
	elseif nNewCount < 0 then
		self:SetStackCount( 0 )
	end

	if IsServer() then
		local fModelScale = self.model_scale_per_stack * self:GetStackCount()
		local fNewOffset = self.fInitialHealthBarOffset + ( self.fInitialHealthBarOffset * ( ( fModelScale * self.model_to_healthbar_mult ) / 100 ) )
		self:GetCaster():SetHealthBarOffsetOverride( fNewOffset )
	end
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierModelScale( params )
	local fScale = self.model_scale_per_stack * self:GetStackCount()

	return fScale
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierDamageOutgoing_Percentage( params )
	local fBonusDamagePct = self.bonus_dmg_pct_per_stack * self:GetStackCount()

	return fBonusDamagePct
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierAttackSpeedBonus_Constant( params )
	local fBonusAttackSpeed = self.attack_speed_per_stack * self:GetStackCount()

	return fBonusAttackSpeed
end

-----------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierMoveSpeedBonus_Percentage( params )
	local fBonusMoveSpeed = self.move_speed_per_stack * self:GetStackCount()

	return fBonusMoveSpeed
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierAttackSpeed_Limit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:GetModifierIgnoreMovespeedLimit( params )
	return 1
end

--------------------------------------------------------------------------------

function modifier_bloodseeker_engorge:OnDeath( params )
	if IsServer() then
		if params.unit == nil or params.unit:IsNull() then
			return 0
		end

		local hSummonAbility = self:GetCaster():FindAbilityByName( "bloodseeker_summon" )
		if hSummonAbility == nil then
			printf( "ERROR - modifier_bloodseeker_engorge:OnDeath - hSummonAbility not found" )
		end

		-- If a bloodbag dies, clean it out of my summons table
		if params.unit:GetUnitName() == "npc_dota_creature_bloodbound_baby_ogre_magi" then
			local hBloodbag = params.unit

			for k, hSummon in pairs( hSummonAbility.hSummons ) do
				if hSummon ~= nil and hSummon:IsNull() == false then
					if hSummon == hBloodbag then
						table.remove( hSummonAbility.hSummons, k )
					end
				end
			end

			return 0
		end

		-- If I die, free all the bloodbags from their modifiers and motioncontroller projectiles
		if params.unit == self:GetParent() then
			for _, hSummon in pairs( hSummonAbility.hSummons ) do
				if hSummon ~= nil and hSummon:IsNull() == false and hSummon:IsAlive() then
					hSummon:RemoveModifierByName( "modifier_bloodbound_bloodbag" )
				end
			end

			return 0
		end
	end

	return 0
end

--------------------------------------------------------------------------------
