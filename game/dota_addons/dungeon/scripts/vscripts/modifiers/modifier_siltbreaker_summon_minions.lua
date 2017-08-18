
modifier_siltbreaker_summon_minions = class({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:OnCreated( kv )
	if IsServer() then
		self.slow_tick_rate = self:GetAbility():GetSpecialValueFor( "slow_tick_rate" )
		self.medium_tick_rate = self:GetAbility():GetSpecialValueFor( "medium_tick_rate" )
		self.fast_tick_rate = self:GetAbility():GetSpecialValueFor( "fast_tick_rate" )

		local flInterval = self.slow_tick_rate
		if self:GetParent():GetHealthPercent() < 50 then
			flInterval = self.medium_tick_rate
		end
		if self:GetParent():GetHealthPercent() < 25 then
			flInterval = self.fast_tick_rate
		end
		
		self:StartIntervalThink( flInterval )
	end
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:GetActivityTranslationModifiers( params )
	return "channelling"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:GetModifierTurnRate_Percentage( params )
	return -50
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions:OnIntervalThink()
	if IsServer() then
		local szMinionName = "npc_dota_creature_meranth_minion"

		local hMinion = CreateUnitByName( szMinionName, self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
		if hMinion ~= nil then
			if self:GetCaster().zone ~= nil then
				self:GetCaster().zone:AddEnemyToZone( hMinion )
			end
			hMinion.hMaster = self:GetCaster()

			local fDist = 1500
			local vCasterPos = self:GetCaster():GetAbsOrigin()
			local vSpawnPoint = vCasterPos + RandomVector( 1 ) * fDist

			-- Verify caster to spawnpoint is pathable
			local nMaxAttempts = 7
			local nAttempts = 0
			while ( not GridNav:CanFindPath( vCasterPos, vSpawnPoint ) ) do
				vSpawnPoint = vCasterPos + Vector( RandomInt( -fDist, fDist ), RandomInt( -fDist, fDist ), 0 )
				nAttempts = nAttempts + 1
				if nAttempts >= nMaxAttempts then
					break
				end
			end
			
			FindClearSpaceForUnit( hMinion, vSpawnPoint, true )

			EmitSoundOn( "Siltbreaker.SummonMinions.Spawn", hMinion )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end