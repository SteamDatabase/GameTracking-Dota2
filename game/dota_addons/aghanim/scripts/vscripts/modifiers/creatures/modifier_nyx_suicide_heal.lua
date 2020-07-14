
modifier_nyx_suicide_heal = class({})

--------------------------------------------------------------

function modifier_nyx_suicide_heal:IsHidden()
	return true
end

--------------------------------------------------------------

function modifier_nyx_suicide_heal:IsPurgable()
	return true
end

--------------------------------------------------------------

function modifier_nyx_suicide_heal:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
-------------------------------------------------------------------

function modifier_nyx_suicide_heal:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local heal = self:GetAbility():GetSpecialValueFor( "heal" )
			local radius = self:GetAbility():GetSpecialValueFor( "radius" )

			if self:GetParent().nFXIndex ~= nil then
				ParticleManager:DestroyParticle( self:GetParent().nFXIndex, true )	
			end
			
			EmitSoundOn( "Burrower.HealExplosion", self:GetParent() )

			local nFXIndex2 = ParticleManager:CreateParticle( "particles/nyx_swarm_explosion/nyx_swarm_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( radius, radius, radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex2 )

			local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			for _,entity in pairs( entities ) do
				if entity ~= nil and entity:IsAlive() then
					entity:Heal( heal, self:GetAbility() )
					ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/items3_fx/fish_bones_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, entity ) )
				end
			end
		end
	end
end

