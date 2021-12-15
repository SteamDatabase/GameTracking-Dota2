
modifier_skeleton_mage_grenade = class({})

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:GetStatusEffectName()
	return "particles/status_fx/status_effect_burn.vpcf"
end

----------------------------------------------------------------------------------------
function modifier_skeleton_mage_grenade:OnCreated( kv )
	if IsServer() then
		self.slow_movement_speed_pct = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
		--self.slow_movement_speed_pct = kv[ "slow_movement_speed_pct" ]
		self.damage_per_second = self:GetAbility():GetSpecialValueFor( "damage_per_second" )
		self.damage_interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )

		self:SetHasCustomTransmitterData( true )

		self:OnIntervalThink()
		self:StartIntervalThink( self.damage_interval )
	end
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:AddCustomTransmitterData()
	return
	{
		slow_movement_speed_pct = self.slow_movement_speed_pct,
	}
end

--------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:HandleCustomTransmitterData( data )
	self.slow_movement_speed_pct = data.slow_movement_speed_pct
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:OnIntervalThink()
	if IsServer() then
		local fDamage = self.damage_per_second * self.damage_interval

		local damageInfo = 
		{
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = fDamage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}

		ApplyDamage( damageInfo )

		EmitSoundOn( "SkeletonMage.Grenade.Damage", self:GetParent() )
	end
end

----------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

------------------------------------------------------------------------------------

function modifier_skeleton_mage_grenade:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.slow_movement_speed_pct
end

--------------------------------------------------------------------------------
