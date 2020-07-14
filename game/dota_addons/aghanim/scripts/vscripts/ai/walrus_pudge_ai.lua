


function Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", context )
end



function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end


	HookAbility = thisEntity:FindAbilityByName( "aghsfort_walrus_pudge_harpoon" )
	flLastOrder = GameRules:GetGameTime()
	thisEntity:SetContextThink( "WalrusPudgeThink", WalrusPudgeThink, 1 )
end




function WalrusPudgeThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not  thisEntity:GetAggroTarget() then
		if (GameRules:GetGameTime() - flLastOrder) > (4 - RandomFloat(0 ,1 )) then
			flLastOrder = GameRules:GetGameTime()
			return DoMove()	
		end
	end


	if HookAbility and HookAbility:IsFullyCastable() then
		local fHookSearchRadius = HookAbility:GetCastRange() 
		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, fHookSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false )
		if #hEnemies > 0 then
			local hFarthestEnemy = hEnemies[ 1 ]
			return ThrowHook( hFarthestEnemy )
		end
	end

	return 0.5
end


function ThrowHook( enemy )
	if ( not thisEntity:HasModifier( "modifier_provide_vision" ) ) then
		--print( "If player can't see me, provide brief vision to his team as I start my hook" )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_provide_vision", { duration = 1.5 } )
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = HookAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 0.2

end


function DoMove()
	if IsServer() then

		for i=1,4 do
			local vLoc = FindPathablePositionNearby(thisEntity:GetAbsOrigin(), 200, 800 )

			if GameRules.Aghanim:GetCurrentRoom():IsInRoomBounds( vLoc ) then

				ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = vLoc
				})
				break
			end
		end
	end
	return 0.5
end	
