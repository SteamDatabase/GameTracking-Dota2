
modifier_respawn_haste = class({})

-----------------------------------------------------------------------------------------

function modifier_respawn_haste:IsPurgable()
	return false
end

----------------------------------------

function modifier_respawn_haste:OnCreated( kv )
	self:OnRefresh( kv )

	self.min_move_speed = kv.min_move_speed
	self.bonus_attack_speed = kv.bonus_attack_speed

	EmitSoundOn( "DOTA_Item.MaskOfMadness.Activate", self:GetParent() )
end

--------------------------------------------------------------------------------

function modifier_respawn_haste:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_respawn_haste:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end

--------------------------------------------------------------------------------

function modifier_respawn_haste:GetModifierMoveSpeed_AbsoluteMin( params )
	return self.min_move_speed
end

--------------------------------------------------------------------------------

function modifier_respawn_haste:GetModifierAttackSpeedBonus_Constant( params )
	return self.bonus_attack_speed
end
