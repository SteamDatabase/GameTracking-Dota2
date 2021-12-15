
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_melee_smash" )
	JumpAbility = thisEntity:FindAbilityByName( "ogre_tank_boss_jump_smash" )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_attack_speed_unslowable", { attack_speed_reduction_pct = 0 } )
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_move_speed_unslowable", { move_speed_reduction_pct = 20 } )

	thisEntity:SetContextThink( "OgreTankBossThink", OgreTankBossThink, 1 )
end

--------------------------------------------------------------------------------

function OgreTankBossThink()
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

	local hWintersCurseBuff = thisEntity:FindModifierByName( "modifier_aghsfort_winter_wyvern_winters_curse" )
	if hWintersCurseBuff and hWintersCurseBuff:GetAuraOwner() ~= nil then
		if SmashAbility ~= nil and SmashAbility:IsCooldownReady() then
			return Smash( hWintersCurseBuff:GetAuraOwner() )
		end
		return 0.1
	end

	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
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
		return 0.5
	end

	if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
		return Smash( enemies[ 1 ] )
	end
	
	return 0.5
end

--------------------------------------------------------------------------------

function Jump()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = JumpAbility:entindex(),
		Queue = false,
	})
	
	return 2.5
end

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
