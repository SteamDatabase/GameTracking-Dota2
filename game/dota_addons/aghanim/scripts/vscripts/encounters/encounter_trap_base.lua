require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_TrapBase == nil then
	CMapEncounter_TrapBase = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
	PrecacheUnitByNameSync( "npc_dota_pendulum_trap", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )

	self.HeroesOnGoal = {}
	self.nHeroOnTrigger1 = 0
	self.nHeroOnTrigger2 = 0
	self.nHeroOnTrigger3 = 0
	self.nHeroOnTrigger4 = 0
	self.nHeroesOnGoal = 0
	
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:InitializeObjectives()
	self:AddEncounterObjective( "navigate_the_traps", 0, 0 )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:GetMaxSpawnedUnitCount()
	return 0
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:Start()
	CMapEncounter.Start( self )

	local hHeroes = HeroList:GetAllHeroes()

	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			hHero:AddNewModifier( hHero, nil, "modifier_aghsfort_player_transform", { duration = -1 } )
		end
	end

	local PendulumSpawners = self:GetRoom():FindAllEntitiesInRoomByName( "pendulum_trap", false )
	for _,Spawner in pairs ( PendulumSpawners ) do
		local hPendulum = CreateUnitByName( "npc_dota_pendulum_trap", Spawner:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS )
		if hPendulum then
			print( "Found pendulum")
			hPendulum:SetForwardVector( Spawner:GetForwardVector() )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnThink()
	CMapEncounter.OnThink( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:CheckForCompletion()
	local nHeroesAlive = 0
	local hHeroes = HeroList:GetAllHeroes()
	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and hHero:IsRealHero() and hHero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			if hHero:IsAlive() or hHero:GetRespawnsDisabled() == false then
				nHeroesAlive = nHeroesAlive + 1
			end
		end
	end
	self.nHeroesOnGoal = self.nHeroOnTrigger1 + self.nHeroOnTrigger2 + self.nHeroOnTrigger3 + self.nHeroOnTrigger4
	return nHeroesAlive > 0 and self.nHeroesOnGoal == nHeroesAlive
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnTriggerStartTouch( event )

	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() then
		if szTriggerName == "trigger_player_1" then
			self.nHeroOnTrigger1 = 1
		elseif szTriggerName == "trigger_player_2" then
			self.nHeroOnTrigger2 = 1
		elseif  szTriggerName == "trigger_player_3" then
			self.nHeroOnTrigger3 = 1
		elseif  szTriggerName == "trigger_player_4" then
			self.nHeroOnTrigger4 = 1
		end
		--table.insert( self.HeroesOnGoal, hUnit )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnTriggerEndTouch( event )
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )
	local szTriggerName = event.trigger_name
	if hUnit ~= nil and hUnit:IsRealHero() and hUnit:IsControllableByAnyPlayer() then
		if szTriggerName == "trigger_player_1" then
			self.nHeroOnTrigger1 = 0
		elseif szTriggerName == "trigger_player_2" then
			self.nHeroOnTrigger2 = 0
		elseif  szTriggerName == "trigger_player_3" then
			self.nHeroOnTrigger3 = 0
		elseif  szTriggerName == "trigger_player_4" then
			self.nHeroOnTrigger4 = 0
		end
		--[[
		for k,hHero in pairs( self.HeroesOnGoal ) do
			if hHero == hUnit then
				table.remove( self.HeroesOnGoal, k )
			end
		end
		]]
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_TrapBase:OnComplete()
	CMapEncounter.OnComplete( self )
	local hHeroes = HeroList:GetAllHeroes()

	for _, hHero in pairs ( hHeroes ) do
		if hHero ~= nil and not hHero:IsNull() and hHero:IsRealHero() then
			hHero:RemoveModifierByName( "modifier_aghsfort_player_transform" )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_TrapBase
