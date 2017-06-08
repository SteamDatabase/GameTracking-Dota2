--[[ units/ai/ai_bat_spitter.lua ]]

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	AcidLaunchAbility = thisEntity:FindAbilityByName( "bat_acid_launch" )

	thisEntity:SetContextThink( "BatSpitterThink", BatSpitterThink, 1 )
end

function BatSpitterThink()
	if not IsServer() then
		return
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- check if we didn't already have aggro and now have aggro, if we do then set bAggro true and get a timestamp which we'll use to determine how soon we can launch acid
    if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	elseif thisEntity.bHasAggro and ( not thisEntity:GetAggroTarget() ) then
		thisEntity.bHasAggro = false
	end

	if ( not thisEntity.bHasAggro ) then
		return 1
	end

	-- If we've had aggro for a bit, we're willing to launch acid
	local fDelayBeforeAcid = RandomFloat( 3, 5 )
	if GameRules:GetGameTime() > ( thisEntity.timeOfLastAggro + fDelayBeforeAcid ) then
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #enemies == 0 then
			return 1
		end

		local vTargetPos = nil
		if AcidLaunchAbility ~= nil and AcidLaunchAbility:IsCooldownReady() then
			-- We want to avoid overlapping with another acid spray thinker
			for _, hEnemy in pairs( enemies ) do
				local hUnitsNearEnemy = FindUnitsInRadius( thisEntity:GetTeamNumber(), hEnemy:GetOrigin(), nil, 680, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
				if not IsAcidNearby( hUnitsNearEnemy ) then
					-- Target the first enemy we find that doesn't have an acid thinker near it
					vTargetPos = hEnemy:GetAbsOrigin()
				end
			end
			
			if vTargetPos ~= nil then
				return LaunchAcid( vTargetPos )
			else
				return 0.5
			end
		end
	end

	return 0.5
end

-------------------------------------------------------------------------------

function IsAcidNearby( hUnitsNearEnemy )
	for _, hUnit in pairs( hUnitsNearEnemy ) do
		local bIsAcidSprayThinker = hUnit:HasModifier( "modifier_alchemist_acid_spray" )
		if bIsAcidSprayThinker then
			--print( "there's an acid spray thinker near unit" )
			return true
		end
	end

	return false
end

-------------------------------------------------------------------------------

function LaunchAcid( vTargetPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = AcidLaunchAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})
	return 1
end

