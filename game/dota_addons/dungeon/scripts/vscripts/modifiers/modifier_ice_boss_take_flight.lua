modifier_ice_boss_take_flight = class({})

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:IsPurgable()
	return false
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:OnCreated( kv )
	self.flight_speed = self:GetAbility():GetSpecialValueFor( "flight_speed" )
	self.per_egg_speed = self:GetAbility():GetSpecialValueFor( "per_egg_speed" )
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
	end
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:GetModifierMoveSpeed_Absolute( params )
	if IsServer() then
		if self:GetParent().numEggsKilled ~= nil then
			return self.flight_speed + ( self:GetParent().numEggsKilled * self.per_egg_speed )
		end
	end
	return self.flight_speed
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:GetModifierMoveSpeed_Max( params )
	if IsServer() then
		if self:GetParent().numEggsKilled ~= nil then
			return self.flight_speed + ( self:GetParent().numEggsKilled * self.per_egg_speed )
		end
	end
	return self.flight_speed
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:GetVisualZDelta( params )
	return 550
end

--------------------------------------------------------------------------------

function modifier_ice_boss_take_flight:GetActivityTranslationModifiers( params )
	return "flying"
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:GetHeroEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_hero_effect.vpcf"
end

-----------------------------------------------------------------------

function modifier_ice_boss_take_flight:CheckState()
	local state = 
	{
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end
