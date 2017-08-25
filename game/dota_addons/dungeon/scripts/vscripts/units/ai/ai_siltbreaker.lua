
require( "units/ai/ai_siltbreaker_shared" )

PHASE_ONE = 1
PHASE_TWO = 2
PHASE_THREE = 3

TAUNT_RATE = 20.0
SPEECH_COOLDOWN = 3.0

SUMMONS_COOLDOWN = 40

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		thisEntity.bHasOwner = ( thisEntity:GetOwnerEntity() ~= nil )
		if thisEntity.bHasOwner == false then
			thisEntity:AddNewModifier( nil, nil, "modifier_boss_inactive", { duration = -1 } )
		end

		thisEntity.abilities =
		{
			hSprint = thisEntity:FindAbilityByName( "siltbreaker_sprint" ),
			hTailSpinCCW = thisEntity:FindAbilityByName( "siltbreaker_tail_spin_ccw" ),
			hTeleport = thisEntity:FindAbilityByName( "siltbreaker_teleport" ),
			hLineWave = thisEntity:FindAbilityByName( "siltbreaker_line_wave" ),
			hMindControl = thisEntity:FindAbilityByName( "siltbreaker_mind_control" ),
			hSummonMinions = thisEntity:FindAbilityByName( "siltbreaker_summon_minions" ),
			hSummonMinionsMedium = thisEntity:FindAbilityByName( "siltbreaker_summon_minions_medium" ),
			hMouthBeam = thisEntity:FindAbilityByName( "siltbreaker_mouth_beam" ),
			hWaves = thisEntity:FindAbilityByName( "siltbreaker_waves" ),
			hTorrents = thisEntity:FindAbilityByName( "siltbreaker_torrents" ),
			hGoPhaseTwo = thisEntity:FindAbilityByName( "siltbreaker_go_phase_two" ),
			hGoPhaseThree = thisEntity:FindAbilityByName( "siltbreaker_go_phase_three" ),
		}

		thisEntity.Phase = PHASE_ONE
		nHighestPhaseReached = PHASE_ONE
		nPhaseTwoHPThreshold = 66
		nPhaseThreeHPThreshold = 33

		thisEntity.nRecentTeleportsCast = 0
		thisEntity.nMaxChainedTeleports = 4
		thisEntity.nTeleportsToChain = 2
		thisEntity.nTeleportChainCD = 40
		thisEntity.fLastTeleportChain = 0

		thisEntity.nSpecialsCD = 45

		thisEntity.nSummonCloneCasts = 0
		thisEntity.fLastSpecialTime = 0

		thisEntity.bEnemiesBehind = false
		thisEntity.bEnemiesInFront = false

		thisEntity:SetContextThink( "SiltbreakerThink", SiltbreakerThink, 1 )

		thisEntity.fOrigSpawnPos = Vector( 10271, -11657, -384 )
	end
end

--------------------------------------------------------------------------------

function SiltbreakerThink()
	if ( not thisEntity.bInit ) then
		InitSiltbreaker()
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity == nil then
		return 1
	end

	if thisEntity:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		return 1
	end

	if thisEntity:IsChanneling() == true then
		return 0.1
	end

	if thisEntity.bStarted == false then
		return 0.1
	end

	if ( not thisEntity.bInitAfterStart ) then
		InitAfterStart()
	end

	local fDistFromSpawn = ( thisEntity:GetOrigin() - thisEntity.fOrigSpawnPos ):Length2D()

	if ( fDistFromSpawn > 7000 ) and ( thisEntity.bHasOwner == false ) then
		FindClearSpaceForUnit( thisEntity, thisEntity.fOrigSpawnPos, true )
		return 0.1
	end

	UpdateEndCamera()

	local lastPhase = thisEntity.Phase
	thisEntity.Phase = CheckToChangePhase()

	if thisEntity.Phase ~= lastPhase then
		if thisEntity.Phase == PHASE_TWO then
			return CastPhaseTwo( thisEntity )
		elseif thisEntity.Phase == PHASE_THREE then
			return CastPhaseThree( thisEntity )
		end
	end

	local hEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 7000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
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

	if GameRules:GetGameTime() > ( thisEntity.fLastSpecialTime + thisEntity.nSpecialsCD ) then
		if WavesIsReady( hSiltUnit ) then
			thisEntity.fLastSpecialTime = GameRules:GetGameTime()
			return CastWaves( hSiltUnit, hEnemies )
		end
	end

	if GameRules:GetGameTime() > ( thisEntity.fLastSummonsTime + SUMMONS_COOLDOWN ) then
		if SummonMinionsIsReady( hSiltUnit ) then
			thisEntity.fLastSummonsTime = GameRules:GetGameTime()
			return CastSummonMinions( hSiltUnit )
		end
	end

	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if LineWaveIsReady( hSiltUnit ) then
		return CastLineWave( hSiltUnit, hEnemies )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if TeleportIsReady( hSiltUnit ) then
		return CastTeleport( hSiltUnit, hEnemies )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function PhaseTwoThink( hSiltUnit, hEnemies )
	UpdatePositionalInfo( hSiltUnit, hEnemies )

	if GameRules:GetGameTime() > ( thisEntity.fLastSpecialTime + thisEntity.nSpecialsCD ) then
		if MouthBeamIsReady( hSiltUnit ) then
			thisEntity.fLastSpecialTime = GameRules:GetGameTime()
			return CastMouthBeam( hSiltUnit, hEnemies )
		end
	end

	if GameRules:GetGameTime() > ( thisEntity.fLastSummonsTime + SUMMONS_COOLDOWN ) then
		if SummonMinionsIsReady( hSiltUnit ) then
			thisEntity.fLastSummonsTime = GameRules:GetGameTime()
			return CastSummonMinions( hSiltUnit )
		end
	end

	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if LineWaveIsReady( hSiltUnit ) then
		return CastLineWave( hSiltUnit, hEnemies )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if MindControlIsReady( hSiltUnit, hEnemies ) then
		return CastMindControl( hSiltUnit, hEnemies )
	end

	if TeleportIsReady( hSiltUnit ) then
		return CastTeleport( hSiltUnit, hEnemies )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function PhaseThreeThink( hSiltUnit, hEnemies )
	UpdatePositionalInfo( hSiltUnit, hEnemies )

	if GameRules:GetGameTime() > ( thisEntity.fLastSpecialTime + thisEntity.nSpecialsCD ) then
		if TorrentsIsReady( hSiltUnit ) then
			thisEntity.fLastSpecialTime = GameRules:GetGameTime()
			return CastTorrents( hSiltUnit )
		end
	end

	if GameRules:GetGameTime() > ( thisEntity.fLastSummonsTime + SUMMONS_COOLDOWN ) then
		if SummonMinionsMediumIsReady( hSiltUnit ) then
			thisEntity.fLastSummonsTime = GameRules:GetGameTime()
			return CastSummonMinionsMedium( hSiltUnit )
		end
	end

	if TailIsReady( hSiltUnit ) then
		return CastTailSpinCCW( hSiltUnit )
	end

	if LineWaveIsReady( hSiltUnit ) then
		return CastLineWave( hSiltUnit, hEnemies )
	end

	if SprintIsReady( hSiltUnit ) then
		AttackTargetOrder( hSiltUnit, hEnemies[ #hEnemies ] )
		return CastSprint( hSiltUnit )
	end

	if MindControlIsReady( hSiltUnit, hEnemies ) then
		return CastMindControl( hSiltUnit, hEnemies )
	end

	if TeleportIsReady( hSiltUnit ) then
		return CastTeleport( hSiltUnit, hEnemies )
	end

	return AttackMoveOrder( hSiltUnit, hEnemies[ 1 ] )
end

--------------------------------------------------------------------------------

function InitSiltbreaker()
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_siltbreaker_phase_one", { duration = -1 } )

	thisEntity.bInit = true
end

--------------------------------------------------------------------------------

function InitAfterStart()
	thisEntity.fLastSpecialTime = GameRules:GetGameTime() - ( thisEntity.nSpecialsCD / 2 )
	thisEntity.fLastSummonsTime = GameRules:GetGameTime() - ( SUMMONS_COOLDOWN / 2 )

	thisEntity.bInitAfterStart = true
end

--------------------------------------------------------------------------------

function UpdateEndCamera()
	local hEndCamera = Entities:FindByName( nil, "dire_end_camera" )
	if hEndCamera ~= nil then
		hEndCamera:SetAbsOrigin( thisEntity:GetAbsOrigin() )
	end
end

--------------------------------------------------------------------------------

function CheckToChangePhase()
	if ( thisEntity:GetHealthPercent() < nPhaseTwoHPThreshold ) and ( thisEntity:GetHealthPercent() > nPhaseThreeHPThreshold ) and ( nHighestPhaseReached < PHASE_TWO ) then
		if PhaseTwoIsReady( thisEntity ) then
			print( string.format( "CheckToChangePhase wants to go phase 2 - hp percent: %.1f", thisEntity:GetHealthPercent() ) )
			return SiltbreakerPhaseTwo()
		end
	elseif ( thisEntity:GetHealthPercent() < nPhaseThreeHPThreshold ) and ( nHighestPhaseReached < PHASE_THREE ) then
		if PhaseThreeIsReady( thisEntity ) then
			print( string.format( "CheckToChangePhase wants to go phase 3 - hp percent: %.1f", thisEntity:GetHealthPercent() ) )
			return SiltbreakerPhaseThree()
		end
	end

	return thisEntity.Phase
end

--------------------------------------------------------------------------------

function SiltbreakerPhaseTwo()
	nHighestPhaseReached = PHASE_TWO
	thisEntity.nTeleportsToChain = 3
	thisEntity.nSpecialsCD = 25

	return PHASE_TWO
end

--------------------------------------------------------------------------------

function SiltbreakerPhaseThree()
	nHighestPhaseReached = PHASE_THREE
	thisEntity.nTeleportsToChain = 4
	thisEntity.nSpecialsCD = 45

	return PHASE_THREE
end

--------------------------------------------------------------------------------

function PhaseTwoIsReady( hCaster )
	local hAbility = hCaster.abilities.hGoPhaseTwo
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------

function CastPhaseTwo( hCaster )
	local hAbility = hCaster.abilities.hGoPhaseTwo
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------

function PhaseThreeIsReady( hCaster )
	local hAbility = hCaster.abilities.hGoPhaseThree
	if hAbility ~= nil and hAbility:IsFullyCastable() then
		return true
	end
	
	return false
end

--------------------------------------------------------------------------------
function CastPhaseThree( hCaster )
	local hAbility = hCaster.abilities.hGoPhaseThree
	ExecuteOrderFromTable({
		UnitIndex = hCaster:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hAbility:entindex(),
		Queue = false,
	})

	return 2
end

--------------------------------------------------------------------------------

