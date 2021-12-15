
require( "ai/boss_base" )
require( "utility_functions" )

--------------------------------------------------------------------------------

if CBossDarkWillow == nil then
	CBossDarkWillow = class( {}, {}, CBossBase )
end

--------------------------------------------------------------------------------

--LinkLuaModifier( "modifier_boss_dark_willow_shadow_realm", "modifiers/creatures/modifier_boss_dark_willow_shadow_realm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

_G.DARK_WILLOW_BRAMBLE_RESPAWN_TIME = 15.0
_G.DARK_WILLOW_BRAMBLE_NO_REGENERATE = -1
_G.DARK_WILLOW_BLOOM_TOSSES = 3
_G.DARK_WILLOW_CURSED_CROWN_CASTS = 1
_G.DARK_WILLOW_TERRORIZE_PCT = 75
_G.DARK_WILLOW_TERRORIZE_GOOD_ATTEMPTS_DURATION = 2
_G.DARK_WILLOW_BEDLAM_PCT = 45

_G.DARK_WILLOW_PHASE_SHADOW_REALM = 1
_G.DARK_WILLOW_PHASE_BLOOM_TOSS = 2
_G.DARK_WILLOW_PHASE_CURSED_CROWN = 3
_G.DARK_WILLOW_PHASE_TERRORIZE = 4
_G.DARK_WILLOW_PHASE_BEDLAM = 5

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.AI = CBossDarkWillow( thisEntity, 0.5 )
	end
end

--------------------------------------------------------------------------------

function UpdateOnRemove()
	if IsServer() then 
		if thisEntity.AI then 
			for _,hBrambleSpawner in pairs( thisEntity.AI.vecBrambleSpawners ) do 
				if hBrambleSpawner.hThinker ~= nil and hBrambleSpawner.hThinker:IsNull() == false then 
					UTIL_Remove( hBrambleSpawner.hThinker )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CBossDarkWillow:constructor( hUnit, flInterval )
	CBossBase.constructor( self, hUnit, flInterval )

	self.vecBrambleSpawners = {}
	self.nBloomTosses = 0
	self.bTerrorizeActivated = false
	self.bBedlamActivated = false
	
	self.vecAllowedPhases = 
	{
		DARK_WILLOW_PHASE_SHADOW_REALM,
		DARK_WILLOW_PHASE_BLOOM_TOSS,
		DARK_WILLOW_PHASE_CURSED_CROWN,
	}

	self.nPhaseIndex = 1

	self.me:SetThink( "OnBossDarkWillowThink", self, "OnBossDarkWillowThink", self.flDefaultInterval )
end

--------------------------------------------------------------------------------


function CBossDarkWillow:SetEncounter( hEncounter )
	CBossBase.SetEncounter( self, hEncounter )

	self.ShadowRealmPositions = {}

	local ShadowRealmPositions = hEncounter:GetRoom():FindAllEntitiesInRoomByName( "shadow_realm_target" )
	for _,hEnt in pairs ( ShadowRealmPositions ) do
		table.insert( self.ShadowRealmPositions, hEnt:GetAbsOrigin() )
	end

	printf( "found " .. #self.ShadowRealmPositions .. " shadow realm positions SetEncounter" )
end

--------------------------------------------------------------------------------

function CBossDarkWillow:SetupAbilitiesAndItems()
	CBossBase.SetupAbilitiesAndItems( self )

	self.hBloomToss = self.me:FindAbilityByName( "boss_dark_willow_bloom_toss" )
	if self.hBloomToss ~= nil then
		self.hBloomToss.Evaluate = self.EvaluateBloomToss
		self.AbilityPriority[ self.hBloomToss:GetAbilityName() ] = 1
	end

	self.hShadowRealm = self.me:FindAbilityByName( "aghsfort_boss_dark_willow_shadow_realm" )
	if self.hShadowRealm ~= nil then
		self.hShadowRealm.Evaluate = self.EvaluateShadowRealm
		self.AbilityPriority[ self.hShadowRealm:GetAbilityName() ] = 2
	end

	self.hCursedCrown = self.me:FindAbilityByName( "aghsfort_boss_dark_willow_cursed_crown" )
	if self.hCursedCrown ~= nil then
		self.hCursedCrown.Evaluate = self.EvaluateCursedCrown
		self.AbilityPriority[ self.hCursedCrown:GetAbilityName() ] = 3
	end

	self.hTerrorize = self.me:FindAbilityByName( "boss_dark_willow_terrorize" )
	if self.hTerrorize ~= nil then
		self.hTerrorize.Evaluate = self.EvaluateTerrorize
		self.AbilityPriority[ self.hTerrorize:GetAbilityName() ] = 4
	end

	self.hBedlam = self.me:FindAbilityByName( "boss_dark_willow_bedlam" )
	if self.hBedlam ~= nil then
		self.hBedlam.Evaluate = self.EvaluateBedlam
		self.AbilityPriority[ self.hBedlam:GetAbilityName() ] = 5
	end
end

--------------------------------------------------------------------------------

function CBossDarkWillow:ShouldAutoAttack()
	return false
end

--------------------------------------------------------------------------------

function CBossDarkWillow:ChangePhase()
	self.nPhaseIndex = self.nPhaseIndex + 1 
	if self.nPhaseIndex > #self.vecAllowedPhases then 
		self.nPhaseIndex = 1 
	end

	printf( "ChangePhase - Current Phase: %s", tostring( self:GetPhase() ) )

	if self:GetPhase() == DARK_WILLOW_PHASE_BLOOM_TOSS then 
		self.nBloomTosses = DARK_WILLOW_BLOOM_TOSSES
	end

	if self:GetPhase() == DARK_WILLOW_PHASE_CURSED_CROWN then 
		self.nCursedCrownCasts = DARK_WILLOW_CURSED_CROWN_CASTS
	end

	if self:GetPhase() == DARK_WILLOW_PHASE_TERRORIZE then 
		--self.nFailedTerrorizeAttemptsThisPhase = 0
		self.fPhaseStartTime = GameRules:GetGameTime()
	end
end

--------------------------------------------------------------------------------

function CBossDarkWillow:GetPhase()
	return self.vecAllowedPhases[ self.nPhaseIndex ]
end

--------------------------------------------------------------------------------

function CBossDarkWillow:OnBossDarkWillowThink()
	if GameRules:IsGamePaused() then
		return 0.01
	end


	if self.me:IsChanneling() then 
		--printf( "CBossDarkWillow:OnBossDarkWillowThink() - self.me:IsChanneling(), return early" )
		return 0.01
	end

	local flNow = GameRules:GetGameTime()
	if self.bSeenAnyEnemy then 
		if #self.vecBrambleSpawners == 0 then 
			if self.me.hEncounter and self.me.hEncounter:GetRoom() then 
				self.vecBrambleSpawners = self.me.hEncounter:GetRoom():FindAllEntitiesInRoomByName( "spawner_willow_bramble", true )
				
				local flDelay = 0.0
				
				for _,hBrambleSpawner in pairs ( self.vecBrambleSpawners ) do 
					hBrambleSpawner.flNextRegenerateTime = flNow + flDelay
					flDelay = flDelay + 0.1
				end 
			end
		else
			for _,hBrambleSpawner in pairs ( self.vecBrambleSpawners ) do 
				if hBrambleSpawner.hThinker == nil or hBrambleSpawner.hThinker:IsNull() then 
					if hBrambleSpawner.flNextRegenerateTime == DARK_WILLOW_BRAMBLE_NO_REGENERATE then 
						hBrambleSpawner.flNextRegenerateTime = flNow + DARK_WILLOW_BRAMBLE_RESPAWN_TIME
					else
						if flNow >= hBrambleSpawner.flNextRegenerateTime then 
							self:RegenerateBramble( hBrambleSpawner )
						end
					end
				end
			end
		end
	end

	if self:GetPhase() == DARK_WILLOW_PHASE_SHADOW_REALM then
		--printf( "CBossDarkWillow:OnBossDarkWillowThink() - self:GetPhase() == DARK_WILLOW_PHASE_SHADOW_REALM" )
		if self.hShadowRealm:IsCooldownReady() then
			--printf( "self.hShadowRealm:IsCooldownReady(), so return self:OnBaseThink()" )
			return self:OnBaseThink()
		end

		return self:MoveToShadowRealmTarget()
	end

	--[[
	if self:GetPhase() == DARK_WILLOW_PHASE_CURSED_CROWN then
		printf( "CBossDarkWillow:OnBossDarkWillowThink() - self:GetPhase() == DARK_WILLOW_PHASE_CURSED_CROWN" )
		if self.hCursedCrown:IsCooldownReady() then
			printf( "self.hCursedCrown:IsCooldownReady(), so return self:OnBaseThink()" )
			return self:OnBaseThink()
		end

		return self:MoveToCursedCrownTargetPos()
	end
	]]

	return self:OnBaseThink()
end

--------------------------------------------------------------------------------

function CBossDarkWillow:RegenerateBramble( hBrambleSpawner )
	if hBrambleSpawner == nil then 
		return 
	end

	if hBrambleSpawner.hThinker ~= nil and hBrambleSpawner.hThinker:IsNull() == false then 
		local hBrambleBuff = hBrambleSpawner.hThinker:FindModifierByName( "modifier_dark_willow_bramble_maze_thinker" )
		if hBrambleBuff then 
			hBrambleBuff:Destroy()
		end
	end

	hBrambleSpawner.hThinker = CreateModifierThinker( self.me, self.hBloomToss, "modifier_dark_willow_bramble_maze_thinker", { duration = -1 }, hBrambleSpawner:GetAbsOrigin(), self.me:GetTeamNumber(), false )
	hBrambleSpawner.flNextRegenerateTime = DARK_WILLOW_BRAMBLE_NO_REGENERATE
end

--------------------------------------------------------------------------------

function CBossDarkWillow:OnFirstSeen()
	CBossBase.OnFirstSeen( self )
end

--------------------------------------------------------------------------------

function CBossDarkWillow:OnHealthPercentThreshold( nPct )
	CBossBase.OnHealthPercentThreshold( self, nPct )

	if self.bTerrorizeActivated == false and nPct < DARK_WILLOW_TERRORIZE_PCT then 
		self.bTerrorizeActivated = true 
		self.vecAllowedPhases = 
		{
			DARK_WILLOW_PHASE_SHADOW_REALM,
			DARK_WILLOW_PHASE_BLOOM_TOSS,
			DARK_WILLOW_PHASE_CURSED_CROWN,
			DARK_WILLOW_PHASE_TERRORIZE,
		}

		self.nPhaseIndex = 3
		self.hTerrorize:SetActivated( true )
		self:ChangePhase()
	end

	if self.bBedlamActivated == false and nPct < DARK_WILLOW_BEDLAM_PCT then 
		self.bBedlamActivated = true 
		self.vecAllowedPhases = 
		{
			DARK_WILLOW_PHASE_SHADOW_REALM,
			DARK_WILLOW_PHASE_BLOOM_TOSS,
			DARK_WILLOW_PHASE_CURSED_CROWN,
			DARK_WILLOW_PHASE_TERRORIZE,
			DARK_WILLOW_PHASE_BEDLAM
		}

		self.nPhaseIndex = 4
		self.hBedlam:SetActivated( true )
		self:ChangePhase()
	end
end

--------------------------------------------------------------------------------

function CBossDarkWillow:EvaluateShadowRealm()
	if self:GetPhase() ~= DARK_WILLOW_PHASE_SHADOW_REALM then 
		return nil 
	end

	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hShadowRealm:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = GetSpellCastTime( self.hShadowRealm ) + 0.1
 	return Order
end


--------------------------------------------------------------------------------

function CBossDarkWillow:MoveToShadowRealmTarget()
	--printf( "CBossDarkWillow:MoveToShadowRealmTarget()" )

	if self:GetPhase() ~= DARK_WILLOW_PHASE_SHADOW_REALM then 
		--printf( "self:GetPhase() ~= DARK_WILLOW_PHASE_SHADOW_REALM" )
		return 0.1 -- this was nil
	end

	if self.vShadowRealmTargetPos == nil then 
		--printf( "self.vShadowRealmTargetPos == nil" )
		return 0.1 -- this was nil and seemed to break AI when combined with >10s Shadow Realm cd
	end

	local flDist = ( self.vShadowRealmTargetPos - self.me:GetAbsOrigin() ):Length2D()
	printf( "dist from shadow realm target: %.1f", flDist )
	if flDist < 150 or self.me:FindModifierByName( "modifier_aghsfort_boss_dark_willow_shadow_realm_buff" ) == nil then
	--if flDist < 150 or self.me:HasModifier( "modifier_aghsfort_boss_dark_willow_shadow_realm_buff" ) == false then
		self:ChangePhase()
		self.vShadowRealmTargetPos = nil
		return 0.1
	end

	printf( "CBossDarkWillow:MoveToShadowRealmTarget() - Issue move command to self.vShadowRealmTargetPos" )

	ExecuteOrderFromTable({
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = self.vShadowRealmTargetPos,
	})

	local fDelay = self.hShadowRealm:GetLevelSpecialValueFor( "duration", GameRules.Aghanim:GetAscensionLevel() ) + 0.25
	--printf( "fDelay: %.1f", fDelay )

	return fDelay
end

--------------------------------------------------------------------------------

function CBossDarkWillow:EvaluateCursedCrown()
	if self:GetPhase() ~= DARK_WILLOW_PHASE_CURSED_CROWN then 
		return nil 
	end

	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hCursedCrown:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = GetSpellCastTime( self.hCursedCrown ) + 0.1

	-- Also queue a move command
	local Enemies = shallowcopy( self.hPlayerHeroes )
	if Enemies == nil or #Enemies == 0 then
		return 0.1
	end

	local nMinTravelDistance = self.hCursedCrown:GetLevelSpecialValueFor( "min_travel_distance", GameRules.Aghanim:GetAscensionLevel() )
	local hValidTarget = nil

	ShuffleListInPlace( Enemies )

	for _, enemy in pairs( Enemies ) do
		if enemy and enemy:IsNull() == false and enemy:IsAlive() then
			local fDistToEnemy = ( enemy:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
			if fDistToEnemy >= nMinTravelDistance then
				hValidTarget = enemy
				printf( "found hValidTarget" )
				break
			end
		end
	end

	if hValidTarget ~= nil then
		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hValidTarget:GetAbsOrigin(),
			Queue = true,
			--OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			--TargetIndex = hValidTarget:entindex()
		})
		printf( "move towards %s\'s position", hValidTarget:GetUnitName() )

		Order.flOrderInterval = Order.flOrderInterval + self.hCursedCrown:GetLevelSpecialValueFor( "delay", GameRules.Aghanim:GetAscensionLevel() )
	else
		printf( "no hValidTarget found" )
	end

 	return Order
end

--------------------------------------------------------------------------------

--[[
function CBossDarkWillow:MoveToCursedCrownTargetPos()
	printf( "CBossDarkWillow:MoveToCursedCrownTargetPos()" )

	if self:GetPhase() ~= DARK_WILLOW_PHASE_CURSED_CROWN then 
		printf( "self:GetPhase() ~= DARK_WILLOW_PHASE_CURSED_CROWN" )
		return 0.1
	end

	-- find a far-ish player (@todo: otherwise maybe go to a shadow realm position maybe)
	local Enemies = shallowcopy( self.hPlayerHeroes )
	if Enemies == nil or #Enemies == 0 then
		return 0.1
	end

	local nMinTravelDistance = self.hCursedCrown:GetLevelSpecialValueFor( "min_travel_distance", GameRules.Aghanim:GetAscensionLevel() )
	local hValidTarget = nil

	ShuffleListInPlace( Enemies )

	for _, enemy in pairs( Enemies ) do
		if enemy and enemy:IsNull() == false and enemy:IsAlive() then
			local fDistToEnemy = ( enemy:GetAbsOrigin() - self.me:GetAbsOrigin() ):Length2D()
			if fDistToEnemy >= nMinTravelDistance then
				hValidTarget = enemy
				printf( "found hValidTarget" )
				break
			end
		end
	end

	if hValidTarget ~= nil then
		ExecuteOrderFromTable({
			UnitIndex = self.me:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hValidTarget:GetAbsOrigin(),
			--OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			--TargetIndex = hValidTarget:entindex()
		})
		printf( "move towards %s\'s position", hValidTarget:GetUnitName() )
	else
		printf( "no hValidTarget found" )
	end

	local fDelay = self.hCursedCrown:GetLevelSpecialValueFor( "delay", GameRules.Aghanim:GetAscensionLevel() ) + 0.25
	printf( "fDelay: %.1f", fDelay )

	return fDelay
end
]]

--------------------------------------------------------------------------------

function CBossDarkWillow:EvaluateBloomToss() 
	if self:GetPhase() ~= DARK_WILLOW_PHASE_BLOOM_TOSS then
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local Order = nil
	if Enemies == nil or #Enemies == 0 then
		return Order
	end

	local hEnemy = Enemies[ RandomInt( 1, #Enemies ) ] 
	if #Enemies > 1 then 
		while hEnemy == self.hBloomToss.hLastTarget do 
			hEnemy = Enemies[ RandomInt( 1, #Enemies ) ] 
		end
	end

	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetAbsOrigin(),
		AbilityIndex = self.hBloomToss:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hBloomToss )
	self.hBloomToss.hLastTarget = hEnemy

	return Order
end

--------------------------------------------------------------------------------

function CBossDarkWillow:EvaluateTerrorize()
	if self:GetPhase() ~= DARK_WILLOW_PHASE_TERRORIZE then
		return nil
	end

	local Enemies = shallowcopy( self.hPlayerHeroes )
	local Order = nil
	if Enemies == nil or #Enemies == 0 then
		return nil
	end

	local nEnemiesInAOERequired = 2

	local fTimeElapsedThisPhase = GameRules:GetGameTime() - self.fPhaseStartTime

	if fTimeElapsedThisPhase >= DARK_WILLOW_TERRORIZE_GOOD_ATTEMPTS_DURATION then
		nEnemiesInAOERequired = 1
		printf( "EvaluateTerrorize - too much time elapsed, set nEnemiesInAOERequired to: %d", nEnemiesInAOERequired )
	end

	local vPosition = self:GetBestAOEPointTarget_Terrorize( self.hTerrorize, nEnemiesInAOERequired )
	if vPosition == nil then
		--self.nFailedTerrorizeAttemptsThisPhase = self.nFailedTerrorizeAttemptsThisPhase + 1

		return nil
	end

	Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = self.hTerrorize:entindex(),
		Queue = false,
	}
	Order.flOrderInterval = GetSpellCastTime( self.hTerrorize )
	
	return Order
end

--------------------------------------------------------------------------------

function CBossDarkWillow:GetBestAOEPointTarget_Terrorize( hSpell, nEnemiesRequired )
	printf( "CBossDarkWillow:GetBestAOEPointTarget_Terrorize: %s", hSpell:GetAbilityName() )

	local nAbilityRadius = hSpell:GetAOERadius()

	local vLocation = GetTargetAOELocation( hSpell:GetCaster():GetTeamNumber(), 
											DOTA_UNIT_TARGET_HERO,  					
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											hSpell:GetCaster():GetOrigin(),
											GetTryToUseSpellRange( hSpell:GetCaster(), hSpell ),
											nAbilityRadius,
											nEnemiesRequired )

	if vLocation == vec3_invalid then
		printf( "--GetBestAOEPointTarget_Terrorize: cannot find location with " .. nAbilityRadius .. " radius and " .. nEnemiesRequired .. " required enemies" )

		return nil
	end

	printf( "--Found aoe target point: (" .. vLocation.x .. ", " .. vLocation.y .. ", " .. vLocation.z .. " : " .. hSpell:GetAbilityName() )

	return vLocation
end

--------------------------------------------------------------------------------

function CBossDarkWillow:EvaluateBedlam()
	if self:GetPhase() ~= DARK_WILLOW_PHASE_BEDLAM then 
		return nil 
	end

	local Order = 
	{
		UnitIndex = self.me:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = self.hBedlam:entindex(),
		Queue = false,
	}

	Order.flOrderInterval = GetSpellCastTime( self.hBedlam ) + 0.1
 	return Order
end

--------------------------------------------------------------------------------

function CBossDarkWillow:OnBossUsedAbility( szAbilityName )
	if szAbilityName == "boss_dark_willow_bloom_toss" then 
		self.nBloomTosses = self.nBloomTosses - 1 
		if self.nBloomTosses <= 0 then 
			self:ChangePhase()
		end 
	end

	if szAbilityName == "aghsfort_boss_dark_willow_shadow_realm" then
		--self.vShadowRealmTargetPos = self.ShadowRealmPositions[ RandomInt( 1, #self.ShadowRealmPositions ) ]

		local nSearchRange = 600

		local vecPositions = deepcopy( self.ShadowRealmPositions )
		for i = #vecPositions, 1, -1 do
			local vPosition = vecPositions[ i ]
			local flDist = ( vPosition - self.me:GetAbsOrigin() ):Length2D() 
			local enemies = FindUnitsInLine( self.me:GetTeamNumber(), self.me:GetAbsOrigin(), vPosition, self.me, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE )
			
			if flDist < 1000 or #enemies == 0 then 
				table.remove( vecPositions, i )
			end
		end

		printf( "found " .. #vecPositions .. " shadow realm positions" )
		if #vecPositions == 0 then
			--printf( "set self.vShadowRealmTargetPos to one of our self.ShadowRealmPositions" )
			self.vShadowRealmTargetPos = self.ShadowRealmPositions[ RandomInt( 1, #self.ShadowRealmPositions ) ]
		else
			--printf( "set self.vShadowRealmTargetPos to one of our vecPositions" )
			self.vShadowRealmTargetPos = vecPositions[ RandomInt( 1, #vecPositions ) ]  
		end
	end

	if szAbilityName == "aghsfort_boss_dark_willow_cursed_crown" then 
		self.nCursedCrownCasts = self.nCursedCrownCasts - 1 
		if self.nCursedCrownCasts <= 0 then 
			self:ChangePhase()
		end 
	end

	if szAbilityName == "boss_dark_willow_terrorize" or szAbilityName == "boss_dark_willow_bedlam" then 
		self:ChangePhase()
	end
end

--------------------------------------------------------------------------------