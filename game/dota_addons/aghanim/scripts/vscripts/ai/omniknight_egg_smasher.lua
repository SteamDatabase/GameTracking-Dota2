
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hPurificationAbility = thisEntity:FindAbilityByName( "omniknight_egg_smasher_purification" )
	thisEntity:SetContextThink( "OmniknightEggSmasherThink", OmniknightEggSmasherThink, 0.25 )

    thisEntity.nPurificationUses = 3 -- Prevent infinite healing
end

--------------------------------------------------------------------------------

function OmniknightEggSmasherThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() == true then
    	return 0.1
	end

    thisEntity:SetInitialGoalEntity( nil )

    -- Avoid double heals: Closest omni gets to heal
    if thisEntity.hPurificationAbility:IsFullyCastable() and thisEntity.nPurificationUses > 0 then
        local flHealThreshold = 80.0

        local vecFriends = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.hPurificationAbility:GetCastRange( thisEntity:GetOrigin(), nil ), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
        local vecOtherHealers = {}
        for _, hFriend in pairs( vecFriends ) do
            if hFriend:IsAlive() and hFriend:GetUnitName() == "npc_dota_creature_omniknight_egg_smasher" then
                if hFriend.hPurificationAbility:IsFullyCastable() then
                    table.insert( vecOtherHealers, hFriend )
                end
            end
        end

        for _, hFriend in pairs( vecFriends ) do
            if hFriend:GetHealthPercent() < flHealThreshold then
                -- If we're closest, heal them
                local bClosest = true
                local fDist = ( thisEntity:GetOrigin() - hFriend:GetOrigin() ):Length2D()

                for _, hHealer in pairs( vecOtherHealers ) do
                    if ( hHealer:GetOrigin() - hFriend:GetOrigin() ):Length2D() < fDist then
                        bClosest = false
                    end
                end

                if bClosest then
                    return CastPurification( hFriend )
                end
            end
        end
    end

    local vecEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #vecEnemies == 0 then
		return FindStuffToSmash()
    end

    return Attack( vecEnemies[1] )
end

--------------------------------------------------------------------------------

function CastPurification( hFriendly )
	--print( "omniknight_egg_smasher - Purification" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hPurificationAbility:entindex(),
		TargetIndex = hFriendly:entindex(),
		Queue = false,
	})

	local fReturnTime = thisEntity.hPurificationAbility:GetCastPoint() + 0.4
	--printf( "Purification - return in %.2f", fReturnTime )
	thisEntity.nPurificationUses = thisEntity.nPurificationUses - 1
	return fReturnTime

	--return 1.3
end

--------------------------------------------------------------------------------

function FindStuffToSmash()

	local hTarget = nil

	local vecEggs = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for _, hEgg in pairs( vecEggs ) do 
		if hEgg:IsAlive() and hEgg:GetUnitName() == "npc_dota_creature_dragon_egg" then
			hTarget = hEgg
			break
		end
	end

	if hTarget == nil then
		local vecHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, hHero in pairs( vecHeroes ) do
			if hHero:IsAlive() then
				hTarget = hHero
			end
		end
	end

	if hTarget ~= nil then
		thisEntity:SetInitialGoalEntity( hTarget )
	end

	return 1.0
end

--------------------------------------------------------------------------------

function Attack( hEnemy )
	--printf( "Attacking enemy %s", hEnemy:GetUnitName() )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})

	return 2.0
end
