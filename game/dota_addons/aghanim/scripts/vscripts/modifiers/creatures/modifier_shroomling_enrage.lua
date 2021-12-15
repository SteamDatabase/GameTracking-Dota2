
modifier_shroomling_enrage = class({})

-----------------------------------------------------------------------------------------

function modifier_shroomling_enrage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_shroomling_enrage:OnCreated( kv )
	self.enrage_movespeed_bonus = 400
	self.enrage_attack_speed_bonus = 50
	self.enrage_model_scale_bonus = 40
	self.enrage_lifesteal_bonus_pct = 50

	if IsServer() then
		EmitSoundOn( "DOTA_Item.MaskOfMadness.Activate", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_shroomling_enrage:GetEffectName()
    return "particles/items2_fx/mask_of_madness.vpcf"
end

--------------------------------------------------------------------------------

function modifier_shroomling_enrage:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_EVENT_ON_ATTACKED,
	}

	return funcs
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_enrage:GetModifierMoveSpeedBonus_Constant( params )
	return self.enrage_movespeed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_enrage:GetModifierAttackSpeedBonus_Constant( params )
	return self.enrage_attack_speed_bonus
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_enrage:GetModifierModelScale( params )
	return self.enrage_model_scale_bonus
end

-----------------------------------------------------------------------------------------

function modifier_shroomling_enrage:OnAttacked( params )
	if IsServer() then

		--print( 'modifier_shroomling_enrage:OnAttacked' )

		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.attacker ~= nil and params.attacker == self:GetParent() and params.target ~= nil then
			local heal = ( params.damage * self.enrage_lifesteal_bonus_pct / 100 )
			--print( 'modifier_shroomling_enrage healing for ' .. heal )
			self:GetParent():HealWithParams( heal, nil, true, true, nil, false )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
		end
	end

	return 1
end
