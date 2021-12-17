--[[ Leshrac AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hSplitEarthAbility = thisEntity:FindAbilityByName( "aghslab_leshrac_split_earth" )
	thisEntity.hEdictAbility = thisEntity:FindAbilityByName( "leshrac_diabolic_edict" )

	thisEntity.flRetreatRange = 500
	thisEntity.flAttackRange = 600
	thisEntity.flSplitEarthDelayTime = GameRules:GetGameTime() + RandomFloat( 8, 12 )	-- need to live for this long before we can think about casting Split Earth
	thisEntity.PreviousOrder = "no_order"

	thisEntity:SetContextThink( "LeshracThink", LeshracThink, 0.5 )
end

--------------------------------------------------------------------------------

function LeshracThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		local hTowers = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #hTowers > 0 then
			local hTower = hTowers[1]
			local fDist = ( hTower:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if fDist < 500 then
				return CastEdict()
			end
			return TargetEnemy( hTower )
		end
		return HoldPosition()
	end

	local bSplitEarthReady = false
	if GameRules:GetGameTime() > thisEntity.flSplitEarthDelayTime and thisEntity.hSplitEarthAbility ~= nil and thisEntity.hSplitEarthAbility:IsFullyCastable() then
		--print( 'Split Earth ready' )
		bSplitEarthReady = true
	end	

	-- grab the closest enemy from our list, but if our disruption is ready make sure we skip over the target if it is stunned
	local hStunnedEnemy = nil
	for _, hEnemy in pairs( hEnemies ) do
		if hEnemy ~= nil and hEnemy:IsAlive() then
			if bSplitEarthReady == true then
				local hStunModifier = hEnemy:FindModifierByName( "modifier_stunned" )
				if hStunModifier then
					print( 'skipping over the stunned enemy as our potential target' )
					hStunnedEnemy = hEnemy
					goto continue
				else
					if thisEntity.PreviousOrder ~= nil and thisEntity.PreviousOrder ~= "split_earth" then
						local target = hEnemies[ #hEnemies ]
						return CastSplitEarth( hEnemy )
					end
				end
			end

			-- ATTACK/APPROACH target
			return TargetEnemy( hEnemy )
		end

		::continue::
	end

	-- if we're still here then the stunned enemy is the only one that could be a target
	if hStunnedEnemy ~= nil then
		-- ATTACK/APPROACH stunned enemy
		return TargetEnemy( hStunnedEnemy )
	end

	return 0.5
end

--------------------------------------------------------------------------------

function TargetEnemy( hEnemy )
	local hAttackTarget = nil
	local hApproachTarget = nil

	local flDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	if flDist < thisEntity.flRetreatRange then
		if ( thisEntity.fTimeOfLastRetreat and ( GameRules:GetGameTime() < thisEntity.fTimeOfLastRetreat + 3 ) ) then
			-- We already retreated recently, so just attack
			hAttackTarget = hEnemy
		else
			return Retreat( hEnemy )
		end
	end

	if flDist <= thisEntity.flAttackRange then
		hAttackTarget = hEnemy
	end
	if flDist > thisEntity.flAttackRange then
		hApproachTarget = hEnemy
	end

	if hAttackTarget == nil and hApproachTarget ~= nil then
		return Approach( hApproachTarget )
	end

	if hAttackTarget then
		thisEntity:FaceTowards( hAttackTarget:GetOrigin() )
		--return HoldPosition()
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastSplitEarth( hEnemy )
	--print( "Leshrac - CastSplitEarth" )

	local fDist = ( hEnemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
	local vTargetPos = hEnemy:GetOrigin() + RandomVector( 100 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.hSplitEarthAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "split_earth"

	return 1
end

--------------------------------------------------------------------------------

function CastEdict()
	--print( "Leshrac - CastEdict" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hEdictAbility:entindex(),
		Queue = false,
	})

	thisEntity.PreviousOrder = "edict"

	return 1
end

--------------------------------------------------------------------------------

function Approach(unit)
	--print( "Leshrac - Approach" )

	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})

	thisEntity.PreviousOrder = "approach"

	return 1
end

--------------------------------------------------------------------------------

function Retreat(unit)
	--print( "Leshrac - Retreat" )
	local objectives = Entities:FindAllByName( "objective" )
	if #objectives > 0 then
		local hObjective = objectives[1]
		local vObjective = hObjective:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vObjective
		})
	end		

	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	thisEntity.PreviousOrder = "retreat"

	return 1.25
end

--------------------------------------------------------------------------------

function HoldPosition()
	--print( "Leshrac - Hold Position" )
	if thisEntity.PreviousOrder == "hold_position" then
		return 0.5
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_HOLD_POSITION,
		Position = thisEntity:GetOrigin()
	})

	thisEntity.PreviousOrder = "hold_position"

	return 0.5
end

--------------------------------------------------------------------------------