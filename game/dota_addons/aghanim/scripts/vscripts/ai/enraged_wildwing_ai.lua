function Precache( context )

	PrecacheUnitByNameSync( "npc_aghsfort_creature_tornado_harpy", context, -1 )

end



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.TornadoAbility = thisEntity:FindAbilityByName( "enraged_wildwing_create_tornado" )
	thisEntity.BlastAbility = thisEntity:FindAbilityByName( "aghsfort_enraged_wildwing_tornado_blast" )
	thisEntity.flLastOrder = GameRules:GetGameTime()
	thisEntity.bHasSummonedTornado = false

	thisEntity:SetContextThink( "EnragedWildwingThink", EnragedWildwingThink, 1 )


end




function EnragedWildwingThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.TornadoAbility ~= true and thisEntity.TornadoAbility:IsFullyCastable() and thisEntity.bHasSummonedTornado == false then
		thisEntity.bHasSummonedTornado = true
		--return CastTornadoAbility()
	end


	if (GameRules:GetGameTime() - thisEntity.flLastOrder) > (20 - RandomFloat(0 ,5 )) then
		thisEntity.flLastOrder = GameRules:GetGameTime()
		return DoMove()	
	end


	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #hEnemies == 0 then

		return 0.5
	end


	if thisEntity.BlastAbility ~= nil and thisEntity.BlastAbility:IsFullyCastable() then
		
		return CastBlastAbility( hEnemies[ #hEnemies ] )
	end

	return 0.5
end


function CastTornadoAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.TornadoAbility:entindex(),
		Queue = true,
	})
	
	return 0.2
end

--------------------------------------------------------------------------------

function CastBlastAbility( enemy )
	local vToTarget = enemy:GetOrigin() - thisEntity:GetOrigin()
	vToTarget = vToTarget:Normalized()
	local vTargetPos = thisEntity:GetOrigin() + vToTarget * 50

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.BlastAbility:entindex(),
		Position = vTargetPos,
		Queue = false,
	})

	return 4
end



function DoMove()
	if IsServer() then

		for i=1,4 do
			local vLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 1000, 2000 )

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
	return 4
end	
