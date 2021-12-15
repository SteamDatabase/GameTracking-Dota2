modifier_bloodbound = class({})

--------------------------------------------------------------------------------

function modifier_bloodbound:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_bloodbound:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_bloodbound:OnCreated( kv )
	if IsServer() == false then
		return
	end

	self.flLastSoundTime = -1
end

--------------------------------------------------------------------------------

function modifier_bloodbound:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bloodbound:GetModifierModelScale( params )
	if self:GetParent() == nil or self:GetParent():PassivesDisabled() then
		return 0
	end

    --return 5 * self:GetStackCount()
	return math.max( 0, math.floor( math.sqrt( self:GetStackCount() ) * 15 - 10 ) )
end

--------------------------------------------------------------------------------

function modifier_bloodbound:GetModifierDamageOutgoing_Percentage( params )
	if self:GetParent() == nil or self:GetParent():PassivesDisabled() then
		return 0
	end

	return 8 * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_bloodbound:OnDeath( params )
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 1
		end

		if params.unit ~= nil and params.unit == self:GetParent() then

			local entities = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

			if #entities > 0 then
				for _,entity in pairs(entities) do
					if entity ~= nil and entity:IsNull() == false and entity ~= self:GetParent() and entity:IsAlive() then
							--and ( ( entity:IsInvulnerable() == false and entity:GetAggroTarget() ~= nil ) -- or ( entity:CanBeSeenByAnyOpposingTeam() )
							--) then
						local hBuff = entity:FindModifierByName( "modifier_bloodbound" )
						if hBuff ~= nil and entity:GetUnitName() ~= "npc_dota_creature_bloodbound_warlock_baby" then
							hBuff:SetStackCount( hBuff:GetStackCount() + 1 )

							-- buff particle
							local nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/bloodbound_cast.vpcf", PATTACH_CUSTOMORIGIN, entity )
							ParticleManager:SetParticleControlEnt( nFXIndex, 0, entity, PATTACH_POINT_FOLLOW, "attach_attack1", entity:GetAbsOrigin(), true )
							ParticleManager:SetParticleControlEnt( nFXIndex, 1, entity, PATTACH_ABSORIGIN_FOLLOW, nil, entity:GetAbsOrigin(), true )
							ParticleManager:SetParticleControlEnt( nFXIndex, 2, entity, PATTACH_POINT_FOLLOW, "attach_hitloc", entity:GetAbsOrigin(), true )
							ParticleManager:SetParticleControlEnt( nFXIndex, 3, entity, PATTACH_ABSORIGIN_FOLLOW, nil, entity:GetAbsOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )

							nFXIndex = ParticleManager:CreateParticle( "particles/gameplay/bloodbound_arc.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
							ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetAbsOrigin() + Vector( 0, 0, 100 ) )
							ParticleManager:SetParticleControlEnt( nFXIndex, 1, entity, PATTACH_POINT_FOLLOW, "attach_hitloc", entity:GetAbsOrigin(), true )
							ParticleManager:ReleaseParticleIndex( nFXIndex )

							
							--[[if GameRules:GetGameTime() > hBuff.flLastSoundTime + 1.0 then
								hBuff.flLastSoundTime = GameRules:GetGameTime()
								EmitSoundOn( "Hero_OgreMagi.Bloodlust.Target", entity )
							end--]]
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
