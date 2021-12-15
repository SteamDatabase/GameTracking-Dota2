


--------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.bHasRun = false
	thisEntity.hImprisonment = thisEntity:FindAbilityByName( "aghsfort_obsidian_destroyer_astral_imprisonment" )
	thisEntity.hArcaneOrb = thisEntity:FindAbilityByName( "aghsfort_obsidian_destroyer_arcane_orb_linear" )
	thisEntity.hImprisonedEnemy = nil
	thisEntity.hAttemptedPrisonTarget = nil
	thisEntity.nAbilityListener1 = ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnNonPlayerUsedAbility' ), nil )
	thisEntity.nAbilityListener2 = ListenToGameEvent( "dota_non_player_used_ability", Dynamic_Wrap( thisEntity:GetPrivateScriptScope(), 'OnNonPlayerUsedAbility' ), nil )
	thisEntity.flTimeToMeteorHammer = -1
	thisEntity:SetContextThink( "ODThink", ODThink, 0.1 )
end


--------------------------------------------------------------------------------------------------------

function UpdateOnRemove()
	StopListeningToGameEvent( thisEntity.nAbilityListener1 )
	StopListeningToGameEvent( thisEntity.nAbilityListener2 )
end

--------------------------------------------------------------------------------------------------------

function OnNonPlayerUsedAbility( event )
	local hCaster = nil
	if event.caster_entindex ~= nil and event.abilityname ~= nil then
		hCaster = EntIndexToHScript( event.caster_entindex )
		if hCaster == thisEntity then 
			if event.abilityname == "aghsfort_obsidian_destroyer_astral_imprisonment" then
				thisEntity.hImprisonedEnemy = thisEntity.hAttemptedPrisonTarget
				thisEntity.flTimeToMeteorHammer = GameRules:GetGameTime() + thisEntity.hImprisonment:GetSpecialValueFor( "prison_duration" ) - thisEntity.hMeteorHammer:GetChannelTime() + RandomFloat( -0.1, 0.1 )
				if thisEntity.hImprisonedEnemy then 
					print( "Imprisoned " .. thisEntity.hImprisonedEnemy:GetUnitName() .. ", going to meteor hammer in " .. thisEntity.flTimeToMeteorHammer - GameRules:GetGameTime() )
				end
			end
			if event.abilityname == "item_od_encounter_meteor_hammer" then
				thisEntity.hImprisonedEnemy = nil
				thisEntity.hAttemptedPrisonTarget = nil
				thisEntity.flTimeToMeteorHammer = -1
			end
			if event.abilityname == "aghsfort_obsidian_destroyer_arcane_orb_linear" then 
				thisEntity.hImprisonment:StartCooldown( 4.0 )
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------

function ODThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity:IsChanneling() then
		return 0.1
	end


	if thisEntity.hMeteorHammer == nil then
		for j = 0,DOTA_ITEM_INVENTORY_SIZE-1 do
			local hItem = thisEntity:GetItemInSlot( j )
			if hItem and hItem:GetAbilityName() == "item_od_encounter_meteor_hammer" then
				thisEntity.hMeteorHammer = hItem
				break
			end
		end
	end

	if thisEntity.hImprisonedEnemy ~= nil then 
		if thisEntity.hImprisonedEnemy:FindModifierByName( "modifier_obsidian_destroyer_astral_imprisonment_prison" ) == nil then 
			thisEntity.hImprisonedEnemy = nil
			thisEntity.hAttemptedPrisonTarget = nil
			thisEntity.flTimeToMeteorHammer = -1
		else
			if thisEntity.flTimeToMeteorHammer ~= -1 and GameRules:GetGameTime() > thisEntity.flTimeToMeteorHammer and thisEntity.hMeteorHammer:IsFullyCastable() then 
				return MeteorHammer( thisEntity.hImprisonedEnemy:GetAbsOrigin() )
			end
		end
	end

	local nSearchRadius = 1500
	if thisEntity.bHasRun then 
		nSearchRadius = 4000
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.1
	end

	if thisEntity.hArcaneOrb and thisEntity.hArcaneOrb:IsFullyCastable() then 
		return ArcaneOrb( enemies[ RandomInt( 1, #enemies ) ] )
	end

	if thisEntity.hImprisonment and thisEntity.hImprisonment:IsFullyCastable() then 
		return Imprison( enemies[ 1 ] )
	end

	if thisEntity.flTimeToMeteorHammer == -1 then 
		local vEnemyPos = nil 
		for _, enemy in pairs ( enemies ) do
			if vEnemyPos == nil then 
				vEnemyPos = enemy:GetAbsOrigin() 
			else
				vEnemyPos = vEnemyPos + enemy:GetAbsOrigin()
			end
		end

		vEnemyPos = vEnemyPos / #enemies 

		local vToEnemies = thisEntity:GetAbsOrigin() - vEnemyPos
		vToEnemies = vToEnemies:Normalized()

		local vRunToPos = thisEntity:GetAbsOrigin() + vToEnemies * RandomInt( 1500, 3000 )
		if thisEntity.Encounter and thisEntity.Encounter:GetRoom() then 
			print( "Od running; clamping location to room bounds" )
			vRunToPos = thisEntity.Encounter:GetRoom():ClampPointToRoomBounds( vRunToPos, 128.0 )
		end
		thisEntity.bHasRun = true
		return Run( vRunToPos )
	end

	return 0.1
end

--------------------------------------------------------------------------------------------------------

function ArcaneOrb( enemy )
	if enemy == nil then 
		return 0.1
	end 

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hArcaneOrb:entindex(),
		Position = enemy:GetAbsOrigin(),
		Queue = false,
	})

	return 0.1
end

--------------------------------------------------------------------------------------------------------

function MeteorHammer( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hMeteorHammer:entindex(),
		Position = vPos,
		Queue = false,
	})

	return 0.1
end

--------------------------------------------------------------------------------------------------------

function Imprison( enemy )
	if enemy == nil then
		return 0.1
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hImprisonment:entindex(),
		TargetIndex  = enemy:entindex(),
		Queue = false,
	})

	thisEntity.hAttemptedPrisonTarget = enemy

	return thisEntity.hImprisonment:GetCastPoint() + 0.1
end

--------------------------------------------------------------------------------------------------------

function Run( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos, 
		Queue = false,
	})


	return RandomFloat( 2.0, 3.0 )
end
