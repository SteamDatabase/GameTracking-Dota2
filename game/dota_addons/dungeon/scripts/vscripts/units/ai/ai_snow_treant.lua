
--[[ units/ai/ai_snow_treant.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hInvisPop = thisEntity:FindAbilityByName( "snow_treant_invis_pop_stun" )
	thisEntity.hLivingArmor = thisEntity:FindAbilityByName( "snow_treant_living_armor" )
	thisEntity.hCallFriends = thisEntity:FindAbilityByName( "snow_treant_call_friends" )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_treant_natures_guise_invis", { cancelattack = false } )

	thisEntity:SetContextThink( "SnowTreantThink", SnowTreantThink, 0.5 )

	thisEntity.bInvisible = true
	thisEntity.nNumSpawns = 4
	thisEntity.bHasSpawned = false
end

--------------------------------------------------------------------------------

function SnowTreantThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end


	if thisEntity.bInvisible == true then
		return SnowTreantInvisThink()
	else
		return SnowTreantCombatThink()
	end
end

--------------------------------------------------------------------------------

function SnowTreantInvisThink()
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	-- print("treant - hello friend")
	thisEntity:RemoveModifierByNameAndCaster("modifier_treant_natures_guise_invis", thisEntity)

	thisEntity.bInvisible = false
	return PopInvis(hEnemies[1])
end

--------------------------------------------------------------------------------

function CastTreantSpawn()
	-- print("treant - spawning")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = thisEntity:GetOrigin(),
		AbilityIndex = thisEntity.hCallFriends:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function PopInvis( hEnemy )
	if hEnemy == nil or not hEnemy:IsAlive() then
		return
	end

	-- print("treant - casting invis pop")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = hEnemy:GetOrigin(),
		AbilityIndex = thisEntity.hInvisPop:entindex(),
		Queue = false,
	})

	return 3.0
end

--------------------------------------------------------------------------------

function CastHeal( )
	-- print("treant - healing")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:entindex(),
		AbilityIndex = thisEntity.hLivingArmor:entindex(),
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function SnowTreantCombatThink()
	-- print("treant - hulk smash")
	if not thisEntity.bHasSpawned then
		CastTreantSpawn()
		thisEntity.bHasSpawned = true
		return 5.0
	end

	if ( thisEntity.hLivingArmor:IsFullyCastable() and thisEntity:GetHealthPercent() < 20 ) then
		CastHeal()
	elseif ( thisEntity.hCallFriends:IsFullyCastable() ) then
		CastTreantSpawn()
	end
	return 2.0
end


