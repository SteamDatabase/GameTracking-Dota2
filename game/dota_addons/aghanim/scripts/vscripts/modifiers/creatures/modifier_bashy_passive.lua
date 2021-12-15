modifier_bashy_passive = class({})

--------------------------------------------------------------------------------

function modifier_bashy_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:ShouldUseOverheadOffset()
	return true 
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:OnCreated( kv )
	self.max_movespeed = self:GetAbility():GetSpecialValueFor( "max_movespeed" )
	--self:SetOverheadEffectOffset( 500 )
	if IsServer() then 
		self:SetStackCount( 0 )

		local nStackCount = 0
		self.hBashModifier = self:GetParent():FindModifierByName( "modifier_slardar_bash_active" )
		if self.hBashModifier then 
			--print( "found modifier" )
			nStackCount = self.hBashModifier:GetStackCount() 
		end
		--print( "Setting stack count:" .. nStackCount )
		
		self.nFXIndex = ParticleManager:CreateParticle( "particles/creatures/bashy_stack_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, Vector( 500, 0, 0 ) )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 0, nStackCount, 0 ) )
		self:AddParticle( self.nFXIndex, false, false, -1, false, true )

		self:StartIntervalThink( 0.05 )
	end
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:OnIntervalThink()
	if IsServer() == false then 
		return 
	end

	local nStackCount = 0
	if self.hBashModifier == nil then 
		self.hBashModifier = self:GetParent():FindModifierByName( "modifier_slardar_bash_active" )
		
	end

	if self.hBashModifier then 
		--print( "found modifier" )
		nStackCount = self.hBashModifier:GetStackCount() 
	end

	--print( "Setting stack count:" .. nStackCount )

	ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 0, nStackCount, 0 ) )
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bashy_passive:GetModifierMoveSpeed_AbsoluteMax( params )
	if IsServer() then
		if self:GetParent() and ( self:GetParent():FindModifierByName( "modifier_slardar_puddle" ) or self:GetStackCount() > 0 ) then 
			return self.max_movespeed 
		end
	end
	return 0
end

-------------------------------------------------------------------------------

function modifier_bashy_passive:GetModifierModelScale( params )
	return self:GetStackCount() 
end