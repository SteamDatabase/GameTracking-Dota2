require( "ai/boss_base" )

--------------------------------------------------------------------------------

if CBossWinterWyvern == nil then
	CBossWinterWyvern = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossWinterWyvern( thisEntity, 0.5 )
	end
end

--------------------------------------------------------------------------------

_G.BOSS_WYVERN_PHASE_FLYING = 0
_G.BOSS_WYVERN_PHASE_RETURN_TO_NEST = 1
_G.BOSS_WYVERN_PHASE_LANDING = 2
_G.BOSS_WYVERN_PHASE_SPECIAL = 3
_G.BOSS_WYVERN_PHASE_ON_GROUND = 4

_G.BOSS_WYVERN_HEALTH_CURSE_ENABLE = 75
_G.BOSS_WYVERN_HEALTH_COLD_ENABLE = 40

_G.MAX_FLYBYS = 3	
_G.LAND_DURATION = 15.0
_G.EGG_HATCH_TIME = 10.0
_G.FLIGHT_DISTANCE = 2500
_G.HOME_VECTOR = Vector( -10629, 9989, 896 )


--------------------------------------------------------------------------------

function CBossWinterWyvern:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.nCurrentFlybys = 0
	self.flNextTakeOffTime = GameRules:GetGameTime()
	self.EggSpawners = Entities:FindAllByName( "aerie_ice_boss_egg" )
	self.HomeNest = nil
	self.nLastLandedHP = 0 
	self.nHPBeforeTakeoff = 0

	local flShortestDist = 99999
	for _,nest in pairs ( self.EggSpawners ) do
		local flDist = ( nest:GetAbsOrigin() - HOME_VECTOR ):Length2D()
		if flDist < flShortestDist then 
			flShortestDist = flDist 
			self.HomeNest = nest 
		end
	end

	if self.HomeNest then 

		local nEggsToCreate = 3
		
		while nEggsToCreate > 0 do
			if self.Nest ~= nil then
				local egg = CreateUnitByName( "npc_dota_creature_ice_boss_egg", self.HomeNest:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
				if egg then
					egg:SetModelScale( RandomFloat( 2.0, 3.0 ) ) 
				end
			end
			nEggsToCreate = nEggsToCreate - 1
		end
	end

	self.nEggsToCreate = 0
	self.me.numEggsKilled = 0

	self.vFlightPos = nil 
	self.Nest = nil 

	self.bCurseEnabled = false 
	self.bColdEnabled = false

	self.nPhaseIndex = 1
	self.vecAllowedPhases = 
	{
		BOSS_WYVERN_PHASE_FLYING,
		BOSS_WYVERN_PHASE_RETURN_TO_NEST,
		BOSS_WYVERN_PHASE_LANDING,
		BOSS_WYVERN_PHASE_ON_GROUND,
	}

	self.bSpecialCold = false 

	self.FlightPositions = {}

	for i=0,17 do
		local vDirection = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, i * 20 , 0 ), Vector( 1, 0, 0 ) ) * FLIGHT_DISTANCE
		local vFlightPos = HOME_VECTOR + vDirection
		table.insert( self.FlightPositions, vFlightPos )
	end

	self.me:SetThink( "OnBossWinterWyvernThink", self, "OnBossWinterWyvernThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:GetPhase()
	return self.vecAllowedPhases[ self.nPhaseIndex ]
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:ChangePhase()
	self.nPhaseIndex = self.nPhaseIndex + 1 
	if self.nPhaseIndex > #self.vecAllowedPhases then 
		self.nPhaseIndex = 1 
	end

	if self:GetPhase() == BOSS_WYVERN_PHASE_ON_GROUND then 
		self.flNextTakeOffTime = GameRules:GetGameTime() + LAND_DURATION 
		self.nLastLandedHP = self.me:GetHealth()
	end
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hLand = self.me:FindAbilityByName( "ice_boss_land" )
	if self.hLand ~= nil then
		self.hLand.Evaluate = self.EvaluateLand
		self.AbilityPriority[ self.hLand:GetAbilityName() ] = 1
	end

	self.hTakeFlight = self.me:FindAbilityByName( "ice_boss_take_flight" )
	if self.hTakeFlight ~= nil then
		self.hTakeFlight.Evaluate = self.EvaluteTakeFlight
		self.AbilityPriority[ self.hTakeFlight:GetAbilityName() ] = 2
	end

	self.hFlyingShatterBlast = self.me:FindAbilityByName( "ice_boss_flying_shatter_blast" )
	if self.hFlyingShatterBlast ~= nil then
		self.hFlyingShatterBlast.Evaluate = self.EvaluateFlyingShatterBlast
		self.AbilityPriority[ self.hFlyingShatterBlast:GetAbilityName() ] = 3
	end

	self.hColdEmbrace = self.me:FindAbilityByName( "boss_winter_wyvern_cold_embrace" )
	if self.hColdEmbrace ~= nil then
		self.hColdEmbrace.Evaluate = self.EvaluateColdEmbrace
		self.AbilityPriority[ self.hColdEmbrace:GetAbilityName() ] = 4
	end 

	self.hWintersCurse = self.me:FindAbilityByName( "ice_boss_projectile_curse" )
	if self.hWintersCurse ~= nil then
		self.hWintersCurse.Evaluate = self.EvaluateWintersCurse
		self.AbilityPriority[ self.hWintersCurse:GetAbilityName() ] = 5
	end

	self.hShatterBlast = self.me:FindAbilityByName( "ice_boss_shatter_projectile" )
	if self.hShatterBlast ~= nil then
		self.hShatterBlast.Evaluate = self.EvaluteShatterBlast
		self.AbilityPriority[ self.hShatterBlast:GetAbilityName() ] = 6
	end
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:ShouldAutoAttack()
	return self:GetPhase() == BOSS_WYVERN_PHASE_ON_GROUND
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:OnBossWinterWyvernThink()
	if GameRules:IsGamePaused() then
		return 0.01
	end

	if self.me:IsChanneling() then 
		return 0.01
	end

	if self.nHPBeforeTakeoff == 0 then 
		self.nHPBeforeTakeoff = math.ceil( self.me:GetMaxHealth() / 4 )
		self.nLastLandedHP = self.me:GetMaxHealth()
	end
	--print( "self:GetPhase() " .. self:GetPhase() )

	if self.vFlightPos ~= nil then
		local flDist = ( self.me:GetAbsOrigin() - self.vFlightPos ):Length2D()
		--print( " I am " .. flDist .. " away from my target destination" )
		if flDist < 150 then
			--print( "finished flight path" )
			self.vFlightPos = nil 

			if self:GetPhase() == BOSS_WYVERN_PHASE_FLYING then
				self.nCurrentFlybys = self.nCurrentFlybys + 1 
				if self.nCurrentFlybys >= MAX_FLYBYS then 
					self.nCurrentFlybys = 0 
					self:ChangePhase()

					local Order = self:EvaluateFlightPath() 
					if Order then 
						ExecuteOrderFromTable( Order )
						return Order.flOrderInterval
					end
				end 
			end 

			if self:GetPhase() == BOSS_WYVERN_PHASE_RETURN_TO_NEST then 
				--print( "Reached the nest, switching to landing" )
				self:ChangePhase() 
			end
		else
			ExecuteOrderFromTable({
				UnitIndex = self.me:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = self.vFlightPos,
			})
		end 
	end

	if self:GetPhase() == BOSS_WYVERN_PHASE_LANDING then 
		if self.me:FindModifierByName( "modifier_ice_boss_land" ) == nil and self.hLand:IsCooldownReady() == false then 
			--print( "land complete, laying eggs" )

			if self.Nest ~= nil then 
				local nEggsToCreate = self:GetNumEggsToHatch() * 2
				--print( "trying to create " .. nEggsToCreate .. " eggs " )
				while nEggsToCreate > 0 do
					if self.Nest ~= nil then
						local egg = CreateUnitByName( "npc_dota_creature_ice_boss_egg", self.Nest:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
						if egg then
							egg:SetModelScale( RandomFloat( 2.0, 3.0 ) ) 
						end
					end
					nEggsToCreate = nEggsToCreate - 1
				end

				local nEggsToHatch = self:GetNumEggsToHatch()
				local eggs = FindUnitsInRadius( self.me:GetTeamNumber(), self.me:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false )
				for _, egg in pairs( eggs ) do
					if egg ~= nil and egg:IsAlive() then
						local hBuff = egg:FindModifierByName( "modifier_ice_boss_egg_passive" )
						if hBuff ~= nil and hBuff.bHatching == false and nEggsToHatch > 0 then
							local ability = egg:FindAbilityByName( "ice_boss_egg_passive" )
							if ability ~= nil then
								ability:LaunchHatchProjectile( thisEntity )
								nEggsToHatch = nEggsToHatch - 1
							end
						end
					end
				end

				self.Nest = nil 
			end

			self:ChangePhase() 
		end  
	end

	local nDamageTaken = self.nLastLandedHP - self.me:GetHealth()
	if self:GetPhase() == BOSS_WYVERN_PHASE_ON_GROUND and ( ( GameRules:GetGameTime() > self.flNextTakeOffTime ) or ( nDamageTaken >= self.nHPBeforeTakeoff ) ) then 
		self.nPhaseIndex = 1
	end

	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if nPct <= BOSS_WYVERN_HEALTH_CURSE_ENABLE and self.bCurseEnabled == false then 
		self.bCurseEnabled = true 

		local nCurrentPhase = self:GetPhase() 
		self.vecAllowedPhases = 
		{
			BOSS_WYVERN_PHASE_FLYING,
			BOSS_WYVERN_PHASE_RETURN_TO_NEST,
			BOSS_WYVERN_PHASE_LANDING,
			BOSS_WYVERN_PHASE_SPECIAL,
			BOSS_WYVERN_PHASE_ON_GROUND,
		}

		local nNewPhaseIndex = -1 
		for n=1,#self.vecAllowedPhases do 
			if self.vecAllowedPhases[ n ] == nCurrentPhase then 
				nNewPhaseIndex = n
			end
		end

		self.nPhaseIndex = nNewPhaseIndex
	end
	if nPct <= BOSS_WYVERN_HEALTH_COLD_ENABLE and self.bColdEnabled == false then 
		self.bColdEnabled = true 
		self.bSpecialCold = true 
	end
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:GetNumEggsToHatch()
	local nPctHealth = self.me:GetHealthPercent()
	if nPctHealth > 33 and nPctHealth <= 66 then
		return 4
	end
	if nPctHealth <= 33 then
		return 5
	end
	return 3
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluteShatterBlast()
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_ON_GROUND then 
		return nil 
	end

	local Order = nil 
	local Enemies = GetEnemyHeroesInRange( self.me, 2000 )
	if #Enemies > 0 then 
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = Enemies[#Enemies]:GetAbsOrigin(),
			AbilityIndex = self.hShatterBlast:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = GetSpellCastTime( self.hShatterBlast )
	end
	return Order
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluteTakeFlight()
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_FLYING then 
		return nil 
	end

	if self.me:FindModifierByName( "modifier_ice_boss_take_flight" ) == nil then 
		local Order = 
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hTakeFlight:entindex(),
			Queue = false,
		}

		Order.flOrderInterval = GetSpellCastTime( self.hTakeFlight ) + 0.1
	 	return Order
	end

	if self.vFlightPos == nil then 
		--print( "Took off for the first time, finding new flight path" )
		return self:EvaluateFlightPath()
	end

	return nil
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluateLand() 
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_LANDING then 
		return nil 
	end

	local Order =
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hLand:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hLand ) + 0.1
 	return Order
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluateFlyingShatterBlast() 
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_FLYING and self:GetPhase() ~= BOSS_WYVERN_PHASE_RETURN_TO_NEST then 
		return nil 
	end

	if self.vFlightPos == nil then 
		return nil 
	end

	if self.nCurrentFlybys == 0 then 
		return nil 
	end

	local Order = nil 
	local Enemies = GetEnemyHeroesInRange( self.me, 800 )
	if #Enemies > 0 then 
		Order =
		{
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self.hFlyingShatterBlast:entindex(),
			Queue = false,
		}
		Order.flOrderInterval = 0.33
	end
	
	return Order
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluateWintersCurse() 
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_SPECIAL then 
		return nil 
	end

	if self.bCurseEnabled == false then 
		return nil 
	end

	if self.bColdEnabled == true and self.bSpecialCold then 
		return nil 
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local Order = nil 

	if Enemies == nil or #Enemies == 0 then
		return Order
	end

	local hTargetEnemy = Enemies[ RandomInt( 1, #Enemies ) ]
	local vBestAOELocation = GetBestAOEPointTarget( self.hWintersCurse )
	if vBestAOELocation then 
		local flShortestDist = 99999
		for _,hEnemy in pairs ( Enemies ) do 
			local flDist = ( hEnemy:GetAbsOrigin() - vBestAOELocation ):Length2D() 
			if flDist < flShortestDist then 
				flShortestDist = flDist 
				hTargetEnemy = hEnemy 
			end
		end
	end

	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTargetEnemy:entindex(),
		AbilityIndex = self.hWintersCurse:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hWintersCurse ) + 0.1 

	return Order
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluateColdEmbrace()
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_SPECIAL then 
		return nil 
	end

	if self.bColdEnabled == false then 
		return nil 
	end

	if self.bSpecialCold == false then 
		return nil 
	end

	local Order Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hColdEmbrace:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = self.hColdEmbrace:GetChannelTime() + 0.2 
	return Order
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:EvaluateFlightPath()
	if self:GetPhase() ~= BOSS_WYVERN_PHASE_FLYING and self:GetPhase() ~= BOSS_WYVERN_PHASE_RETURN_TO_NEST then 
		return nil 
	end

	--print( "EvaluateFlightPath" )
	if self.vFlightPos == nil then 
		if self:GetPhase() == BOSS_WYVERN_PHASE_RETURN_TO_NEST then 
			--print( "returning to nest" )
			self.Nest = self.EggSpawners[ RandomInt( 1, #self.EggSpawners ) ]
			self.vFlightPos = self.Nest:GetAbsOrigin()
			if self.bSpecialCold then 
				--print( "Going to cast cold embrace, headed to home nest" )
				self.Nest = self.HomeNest 
				self.vFlightPos = HOME_VECTOR
			end
			--print( "target nest pos: " .. tostring( self.vFlightPos ))
		else
			local PotentialPositions = {}
			for _,vPos in pairs ( self.FlightPositions ) do
				local enemies = FindUnitsInLine( self.me:GetTeamNumber(), self.me:GetAbsOrigin(), vPos, self.me, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE )
				if #enemies > 0 then
					table.insert( PotentialPositions, vPos )
				end	
			end

			if #PotentialPositions == 0 then 
				print( "found no potential fallbacks?  flying to home nest" )
				self.vFlightPos = HOME_VECTOR 
			else
				self.vFlightPos = PotentialPositions[ RandomInt( 1, #PotentialPositions ) ]
			end	
		end
	else
		--print( "we already have a flight path, aborting" )
		return nil 
	end

	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vFlightPos,
	}

	local flDist = ( self.vFlightPos - self.me:GetAbsOrigin() ):Length2D()
	--print( "found a valid flight path of " .. flDist )

	Order.flOrderInterval = 0.1
	return Order 
end

--------------------------------------------------------------------------------

function CBossWinterWyvern:OnBossUsedAbility( szAbilityName )
	if szAbilityName == "boss_winter_wyvern_cold_embrace" then 
		self.bSpecialCold = false 
		self:ChangePhase()
	end
	if szAbilityName == "ice_boss_projectile_curse" then
		if self.bColdEnabled then 
			self.bSpecialCold = true 
		end
		self:ChangePhase()
	end
end

--------------------------------------------------------------------------------