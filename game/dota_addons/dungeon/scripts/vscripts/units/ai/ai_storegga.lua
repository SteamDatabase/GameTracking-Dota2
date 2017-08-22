function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	SlamAbility = thisEntity:FindAbilityByName( "storegga_arm_slam" )
	GrabAbility = thisEntity:FindAbilityByName( "storegga_grab" )
	ThrowAbility = thisEntity:FindAbilityByName( "storegga_grab_throw" )
	AvalancheAbility = thisEntity:FindAbilityByName( "storegga_avalanche" )

	thisEntity.flThrowTimer = 0.0

	thisEntity:SetContextThink( "StoreggaThink", StoreggaThink, 1 )
end

function StoreggaThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity.bStarted == false then
		return 0.1
	elseif ( not thisEntity.bInitialInvulnRemoved ) then
		thisEntity:RemoveModifierByName( "modifier_invulnerable" )
		--print( "removed invuln modifier from Storegga boss" )
		thisEntity.bInitialInvulnRemoved = true
	end

	if thisEntity:IsChanneling() then
		return 1
	end

	if thisEntity:FindModifierByName( "modifier_boss_intro" ) ~= nil then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
	local rocks = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )

	local nEnemiesAlive = 0
	for i=1,#enemies do
		local enemy = enemies[i]
		if enemy ~= nil then
			if enemy:IsRealHero() and enemy:IsAlive() then
				nEnemiesAlive = nEnemiesAlive + 1
				if enemy:FindModifierByName( "modifier_storegga_grabbed_debuff" ) ~= nil then
					table.remove( enemies, i )
				end
			end
		end
	end

	if AvalancheAbility ~= nil and AvalancheAbility:IsFullyCastable() and thisEntity:GetHealthPercent() < 50 then
		return CastAvalanche()
	end

	local hGrabbedEnemyBuff = thisEntity:FindModifierByName( "modifier_storegga_grabbed_buff" )
	local hGrabbedTarget = nil
	if hGrabbedEnemyBuff == nil then
		if GrabAbility ~= nil and GrabAbility:IsFullyCastable() and enemies[1] ~= nil and rocks[1] ~= nil then
			if nEnemiesAlive > 1 and RandomInt( 0, 1 ) == 0 then
				return CastGrab( enemies[1] )
			else
				return CastGrab( rocks[ RandomInt( 1, #rocks ) ] )
			end
		end
	else
		local hGrabbedTarget = hGrabbedEnemyBuff.hThrowObject
		if GameRules:GetGameTime() > thisEntity.flThrowTimer and hGrabbedTarget ~= nil then
			if ThrowAbility ~= nil and ThrowAbility:IsFullyCastable() then
				if #enemies > 0 then
					if enemies[#enemies] ~= nil then
						return CastThrow( enemies[#enemies]:GetOrigin() )
					end
				else
					if rocks[#rocks] ~= nil then
						return CastThrow( rocks[#rocks]:GetOrigin() )
					end
				end	
			end
		end
	end

	if SlamAbility ~= nil and SlamAbility:IsFullyCastable() then
		if RandomInt( 0, 1 ) == 1 then
			return CastSlam( enemies[1] )
		else
			return CastSlam( enemies[#enemies] )
		end							
	end
	
	return 0.5
end


function CastSlam( enemy )
	if enemy == nil then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = SlamAbility:entindex(),
	})
	return 1.2
end

function CastGrab( enemy )
	if enemy == nil then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = GrabAbility:entindex(),
	})
	return 1.5
end

function CastThrow( vPos )
	local vDir = vPos - thisEntity:GetOrigin()
	local flDist = vDir:Length2D()
	vDir.z = 0.0
	vDir = vDir:Normalized()

	flDist = math.max( 200, flDist - 200 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = thisEntity:GetOrigin() + vDir * flDist,
		AbilityIndex = ThrowAbility:entindex(),
		Queue = false,
	})
	return 1.5
end

function CastAvalanche()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = AvalancheAbility:entindex(),
		Queue = false,
	})
	return 11
end