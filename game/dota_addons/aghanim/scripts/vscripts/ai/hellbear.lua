
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "hellbear_smash" )

	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end

--------------------------------------------------------------------------------

function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 750 )
		thisEntity.bAcqRangeModified = true
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

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.5
	end

	if SmashAbility ~= nil and SmashAbility:IsCooldownReady() then
		return Smash()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function Smash()
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.3 } )
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = SmashAbility:entindex(),
		Queue = false,
	})

	return 1.1 -- was 1.2
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
