modifier_winter_wyvern_arctic_burn_nb2017 = class({})

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:OnCreated( kv )
	if IsServer() then
		self:GetParent():StartGesture( ACT_DOTA_CAST_ABILITY_1 )

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetOrigin(), true );
		ParticleManager:SetParticleControlEnt( nFXIndex, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetOrigin(), true );
		self:AddParticle( nFXIndex, false, false, -1, false, false );

		if self:GetCaster() == self:GetParent() then
			local nFXIndexB = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_flying.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine_1", self:GetParent():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine_2", self:GetParent():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine_3", self:GetParent():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine_4", self:GetParent():GetOrigin(), true );
			ParticleManager:SetParticleControlEnt( nFXIndexB, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_spine_5", self:GetParent():GetOrigin(), true );
			self:AddParticle( nFXIndexB, false, false, -1, false, false );
		end

		if self:GetCaster():HasScepter() and ( self:GetParent() == self:GetCaster() ) then
			self:StartIntervalThink( 1.0 )
		end

		if self:GetParent():IsRangedAttacker() then
			self.szRangedProjectileName = self:GetParent():GetRangedProjectileName();
			self:GetParent():SetRangedProjectileName( "particles/units/heroes/hero_winter_wyvern/winter_wyvern_arctic_attack.vpcf" )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == self:GetParent() then
			local mana_cost_scepter = self:GetAbility():GetSpecialValueFor( "mana_cost_scepter" ) 
			self:GetParent():SpendMana( mana_cost_scepter, self:GetAbility() )
			if self:GetAbility():GetToggleState() == true and ( self:GetParent():GetMana() <= mana_cost_scepter ) then
				self:GetAbility():OnToggle()
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:OnDestroy()
	if IsServer() then
		self:GetParent():StartGesture( ACT_DOTA_ARCTIC_BURN_END )
		StopSoundOn( "Hero_Winter_Wyvern.ArcticBurn.Cast", self:GetParent() )

		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self:GetAbility():GetSpecialValueFor( "tree_destruction_radius" ), false )
		if self:GetParent():IsRangedAttacker() then
			self:GetParent():SetRangedProjectileName( self.szRangedProjectileName );
		end
		
	end 
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:OnAttackLanded( params )
	if IsServer() then
		local hAttacker = params.attacker
		local hTarget = params.target

		if hAttacker == nil or hTarget == nil or hAttacker ~= self:GetParent() then
			return 0
		end

		if hTarget:IsBuilding() or hTarget:IsMagicImmune() then
			return 0
		end

		local kv = 
		{
			duration = self:GetAbility():GetSpecialValueFor( "damage_duration" )
		}
 
		hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_winter_wyvern_arctic_burn_debuff_dark_moon", kv )
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:GetModifierAttackPointConstant( params )
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor( "attack_point" )
		else
			return 0
		end
	end
	
	return self:GetAbility():GetSpecialValueFor( "attack_point" )
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:GetActivityTranslationModifiers( params )
	return "flying"
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:GetModifierAttackRangeBonus( params )
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
		else
			return 0
		end
	end

	return self:GetAbility():GetSpecialValueFor( "attack_range_bonus" )
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:GetModifierProjectileSpeedBonus( params )
	if IsServer() then
		if self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor( "projectile_speed_bonus" )
		else
			return 0
		end
	end

	return self:GetAbility():GetSpecialValueFor( "projectile_speed_bonus" )
end

--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:GetBonusNightVision( params )
	return self:GetAbility():GetSpecialValueFor( "night_vision_bonus" )
end


--------------------------------------------------------------------------------

function modifier_winter_wyvern_arctic_burn_nb2017:CheckState()
	local state = {
	[MODIFIER_STATE_FLYING] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

