
function CJungleSpirits:PlanNextSpawn()
	self.nCarePackageCount = self.nCarePackageCount + 1

	local missingSpawnPoint =
	{
		origin = "0 0 0",
		targetname = "item_spawn_missing"
	}

	local vDropPosCenter = GEM_DROP_LOCATIONS[ RandomInt( 1, #GEM_DROP_LOCATIONS ) ]

	local nMinRadius = 0
	local nRadius = 50
	local vSpawnPos = GetRandomPathablePositionWithin( vDropPosCenter, nRadius, nMinRadius )

	if vSpawnPos == nil then
		print( "WARNING - PlanNextSpawn: vSpawnPos is nil, setting it to 0,0,0" )
		vSpawnPos = missingSpawnPoint
	end

	--printf( "vDropPosCenter = ( %.2f, %.2f )", vDropPosCenter.x, vDropPosCenter.y )
	--printf( "PlanNextSpawn - next gem drop position: ( %.2f, %.2f )", vSpawnPos.x, vSpawnPos.y )

	local flGroundHeight = GetGroundHeight( vSpawnPos, nil )
	vSpawnPos.z = flGroundHeight

	self._GemSpawnLocation = vSpawnPos
end

--------------------------------------------------------------------------------

function CJungleSpirits:WarnGemSpawn()
	self:PlanNextSpawn()

	-- Unit is on goodguys, but shares vision to both teams
	self.hVisionRevealer = CreateUnitByName( "npc_vision_revealer", self._GemSpawnLocation, false, nil, nil, DOTA_TEAM_GOODGUYS )

	self:CreateGemDropWarning( DOTA_TEAM_GOODGUYS, self.hVisionRevealer )
	self:CreateGemDropWarning( DOTA_TEAM_BADGUYS, self.hVisionRevealer )

	self._hasWarnedGemSpawn = true

	self.EventQueue = CEventQueue()
	self.EventQueue:AddEvent( ANNOUNCER_CARE_PACKAGE_DELAY,
		function()
			self:FireAnnouncerCarePackageNotification()
		end
	)
end

--------------------------------------------------------------------------------

function CJungleSpirits:SpawnGem()
	if self._GemSpawnLocation == nil then
		print( "ERROR (gemdroplua) - no location set for the next gem drop" )
		return
	end

	EmitGlobalSound( "Gem.Spawn" )

	if self.nCarePackageCount % BATTLE_POINTS_CARE_PACKAGE_INTERVAL == 0 then
		CreateUnitByName( "npc_battle_point_pinata", self._GemSpawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	else
		CreateUnitByName( "npc_dota_gem_pinata", self._GemSpawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	end

	self._fNextGemTime = GameRules:GetGameTime() + TIME_PER_GEM_SPAWN
	self._hasWarnedGemSpawn = false

	if RandomFloat( 0, 1 ) >= 0.5 then
		self.EventQueue = CEventQueue()
		self.EventQueue:AddEvent( ANNOUNCER_CARE_PACKAGE_DELAY,
			function()
				self:FireAnnouncerCarePackageArrival()
			end
		)
	end
end

--------------------------------------------------------------------------------

function CJungleSpirits:CreateGemDropWarning( team, hEnt )
	if self.nCarePackageCount % BATTLE_POINTS_CARE_PACKAGE_INTERVAL == 0 then
		local gameEvent = {}
		gameEvent[ "teamnumber" ] = team
		gameEvent[ "message" ] = "#JungleSpirits_BattlePointsPackageWarning"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	else
		local gameEvent = {}
		gameEvent[ "teamnumber" ] = team
		gameEvent[ "message" ] = "#JungleSpirits_GemWarning"
		FireGameEvent( "dota_combat_event_message", gameEvent )
	end

	MinimapEvent( team, hEnt, hEnt:GetAbsOrigin().x, hEnt:GetAbsOrigin().y, DOTA_MINIMAP_EVENT_HINT_LOCATION, GEM_SPAWN_WARNING_TIME )
end

--------------------------------------------------------------------------------
