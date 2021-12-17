modifier_amoeba_baby_death_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_amoeba_baby_death_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_baby_death_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_baby_death_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-------------------------------------------------------------------

function modifier_amoeba_baby_death_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-------------------------------------------------------------------

function modifier_amoeba_baby_death_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/act_2/amoeba_baby_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )

			local vPos = self:GetParent():GetAbsOrigin()
			vPos.z = vPos.z + 96
			local vForward = self:GetParent():GetForwardVector()
			local vUp = self:GetParent():GetUpVector()
			local vRight = self:GetParent():GetRightVector()

			ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
			ParticleManager:SetParticleControlOrientation( nFXIndex, 1, vForward, vRight, vUp )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )

			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self:GetParent():AddEffects( EF_NODRAW )
			--self:StartIntervalThink( 0.5 )
		end
	end
end

-------------------------------------------------------------------
--[[
function modifier_amoeba_baby_death_passive:OnIntervalThink()
	if IsServer() == false then
		return
	end

	self:GetParent():AddEffects( EF_NODRAW )	

	self:StartIntervalThink( -1 )
end
]]--