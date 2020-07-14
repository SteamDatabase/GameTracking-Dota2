modifier_brewmaster_unit_passive = class({})

--------------------------------------------------------------

function modifier_brewmaster_unit_passive:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

--------------------------------------------------------------

function modifier_brewmaster_unit_passive:OnDeath( params )
	if not IsServer() or params.unit ~= self:GetParent() then
		return 0
	end

	print("Brewling died!")
	local killedUnit = self:GetParent()
	local unitName = killedUnit:GetUnitName()
	print(unitName)
	if killedUnit:GetUnitName() == "npc_dota_brewmaster_earth_unit" then
		local vPos = killedUnit:GetAbsOrigin()
		local fx_name = "particles/units/heroes/hero_brewmaster/brewmaster_earth_death_collapse.vpcf"
		local fx = ParticleManager:CreateParticle( fx_name, PATTACH_ABSORIGIN, killedUnit )
		ParticleManager:SetParticleControlEnt( fx, 0, killedUnit, PATTACH_ABSORIGIN, nil, killedUnit:GetOrigin(), true )
		killedUnit:SetModelScale(0.1)
		--ParticleManager:DestroyParticle( fx, false )
	elseif killedUnit:GetUnitName() == "npc_dota_brewmaster_storm_unit" then
		local vPos = killedUnit:GetAbsOrigin()
		local fx_name = "particles/units/heroes/hero_brewmaster/brewmaster_storm_death.vpcf"
		local fx = ParticleManager:CreateParticle( fx_name, PATTACH_ABSORIGIN, killedUnit )
		ParticleManager:SetParticleControlEnt( fx, 0, killedUnit, PATTACH_ABSORIGIN, nil, killedUnit:GetOrigin(), true )
		killedUnit:SetModelScale(0.1)
		--ParticleManager:DestroyParticle( fx, false )
	elseif killedUnit:GetUnitName() == "npc_dota_brewmaster_fire_unit" then
		local vPos = killedUnit:GetAbsOrigin()
		local fx_name = "particles/units/heroes/hero_brewmaster/brewmaster_fire_death.vpcf"
		local fx = ParticleManager:CreateParticle( fx_name, PATTACH_ABSORIGIN, killedUnit )
		ParticleManager:SetParticleControlEnt( fx, 0, killedUnit, PATTACH_ABSORIGIN, nil, killedUnit:GetOrigin(), true )
		killedUnit:SetModelScale(0.1)
		--ParticleManager:DestroyParticle( fx, false )
	end

end

