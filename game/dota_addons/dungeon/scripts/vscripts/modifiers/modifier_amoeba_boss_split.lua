modifier_amoeba_boss_split = class({})

-------------------------------------------------------------

function modifier_amoeba_boss_split:IsHidden()
	return true
end

-------------------------------------------------------------

function modifier_amoeba_boss_split:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

-------------------------------------------------------------

function modifier_amoeba_boss_split:GetEffectName()
	return "particles/act_2/amoeba_boss_split.vpcf"
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_split:CheckState()
	local state = {}
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_OUT_OF_GAME] = true
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	return state
end

-----------------------------------------------------------------------------------------

function modifier_amoeba_boss_split:OnDestroy()
	if IsServer() then
		EmitSoundOn( "DOTA_Item.Manta.Activate", self:GetParent() )
		local vDir = RandomVector( 1 )
		local vLocation1 = self:GetParent():GetOrigin() + vDir * 800
		local vLocation2 = self:GetParent():GetOrigin() - vDir * 800

		local nFXCastIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXCastIndex1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXCastIndex1, 1, vLocation1 )
		ParticleManager:ReleaseParticleIndex( nFXCastIndex1 )

		local nFXCastIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXCastIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControl( nFXCastIndex2, 1, vLocation2 )
		ParticleManager:ReleaseParticleIndex( nFXCastIndex2 )

		local hAmoeba1 = CreateUnitByName( "npc_dota_creature_sub_amoeba_boss", vLocation1, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hAmoeba1 ~= nil then
			if self:GetCaster().zone ~= nil then
				self:GetCaster().zone:AddEnemyToZone( hAmoeba1 )
			end	
			local hBuff = hAmoeba1:FindModifierByName( "modifier_amoeba_boss_passive" )
			if hBuff ~= nil then
				hBuff:SetStackCount( 50 )
			end
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation1 )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAmoeba, PATTACH_POINT_FOLLOW, "attach_hitloc", hAmoeba1:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
		local hAmoeba2 = CreateUnitByName( "npc_dota_creature_sub_amoeba_boss", vLocation2, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hAmoeba2 ~= nil then
			if self:GetCaster().zone ~= nil then
				self:GetCaster().zone:AddEnemyToZone( hAmoeba2 )
			end	
			local hBuff = hAmoeba2:FindModifierByName( "modifier_amoeba_boss_passive" )
			if hBuff ~= nil then
				hBuff:SetStackCount( 50 )
			end
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, vLocation2 )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150, 150, 150 ) )
			ParticleManager:SetParticleControlEnt( nFXIndex, 2, hAmoeba, PATTACH_POINT_FOLLOW, "attach_hitloc", hAmoeba2:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end

	end
end
