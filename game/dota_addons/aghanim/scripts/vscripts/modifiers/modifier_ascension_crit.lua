
modifier_ascension_crit = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_crit:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_crit:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_crit:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )
	self.bIsCrit = false
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:OnTooltip( params )
	return self.crit_chance
end


--------------------------------------------------------------------------------

function modifier_ascension_crit:OnTooltip2( params )
	return self.crit_multiplier
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) 
				and hAttacker and ( hAttacker == self:GetParent() )
				and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if RollPseudoRandomPercentage( self.crit_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, hAttacker ) == true then
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then

				local vDir = ( self:GetParent():GetAbsOrigin() - hTarget:GetAbsOrigin() ):Normalized()

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetAbsOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, vDir )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Ability.CoupDeGrace", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0

end