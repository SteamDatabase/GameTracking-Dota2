
modifier_siltbreaker_mind_control = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:GetStatusEffectName()
	return "particles/econ/events/ti7/fountain_regen_ti7_bubbles.vpcf"
	--return "particles/status_fx/status_effect_bloodrage.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:OnCreated( kv )
	if IsServer() then
		if self:GetParent():GetForceAttackTarget() then
			self:Destroy()
			return
		end

		self.movespeed_bonus = self:GetAbility():GetSpecialValueFor( "movespeed_bonus" )
		self.attackspeed_bonus = self:GetAbility():GetSpecialValueFor( "attackspeed_bonus" )
		self.target_search_radius = self:GetAbility():GetSpecialValueFor( "target_search_radius" )
		self.charm_duration = self:GetAbility():GetSpecialValueFor( "charm_duration" )
		self.model_scale_perc = self:GetAbility():GetSpecialValueFor( "model_scale_perc" )

		self:GetParent():Interrupt()
		self:GetParent():SetIdleAcquire( true )

		self:GetParent():AddNewModifier( self:GetCaster(), nil, "modifier_phased", { duration = -1 } )

		local hAllies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.target_search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #hAllies > 1 then
			self.hDesiredTarget = hAllies[ 2 ] -- assumes 1 will always be parent
			self:GetParent():SetForceAttackTargetAlly( self.hDesiredTarget )
			self.hDesiredTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_siltbreaker_mind_control_marked", { duration = self.charm_duration } )
			EmitSoundOn( "Siltbreaker.MindControl.VictimLoop", self:GetParent() )

			self:StartIntervalThink( 0 )
		else
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}	
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movespeed_bonus
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:GetModifierAttackSpeedBonus_Constant( params )
	return self.attackspeed_bonus
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:GetModifierModelScale( params )
	return self.model_scale_perc
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetForceAttackTarget() == nil then
			self:GetParent():SetForceAttackTargetAlly( self.hDesiredTarget )
		end

		if self.hDesiredTarget == nil or self.hDesiredTarget:IsAlive() == false then
			self:Destroy()
			return
		end
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTargetAlly( nil )

		self:GetParent():RemoveModifierByName( "modifier_phased" )

		StopSoundOn( "Siltbreaker.MindControl.VictimLoop", self:GetParent() )
		EmitSoundOn( "Siltbreaker.MindControl.VictimEnd", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_mind_control:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	end

	return state
end

--------------------------------------------------------------------------------

