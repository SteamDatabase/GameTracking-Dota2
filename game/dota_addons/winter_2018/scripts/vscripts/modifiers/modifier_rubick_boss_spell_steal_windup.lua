modifier_rubick_boss_spell_steal_windup = class({})

--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:IsHidden()
	return true
end

-----------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA + 1
end

-----------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:OnCreated( kv )
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle( "particles/dark_moon/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 0, 191, 0 ) )
	end
end

-----------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:SetAnim( act )
	if IsServer() then
		self.Gesture = act
		self:GetParent():StartGesture( self.Gesture )
	end
end

-----------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
		self:GetParent():RemoveGesture( self.Gesture )
		CustomGameEventManager:Send_ServerToAllClients( "rubick_finished_stolen_spell", {  } )
	end
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:GetActivityTranslationModifiers( params )
	return ""
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:CheckState()
	local state = {}
	state[MODIFIER_STATE_DISARMED] = true
	return state
end


--------------------------------------------------------------------------------

function modifier_rubick_boss_spell_steal_windup:OnAbilityFullyCast( params )
	if IsServer() then
		local hAbility = params.ability
		if hAbility == self.hForceCastStolenSpell then
			self:Destroy()
		end
	end
end