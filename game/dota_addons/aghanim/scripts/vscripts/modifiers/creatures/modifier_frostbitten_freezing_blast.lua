
modifier_frostbitten_freezing_blast = class({})

-----------------------------------------------------------------------------

function modifier_frostbitten_freezing_blast:IsHidden()
	return false
end

-----------------------------------------------------------------------------

function modifier_frostbitten_freezing_blast:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_freezing_blast:GetStatusEffectName()
	return "particles/status_fx/status_effect_wyvern_arctic_burn.vpcf"
end

-----------------------------------------------------------------------------

function modifier_frostbitten_freezing_blast:OnCreated( kv )
	if not IsServer() then
		return
	end

	self.movespeed_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.attackspeed_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )

	--[[
	int nFXIndex = GetParticleManager()->CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", PATTACH_CUSTOMORIGIN, GetParent() );
	GetParticleManager()->SetParticleControlEnt( nFXIndex, 0, GetParent(), PATTACH_ABSORIGIN_FOLLOW, NULL );
	GetParticleManager()->SetParticleControlEnt( nFXIndex, 1, GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", GetParent()->GetAbsOrigin() );
	GetParticleManager()->SetParticleControlEnt( nFXIndex, 2, GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1" );
	AddParticle( nFXIndex );
	]]
end

-----------------------------------------------------------------------------

function modifier_frostbitten_freezing_blast:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}	
	return funcs
end
----------------------------------------

function modifier_frostbitten_freezing_blast:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movespeed_slow
end

----------------------------------------

function modifier_frostbitten_freezing_blast:GetModifierAttackSpeedBonus_Constant( params )
	return self.attackspeed_slow
end

--------------------------------------------------------------------------------

