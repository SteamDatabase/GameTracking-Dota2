LinkLuaModifier( "modifier_campfire_effect", "heroes/campfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_campfire", "heroes/campfire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_provides_fow_position", "heroes/campfire", LUA_MODIFIER_MOTION_NONE )


campfire = class({})

function campfire:GetIntrinsicModifierName()
	return "modifier_campfire"
end

--------------------------------------------------------------------------------

modifier_campfire = class({})

function modifier_campfire:IsHidden()
	return true
end

function modifier_campfire:IsAura()
	return true
end

function modifier_campfire:GetModifierAura()
	return  "modifier_campfire_effect"
end

function modifier_campfire:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_campfire:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
 
function modifier_campfire:GetAuraRadius()
	return self.aura_radius
end

function modifier_campfire:OnCreated( kv )
	if IsServer() then
		self.aura_radius = self:GetAbility():GetSpecialValueFor( "aura_radius" )

		self.fCreationTime = GameRules:GetGameTime()

		self:GetParent():AddNewModifier( nil, nil, "modifier_disable_aggro", { duration = -1 } )
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_provide_vision", { duration = -1 } )

		EmitSoundOn( "Campfire.Warmth.Loop", self:GetParent() )

		self:StartIntervalThink( 0.25 )
	end
end

function modifier_campfire:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	end

	return state
end

function modifier_campfire:OnIntervalThink()
	if IsServer() then
		if ( not self.nFXIndex ) then
			local vCasterPos = self:GetCaster():GetOrigin()
			local vOffset = Vector( 0, 0, 50 )

			self.nFXIndex = ParticleManager:CreateParticle( "particles/act_2/campfire_flame.vpcf",
															 PATTACH_ABSORIGIN, 
															 self:GetCaster() )
			ParticleManager:SetParticleControl( self.nFXIndex, 2, vCasterPos + vOffset )			
		end

		local duration = self:GetAbility():GetSpecialValueFor( "campfire_duration" )
		if GameRules:GetGameTime() > self.fCreationTime + duration then
			self:Destroy()
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
		end
	end
end

function modifier_campfire:OnDestroy()
	if IsServer() then
		StopSoundOn( "Campfire.Warmth.Loop", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

modifier_campfire_effect = class({})

function modifier_campfire_effect:GetEffectName()
	return "particles/camp_fire_buff.vpcf"
	--return "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
	--return "particles/units/heroes/hero_legion_commander/legion_commander_duel_buff.vpcf"
	--return "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_totem_buff_egset.vpcf"
end
function modifier_campfire_effect:OnCreated( kv )	
	self.aura_hp_regen = .5
	self.aura_mana_regen = .5
end

function modifier_campfire_effect:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_campfire_effect:GetModifierConstantHealthRegen( params )
	return self.aura_hp_regen
end

function modifier_campfire_effect:GetModifierConstantManaRegen( params )
	return self.aura_mana_regen
end

--------------------------------------------------------------------------------

modifier_provides_fow_position = class({})

function modifier_provides_fow_position:IsHidden()
	return false
end

function modifier_provides_fow_position:CheckState()
    local state = {
	    [MODIFIER_STATE_PROVIDES_VISION] = true,
	}
 
    return state
end

function modifier_provides_fow_position:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end