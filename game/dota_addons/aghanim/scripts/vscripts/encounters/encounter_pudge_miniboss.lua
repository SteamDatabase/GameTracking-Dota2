require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )

--------------------------------------------------------------------------------

if CMapEncounter_PudgeMiniboss == nil then
	CMapEncounter_PudgeMiniboss = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:constructor( hRoom, szEncounterName )

	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self.flNextWaveSpawnTime = -1
	self.flSpawnInterval = 5
	self.flWaveDelay = 0 
	self.nWaves = 16
	self.hHeroes = {}
	self:SetCalculateRewardsFromUnitCount( false )
	self.szPeonSpawner = "spawner_peon"
	self.szBossSpawner = "spawner_pudge"

	self.hPudge = nil

	self.bBossSpawned = false

	self.nMaxZombies = 100

	self.hPeonSpawner = self:AddSpawner( CDotaSpawner( self.szPeonSpawner, self.szPeonSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_pudge_miniboss_minion",
				Team = DOTA_TEAM_BADGUYS,
				Count = 5,
				PositionNoise = 200.0,
			},
		} ) )

	self.hBossSpawner = self:AddSpawner( CDotaSpawner( self.szBossSpawner, self.szBossSpawner,
		{ 
			{
				EntityName = "npc_dota_creature_pudge_miniboss",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		} ) )

end

-------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:Precache( context )
	CMapEncounter.Precache( self, context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_pudge", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_pudge.vsndevts", context )
end


--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:GetPreviewUnit()
	return "npc_dota_creature_pudge_miniboss"
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:OnThink()
	CMapEncounter.OnThink( self )
	self:CreateMinions()
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:CreateMinions()
	if self.bCreatureSpawnsActivated ~= true then
		return
	end

	if self.nWaves > 0 and GameRules:GetGameTime() > self.flNextWaveSpawnTime then	

		for _,Spawner in pairs ( self:GetSpawners() ) do
			if Spawner ~= self.hBossSpawner and self.hPudge ~= nil and self.hPudge:IsNull() == false and self.hPudge:IsAlive() then

				local nSpawnedEnemies = #self.SpawnedEnemies + 1
				if self.nMaxZombies > nSpawnedEnemies then
					Spawner:SpawnUnits()
				else
					print( "Skipping zombie minion spawn; too many zombies!" )
				end
			end
		end

		self.nWaves = self.nWaves - 1
		self.flNextWaveSpawnTime = GameRules:GetGameTime() + self.flSpawnInterval
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:AggroPudgeMinions( Mobs )
	if Mobs == nil or #Mobs == 0 then
		return
	end

	for _,Mob in pairs ( Mobs ) do
		local hEnemies = self.hRoom:GetPlayerUnitsInRoom()
		if #hEnemies > 0 then
			AttackTargetOrder( Mob, hEnemies[ RandomInt( 1, #hEnemies)] )
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:OnSpawnerFinished( hSpawner, hSpawnedUnits )
	CMapEncounter.OnSpawnerFinished( self, hSpawner, hSpawnedUnits )

	if hSpawner == self.hBossSpawner then
		return
	end

	-- randomize zombie speed
	for _,Mob in pairs ( hSpawnedUnits ) do
		Mob:SetBaseMoveSpeed( Mob:GetBaseMoveSpeed() + RandomFloat( -100, 100 ) )
	end

	self:AggroPudgeMinions( hSpawnedUnits )

end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:GetMaxSpawnedUnitCount()
	local nCount = 0
	local hPeonSpawners = self:GetSpawner( self.szPeonSpawner )
	if hPeonSpawners then
		nCount = nCount + hPeonSpawners:GetSpawnPositionCount() * 3 * self.nWaves
	end

	nCount = nCount + 1

	return nCount
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:CheckForCompletion()
	if self.bBossSpawned and not self:HasRemainingEnemies() then
		return true
	end
	return false
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:OnComplete()
	CMapEncounter.OnComplete( self )

	if self.nAbilityListener ~= nil then
		StopListeningToGameEvent( self.nAbilityListener )
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_PudgeMiniboss:OnTriggerStartTouch( event )
	CMapEncounter.OnTriggerStartTouch( self, event )

	-- Get the trigger that activates the room
	local szTriggerName = event.trigger_name
	local hUnit = EntIndexToHScript( event.activator_entindex )
	local hTriggerEntity = EntIndexToHScript( event.caller_entindex )

	if self.bCreatureSpawnsActivated == nil and szTriggerName == "trigger_spawn_creatures" then
		self.bCreatureSpawnsActivated = true

		if not self.bBossSpawned then 
			local hUnits = self.hBossSpawner:SpawnUnits()
			for _,hBoss in pairs ( hUnits) do
				EmitSoundOn( "pudge_pud_spawn_03", hBoss )
				self.hPudge = hBoss
				self.nAbilityListener = ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( getclass( self ), 'OnNonPlayerUsedAbility' ), self )
			end
			self.bBossSpawned = true
		end

		self.flNextWaveSpawnTime = GameRules:GetGameTime() + self.flWaveDelay	
   		EmitGlobalSound( "RoundStart" )
	end
end

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------
function CMapEncounter_PudgeMiniboss:OnNonPlayerUsedAbility( event )
	
	local hCaster = nil
	if event.caster_entindex ~= nil and event.abilityname ~= nil then
		hCaster = EntIndexToHScript( event.caster_entindex )
		if hCaster ~= nil and hCaster == self.hPudge and event.abilityname == "creature_pudge_dismember" then
			local nRandomInt = RandomInt( 1, 3 )
			if nRandomInt == 1 then
				EmitSoundOn( "pudge_pud_ability_devour_02", self.hPudge )
			end
			if nRandomInt == 2 then
				EmitSoundOn( "pudge_pud_ability_devour_03", self.hPudge )
			end
			if nRandomInt == 3 then
				EmitSoundOn( "pudge_pud_ability_devour_04", self.hPudge )
			end
		end
	end
end



--------------------------------------------------------------------------------

return CMapEncounter_PudgeMiniboss
