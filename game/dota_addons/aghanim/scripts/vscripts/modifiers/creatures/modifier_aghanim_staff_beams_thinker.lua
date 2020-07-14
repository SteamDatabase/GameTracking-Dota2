
modifier_aghanim_staff_beams_thinker = class({})

-----------------------------------------------------------------------------

function modifier_aghanim_staff_beams_thinker:OnCreated( kv )
	if IsServer() then
		self.linger_time = self:GetAbility():GetSpecialValueFor( "linger_time" )
		self.linger_create_interval = self:GetAbility():GetSpecialValueFor( "linger_create_interval" )
		self:StartIntervalThink( self.linger_create_interval )
	end
end

-----------------------------------------------------------------------------

function modifier_aghanim_staff_beams_thinker:OnIntervalThink()
	if IsServer() then
		CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_aghanim_staff_beams_linger_thinker", { duration = self.linger_time }, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )
	end
end

-----------------------------------------------------------------------------