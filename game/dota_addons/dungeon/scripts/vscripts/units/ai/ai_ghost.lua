
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	hTerrorAbility = thisEntity:FindAbilityByName( "ghost_terror" )

	thisEntity:SetContextThink( "GhostThink", GhostThink, 1 )
end

--------------------------------------------------------------------------------

function GhostThink()
	if GameRules:IsGamePaused() == true or GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME or thisEntity:IsAlive() == false then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeIncreased ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 750 )
		thisEntity.bAcqRangeIncreased = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.fTimeWeLostAggro = nil
	end

	if thisEntity:GetAggroTarget() and ( thisEntity.fTimeAggroStarted == nil ) then
		--print( "Do we have aggro and need to get a timestamp?" )
		thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
	end

	if ( not thisEntity:GetAggroTarget() ) and ( thisEntity.fTimeAggroStarted ~= nil ) then
		--print( "We lost aggro." )
		thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
		thisEntity.fTimeAggroStarted = nil
	end

	if ( not thisEntity:GetAggroTarget() ) then
		if thisEntity.fTimeWeLostAggro and ( GameRules:GetGameTime() > ( thisEntity.fTimeWeLostAggro + 1.0 ) ) then
			return RetreatHome()
		end
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	if hTerrorAbility ~= nil and hTerrorAbility:IsFullyCastable() then
		return CastTerror( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastTerror( unit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hTerrorAbility:entindex(),
		Position = unit:GetOrigin(),
		Queue = false,
	})

	return 1.1
end

--------------------------------------------------------------------------------

function RetreatHome()
	--print( "RetreatHome - " .. thisEntity:GetUnitName() .. " is returning to home position" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})

	return 0.5
end

--------------------------------------------------------------------------------
