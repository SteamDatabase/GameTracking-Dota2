
require( "map_encounter" )
require( "aghanim_utility_functions" )
require( "spawner" )
require( "portalspawner" )

--------------------------------------------------------------------------------

if CMapEncounter_Twilight_Maze == nil then
	CMapEncounter_Twilight_Maze = class( {}, {}, CMapEncounter )
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:constructor( hRoom, szEncounterName )
	CMapEncounter.constructor( self, hRoom, szEncounterName )

	self:AddSpawner( CDotaSpawner( "spawner_preplaced_big_skeleton_1", "spawner_preplaced_big_skeleton",
		{
			{
				EntityName = "npc_dota_creature_big_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "spawner_preplaced_skeleton_mage_1", "spawner_preplaced_skeleton_mage",
		{
			{
				EntityName = "npc_dota_creature_skeleton_mage",
				Team = DOTA_TEAM_BADGUYS,
				Count = 1,
				PositionNoise = 0.0,
			},
		}
	) )

	self:AddSpawner( CDotaSpawner( "spawner_preplaced_small_skeleton_1", "spawner_preplaced_small_skeleton",
		{
			{
				EntityName = "npc_dota_creature_small_skeleton",
				Team = DOTA_TEAM_BADGUYS,
				Count = 4,
				PositionNoise = 0.0,
			},
		}
	) )

	self:SetCalculateRewardsFromUnitCount( true )
	self.nEnemyCount = 0

	self.BigSkeletons = {}
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:Precache( context )
	CMapEncounter.Precache( self, context )

	PrecacheUnitByNameSync( "npc_dota_creature_big_skeleton", context, -1 )
	PrecacheUnitByNameSync( "npc_dota_creature_small_skeleton", context, -1 )
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:GetPreviewUnit()
	return "npc_dota_creature_big_skeleton"
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:OnEncounterLoaded()
	CMapEncounter.OnEncounterLoaded( self )
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:Start()
	local vRoomCenter = GameRules.Aghanim:GetCurrentRoom():GetOrigin()
	self.hDummyCaster = CreateUnitByName( "npc_dota_dummy_caster_twilight_maze", vRoomCenter, true, nil, nil, DOTA_TEAM_BADGUYS )
	DoScriptAssert( self.hDummyCaster ~= nil, "self.hDummyCaster not found" )

	self:CreateEnemies()

	CMapEncounter.Start( self )

	--print( '^^^CMapEncounter_Twilight_Maze:Start()!' )
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:GetMaxSpawnedUnitCount()
	return self.nEnemyCount
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:CreateEnemies()
	self.nEnemyCount = 0

	for _, Spawner in pairs ( self:GetSpawners() ) do
		local hUnits = Spawner:SpawnUnits()
		if #hUnits > 0 then 
			self.nEnemyCount = self.nEnemyCount + #hUnits

			for _,hUnit in pairs ( hUnits ) do 
				if hUnit:GetUnitName() == "npc_dota_creature_big_skeleton" then 
					local nSkeleteeniesPerBigSkeleton = 20
					self.nEnemyCount = self.nEnemyCount + nSkeleteeniesPerBigSkeleton

					table.insert( self.BigSkeletons, hUnit )
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:MustKillForEncounterCompletion( hEnemyCreature )
	if hEnemyCreature:GetUnitName() == "npc_dota_dummy_caster_twilight_maze" then
		return false
	end

	return CMapEncounter.MustKillForEncounterCompletion( self, hEnemyCreature )
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:OnRequiredEnemyKilled( hAttacker, hVictim )
	CMapEncounter.OnRequiredEnemyKilled( self, hAttacker, hVictim )

	local nCurrentValue = self:GetEncounterObjectiveProgress( "defeat_all_enemies" )
	if nCurrentValue ~= -1 then 
		local nMaxSpawnedUnits = self:GetMaxSpawnedUnitCount()
		self:UpdateEncounterObjective( "defeat_all_enemies", math.min( nCurrentValue + 1, nMaxSpawnedUnits ), nMaxSpawnedUnits )
	end

	if hVictim and hVictim:GetUnitName() == "npc_dota_creature_big_skeleton" then
		for k, hBigSkeleton in pairs( self.BigSkeletons ) do
			if hBigSkeleton == nil or hBigSkeleton:IsNull() or hBigSkeleton:IsAlive() == false then
				table.remove( self.BigSkeletons, k )
			end
		end

		if #self.BigSkeletons == 0 then
			--printf( "All big skeletons are dead, look for creature stragglers to send towards players" )

			local allies = FindUnitsInRadius( hVictim:GetTeamNumber(), hVictim:GetOrigin(),
				hVictim, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false
			)

			if #allies > 0 then
				local AttackPositions = Entities:FindAllByName( "stragglers_attack_position" )
				DoScriptAssert( AttackPositions ~= nil, "found no ents named stragglers_attack_position" )

				if #AttackPositions > 0 then
					local hAttackPosition = AttackPositions[ 1 ]
					if hAttackPosition then
						local vMoveToPosition = hAttackPosition:GetAbsOrigin()
						if vMoveToPosition then
							for _, ally in pairs( allies ) do
								if ally ~= nil then
									--printf( "  sending straggler \"%s\" to %s", ally:GetUnitName(), vMoveToPosition )
									ally:MoveToPositionAggressive( vMoveToPosition )
								end
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function CMapEncounter_Twilight_Maze:OnComplete()
	CMapEncounter.OnComplete( self )

	local units = FindUnitsInRadius( DOTA_TEAM_BADGUYS, self.hRoom:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, true )
	for _, unit in pairs( units ) do
		if unit:GetUnitName() == "npc_dota_creature_skeleteeny" then
			unit:ForceKill( false )
		end
	end
end

--------------------------------------------------------------------------------

return CMapEncounter_Twilight_Maze
