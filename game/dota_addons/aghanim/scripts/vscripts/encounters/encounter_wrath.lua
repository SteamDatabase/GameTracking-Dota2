
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Wrath == nil then
	CMapEncounter_Wrath = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:GetPreviewUnit()
	return "npc_dota_hero_zuus"
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.bGreenLight = true

	self.HeroesOnGoal = {}
end


--------------------------------------------------------------------------------

function CMapEncounter_Wrath:GetMaxSpawnedUnitCount()
	return 0
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:Start()
	CMapEncounter.Start( self )

	local hGreenLights = self:GetRoom():FindAllEntitiesInRoomByName( "green_light", true )
	if #hGreenLights > 0 then
		self.hGreenLight = hGreenLights[ 1 ]
	end
	if self.hGreenLight == nil then
		print( "Unable to find \"green_light\"" )
	end

	local hRedLights = self:GetRoom():FindAllEntitiesInRoomByName( "red_light", true )
	if #hRedLights > 0 then
		self.hRedLight = hRedLights[ 1 ]
	end
	if self.hRedLight == nil then
		print( "Unable to find \"red_light\"" )
	end

	self.fEncounterStartTime = GameRules:GetGameTime()
	self.fNextLightChangeTime = self.fEncounterStartTime + self:GetNextLightChangeTime()
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:OnThink()
	CMapEncounter.OnThink( self )

	if GameRules:GetGameTime() >= self.fNextLightChangeTime then
		printf( "self:ToggleLights()" )
		self:ToggleLights()
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:GetNextLightChangeTime()
	return RandomFloat( 1.0, 7.0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:ToggleLights()
	if self.bGreenLight then
		self.hGreenLight:Disable()
		self.hRedLight:Enable()
		self.bGreenLight = false
	else
		self.hGreenLight:Enable()
		self.hRedLight:Disable()
		self.bGreenLight = true
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:CheckForCompletion()
	local nHeroesAlive = 0
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() and hHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and ( hHero:IsAlive() or hHero:IsReincarnating() )  then
			nHeroesAlive = nHeroesAlive + 1
		end
	end

	return nHeroesAlive > 0 and #self.HeroesOnGoal == nHeroesAlive
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:OnTriggerStartTouch( event )

	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() and event.trigger_name == "goal_trigger" then
		table.insert( self.HeroesOnGoal, hUnit )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Wrath:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() and event.trigger_name == "goal_trigger" then
		for k,hHero in pairs( self.HeroesOnGoal ) do
			if hHero == hUnit then
				table.remove( self.HeroesOnGoal, k )
			end
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Wrath
