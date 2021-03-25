require( "ai/ai_laning" )

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SFEconomyThink", SFEconomyThink, 0.25 )	
		--thisEntity.LaningAI = CDotaAILaning( LAST_HIT_AI_SKILL.EASY, LAST_HIT_AI_TYPE.LAST_HIT_FOCUSED, thisEntity )
		--thisEntity.LaningAI:SetLastHitHoverRange( 100.0 + thisEntity:Script_GetAttackRange() )
		
		local AbilityLearnOrder = {}
		AbilityLearnOrder[1] = "nevermore_necromastery"
		AbilityLearnOrder[2] = "nevermore_shadowraze3"
		AbilityLearnOrder[3] = "nevermore_necromastery"
		AbilityLearnOrder[4] = "nevermore_shadowraze3"
		AbilityLearnOrder[5] = "nevermore_shadowraze3"
		AbilityLearnOrder[6] = "nevermore_necromastery"
		--thisEntity.LaningAI:SetAbilityLearnOrder( AbilityLearnOrder )

		thisEntity.Raze1 = thisEntity:FindAbilityByName( "nevermore_shadowraze1" )
		thisEntity.Raze2 = thisEntity:FindAbilityByName( "nevermore_shadowraze2" )
		thisEntity.Raze3 = thisEntity:FindAbilityByName( "nevermore_shadowraze3" )
		--thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze1", Shadowraze1 )
		--thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze2", Shadowraze2 )
		--thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze3", Shadowraze3 )

		thisEntity.Raze1Targets = {}
		thisEntity.Raze2Targets = {}
		thisEntity.Raze3Targets = {}

		thisEntity.Requiem = thisEntity:FindAbilityByName( "nevermore_requiem" )

		thisEntity.bReturnedHome = false
		thisEntity.bAttackTower = false
		thisEntity.hSpawnEnt = FindSpawnEntityForTeam( DOTA_TEAM_BADGUYS )
		thisEntity.vHomePosition = thisEntity.hSpawnEnt:GetAbsOrigin()
		thisEntity.bHasPickedUpRune = false
	end
end

-----------------------------------------------------------------------------------------------------

function SFEconomyThink()
	if IsServer() == false then
		return -1
	end

	if GameRules:IsGamePaused() then
		return 0.1
	end

	if thisEntity == nil or thisEntity:IsNull() then
		return -1
	end

	if thisEntity:GetUnitName() ~= "npc_dota_hero_nevermore" then
		return -1
	end

	if thisEntity.bHasPickedUpRune == false then
		local hRune = Entities:FindByClassname( nil, "dota_item_rune" )
		if hRune then
			ExecuteOrderFromTable( {
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_PICKUP_RUNE,
				TargetIndex = hRune:entindex()
			} )
		else
			thisEntity.bHasPickedUpRune = true
		end

		return 0.25
	end

	if thisEntity.bAttackTower then
		local hT1BotTower = Entities:FindByName( nil, "dota_goodguys_tower1_bot" )
		if hT1BotTower == nil then
			print( "ERROR! Unable to find t1 tower?" )
			return
		end

		local NecroBuff = thisEntity:FindModifierByName( "modifier_nevermore_necromastery" )
		if NecroBuff then
			NecroBuff:SetStackCount( 2 )
		end

		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = hT1BotTower:GetAbsOrigin(), 
		})
		return 1
	end

	if PlayerResource:GetKills( thisEntity:GetPlayerOwnerID() ) >= 1 and thisEntity:GetAggroTarget() == nil and thisEntity:GetAbsOrigin() ~= thisEntity.vHomePosition then
		
		if thisEntity.hSpawnEnt then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = thisEntity.hSpawnEnt:GetAbsOrigin(), 
			})
		end
	else
		if thisEntity.Requiem ~= nil and thisEntity.bReturnedHome == false then
			local NecroBuff = thisEntity:FindModifierByName( "modifier_nevermore_necromastery" )
			if NecroBuff then
				NecroBuff:SetStackCount( 32 )
			end
			if thisEntity.Requiem:IsFullyCastable() then
				ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = thisEntity.Requiem:entindex(),
			})
			else
				local hHeroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), thisEntity, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
				if #hHeroes > 0 then
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = hHeroes[1]:entindex(),
					})
				end
			end
		end
	end

	return 0.1
	--return thisEntity.LaningAI:DoLaning()
end

-----------------------------------------------------------------------------------------------------

function RebuildRazeTargets()
	thisEntity.Raze1Targets = {}
	thisEntity.Raze2Targets = {}
	thisEntity.Raze3Targets = {}

	local flRazeDamage = thisEntity.Raze1:GetSpecialValueFor( "shadowraze_damage" ) * 1.33 -- buffer
	local nRazeRadius = thisEntity.Raze1:GetSpecialValueFor( "shadowraze_radius" )

	local nRaze1Range = thisEntity.Raze1:GetSpecialValueFor( "shadowraze_range" )
	local nRaze2Range = thisEntity.Raze2:GetSpecialValueFor( "shadowraze_range" )
	local nRaze3Range = thisEntity.Raze3:GetSpecialValueFor( "shadowraze_range" )

	for _,Hero in pairs( thisEntity.LaningAI.Heroes ) do
		if Hero and Hero:GetTeamNumber() ~= thisEntity:GetTeamNumber() then
			local flDistToMe = (thisEntity:GetAbsOrigin() - Hero:GetAbsOrigin()):Length2D()
			
			if flDistToMe > ( nRaze1Range- nRazeRadius ) and flDistToMe < ( nRaze1Range + nRazeRadius ) then
				table.insert( thisEntity.Raze1Targets, Hero )
			end

			if flDistToMe > ( nRaze2Range - nRazeRadius ) and flDistToMe < ( nRaze2Range + nRazeRadius ) then
				table.insert( thisEntity.Raze2Targets, Hero )
			end

			if flDistToMe > ( nRaze3Range - nRazeRadius ) and flDistToMe < ( nRaze3Range + nRazeRadius ) then
				table.insert( thisEntity.Raze3Targets, Hero )
			end
		end
	end

	for _,Creep in pairs ( thisEntity.LaningAI.Creeps ) do
		if Creep:GetTeamNumber() ~= thisEntity:GetTeamNumber() and Creep:GetHealth() < flRazeDamage then
			local flDistToMe = (thisEntity:GetAbsOrigin() - Creep:GetAbsOrigin()):Length2D()
			
			if flDistToMe > ( nRaze1Range- nRazeRadius ) and flDistToMe < ( nRaze1Range + nRazeRadius ) then
				table.insert( thisEntity.Raze1Targets, Creep )
			end

			if flDistToMe > ( nRaze2Range - nRazeRadius ) and flDistToMe < ( nRaze2Range + nRazeRadius ) then
				table.insert( thisEntity.Raze2Targets, Creep )
			end

			if flDistToMe > ( nRaze3Range - nRazeRadius ) and flDistToMe < ( nRaze3Range + nRazeRadius ) then
				table.insert( thisEntity.Raze3Targets, Creep )
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------

function GetRazePosition( szRazeName )
	local nEnemiesTogether = 0
	local vRazePos = Vector( 0, 0, 0 )
	if szRazeName == "nevermore_shadowraze1" then
		for _,Enemy in pairs ( thisEntity.Raze1Targets ) do
			nEnemiesTogether = nEnemiesTogether + 1
			vRazePos = vRazePos + Enemy:GetAbsOrigin() 
		end
	end
	if szRazeName == "nevermore_shadowraze2" then
		for _,Enemy in pairs ( thisEntity.Raze2Targets ) do
			nEnemiesTogether = nEnemiesTogether + 1
			vRazePos = vRazePos + Enemy:GetAbsOrigin() 
		end
	end
	if szRazeName == "nevermore_shadowraze3" then
		for _,Enemy in pairs ( thisEntity.Raze3Targets ) do
			nEnemiesTogether = nEnemiesTogether + 1
			vRazePos = vRazePos + Enemy:GetAbsOrigin() 
		end
	end


	if nEnemiesTogether < 2 then
		return Vector( 0, 0, 0 )
	end

	vRazePos = vRazePos / nEnemiesTogether

	return vRazePos
end

-----------------------------------------------------------------------------------------------------

function Shadowraze( hRaze )
	if hRaze == nil or hRaze:IsFullyCastable() == false then
		return -1
	end

	RebuildRazeTargets()

	local vRazePos = GetRazePosition( hRaze:GetAbilityName() )
	if vRazePos == Vector( 0, 0, 0 ) then
		return -1
	end

	thisEntity.LaningAI:InvalidateCurrentAction()

	--print ( "Casting " .. hRaze:GetAbilityName() )

	local vToRazePos = vRazePos - thisEntity:GetAbsOrigin()
	vToRazePos = vToRazePos:Normalized()

	ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP,
		})

	ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION,
			Position = thisEntity:GetAbsOrigin() + vToRazePos * 35,
		})

	DebugDrawCircle( vRazePos, Vector( 0, 0, 255 ), 255, 25, true, 0.25 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hRaze:entindex(),
		Queue = 1,
	})

	thisEntity.LaningAI:SetCastingAbility( hRaze:GetAbilityName(), nil, 3.0 )
	return 0.1
end

-----------------------------------------------------------------------------------------------------

function Shadowraze1()
	return Shadowraze( thisEntity.Raze1 )
end

-----------------------------------------------------------------------------------------------------

function Shadowraze2()
	return Shadowraze( thisEntity.Raze2 )
end

-----------------------------------------------------------------------------------------------------

function Shadowraze3()
	return Shadowraze( thisEntity.Raze3 )
end

-----------------------------------------------------------------------------------------------------