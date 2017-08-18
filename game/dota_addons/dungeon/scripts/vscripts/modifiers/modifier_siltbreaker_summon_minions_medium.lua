
modifier_siltbreaker_summon_minions_medium = class({})

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:OnCreated( kv )
	if IsServer() then
		self.slow_tick_rate = self:GetAbility():GetSpecialValueFor( "slow_tick_rate" )
		self.medium_tick_rate = self:GetAbility():GetSpecialValueFor( "medium_tick_rate" )
		self.fast_tick_rate = self:GetAbility():GetSpecialValueFor( "fast_tick_rate" )
		self.specials_to_spawn = self:GetAbility():GetSpecialValueFor( "specials_to_spawn" )

		self.nSpecialsSpawned = 0

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

function modifier_siltbreaker_summon_minions_medium:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:GetActivityTranslationModifiers( params )
	return "channelling"
end

--------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:GetModifierTurnRate_Percentage( params )
	return -50
end

-----------------------------------------------------------------------------------------

function modifier_siltbreaker_summon_minions_medium:OnIntervalThink()
	if IsServer() then
		local bSpawnSpecial = nil
		if self.nSpecialsSpawned < self.specials_to_spawn then
			bSpawnSpecial = ( RandomFloat( 0, 1 ) > 0.5 )
		else
			bSpawnSpecial = false
		end

		local szMinionName = nil
		if bSpawnSpecial then
			szMinionName = "npc_dota_creature_swoledar"
		else
			szMinionName = "npc_dota_creature_meranth_minion"
		end

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

			if szMinionName == "npc_dota_creature_swoledar" then
				self.nSpecialsSpawned = self.nSpecialsSpawned + 1
			end

			EmitSoundOn( "Siltbreaker.SummonMinions.Spawn", hMinion )

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
			ParticleManager:SetParticleControl( nFXIndex, 0, vSpawnPoint )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
	end
end