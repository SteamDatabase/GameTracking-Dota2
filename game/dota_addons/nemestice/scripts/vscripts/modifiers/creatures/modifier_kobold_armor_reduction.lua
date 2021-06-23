
if modifier_kobold_armor_reduction == nil then
	modifier_kobold_armor_reduction = class( {} )
end

-----------------------------------------------------------------------------

function modifier_kobold_armor_reduction:OnCreated( kv )
	self:OnRefresh( kv )
end

-----------------------------------------------------------------------------

function modifier_kobold_armor_reduction:OnRefresh( kv )
	if self:GetAbility() ~= nil and self:GetAbility():IsNull() == false then
		self.debuff_duration = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
		self.armor_reduction = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	end
end

-----------------------------------------------------------------------------

function modifier_kobold_armor_reduction:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

-----------------------------------------------------------------------------

function modifier_kobold_armor_reduction:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if params.target ~= nil and params.target:IsNull() == false and params.target:IsAlive() == true then
				local bIncreaseCounterStack = false
				local hDebuff = params.target:FindModifierByNameAndCaster( "modifier_kobold_armor_reduction_debuff", self:GetParent() )
				if hDebuff ~= nil then
					--print( '^^^ARMOR REDUCTION ALREADY EXISTS - refreshing duration' )
					hDebuff:SetDuration( self.debuff_duration, true )
				else
					bIncreaseCounterStack = true
					--print( '^^^ARMOR REDUCTION INITAL ADD w/ armor_reduction = ' .. self.armor_reduction )
					local kv =
					{
						duration = self.debuff_duration,
						armor_reduction = self.armor_reduction,
					}
					hDebuff = params.target:AddNewModifier( self:GetParent(), nil, "modifier_kobold_armor_reduction_debuff", kv )
				end

				local hCounter = params.target:FindModifierByName( "modifier_kobold_armor_reduction_counter" )
				if hCounter ~= nil then
					--print( '^^^COUNTER ALREADY EXISTS - refreshing duration' )
					hCounter:SetDuration( self.debuff_duration, true )
					if bIncreaseCounterStack == true then
						hCounter:SetStackCount( hCounter:GetStackCount() + 1 )
					end
				else
					--print( '^^^COUNTER INITAL ADD' )
					local kv =
					{
						duration = self.debuff_duration,
					}
					hCounter = params.target:AddNewModifier( self:GetParent(), nil, "modifier_kobold_armor_reduction_counter", kv )
					hCounter:SetStackCount( 1 )
				end
			end
		end
	end
end
