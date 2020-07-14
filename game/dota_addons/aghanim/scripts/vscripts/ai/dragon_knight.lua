
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.fMaxSearchRange = 1000

	thisEntity.hDragonTailAbility = thisEntity:FindAbilityByName( "aghsfort_dragon_knight_dragon_tail" )
	thisEntity.hDragonFormAbility = thisEntity:FindAbilityByName( "aghsfort_dragon_knight_elder_dragon_form" )

	thisEntity:SetContextThink( "DragonKnightThink", DragonKnightThink, 0.5 )
end

--------------------------------------------------------------------------------

function DragonKnightThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	--[[
	if not thisEntity.bInitialized then
		for i = 0, DOTA_ITEM_MAX - 1 do
			local item = thisEntity:GetItemInSlot( i )
			if item and item:GetAbilityName() == "item_creature_black_king_bar" then
				thisEntity.bkbAbility = item
			end
		end

		thisEntity.bInitialized = true
	end
	]]

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fMaxSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.25
	end

	local fHealthPctToDragon = 50
	if thisEntity:GetHealthPercent() < fHealthPctToDragon and thisEntity.hDragonFormAbility and thisEntity.hDragonFormAbility:IsFullyCastable() then
		return CastDragonForm()
	end

	--[[
	local fHealthPctToBKB = 30
	if thisEntity:GetHealthPercent() < fHealthPctToBKB and thisEntity.bkbAbility and thisEntity.bkbAbility:IsFullyCastable() then
		return CastBKB()
	end
	]]

	local fTailSearchRange = thisEntity.hDragonTailAbility:GetCastRange()
	local hTailEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fTailSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hTailEnemies == 0 then
		return 0.25
	end

	local fHealthPctToTail = 90
	if thisEntity:GetHealthPercent() < fHealthPctToTail and thisEntity.hDragonTailAbility and thisEntity.hDragonTailAbility:IsFullyCastable() then
		local hRandomTailTarget = hTailEnemies[ RandomInt( 1, #hTailEnemies ) ]
		return CastDragonTail( hRandomTailTarget )
	end

	return 0.25
end

--------------------------------------------------------------------------------

function CastDragonTail( hTarget )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = thisEntity.hDragonTailAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------

function CastDragonForm()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hDragonFormAbility:entindex(),
		Queue = false,
	})

	return 0.5
end

--------------------------------------------------------------------------------

--[[
function CastBKB()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.bkbAbility:entindex()
	})

	return 0.5
end
]]

--------------------------------------------------------------------------------
