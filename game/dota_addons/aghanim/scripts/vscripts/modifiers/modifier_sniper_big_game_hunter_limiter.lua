
modifier_sniper_big_game_hunter_limiter = class({})

--------------------------------------------------------------------------------

function modifier_sniper_big_game_hunter_limiter:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sniper_big_game_hunter_limiter:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sniper_big_game_hunter_limiter:OnCreated( kv )
	if IsServer() then
		local nStacks = self:GetAbility():GetSpecialValueFor( "value2" )
		self:SetStackCount( nStacks )
	end
end

--------------------------------------------------------------------------------
