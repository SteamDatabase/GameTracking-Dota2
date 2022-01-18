
require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end
	thisEntity.bPatrolled = false
	thisEntity:SetContextThink( "DiregullSmallThink", DiregullSmallThink, 1 )
end

--------------------------------------------------------------------------------

function DiregullSmallThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if not IsServer() then
		return
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false
	)

	if #hEnemies == 0 then
		if thisEntity.bPatrolled == false then
			thisEntity.bPatrolled = true
			return Patrol()
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------------------------------

function Patrol()
	if thisEntity:GetInitialGoalEntity() == nil then
		--local hWaypoint = Entities:FindByClassnameNearest( "path_track", thisEntity:GetOrigin(), 2000.0 )
		local EntityNames = 
			{
				"diregull_patrol_a_1",
				"diregull_patrol_b_1",
				"diregull_patrol_c_1",
			}	
		local nRandom = RandomInt(1,3)
		local szEntityName = EntityNames[nRandom]
		local hWaypoint = Entities:FindByName( nil, szEntityName )
		if hWaypoint ~= nil then
			--print( "Patrolling to " .. hWaypoint:GetName() )
			thisEntity:SetInitialGoalEntity( hWaypoint )
		end
	end

	return 1.0
end

--------------------------------------------------------------------------------
