
--[[ units/ai/ai_exploding_burrower.lua ]]

----------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	hExplosionAbility = thisEntity:FindAbilityByName( "burrower_explosion" )
	hBurrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_burrow" )
	hUnburrowAbility = thisEntity:FindAbilityByName( "nyx_assassin_unburrow" )

	-- Start already burrowed
	thisEntity:AddNewModifier( thisEntity, nil, "modifier_nyx_assassin_burrow", { duration = -1 } )
	hUnburrowAbility:SetHidden( false )

	thisEntity:SetContextThink( "ExplodingNyxThink", ExplodingNyxThink, 0.5 )
end

----------------------------------------------------------------------------------------------

function ExplodingNyxThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local bIsBurrowed = ( thisEntity:FindModifierByName( "modifier_nyx_assassin_burrow" ) ~= nil )

	-- Is the assigned target our parent gave us dead?
	if thisEntity.hParentImpaleTarget and ( ( not thisEntity.hParentImpaleTarget:IsAlive() ) or thisEntity.hParentImpaleTarget:IsNull() ) then
		thisEntity.hParentImpaleTarget = nil
	end

	-- Is the assigned target our parent gave us an old assignment?
	if thisEntity.timeTargetAssigned and ( GameRules:GetGameTime() > ( thisEntity.timeTargetAssigned + 10 ) ) then
		thisEntity.hParentImpaleTarget = nil
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then	
		-- Don't let our mom get too far away from us
		if thisEntity.hParent ~= nil and ( not thisEntity.hParent:IsNull() ) and thisEntity.hParent:IsAlive() then
			local fDistToMom = ( thisEntity:GetOrigin() - thisEntity.hParent:GetOrigin() ):Length2D()
			if fDistToMom > 1000 then
				--print( "ExplodingBurrower - Mom is far away" )
				return RunToMom()
			end
		end

		local bParentIsSK = ( thisEntity.hParent ~= nil ) and ( not thisEntity.hParent:IsNull() ) and ( thisEntity.hParent:GetUnitName() == "npc_dota_creature_sand_king" )

		-- Burrow ourselves while we wait for enemies, but not if I work for sandking
		if ( not bParentIsSK ) and ( not bIsBurrowed ) and ( not thisEntity.hParentImpaleTarget ) and hBurrowAbility ~= nil and hBurrowAbility:IsCooldownReady() then
			return CastBurrow()
		end

		return 1
	end

	local hExplosionTarget = nil
	local hApproachTarget = nil

	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if bIsBurrowed then
				if flDist <= 600 then
					return CastUnburrow()
				end
			else
				if flDist <= 150 then
					hExplosionTarget = hEnemy
				end
				if flDist > 150 then
					hApproachTarget = hEnemy
				end
			end
		end
	end

	-- Has our parent given us an impale target to chase down?
	if hExplosionTarget == nil and thisEntity.hParentImpaleTarget and ( not thisEntity.hParentImpaleTarget:IsNull() ) then
		if bIsBurrowed then
			if hUnburrowAbility and hUnburrowAbility:IsFullyCastable() then
				return CastUnburrow()
			end
		else
			return Approach( thisEntity.hParentImpaleTarget )
		end
	end

	if hExplosionTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hExplosionTarget and hExplosionAbility and hExplosionAbility:IsCooldownReady() then
		return CastExplosion()
	end

	if hExplosionTarget then
		thisEntity:FaceTowards( hExplosionTarget:GetOrigin() )
	end

	return 0.5
end

----------------------------------------------------------------------------------------------

function CastBurrow()
	--print( "ExplodingBurrower - CastBurrow()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hBurrowAbility:entindex(),
	})
	return 2
end

----------------------------------------------------------------------------------------------

function CastUnburrow()
	--print( "ExplodingBurrower - CastUnburrow()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hUnburrowAbility:entindex(),
	})
	return 0.3
end

----------------------------------------------------------------------------------------------

function CastExplosion()
	--print( "ExplodingBurrower - CastExplosion()" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hExplosionAbility:entindex(),
		Queue = false,
	})
	return 1
end

----------------------------------------------------------------------------------------------

function Approach( unit )
	--print( "ExplodingBurrower - Approach()" )
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 0.4
end

----------------------------------------------------------------------------------------------

function RunToMom()
	--print( "ExplodingBurrower - RunToMom()" )

	if hUnburrowAbility and hUnburrowAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hUnburrowAbility:entindex(),
		})
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.hParent:GetOrigin(),
		Queue = true,
	})
	return 1
end

----------------------------------------------------------------------------------------------

