require( "ai/ai_laning" )

-----------------------------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() then
		thisEntity:SetContextThink( "SFMid1v1Think", SFMid1v1Think, 0.25 )	
		thisEntity.LaningAI = CDotaAILaning( LAST_HIT_AI_SKILL.HARD, LAST_HIT_AI_TYPE.LAST_HIT_FOCUSED, thisEntity )
		thisEntity.LaningAI:SetLastHitHoverRange( 100.0 + thisEntity:Script_GetAttackRange() )
		
		local AbilityLearnOrder = {}
		AbilityLearnOrder[1] = "nevermore_necromastery"
		AbilityLearnOrder[2] = "nevermore_shadowraze3"
		AbilityLearnOrder[3] = "nevermore_necromastery"
		AbilityLearnOrder[4] = "nevermore_shadowraze3"
		AbilityLearnOrder[5] = "nevermore_shadowraze3"
		AbilityLearnOrder[6] = "nevermore_necromastery"
		thisEntity.LaningAI:SetAbilityLearnOrder( AbilityLearnOrder )

		thisEntity.Raze1 = thisEntity:FindAbilityByName( "nevermore_shadowraze1" )
		thisEntity.Raze2 = thisEntity:FindAbilityByName( "nevermore_shadowraze2" )
		thisEntity.Raze3 = thisEntity:FindAbilityByName( "nevermore_shadowraze3" )
		thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze1", Shadowraze1 )
		thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze2", Shadowraze2 )
		thisEntity.LaningAI:AddAbilityFunc( "nevermore_shadowraze3", Shadowraze3 )

		thisEntity.Raze1Targets = {}
		thisEntity.Raze2Targets = {}
		thisEntity.Raze3Targets = {}
	end
end

-----------------------------------------------------------------------------------------------------

function SFMid1v1Think()
	if IsServer() == false then
		return -1
	end

	if GameRules:IsGamePaused() then
		return 0.1
	end

	if thisEntity == nil or thisEntity:IsNull() then
		return -1
	end

	return thisEntity.LaningAI:DoLaning()
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

	--DebugDrawCircle( vRazePos, Vector( 0, 0, 255 ), 255, 25, true, 0.25 )

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