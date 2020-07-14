modifier_brewmaster_split = class({})

--------------------------------------------------------------------------------

function modifier_brewmaster_split:IsHidden()
	return true
end

-----------------------------------------------------------------------------------------

function modifier_brewmaster_split:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_brewmaster_split:GetPriority()
	return MODIFIER_PRIORITY_ULTRA + 10001
end

--------------------------------------------------------------------------------

function modifier_brewmaster_split:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	
	return state
end

--------------------------------------------------------------------------------

function modifier_brewmaster_split:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf"
end

--------------------------------------------------------------------------------

function modifier_brewmaster_split:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end


--------------------------------------------------------------------------------

function modifier_brewmaster_split:OnCreated( kv )
	if IsServer() then
		
	end
end

--------------------------------------------------------------------------------

function modifier_brewmaster_split:OnDestroy()
	if IsServer() then	
		EmitSoundOn( "Hero_Brewmaster.PrimalSplit.Spawn", self:GetParent() )
		
		local vPos = self:GetParent():GetAbsOrigin()

		local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vPos, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		local target = enemies[RandomInt(1,#enemies)]

		local earthspirit_name = "npc_dota_brewmaster_earth_unit"
		local earthspirit_origin = vPos
		local earthspirit = CreateUnitByName(earthspirit_name, earthspirit_origin, true, self:GetParent(), nil, DOTA_TEAM_BADGUYS)
		local earthspiritfx_name = "particles/units/heroes/hero_brewmaster/brewmaster_earth_ambient.vpcf"
		local earthspiritfx = ParticleManager:CreateParticle( earthspiritfx_name, PATTACH_ABSORIGIN_FOLLOW, earthspirit )
		ParticleManager:SetParticleControlEnt( earthspiritfx, 0, earthspirit, PATTACH_ABSORIGIN_FOLLOW, nil, earthspirit:GetOrigin(), true )
	 	earthspirit:SetInitialGoalEntity( target )

	 	local stormspirit_name = "npc_dota_brewmaster_storm_unit"
		local stormspirit_origin = vPos
		local stormspirit = CreateUnitByName(stormspirit_name, stormspirit_origin, true, self:GetParent(), nil, DOTA_TEAM_BADGUYS)
		local stormspiritfx_name = "particles/units/heroes/hero_brewmaster/brewmaster_storm_ambient.vpcf"
		local stormspiritfx = ParticleManager:CreateParticle( stormspiritfx_name, PATTACH_ABSORIGIN_FOLLOW, stormspirit )
		ParticleManager:SetParticleControlEnt( stormspiritfx, 0, stormspirit, PATTACH_ABSORIGIN_FOLLOW, nil, stormspirit:GetOrigin(), true )
	 	stormspirit:SetInitialGoalEntity( target )

	 	local firespirit_name = "npc_dota_brewmaster_fire_unit"
		local firespirit_origin = vPos
		local firespirit = CreateUnitByName(firespirit_name, firespirit_origin, true, self:GetParent(), nil, DOTA_TEAM_BADGUYS)
		local firespiritfx_name = "particles/units/heroes/hero_brewmaster/brewmaster_fire_ambient.vpcf"
		local firespiritfx = ParticleManager:CreateParticle( firespiritfx_name, PATTACH_ABSORIGIN_FOLLOW, firespirit )
		ParticleManager:SetParticleControlEnt( firespiritfx, 0, firespirit, PATTACH_ABSORIGIN_FOLLOW, nil, firespirit:GetOrigin(), true )
	 	firespirit:SetInitialGoalEntity( target )
		
		self:GetParent():AddEffects( EF_NODRAW )
		self:GetParent():ForceKill( false )
	end
end

--------------------------------------------------------------------------------
