modifier_creature_big_bomb_passive = class({})

--------------------------------------------------------------------------------

function modifier_creature_big_bomb_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_big_bomb_passive:IsHidden()
	return false;
end

--------------------------------------------------------------------------------

function modifier_creature_big_bomb_passive:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_creature_big_bomb_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_creature_big_bomb_passive:GetModifierMoveSpeed_Absolute( params )
	--if IsServer() then
	--end
	return self.move_speed
end

-----------------------------------------------------------------------

function modifier_creature_big_bomb_passive:CheckState()
	local state = {
		--[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_BLOCK_DISABLED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end



--------------------------------------------------------------------------------