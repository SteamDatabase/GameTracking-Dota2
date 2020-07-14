


function Precache( context )
	PrecacheUnitByNameSync( "npc_aghsfort_creature_bomb_squad_landmine", context, -1 )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/darkmoon_2017/darkmoon_calldown_marker_ring.vpcf", context )
end



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.AggroAbility = thisEntity:FindAbilityByName( "bomb_squad_self_cast" )
	thisEntity.MineCharge = thisEntity:FindAbilityByName( "bomb_squad_mine_charge" )
	thisEntity.StasisLaunch = thisEntity:FindAbilityByName( "bomb_squad_stasis_launch" )

	thisEntity.flLastOrder = GameRules:GetGameTime()
	thisEntity:SetContextThink( "BombSquadThink", BombSquadThink, 1 )
end




function BombSquadThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

		
	if (thisEntity:GetAggroTarget() == nil and GameRules:GetGameTime() - thisEntity.flLastOrder) > (4 - RandomFloat(0 ,1 )) then
		thisEntity.flLastOrder = GameRules:GetGameTime()
		return DoMove()	
	end

	if thisEntity.StasisLaunch and thisEntity.StasisLaunch:IsFullyCastable() then
		local StasisLaunchRadius = 650
		local hEnemiesNearby = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, StasisLaunchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )
		if #hEnemiesNearby > 0 then
			local hFarthestEnemy = hEnemiesNearby[ 1 ]
			return CastStasisLaunch( hFarthestEnemy )
		end
	end

	if thisEntity.MineCharge and thisEntity.MineCharge:IsFullyCastable() then
		return CastMineCharge()
	end

--	if AggroAbility ~= true and AggroAbility:IsFullyCastable() then
--		bIsAggro = true
--		return CastAggroAbility()
--	end

	return 0.5
end


--function CastAggroAbility()
--	ExecuteOrderFromTable({
--		UnitIndex = thisEntity:entindex(),
--		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
--		AbilityIndex = AggroAbility:entindex(),
--		Queue = false,
--	})
--	
--	return 1
--end


function DoMove()
	if IsServer() then

		for i=1,4 do
			local vLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 100, 400 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

				ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = vLoc
				})
				break
			end
		end
	end
	return 0.5
end	


--------------------------------------------------------------------------------

function CastMineCharge()
	if IsServer() then

		for i=1,12 do
			local vLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 1800, 2400 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

				ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = vLoc,
				AbilityIndex = thisEntity.MineCharge:entindex(),
				Queue = false,
				})
				break
			end
		end
		return 3
	end
end


--------------------------------------------------------------------------------

function CastStasisLaunch( hTarget )
	if hTarget == nil or hTarget:IsNull() or hTarget:IsAlive() == false then
		return 0.5
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hTarget:GetOrigin(),
		AbilityIndex = thisEntity.StasisLaunch:entindex(),
		Queue = false,
	})

	return 2
end
