

function Precache( context )
	PrecacheUnitByNameSync( "npc_aghsfort_creature_wave_blaster_ghost", context, -1 )
	PrecacheResource( "particle", "particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf", context )
end


function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hWaveAbility = thisEntity:FindAbilityByName( "aghsfort_wave_blast" )
	thisEntity.hLeapAbility = thisEntity:FindAbilityByName( "aghsfort_waveblaster_leap" )
	thisEntity.hSummonGhostAbility = thisEntity:FindAbilityByName( "aghsfort_waveblaster_summon_ghost" )
	thisEntity:SetContextThink( "WaveBlasterThink", WaveBlasterThink, 1 )

end

function WaveBlasterThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	--print ("thinking")
	
	if GameRules:IsGamePaused() == true then
		return 1
	end


	if thisEntity.hWaveAbility and thisEntity.hWaveAbility:IsFullyCastable() then
		local fWaveSearchRadius = thisEntity.hWaveAbility:GetCastRange() 
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fWaveSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )
		if #hEnemies > 0 then
			local hFarthestEnemy = hEnemies[ 1 ]
			return WaveBlast( hFarthestEnemy )
		end
	end

	if thisEntity.hLeapAbility and thisEntity.hLeapAbility:IsFullyCastable() then
		local fSearchRadius = 750
		local hEnemiesToAvoid = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		if #hEnemiesToAvoid > 0 then
			return CastLeap()
		end
	end

	
	return 0.5
end

function WaveBlast( enemy )
	if enemy == nil then
		return
	end

	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		--print( "If player can't see me, provide brief vision to his team as I start my Smash" )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hWaveAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 0.2
end

--------------------------------------------------------------------------------

function CastLeap()
	if IsServer() then 
		local bLeapSuccess = false
		for i=1,6 do
			local vLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 650, 1550 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

				ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = thisEntity.hLeapAbility:entindex(),
				Position = vLoc,
				Queue = false,
				})
				bLeapSuccess = true
				break
			end
		end	
		
		if bLeapSuccess == true and thisEntity.hSummonGhostAbility and thisEntity.hSummonGhostAbility:IsFullyCastable() then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.hSummonGhostAbility:entindex(),
				Queue = false,
			})
		end
	end
	return 3
end
