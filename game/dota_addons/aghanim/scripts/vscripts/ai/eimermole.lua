
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hBurrowAbility = thisEntity:FindAbilityByName( "eimermole_burrow" )
	thisEntity.hEmergeAbility = thisEntity:FindAbilityByName( "eimermole_emerge" )

	thisEntity.fTimeBeforeFirstBurrow = RandomInt( 1, 3 )
	thisEntity.fTimeBeforeGiveUpBurrow = 8

	thisEntity:SetContextThink( "EimermoleThink", EimermoleThink, 0.1 )
end

--------------------------------------------------------------------------------

function EimermoleThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	-- Doing initialization in Think to give abilities time to exist
	if not thisEntity.bInitialized then
		thisEntity.nEmergeCastRange = thisEntity.hEmergeAbility:GetCastRange( thisEntity:GetOrigin(), nil )

		thisEntity.bInitialized = true
	end

	if not thisEntity.fTimeSawFirstHero then
		local nAggroRange = thisEntity:GetAcquisitionRange()
		local hAggroRangeHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(),
				nil, nAggroRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_CLOSEST, false
		)

		if #hAggroRangeHeroes > 0 then
			thisEntity.fTimeSawFirstHero = GameRules:GetGameTime()
		end

		--printf( "saw first hero, will wait %d secs until first burrow is allowed", thisEntity.fTimeBeforeFirstBurrow )

		return 0.1
	end

	if thisEntity.fTimeSawFirstHero ~= nil then
		if ( GameRules:GetGameTime() < thisEntity.fTimeSawFirstHero + thisEntity.fTimeBeforeFirstBurrow ) then
			--printf( "end Think early, it's not yet time for my first burrow" )
			return 0.1
		end
	end

	if thisEntity:HasModifier( "modifier_eimermole_burrow" ) == false then
		--printf( "does not have burrow modifier" )
		if thisEntity.hBurrowAbility and thisEntity.hBurrowAbility:IsFullyCastable() then
			return CastBurrowAbility()
		end
	elseif thisEntity:HasModifier( "modifier_eimermole_burrow" ) then
		if thisEntity.fTimeOfLastBurrow then
			--printf( "evaluate whether it's taking too long" )
			if GameRules:GetGameTime() >= ( thisEntity.fTimeOfLastBurrow + thisEntity.fTimeBeforeGiveUpBurrow ) then
				--printf( "> it's taking too long, just emerge at my positon" )
				return CastEmergeAbility( thisEntity:GetAbsOrigin() )
			end
		end

		local nSearchRange = 2000
		local hHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(),
				nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_CLOSEST, false
		)

		if #hHeroes == 0 then
			-- We'd rather choose a random hero within some reasonable distance, but if nobody
			--	is around then just get all the heroes
			hHeroes = HeroList:GetAllHeroes()
		end

		--[[
		printf( "hHeroes:" )
		for _, hero in pairs ( hHeroes ) do
			if hero ~= nil then
				printf( "> hero: %s", hero:GetUnitName() )
			end
		end
		]]

		--printf( "has burrow modifier" )
		if ( ( not thisEntity.hEmergeTarget ) or thisEntity.hEmergeTarget:IsAlive() == false ) then
			--printf( "> has no hEmergeTarget or hEmergeTarget is dead" )
			local hRandomEnemy = hHeroes[ RandomInt( 1, #hHeroes ) ]
			if hRandomEnemy and hRandomEnemy:IsAlive() then
				return MoveToUnitPosition( hRandomEnemy )
			end
		elseif ( thisEntity.vEmergeGoalPos ~= nil and thisEntity.hEmergeTarget ~= nil ) then
			--printf( "> has vEmergeGoalPos and hEmergeTarget" )
			local fArrivalThreshold = 150
			local fDistToEmergeGoalPos = ( thisEntity.vEmergeGoalPos - thisEntity:GetAbsOrigin() ):Length2D()
			if fDistToEmergeGoalPos < fArrivalThreshold then
				--printf( ">> arrived at vEmergeGoalPos" )
				local fDistToEmergeTarget = ( thisEntity.hEmergeTarget:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
				if fDistToEmergeTarget < thisEntity.nEmergeCastRange then
					--printf( ">>> is close enough to hEmergeTarget to cast Emerge" ) 
					if thisEntity.hEmergeAbility and thisEntity.hEmergeAbility:IsFullyCastable() then
						return CastEmergeAbility( thisEntity.hEmergeTarget:GetAbsOrigin() )
					end
				else
					--printf( ">>> hEmergeTarget is out of Emerge's cast range, so move-while-burrowed towards nearest hero" )
					local hNearestEnemy = hHeroes[ 1 ]
					if hNearestEnemy and hNearestEnemy:IsAlive() then
						return MoveToUnitPosition( hNearestEnemy )
					end
				end
			end
		elseif thisEntity.hEmergeTarget and thisEntity.hEmergeTarget:IsAlive() then
			--printf( "> has hEmergeTarget and hEmergeTarget is alive" )
			local fDistanceToEmergeTarget = ( thisEntity.hEmergeTarget:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()
			local nBufferDistance = 150 -- hack
			if fDistanceToEmergeTarget < ( thisEntity.nEmergeCastRange - nBufferDistance ) then
				--printf( ">> is close enough to hEmergeTarget to cast Emerge" ) 
				if thisEntity.hEmergeAbility and thisEntity.hEmergeAbility:IsFullyCastable() then
					return CastEmergeAbility( thisEntity.hEmergeTarget:GetAbsOrigin() )
				end
			end
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function CastBurrowAbility()
	printf( "eimermole - CastBurrowAbility" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBurrowAbility:entindex(),
		Queue = false,
	})

	thisEntity.fTimeOfLastBurrow = GameRules:GetGameTime()

	local fTimeToWait = thisEntity.hBurrowAbility:GetCastPoint() + 0.4

	return fTimeToWait
end

--------------------------------------------------------------------------------

function MoveToUnitPosition( hTarget )
	printf( "eimermole - MoveToUnitPosition" )

	thisEntity.vEmergeGoalPos = hTarget:GetAbsOrigin()

	thisEntity:SetInitialGoalEntity( nil ) -- trying this because portaled units with AggroHero=false aren't working

	local MoveOrder =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vEmergeGoalPos,
		Queue = true,
	}

	ExecuteOrderFromTable( MoveOrder )

	--thisEntity:MoveToPositionAggressive( hTarget:GetAbsOrigin() )

	thisEntity.hEmergeTarget = hTarget

	local fTimeToWait = 0.1

	return fTimeToWait
end

--------------------------------------------------------------------------------

function CastEmergeAbility( vPosition )
	printf( "eimermole - CastEmergeAbility" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vPosition,
		AbilityIndex = thisEntity.hEmergeAbility:entindex(),
		Queue = false,
	})

	-- Restore aggro stance
	local AttackMoveOrder =
	{
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity:GetAbsOrigin(),
		Queue = true, -- must queue this, otherwise it'll interrupt the cast
	}

	ExecuteOrderFromTable( AttackMoveOrder )

	thisEntity.hEmergeTarget = nil
	thisEntity.vEmergeGoalPos = nil

	thisEntity.hBurrowAbility:StartCooldown( thisEntity.hEmergeAbility:GetSpecialValueFor( "delay_before_next_burrow" ) )

	local fTimeToWait = thisEntity.hEmergeAbility:GetCastPoint() + 0.2

	return fTimeToWait
end

--------------------------------------------------------------------------------
