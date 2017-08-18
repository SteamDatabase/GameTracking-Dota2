
modifier_siltbreaker_summon_clone = class ({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_clone:GetEffectName()
	return "particles/items2_fx/manta_phase.vpcf"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_clone:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_clone:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_clone:OnDestroy()
	local hBoss = self:GetCaster()

	local hClone = CreateUnitByName( "npc_dota_creature_siltbreaker_clone", hBoss:GetAbsOrigin(), true, hBoss, hBoss, hBoss:GetTeamNumber() )
	if hClone ~= nil then
		--[[
		local bCloneImmunePhys = ( RandomFloat( 0, 1 ) > 0.5 )
		if bCloneImmunePhys then
			hClone:AddNewModifier( hBoss, self:GetAbility(), "modifier_siltbreaker_immune_physical", { duration = -1 } )
			hBoss:AddNewModifier( hBoss, self:GetAbility(), "modifier_siltbreaker_immune_magical", { duration = -1 } )
		else
			hClone:AddNewModifier( hBoss, self:GetAbility(), "modifier_siltbreaker_immune_magical", { duration = -1 } )
			hBoss:AddNewModifier( hBoss, self:GetAbility(), "modifier_siltbreaker_immune_physical", { duration = -1 } )
		end
		]]

		hClone.hMaster = hBoss

		local vRandomOffset = Vector( RandomInt( -300, 300 ), RandomInt( -300, 300 ), 0 )
		local vSpawnPoint = hBoss:GetAbsOrigin() + vRandomOffset
		FindClearSpaceForUnit( hClone, vSpawnPoint, true )
	end

	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_clone:CheckState()
	local state = {}
	if IsServer() then
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_STUNNED ] = true
		state[ MODIFIER_STATE_UNSELECTABLE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true
	end

	return state
end

--------------------------------------------------------------------------------

