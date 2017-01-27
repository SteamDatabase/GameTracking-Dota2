modifier_zombie_torso = class({})

------------------------------------------------------------------

function modifier_zombie_torso:OnCreated( kv )
	if IsServer() then
		if self:GetAbility() ~= nil then
			self.spawn_delay = self:GetAbility():GetSpecialValueFor( "spawn_delay" )
		end	
	end
end

------------------------------------------------------------------

function modifier_zombie_torso:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_zombie_torso:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		if hUnit == self:GetParent() then
			CreateModifierThinker( self:GetCaster(), self, "modifier_zombie_torso_thinker", { duration = self.spawn_delay }, self:GetParent():GetOrigin(), self:GetParent():GetTeamNumber(), false )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_tower_destruct_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin()  )
		end
	end
end