
require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossVoidSpirit == nil then
	CBossVoidSpirit = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossVoidSpirit( thisEntity, 1.0 )
	end
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.fDissimilateStartTime = nil

	self.nEnragePct = 40
	self.bEnraged = false

	self.nAstralPct = 90
	self.bAstralEnabled = false

	self.me:SetThink( "OnBossVoidSpiritThink", self, "OnBossVoidSpiritThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hAetherRemnant = self.me:FindAbilityByName( "aghsfort_void_spirit_boss_aether_remnant" )
	if self.hAetherRemnant ~= nil then
		self.hAetherRemnant.Evaluate = self.EvaluateAetherRemnant
		self.AbilityPriority[ self.hAetherRemnant:GetAbilityName() ] = 5
	end

	self.hDissimilate = self.me:FindAbilityByName( "aghsfort_void_spirit_boss_dissimilate" )
	if self.hDissimilate ~= nil then
		self.fDissimilatePhaseDuration = self.hDissimilate:GetSpecialValueFor( "phase_duration" )
		self.fPctOfPhaseForSelection = self.hDissimilate:GetSpecialValueFor( "pct_of_phase_for_selection" )
		local first_ring_distance_offset = self.hDissimilate:GetSpecialValueFor( "first_ring_distance_offset" )
		local damage_radius = self.hDissimilate:GetSpecialValueFor( "damage_radius" )
		self.fDissimilateFullRadius = first_ring_distance_offset + damage_radius

		self.hDissimilate.Evaluate = self.EvaluateDissimilate
		self.AbilityPriority[ self.hDissimilate:GetAbilityName() ] = 3
	end

	self.hResonantPulse = self.me:FindAbilityByName( "aghsfort_void_spirit_boss_resonant_pulse" )
	if self.hResonantPulse ~= nil then
		self.hResonantPulse.Evaluate = self.EvaluateResonantPulse
		self.AbilityPriority[ self.hResonantPulse:GetAbilityName() ] = 4
	end

	self.hAstralStep = self.me:FindAbilityByName( "aghsfort_void_spirit_boss_astral_step" )
	if self.hAstralStep ~= nil then
		self.hAstralStep.Evaluate = self.EvaluateAstralStep
		self.AbilityPriority[ self.hAstralStep:GetAbilityName() ] = 2
	end

	self.hActivateEarthSpirits = self.me:FindAbilityByName( "void_spirit_boss_activate_earth_spirits" )
	if self.hActivateEarthSpirits then
		self.hActivateEarthSpirits.Evaluate = self.EvaluateActivateEarthSpirits
		self.AbilityPriority[ self.hActivateEarthSpirits:GetAbilityName() ] = 1
	end
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:OnBossVoidSpiritThink()
	if GameRules:IsGamePaused() then
		return 0.1
	end

	if self.me:IsChanneling() then
		return 0.1
	end

	-- Am I in Dissimilate?
	if self.fDissimilateStartTime and ( GameRules:GetGameTime() < ( self.fDissimilateStartTime + self.fDissimilatePhaseDuration ) ) then
		--printf( "I'm in Dissimilate phase, game time: %.2f; dissimilate start time: %.2f; dissimilate phase duration: %.2f", GameRules:GetGameTime(), self.fDissimilateStartTime, self.fDissimilatePhaseDuration )

		-- Issue a move command that takes me near a random player within the full Dissimilate radius
		local nSearchRangeReduction = self.hDissimilate:GetSpecialValueFor( "search_range_reduction" )
		local fSearchRange = self.fDissimilateFullRadius - nSearchRangeReduction
		--printf( "fSearchRange: %d, self.fDissimilateFullRadius: %d, nSearchRangeReduction: %d", fSearchRange, self.fDissimilateFullRadius, nSearchRangeReduction )
		local enemiesInDissimilate = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemiesInDissimilate > 0 then
			--printf( "#enemiesInDissimilate: %d; self.fDissimilateFullRadius: %.2f", #enemiesInDissimilate, self.fDissimilateFullRadius )
			local hRandomEnemy = enemiesInDissimilate[ RandomInt( 1, #enemiesInDissimilate ) ]

			local Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hRandomEnemy:GetOrigin(),
				Queue = true,
			}

			ExecuteOrderFromTable( Order )

			--printf( "-----" )
			--printf( "Current time: %.2f, dissimilate phase ends at: %.2f", GameRules:GetGameTime(), ( self.fDissimilateStartTime + self.fDissimilatePhaseDuration ) )
			--printf( "Found a random enemy in Dissimilate (%s); moving to: %s", hRandomEnemy:GetUnitName(), hRandomEnemy:GetOrigin() )
			--printf( "%s was issued move order", self.me:GetUnitName() )

			local fInterval = self.fDissimilatePhaseDuration + 0.2
			--printf( "returning in %.2f seconds", fInterval )

			return fInterval
		else
			-- Nobody's within Dissimilate's full radius, so just try to get to the closest player
			local fSearchRadius = 4000
			local enemies = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), nil, fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
			if #enemies > 0 then
				local hNearestEnemy = enemies[ 1 ]
				local vDir = hNearestEnemy:GetAbsOrigin() - self.me:GetAbsOrigin()
				vDir.z = 0.0
				vDir = vDir:Normalized()

				local vRightClickPos = self.me:GetAbsOrigin() + ( vDir * ( self.me:GetDayTimeVisionRange() - 20 ) )

				local Order =
				{
					UnitIndex = self.me:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = vRightClickPos,
					Queue = true,
				}

				ExecuteOrderFromTable( Order )

				--printf( "-----" )
				--printf( "Current time: %.2f, dissimilate phase ends at: %.2f", GameRules:GetGameTime(), ( self.fDissimilateStartTime + self.fDissimilatePhaseDuration ) )
				--printf( "There are no enemies in Dissimilate; moving to nearest enemy \"%s\" at: %s", hNearestEnemy:GetUnitName(), hNearestEnemy:GetOrigin() )
				--printf( "%s was issued move order", self.me:GetUnitName() )

				local fInterval = self.fDissimilatePhaseDuration + 0.2
				--printf( "returning in %.2f seconds", fInterval )

				return fInterval
			end
		end
	end

	--printf( "OnBossVoidSpiritThink - Chain to OnBaseThink at time: %.2f", GameRules:GetGameTime() )
	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if IsServer() then
		if nPct <= self.nEnragePct and self.bEnraged == false then
			self.bEnraged = true
		end

		if nPct <= self.nAstralPct and self.bAstralEnabled == false then
			self.bAstralEnabled = true
		end
	end
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:EvaluateAetherRemnant()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hAetherRemnant:GetCastRange()
	Enemies = GetEnemyHeroesInRange( self.me, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		-- Hack alert: the aghsfort Aether Remnant ability C++ stomps some of this with its own farthest target selection
		local hFarthestEnemy = Enemies[ #Enemies ]
		local vDir = hFarthestEnemy:GetAbsOrigin() - self.me:GetAbsOrigin()
		local fDistance = vDir:Length2D()
		vDir.z = 0
		vDir = vDir:Normalized()

		local vTargetLocation = hFarthestEnemy:GetAbsOrigin() - ( vDir * 350 )

		if fDistance < 400 then
			-- Place remnant behind the target enemy instead
			vTargetLocation = hFarthestEnemy:GetAbsOrigin() + ( vDir * 200 )
		end

		if vTargetLocation ~= nil then
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = vTargetLocation,
				AbilityIndex = self.hAetherRemnant:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hAetherRemnant )
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:EvaluateDissimilate()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hDissimilate:GetSpecialValueFor( "damage_radius" ) * 3 -- total radius is approx 3 portal radii
	--printf( "EvaluateDissimilate - nSearchRadius == %d", nSearchRadius )
	Enemies = GetEnemyHeroesInRange( self.me, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hDissimilate:entindex(),
			Queue = false,
		}

		local fPhaseDuration = self.hDissimilate:GetSpecialValueFor( "phase_duration" )
		Order.flOrderInterval = GetSpellCastTime( self.hDissimilate ) + ( fPhaseDuration * ( self.fPctOfPhaseForSelection / 100 ) )
		--printf( "EvaluateDissimilate - order interval: %.2f (spell cast time: %.2f, phase duration: %.2f, pct_of_phase_for_selection: %.2f)", Order.flOrderInterval, GetSpellCastTime( self.hDissimilate ), fPhaseDuration, self.fPctOfPhaseForSelection )

		self.fDissimilateStartTime = GameRules:GetGameTime()
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:EvaluateResonantPulse()
	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hResonantPulse:GetSpecialValueFor( "radius" )
	Enemies = GetEnemyHeroesInRange( self.me, nSearchRadius )

	local Order = nil
	if #Enemies >= 1 then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hResonantPulse:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hResonantPulse ) 
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:EvaluateAstralStep()
	if not self.bAstralEnabled then
		return
	end

	local Order = nil

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local nSearchRadius = self.hAstralStep:GetSpecialValueFor( "max_travel_distance" )
	Enemies = GetEnemyHeroesInRange( self.me, nSearchRadius )

	if #Enemies >= 1 then
		local vTargetLocation = Enemies[ #Enemies ]:GetAbsOrigin() -- target the farthest unit
		if vTargetLocation ~= nil then
			Order =
			{
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = vTargetLocation,
				AbilityIndex = self.hAstralStep:entindex(),
				Queue = false,
			}
			Order.flOrderInterval = GetSpellCastTime( self.hAstralStep ) + 0.5 -- Factor in a little travel time
		end
	end

	return Order
end

--------------------------------------------------------------------------------

function CBossVoidSpirit:EvaluateActivateEarthSpirits()
	local Order = nil
	if self.bEnraged == true then
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hActivateEarthSpirits:entindex(),
			Queue = false,
		}

		Order.flOrderInterval = self.hActivateEarthSpirits:GetChannelTime() + 0.2
	end

	return Order
end

--------------------------------------------------------------------------------
