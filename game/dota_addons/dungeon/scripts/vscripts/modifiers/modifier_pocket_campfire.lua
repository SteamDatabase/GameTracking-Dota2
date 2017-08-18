
modifier_pocket_campfire = class({})

--------------------------------------------------------------------------------

function modifier_pocket_campfire:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:GetModifierAura()
	return  "modifier_pocket_campfire_effect"
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:GetAuraRadius()
	return self.aura_radius
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:OnCreated( kv )
	if IsServer() then
		self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

		self.fCreationTime = GameRules:GetGameTime()

		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
		self:GetParent():AddNewModifier( nil, nil, "modifier_provides_fow_position", { duration = -1 } )

		EmitSoundOn( "Campfire.Warmth.Loop", self:GetParent() )

		self:StartIntervalThink( 0.25 )
	end
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_BLIND] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_OUT_OF_GAME] = true
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:OnIntervalThink()
	if IsServer() then
		if ( not self.nFXIndex ) then
			local vCasterPos = self:GetCaster():GetOrigin()
			local vOffset = Vector( 0, 0, 50 )

			self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/campfire_flame.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( self.nFXIndex, 2, vCasterPos + vOffset )
		end

		local duration = self:GetAbility():GetSpecialValueFor( "campfire_duration" )
		if GameRules:GetGameTime() > self.fCreationTime + duration then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_pocket_campfire:OnDestroy()
	if IsServer() then
		StopSoundOn( "Campfire.Warmth.Loop", self:GetParent() )

		UTIL_RemoveImmediate( self:GetParent() )
	end
end

--------------------------------------------------------------------------------

