
--[[ units/ai/ai_ice_boss.lua ]]

FLIGHT_DISTANCE = 2500
DEFAULT_FLYBYS = 3
MAX_FLYBYS = 3
LAND_DURATION = 20.0
EGG_HATCH_TIME = 10.0
HOME_VECTOR = Vector( -10629, 9989, 896 )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_ice_boss_passive", "modifiers/creatures/modifier_ice_boss_passive", LUA_MODIFIER_MOTION_NONE )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	thisEntity.hShatterProjectile = thisEntity:FindAbilityByName( "ice_boss_shatter_projectile" )
	thisEntity.hFlyingShatterProjectile = thisEntity:FindAbilityByName( "ice_boss_flying_shatter_blast" )
	thisEntity.hTakeFlight = thisEntity:FindAbilityByName( "ice_boss_take_flight" )
	thisEntity.hLand = thisEntity:FindAbilityByName( "ice_boss_land" )
	thisEntity.hWintersCurse = thisEntity:FindAbilityByName( "ice_boss_projectile_curse" )

	thisEntity.FlightPositions = {}

	for i=0,11 do
		local vDirection = RotatePosition( Vector( 0, 0, 0 ), QAngle( 0, i * 30 , 0 ), Vector( 1, 0, 0 ) ) * FLIGHT_DISTANCE
		local vFlightPos = HOME_VECTOR + vDirection
		table.insert( thisEntity.FlightPositions, vFlightPos )
	end

	thisEntity.vFlightPosition = nil
	thisEntity.nCurrentFlybys = 0
	thisEntity.bLandPending = false
	thisEntity.flNextTakeOffTime = GameRules:GetGameTime()
	thisEntity.numEggsKilled = 0
	thisEntity.bEggDied = false

	thisEntity.EggSpawners = Entities:FindAllByName( "aerie_ice_boss_egg" )
	thisEntity.nEggsToCreate = 0

	thisEntity:SetContextThink( "IceBossThink", IceBossThink, 0.5 )
end



--------------------------------------------------------------------------------

function IceBossThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return 0.5
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity:FindModifierByName( "modifier_boss_intro" ) then 
		return 0.01
	end

	if thisEntity.Encounter and thisEntity.Encounter.bBossFightStarted == false then 
		return 0.01
	end

	if thisEntity.bStarted == false then
		return 0.1
	elseif ( not thisEntity.bInitialInvulnRemoved ) then
		thisEntity:RemoveModifierByName( "modifier_invulnerable" )
		--print( "removed invuln modifier from ice boss" )
		thisEntity.bInitialInvulnRemoved = true
	end

	if thisEntity:FindModifierByName( "modifier_ice_boss_land" ) ~= nil then
		return 0.25
	end 

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	local bFlying =  ( thisEntity:FindModifierByName( "modifier_ice_boss_take_flight" ) ~= nil )
	local bWantsToFly = WantsToFly( bFlying )

	if bFlying ~= bWantsToFly then
		if bFlying then
			if thisEntity.bLandPending == false then
				thisEntity.vFlightPosition = HOME_VECTOR
				local spawner = thisEntity.EggSpawners[RandomInt(1,#thisEntity.EggSpawners)]
				if spawner ~= nil then
					thisEntity.vFlightPosition = spawner:GetOrigin()
					thisEntity.Nest = spawner
				end
				thisEntity.bLandPending = true
			end
			return FlyingThink()
		else
			thisEntity.nCurrentFlybys = 0
			thisEntity.bEggDied = false
			return TakeFlight()
		end
	else
		if bFlying then
			return FlyingThink()
		else
			return GroundThink( enemies )
		end
	end

	return 0.1
end

--------------------------------------------------------------------------------

function WantsToFly( bFlying )
	if thisEntity:FindModifierByName( "modifier_ice_boss_land" ) ~= nil or thisEntity.bLandPending == true then
		return false
	end 
	if thisEntity.flNextTakeOffTime > GameRules:GetGameTime() then
		return false
	end
	if thisEntity.nCurrentFlybys > MAX_FLYBYS and bFlying then
		return false
	end
	if thisEntity.nCurrentFlybys >= DEFAULT_FLYBYS and thisEntity.bEggDied and bFlying then
		return false
	end

	return true
end

--------------------------------------------------------------------------------

function TakeFlight()
	if thisEntity:FindModifierByName( "modifier_ice_boss_land" ) ~= nil then
		return 0.25
	end 

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hTakeFlight:entindex(),
		Queue = false,
	})
	return 0.25
end

--------------------------------------------------------------------------------

function CastLand()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hLand:entindex(),
		Queue = false,
	})
	return 0.25
end

--------------------------------------------------------------------------------

function GetNumEggsToHatch()
	local nPctHealth = thisEntity:GetHealthPercent()
	if nPctHealth > 66 then
		return 3
	end
	if nPctHealth > 33 and nPctHealth <= 66 then
		return 4
	end
	if nPctHealth <= 33 then
		return 5
	end
	return 3
end

--------------------------------------------------------------------------------

function FlyingThink()
	if thisEntity:FindModifierByName( "modifier_ice_boss_take_flight" ) == nil then
		return TakeFlight()
	end

	if thisEntity.vFlightPosition == nil then
		--print( "Position is null, calculating new pos" )
		local PotentialPositions = {}
		for _,vPos in pairs ( thisEntity.FlightPositions ) do
			local flDist = ( vPos - thisEntity:GetOrigin() ):Length2D()
			if flDist > ( FLIGHT_DISTANCE + 2000 ) then
				table.insert( PotentialPositions, vPos )
			end	
		end

		--print( #PotentialPositions )
		if #PotentialPositions == 0 then
			thisEntity.vFlightPosition = thisEntity.FlightPositions[RandomInt( 1, #thisEntity.FlightPositions )]
		else
			thisEntity.vFlightPosition = PotentialPositions[RandomInt( 1, #PotentialPositions)]
		end
	else
		local flDist = ( thisEntity.vFlightPosition - thisEntity:GetOrigin() ):Length2D()
		if flDist < 200 then
			if thisEntity.bLandPending == true then
				--print( "Landing" )
				return CastLand()
			end
			--print( "Reached flight target" )
			thisEntity.vFlightPosition = nil
			thisEntity.nCurrentFlybys = thisEntity.nCurrentFlybys + 1
			return 0.25
		else
			--print ( "Looking for enemies ")
			local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
			if #enemies ~= 0 and thisEntity.nCurrentFlybys > 0 then
				return CastFlyingShatterProjectile()
			end
		end
	end

	return Fly()
end

--------------------------------------------------------------------------------

function Fly()
	--print( "Flying to position" )
	--print( "thisEntity.vFlightPosition: ( " .. thisEntity.vFlightPosition.x .. ", " .. thisEntity.vFlightPosition.y .. ", " .. thisEntity.vFlightPosition.z .. ")"  )
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.vFlightPosition
	})
	return 0.25
end

--------------------------------------------------------------------------------

function CastFlyingShatterProjectile()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hFlyingShatterProjectile:entindex(),
		Queue = false,
	})
	return 0.33
end

--------------------------------------------------------------------------------

function GroundThink( enemies )
	if #enemies == 0 then
		return 0.25
	end

	if thisEntity:FindModifierByName( "modifier_ice_boss_land" ) ~= nil then
		return 0.25
	end 

	if thisEntity.bLandPending == true then
		thisEntity.bLandPending = false
		thisEntity.flNextTakeOffTime = GameRules:GetGameTime() + LAND_DURATION
		local nEggsToCreate = GetNumEggsToHatch() * 2
		while nEggsToCreate > 0 do
			if thisEntity.Nest ~= nil then
				CreateUnitByName( "npc_dota_creature_ice_boss_egg", thisEntity.Nest:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
			end
			nEggsToCreate = nEggsToCreate - 1
		end

		local nEggsToHatch = GetNumEggsToHatch()
		local eggs = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_FARTHEST, false )
		for _, egg in pairs( eggs ) do
			if egg ~= nil and egg:IsAlive() then
				local hBuff = egg:FindModifierByName( "modifier_ice_boss_egg_passive" )
				if hBuff ~= nil and hBuff.bHatching == false and nEggsToHatch > 0 then
					local ability = egg:FindAbilityByName( "ice_boss_egg_passive" )
					if ability ~= nil then
						ability:LaunchHatchProjectile( thisEntity )
						nEggsToHatch = nEggsToHatch - 1
					end
				end
			end
		end
	end

	if thisEntity.hWintersCurse ~= nil and thisEntity.hWintersCurse:IsFullyCastable() then
		return CastWintersCurse( enemies[RandomInt( 1, #enemies)] )
	end
	
	if thisEntity.hShatterProjectile ~= nil and thisEntity.hShatterProjectile:IsFullyCastable() then
		return CastShatterProjectile( enemies[#enemies]:GetOrigin() )
	end
	return 0.25
end

----------------------------------------------------------------------------------

function CastWintersCurse( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hWintersCurse:entindex(),
		Queue = false,
	})
	return 1.6
end

--------------------------------------------------------------------------------

function CastShatterProjectile( position )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = position,
		AbilityIndex = thisEntity.hShatterProjectile:entindex(),
		Queue = queue,
	})
	return 1.0
end
