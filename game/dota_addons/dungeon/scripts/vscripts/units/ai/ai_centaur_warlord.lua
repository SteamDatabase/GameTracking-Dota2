
--[[ units/ai/ai_centaur_warlord.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hHoofStompAbility = thisEntity:FindAbilityByName( "centaur_warlord_hoof_stomp" )
	thisEntity.hDoubleEdgeAbility = thisEntity:FindAbilityByName( "centaur_warlord_double_edge" )
	thisEntity.hStampedeAbility = thisEntity:FindAbilityByName( "centaur_warlord_stampede" )

	thisEntity:SetContextThink( "CentaurWarlordThink", CentaurWarlordThink, 0.5 )
end

--------------------------------------------------------------------------------

function CentaurWarlordThink()
	if not IsServer() then
		return
	end

	-- Search for items here instead of in Spawn, because they don't seem to exist yet when Spawn runs
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 0.5
	end

	-- @fixme: need to check if we have an enemy within 550 radius
	if thisEntity.hHoofStompAbility ~= nil and thisEntity.hHoofStompAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 80 ) then
			return CastHoofStomp()
		end
	end

	if thisEntity.hDoubleEdgeAbility ~= nil and thisEntity.hDoubleEdgeAbility:IsFullyCastable() then
		return CastDoubleEdge( hEnemies[ RandomInt( 1, #hEnemies ) ] )
	end

	--[[
	if thisEntity.hStampedeAbility ~= nil and thisEntity.hStampedeAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 50 ) then
			return CastStampede()
		end
	end
	]]

	--[[
	local hAggroTarget = thisEntity:GetAggroTarget()
	local fDistToAggroTarget = nil
	if hAggroTarget then
		fDistToAggroTarget = ( hAggroTarget:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	end
	]]

	-- Blademail
	if ( #hEnemies >= 1 ) and thisEntity.hBlademailAbility and thisEntity.hBlademailAbility:IsFullyCastable() then
		if ( thisEntity:GetHealthPercent() < 75 ) then
			return UseBlademail()
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_blade_mail" then
				thisEntity.hBlademailAbility = item
			end
		end
	end
end

--------------------------------------------------------------------------------

function CastHoofStomp()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hHoofStompAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

function CastDoubleEdge( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.hDoubleEdgeAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

function CastStampede()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hStampedeAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

function UseBlademail()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBlademailAbility:entindex(),
		Queue = false,
	})
	return 2
end

--------------------------------------------------------------------------------

