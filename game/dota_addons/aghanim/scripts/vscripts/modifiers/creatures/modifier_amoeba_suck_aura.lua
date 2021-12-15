modifier_amoeba_suck_aura = class({})

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetStatusEffectName()
	return "particles/status_fx/status_effect_guardian_angel.vpcf"
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetModifierAura()
	return "modifier_amoeba_suck_debuff"
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetAuraRadius()
	return self.nRadius
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:GetBabiesConsumed()
	if IsServer() then
		return self.nBabiesConsumed
	end
	return 0
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:OnCreated( kv )
	self.nRadius = 0
	if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.eat_radius = self:GetAbility():GetSpecialValueFor( "eat_radius" )
		self.suck_radius_per_stack = self:GetAbility():GetSpecialValueFor( "suck_radius_per_stack" )

		self.nRadius = self.radius
		self.nBabiesConsumed = 0

		self:StartIntervalThink( 0.2 )
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:OnIntervalThink()
	if IsServer() then
		local babies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), nil, self.eat_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
		for _,baby in pairs( babies ) do
			if baby ~= nil and baby:IsNull() == false and baby:IsAlive() == true and baby:GetUnitName() == "npc_dota_creature_amoeba_baby" then
				baby:ForceKill( false )
				baby:AddEffects( EF_NODRAW )
				self.nBabiesConsumed = self.nBabiesConsumed + 1

				self.nRadius = self.radius + self.suck_radius_per_stack * self.nBabiesConsumed
				EmitSoundOn( "DOTA_Item.Cheese.Activate", self:GetParent() )
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:OnRefresh( kv )
	if IsServer() then
		--self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	end
end

--------------------------------------------------------------------------------

function modifier_amoeba_suck_aura:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
	}

	return state
end
