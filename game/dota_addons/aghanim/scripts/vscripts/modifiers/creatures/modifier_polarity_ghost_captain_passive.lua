modifier_polarity_ghost_captain_passive = class({})

-----------------------------------------------------------------------------------------

function modifier_polarity_ghost_captain_passive:IsPurgable()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_polarity_ghost_captain_passive:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_polarity_ghost_captain_passive:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-------------------------------------------------------------------

function modifier_polarity_ghost_captain_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

-------------------------------------------------------------------

function modifier_polarity_ghost_captain_passive:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_death_prophet/death_prophet_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )

			local vPos = self:GetParent():GetAbsOrigin()
			ParticleManager:SetParticleControl( nFXIndex, 0, vPos )
			ParticleManager:SetParticleAlwaysSimulate( nFXIndex )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			self:GetParent():AddEffects( EF_NODRAW )

			EmitSoundOn( "Hero_DeathProphet.Death", self:GetParent() )			
		end
	end
end

