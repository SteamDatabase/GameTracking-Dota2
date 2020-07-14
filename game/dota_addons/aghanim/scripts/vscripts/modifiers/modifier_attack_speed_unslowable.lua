
modifier_attack_speed_unslowable = class({})

-----------------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:IsPurgable()
	return false
end

----------------------------------------

function modifier_attack_speed_unslowable:OnCreated( kv )

	-- Allow units to directly use this modifier, in which case the kv has the amount of reduction
	if self:GetAbility() == nil and IsServer() == true then
		self.attack_speed_reduction_pct = 0
		if kv.attack_speed_reduction_pct ~= nil then
			self.attack_speed_reduction_pct = kv.attack_speed_reduction_pct
			if self.attack_speed_reduction_pct ~= 0 then
				self:SetHasCustomTransmitterData( true )
			end
		end
	end 	

	self:OnRefresh( kv )
end

----------------------------------------

function modifier_attack_speed_unslowable:OnRefresh( kv )
	if self:GetAbility() ~= nil then
		self.attack_speed_reduction_pct = self:GetAbility():GetSpecialValueFor( "attack_speed_reduction_pct" )	
	end
end

--------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:GetModifierAttackSpeedReductionPercentage( params )
	return self.attack_speed_reduction_pct
end

--------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:AddCustomTransmitterData( )
	return
	{
		armor = self.attack_speed_reduction_pct
	}
end

--------------------------------------------------------------------------------

function modifier_attack_speed_unslowable:HandleCustomTransmitterData( data )
	self.attack_speed_reduction_pct = data.armor
end
