
modifier_ability_cast_warning = class({})

--------------------------------------------------------------------------------

function modifier_ability_cast_warning:IsHidden()
	return true
end


--------------------------------------------------------------------------------

function modifier_ability_cast_warning:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_STATE_CHANGED,
		MODIFIER_EVENT_ON_ORDER,

	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ability_cast_warning:OnAbilityStart( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end

		-- Don't show exclamation mark on bosses
		if self:GetParent().bIsBoss then
			self:Destroy()
		end

		--printf("function modifier_ability_cast_warning:OnAbilityStart( params )")
		self.m_nWarningFX = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		self:AddParticle( self.m_nWarningFX, false, false, -1, false, true )

		self:StartIntervalThink( 0.75 )
	end
	return

end

-----------------------------------------------------------------------

function modifier_ability_cast_warning:OnIntervalThink()
	if IsServer() then
		if self.m_nWarningFX ~= nil then
			ParticleManager:DestroyParticle( self.m_nWarningFX, true )
		end
		return -1
	end
	return
end
--------------------------------------------------------------------------------

-----------------------------------------------------------------------

function modifier_ability_cast_warning:OnAbilityExecuted( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end
		if self.m_nWarningFX == nil then
			return
		end
		ParticleManager:DestroyParticle( self.m_nWarningFX, true )

	end
	return
end
--------------------------------------------------------------------------------
	
function modifier_ability_cast_warning:OnStateChanged( params )
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit ~= hParent then
			return
		end

		if self.m_nWarningFX == nil then
			return
		end

		if hParent ~= nil and hParent:IsAlive() then
			if hParent:IsSilenced() or hParent:IsStunned() or hParent:IsHexed() or hParent:IsFrozen() then
				ParticleManager:DestroyParticle( self.m_nWarningFX, true )
			end
			return
		else
			ParticleManager:DestroyParticle( self.m_nWarningFX, true )
		end
	end
	return
end

-----------------------------------------------------------------------

function modifier_ability_cast_warning:OnDeath( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end
		if self.m_nWarningFX ~= nil then
			ParticleManager:DestroyParticle( self.m_nWarningFX, true )
			return
		end
	end
	return
end

-----------------------------------------------------------------------

function modifier_ability_cast_warning:OnOrder( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end
		if self.m_nWarningFX ~= nil then
			ParticleManager:DestroyParticle( self.m_nWarningFX, true )
			return
		end
	end
	return
end