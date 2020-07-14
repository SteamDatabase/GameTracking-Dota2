modifier_sand_king_boss_burrow = class({})

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:OnCreated( kv )
	if IsServer() then
		local flInterval = 0.65
		if self:GetParent():GetHealthPercent() < 50 then
			flInterval = 0.5
		end
		if self:GetParent():GetHealthPercent() < 25 then
			flInterval = 0.3
		end
		self:StartIntervalThink( flInterval )
	end
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:GetActivityTranslationModifiers( params )
	return "burrowed"
end

--------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:GetModifierTurnRate_Percentage( params )
	return -50
end

-----------------------------------------------------------------------------------------

function modifier_sand_king_boss_burrow:OnIntervalThink()
	if IsServer() then
		local nBurrowerType = RandomInt( 0, 1 )
		local szBurrowerName = nil
		if nBurrowerType == 0 then
			szBurrowerName = "npc_dota_creature_healing_burrower"
		end
		if nBurrowerType == 1 then
			szBurrowerName = "npc_dota_creature_big_exploding_burrower"
		end

		local hMinion = CreateUnitByName( szBurrowerName, self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hMinion ~= nil then
			if self:GetCaster().zone ~= nil then
				self:GetCaster().zone:AddEnemyToZone( hMinion )
			end
			hMinion.hParent = self:GetCaster()
			
			local vCasterPos = self:GetCaster():GetAbsOrigin()
			local vSpawnPoint = vCasterPos + RandomVector( 1 ) * 2500
			if nBurrowerType ~= 0 then
				vSpawnPoint = vCasterPos + RandomVector( RandomFloat( 200, 500 ) )
			end

			FindClearSpaceForUnit( hMinion, vSpawnPoint, true )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			if nBurrowerType == 0 then
				local nFxIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, hMinion )
				ParticleManager:SetParticleControlEnt( nFxIndex2, 0, hMinion, PATTACH_ABSORIGIN_FOLLOW, nil, hMinion:GetOrigin(), false )
				hMinion.nFXIndex = nFxIndex2
			end
		end
	end
end