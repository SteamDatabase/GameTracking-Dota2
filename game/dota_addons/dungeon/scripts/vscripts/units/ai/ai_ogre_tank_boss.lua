
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	SmashAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_melee_smash" )
	JumpAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_jump_smash" )

	thisEntity:SetContextThink( "OgreTankBossThink", OgreTankBossThink, 1 )
end

function OgreTankBossThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.bStarted == false then
		return 0.1
	else
		thisEntity:RemoveModifierByName( "modifier_invulnerable" )
		print( "removed invuln modifier from ogre boss" )
	end

	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	for i = 1, #enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 300 then
				nEnemiesRemoved = nEnemiesRemoved + 1
				table.remove( enemies, i )
			end
		end
	end

	if JumpAbility ~= nil and JumpAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
		return Jump()
	end

	if #enemies == 0 then
		-- @todo: Could check whether there are ogre magi nearby that I should be positioning myself next to.  Either that or have the magi come to me.
		return 1
	end

	if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
		return Smash( enemies[ 1 ] )
	end
	
	return 0.5
end


function Jump()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = JumpAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end


function Smash( enemy )
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
		AbilityIndex = SmashAbility:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})

	return 3 / thisEntity:GetHasteFactor()
end

