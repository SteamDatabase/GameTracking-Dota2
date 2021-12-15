modifier_diregull_passive = class({})

--------------------------------------------------------------------------------

function modifier_diregull_passive:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_diregull_passive:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_diregull_passive:OnCreated( kv )
	if IsServer() == false then
		return
	end

end

--------------------------------------------------------------------------------

function modifier_diregull_passive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_diregull_passive:OnDeath( params )
	if IsServer() then
		local hUnit = params.unit
		local hAttacker = params.attacker
		if hAttacker == nil or hAttacker:IsBuilding() then
			return 0
		end
		if hUnit == self:GetParent() then
			--print( "Diregull has died" )
			EmitSoundOn( "Diregull.Death", hUnit )
			hUnit:AddEffects( EF_NODRAW )
			local radius = 150
			if hUnit:GetUnitName() == "npc_dota_creature_diregull" then
				radius = 300
			end
			local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/diregull/diregull_death_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, radius, radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end

	return 0
end

--------------------------------------------------------------------------------

function modifier_diregull_passive:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------
