
modifier_siltbreaker_sprint = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:GetEffectName()
	return "particles/act_2/siltbreaker_sprint.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:OnCreated( kv )
	if IsServer() then
		self.sprint_speed = self:GetAbility():GetSpecialValueFor( "sprint_speed" )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:GetModifierMoveSpeed_Absolute( params )
	return self.sprint_speed
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_sprint:GetModifierMoveSpeed_Max( params )
	return self.sprint_speed
end

--------------------------------------------------------------------------------

