
--[[ ai/rhyzik.lua ]]

PHASE_PHYSICAL = 0
PHASE_SANDSTORM = 1
PHASE_EPICENTER = 2

TRIGGER_PHASE_CD = 12
PHASE_DURATION = 15
BURROW_DURATION = 15
MIN_BURROWSTRIKES = 2
MAX_BURROWSTRIKES = 5

function Spawn( entityKeyValues )
	if IsServer() then
		if thisEntity == nil then
			return
		end

		TailSwipeLeft = thisEntity:FindAbilityByName( "sand_king_tail_swipe_left" )
		TailSwipeRight = thisEntity:FindAbilityByName( "sand_king_tail_swipe_right" )
		BurrowStrike = thisEntity:FindAbilityByName( "sand_king_boss_burrowstrike" )
		BurrowDown = thisEntity:FindAbilityByName( "sand_king_boss_burrow" )
		BurrowUp = thisEntity:FindAbilityByName( "sand_king_boss_unburrow" )
		SandStorm = thisEntity:FindAbilityByName( "sand_king_boss_sandstorm" )
		Epicenter = thisEntity:FindAbilityByName( "sand_king_boss_epicenter" )
		ForwardTailSwipe = thisEntity:FindAbilityByName( "sand_king_burrowed_forward_strike" )
		BackwardsTailSwipe = thisEntity:FindAbilityByName( "sand_king_burrowed_backward_strike" )

		DirectionalMoveLeft = thisEntity:FindAbilityByName( "sand_king_boss_move_left" )
		DirectionalMoveRight = thisEntity:FindAbilityByName( "sand_king_boss_move_right" )
		DirectionalMoveBack = thisEntity:FindAbilityByName( "sand_king_boss_move_back" )

		--thisEntity.PHASE = PHASE_PHYSICAL
		thisEntity.PHASE = PHASE_SANDSTORM

		Blink = thisEntity:FindItemInInventory( "item_blink" )
		Shivas = thisEntity:FindItemInInventory( "item_shivas_guard" )
		
		thisEntity:SetContextThink( "SandKingThink", SandKingThink, 1 )
		thisEntity.flNextPhaseTime = nil
		thisEntity.flPhaseTriggerEndTime = 0
		thisEntity.bBurrowStateQueued = false
		thisEntity.nBurrowStrikesRemaining = MIN_BURROWSTRIKES
		thisEntity.nCurrentBurrowStrikes = MIN_BURROWSTRIKES
		thisEntity.flUnburrowTime = 0
		
		thisEntity.BurrowSkill = BurrowStrike

		--thisEntity.fOrigSpawnPos = Vector( 11136, 12160, 384 ) -- Removed in AghsFort until we figure what this should mean
		--print( string.format( "saved SK's spawn point: %.2f, %.2f, %.2f", thisEntity.fOrigSpawnPos.x, thisEntity.fOrigSpawnPos.y, thisEntity.fOrigSpawnPos.z ) )
	end
end

function GetNumberBurrowStrikes()
	local nHealthPct = thisEntity:GetHealthPercent()
	if nHealthPct > 80 then
		return MIN_BURROWSTRIKES
	end

	if nHealthPct > 60 then
		return MIN_BURROWSTRIKES + 1
	end

	if nHealthPct > 40 then
		return MIN_BURROWSTRIKES + 2
	end

	return MAX_BURROWSTRIKES
end

function TailIsReady()
	if thisEntity:FindModifierByName( "modifier_sand_king_boss_burrow" ) == nil then
		if TailSwipeLeft ~= nil and TailSwipeRight ~= nil and TailSwipeLeft:IsCooldownReady() and TailSwipeRight:IsCooldownReady() then
			return true
		end
	else
		if ForwardTailSwipe ~= nil and BackwardsTailSwipe ~= nil and ForwardTailSwipe:IsCooldownReady() and BackwardsTailSwipe:IsCooldownReady() then
			return true
		end
	end
	
	return false
end

function WalkIsReady()
	if DirectionalMoveLeft ~= nil and DirectionalMoveRight ~= nil and DirectionalMoveBack ~= nil then
		if DirectionalMoveLeft:IsCooldownReady() or DirectionalMoveRight:IsCooldownReady() or DirectionalMoveBack:IsCooldownReady() then
			return true
		end
	end

	return false
end

function ChangePhase()
	if thisEntity.flNextPhaseTime > GameRules:GetGameTime() then
		return false
	end

	if thisEntity:FindModifierByName( "modifier_sand_king_boss_burrow" ) ~= nil then
		return 0.1
	end	

	if thisEntity.bBurrowStateQueued == true then
		return false
	end

	printf( "Changing Phase " .. GameRules:GetGameTime() )

	if thisEntity.PHASE == PHASE_EPICENTER then
		thisEntity.PHASE = PHASE_PHYSICAL
	else
		thisEntity.PHASE = thisEntity.PHASE + 1
	end

	return true
end

function SandKingThink()
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

	--[[ Removed in Aghanim's Fortress
	if thisEntity.bStarted ~= true then
		return 0.1
	end
	]]

	--[[ Removed in Aghanim's Fortress until we figure out what fOriginalSpawnPos should mean
	local fDistFromSpawn = ( thisEntity:GetOrigin() - thisEntity.fOrigSpawnPos ):Length2D()
	if fDistFromSpawn > 7000 then
		--print( "teleport SK back to his spawn point" )
		FindClearSpaceForUnit( thisEntity, thisEntity.fOrigSpawnPos, true )
		return 0.1
	end
	]]

	local hEndCamera = Entities:FindByName( nil, "boss_camera" )
	if hEndCamera ~= nil then
		hEndCamera:SetAbsOrigin( thisEntity:GetAbsOrigin() )
	end

	if thisEntity.flNextPhaseTime == nil then
		thisEntity.bBurrowStateQueued = true
		thisEntity.flNextPhaseTime = GameRules:GetGameTime() + TRIGGER_PHASE_CD
	--	print( "Setting inital phase time to " .. thisEntity.flNextPhaseTime )
	end

	if ChangePhase() then
	--	print( "Changing Phase..")
		thisEntity.flPhaseTriggerEndTime = GameRules:GetGameTime() + PHASE_DURATION
		thisEntity.bBurrowStateQueued = true
		if thisEntity.BurrowSkill == BurrowStrike then
			thisEntity.BurrowSkill = BurrowDown
			thisEntity.flUnburrowTime = GameRules:GetGameTime() + PHASE_DURATION + BURROW_DURATION
			thisEntity.flNextPhaseTime = GameRules:GetGameTime() + TRIGGER_PHASE_CD + PHASE_DURATION + BURROW_DURATION
	--		print( "Setting next phase time to " .. thisEntity.flNextPhaseTime )
		else
			thisEntity.BurrowSkill = BurrowStrike
			thisEntity.nBurrowStrikesRemaining = GetNumberBurrowStrikes()
			thisEntity.nCurrentBurrowStrikes = GetNumberBurrowStrikes()
			thisEntity.flNextPhaseTime = GameRules:GetGameTime() + TRIGGER_PHASE_CD + PHASE_DURATION --Burrowstrikes adds to this time later after tracking the duration of strikes
	--		print( "Setting next phase time to " .. thisEntity.flNextPhaseTime )
		end
	end

	if thisEntity.flPhaseTriggerEndTime > GameRules:GetGameTime() then
		if thisEntity.PHASE == PHASE_SANDSTORM then
			return SandstormThink()
		end
		if thisEntity.PHASE == PHASE_EPICENTER then
			return EpicenterThink()
		end
	end

	local enemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, thisEntity:GetOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end

	if thisEntity.bBurrowStateQueued == true then
		return BurrowThink( enemies )
	end

	return PhysicalThink( enemies )
end

function BurrowThink( enemies )
	if thisEntity.BurrowSkill == BurrowDown then
		if GameRules:GetGameTime() > thisEntity.flUnburrowTime then
			thisEntity.bBurrowStateQueued = false
			return CastBurrowUp()
		end
		if thisEntity:FindModifierByName( "modifier_sand_king_boss_burrow" ) == nil then
			return CastBurrowDown()
		else
			return PhysicalThink( enemies )
		end
	end

	if thisEntity.BurrowSkill == BurrowStrike then
		if thisEntity:FindModifierByName( "modifier_sand_king_boss_burrowstrike" ) ~= nil or thisEntity:FindModifierByName( "modifier_sand_king_boss_burrowstrike_end" ) ~= nil then
			return 0.1
		end

		if thisEntity.nBurrowStrikesRemaining == thisEntity.nCurrentBurrowStrikes then
			thisEntity.flBurrowStrikesStartTime = GameRules:GetGameTime()
		end

		if thisEntity.nBurrowStrikesRemaining <= 0 then
			thisEntity.bBurrowStateQueued = false
			thisEntity.flNextPhaseTime = thisEntity.flNextPhaseTime + ( GameRules:GetGameTime() - thisEntity.flBurrowStrikesStartTime )
			return 0.1
		end 

		thisEntity.nBurrowStrikesRemaining = thisEntity.nBurrowStrikesRemaining - 1

		for _, enemy in pairs ( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				return CastBurrowstrike( enemy )
			end
		end
	end

	return 1
end

function CastBurrowstrike( enemy )
	--print( "SandKingBoss - Cast Burrowstrike" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = BurrowStrike:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 2.5
end

function CastBurrowDown()
	--print( "SandKingBoss - Cast BurrowDown" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = BurrowDown:entindex(),
		Queue = false,
	})

	return 2.5
end

function CastBurrowUp()
	--print( "SandKingBoss - Cast BurrowUp" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = BurrowUp:entindex(),
		Queue = false,
	})

	return 2.5
end

function SandstormThink()
	return CastSandstorm()
end

function CastSandstorm()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SandStorm:entindex()
	})

	return 1.0
end

function EpicenterThink()
	return CastEpicenter()
end

function CastEpicenter()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Epicenter:entindex()
	})

	return 1.0
end

function PhysicalThink( enemies )
	if thisEntity:FindModifierByName( "modifier_sand_king_boss_directional_move" ) then
		return 0.2
	end

	local vDirection = thisEntity:GetForwardVector()
	local vRight = thisEntity:GetRightVector()
	local vLeft = -vRight
	local flQuadrantDistance = 200
	local bBurrowed = thisEntity:FindModifierByName( "modifier_sand_king_boss_burrow" ) ~= nil

	local vFrontRightQuadrant = thisEntity:GetOrigin() + (( vDirection + vRight ) * flQuadrantDistance )
	local vFrontLeftQuadrant = thisEntity:GetOrigin() + (( vDirection + vLeft ) * flQuadrantDistance )
	local vBackRightQuadrant = thisEntity:GetOrigin() + (( -vDirection + vRight ) * flQuadrantDistance )
	local vBackLeftQuadrant = thisEntity:GetOrigin() + (( -vDirection + vLeft ) * flQuadrantDistance )
	local frontRightEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vFrontRightQuadrant, enemies[1], 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local frontLeftEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vFrontLeftQuadrant, enemies[1], 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local backRightEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vBackRightQuadrant, enemies[1], 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local backLeftEnemies = FindUnitsInRadius( DOTA_TEAM_BADGUYS, vBackLeftQuadrant, enemies[1], 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

	local bEnemiesBehind = true
	if #backRightEnemies == 0 and #backLeftEnemies == 0 then
		bEnemiesBehind = false
	end

	local bEnemiesInFront = true
	if #frontRightEnemies == 0 and #frontLeftEnemies == 0 then
		bEnemiesInFront = false
	end

	if bBurrowed then
		return CastForwardsTailSwipe( enemies[1] )
	end
	
	if bBurrowed then
		return 1
	end

	if Blink ~= nil and Blink:IsFullyCastable() then
		--print ( "Use Blink" )
		return CastBlink( enemies[#enemies]:GetOrigin() )
	else
		if Blink == nil then
			--print ( "blink is nil" )
			Blink = thisEntity:FindItemInInventory( "item_blink" )
		end
	end

	if Shivas ~= nil and Shivas:IsFullyCastable() then
		return CastShivas()
	else
		if Shivas == nil then
			--print ( "shivas is nil" )
			Shivas = thisEntity:FindItemInInventory( "item_shivas_guard" )
		end
	end

	if bEnemiesBehind == true and TailIsReady() then
		if #backLeftEnemies > 0 and #backRightEnemies > 0 then
			local nRoll = RandomInt( 0, 1 )
			if nRoll == 0 then
				return CastTailSwipeLeft()
			else
				return CastTailSwipeRight()
			end
		else
			if #backLeftEnemies > 0 then
				return CastTailSwipeLeft()
			end
			if #backRightEnemies > 0 then
				return CastTailSwipeRight()
			end
		end
	end

	if TailIsReady() == false and WalkIsReady() == true and RandomInt( 0, 3 ) == 0 then
		if enemies[1] ~= nil then
			local flDist = ( enemies[1]:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist <= 200 and DirectionalMoveBack:IsCooldownReady() then
				return MoveBack( enemies[1] )
			else
				return MoveSideWays( enemies[1] )
			end
		end
	end

	return Attack( enemies[1] )
end

function CastBlink( vPos )
	--print ( "Use Blink" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPos,
		AbilityIndex = Blink:entindex()
		})

	return 0.5
end

function CastShivas()
	--print ( "Use Shivas" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = Shivas:entindex()
	})

	return 0.25
end

function Attack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = enemy:GetOrigin(),
	})

	return 2.0
end

function MoveBack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = DirectionalMoveBack:entindex(),
	})

	return 1.0
end

function MoveSideWays( enemy )
	local Ability = DirectionalMoveRight
	if RandomInt( 0, 1 ) == 1 then
		Ability = DirectionalMoveLeft
	end
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = Ability:entindex(),
	})

	return 1.0
end

function CastClawAttack( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = ClawAttack:entindex(),
	})

	return 1.1
end

function CastTailSwipeLeft()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = TailSwipeLeft:entindex()
	})

	return 2.5
end

function CastTailSwipeRight()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = TailSwipeRight:entindex()
	})

	return 2.5
end


function CastBackwardsTailSwipe()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = BackwardsTailSwipe:entindex()
	})

	return 2.5
end

function CastForwardsTailSwipe( enemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = ForwardTailSwipe:entindex(),
	})

	return 2.5
end
