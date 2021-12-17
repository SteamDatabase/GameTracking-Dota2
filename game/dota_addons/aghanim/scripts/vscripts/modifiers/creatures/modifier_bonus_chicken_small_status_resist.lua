
require( "utility_functions" )

modifier_bonus_chicken_small_status_resist = class({})

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:IsPurgeException()
	return true
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10000
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:OnCreated( kv )
	self.status_resist_max_stacks = self:GetAbility():GetSpecialValueFor( "status_resist_max_stacks" )
	self.status_resist_per_stack = self:GetAbility():GetSpecialValueFor( "status_resist_per_stack" )

	self:SetStackCount( 0 )

	--printf( "modifier_bonus_chicken_small_status_resist:OnCreated - stack count: %d", self:GetStackCount() )
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:OnRefresh( kv )
	--self:IncrementStackCount()
end

--------------------------------------------------------------------------------

function modifier_bonus_chicken_small_status_resist:OnStackCountChanged( nOldCount )
	--printf( "-----------------" )
	--printf( "modifier_bonus_chicken_small_status_resist:OnStackCountChanged" )

	local nNewCount = self:GetStackCount()

	if nNewCount > self.status_resist_max_stacks then
		self:SetStackCount( self.status_resist_max_stacks )
		printf( "  max-clamped stack count, stack count is now: %d", self:GetStackCount() )
	elseif nNewCount < 0 then
		self:SetStackCount( 0 )
		printf( "  min-clamped stack count, stack count is now: %d", self:GetStackCount() )
	end

	--local nStatusResist = self.status_resist_per_stack * self:GetStackCount() 
	--printf( "  stack count: %d, nStatusResist: %d", self:GetStackCount(), nStatusResist )
	--printf( "\n" )
end

--------------------------------------------------------------------------------

--[[
function modifier_bonus_chicken_small_status_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end
]]

--------------------------------------------------------------------------------

--[[
function modifier_bonus_chicken_small_status_resist:GetModifierStatusResistanceStacking( params )
	local nStatusResist = 0

	if IsServer() then
		--printf( "---------------------" )
		--printf( "modifier_bonus_chicken_small:GetModifierStatusResistanceStacking" )

		nStatusResist = self.status_resist_per_stack * self:GetStackCount() 
		printf( "  nStatusResist: %d", nStatusResist )
		--printf( "\n" )
	end

	return nStatusResist
end
]]

--------------------------------------------------------------------------------

