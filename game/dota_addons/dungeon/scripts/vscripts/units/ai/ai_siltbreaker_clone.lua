
require( "units/ai/ai_siltbreaker_shared" )

PHASE_ONE = 1
PHASE_TWO = 2
PHASE_THREE = 3

TAUNT_RATE = 20.0
SPEECH_COOLDOWN = 3.0

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.abilities =
		{
			hMouthBeam = thisEntity:FindAbilityByName( "siltbreaker_mouth_beam" ),
		}

		thisEntity.bEnemiesBehind = false
		thisEntity.bEnemiesInFront = false

		thisEntity:SetContextThink( "SiltbreakerCloneThink", SiltbreakerCloneThink, 1 )

		thisEntity.fOrigSpawnPos = Vector( 10271, -11657, -384 )
	end
end

--------------------------------------------------------------------------------

function SiltbreakerCloneThink()
	if ( not thisEntity.bCloneInitialized ) then
		InitClone()
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity == nil then
		return nil
	end

	if thisEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		return 1
	end

	if HasReachedWaypoint( thisEntity.vInitialWaypoint ) == false then
		return 0.1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end

	local fDistFromSpawn = ( thisEntity:GetOrigin() - thisEntity.fOrigSpawnPos ):Length2D()
	if fDistFromSpawn > 7000 then
		FindClearSpaceForUnit( thisEntity, thisEntity.fOrigSpawnPos, true )
		return 0.1
	end

	local hEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.Phase == PHASE_ONE then
		return PhaseOneThink( thisEntity, hEnemies )
	elseif thisEntity.Phase == PHASE_TWO then
		return PhaseTwoThink( thisEntity, hEnemies )
	elseif thisEntity.Phase == PHASE_THREE then
		return PhaseThreeThink( thisEntity, hEnemies )
	end
 
	return 0.5
end

--------------------------------------------------------------------------------

function PhaseOneThink( hSiltUnit, hEnemies )
	UpdatePositionalInfo( hSiltUnit, hEnemies )

	if MouthBeamIsReady( hSiltUnit ) then
		return CastMouthBeam( hSiltUnit, hEnemies )
	end
	
	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if SummonMinionsIsReady( hSiltUnit ) then
		return CastSummonMinions( hSiltUnit )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function PhaseTwoThink( hSiltUnit, hEnemies )
	UpdatePositionalInfo( hSiltUnit, hEnemies )

	if SummonCloneIsReady( hSiltUnit ) then
		return CastSummonClone( hSiltUnit )
	end

	if MouthBeamIsReady( hSiltUnit ) then
		return CastMouthBeam( hSiltUnit, hEnemies )
	end
	
	if TorrentsIsReady( hSiltUnit ) then
		return CastTorrents( hSiltUnit )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if SummonMinionsIsReady( hSiltUnit ) then
		return CastSummonMinions( hSiltUnit )
	end

	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if MindControlIsReady( hSiltUnit ) then
		return CastMindControl( hSiltUnit, hEnemies )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function PhaseThreeThink( hSiltUnit, hEnemies )
	UpdatePositionalInfo( hSiltUnit, hEnemies )

	if MouthBeamIsReady( hSiltUnit ) then
		return CastMouthBeam( hSiltUnit, hEnemies )
	end

	if TorrentsIsReady( hSiltUnit ) then
		return CastTorrents( hSiltUnit )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if SummonMinionsIsReady( hSiltUnit ) then
		return CastSummonMinions( hSiltUnit )
	end

	if SummonCloneIsReady( hSiltUnit ) then
		return CastSummonClone( hSiltUnit )
	end

	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if MindControlIsReady( hSiltUnit ) then
		return CastMindControl( hSiltUnit, hEnemies )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function InitClone()
	thisEntity.Phase = thisEntity.hMaster.Phase
	print( string.format( "Clone's phase: %d", thisEntity.Phase ) )

	thisEntity.vInitialWaypoint = Vector( 10240, -10112, -384 )
	MoveOrder( thisEntity, thisEntity.vInitialWaypoint )

	thisEntity:SetIdleAcquire( false )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provides_vision", { duration = -1 } )

	thisEntity.bCloneInitialized = true
end

--------------------------------------------------------------------------------

function HasReachedWaypoint( vWaypoint )
	local fDist = ( thisEntity:GetOrigin() - vWaypoint ):Length2D()
	if fDist < 50 then
		return true
	end

	return false
end

--------------------------------------------------------------------------------

