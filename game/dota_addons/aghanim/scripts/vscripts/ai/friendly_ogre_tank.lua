
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	SmashAbility = thisEntity:FindAbilityByName( "ogre_tank_melee_smash" )
	JumpAbility = thisEntity:FindAbilityByName( "ogre_tank_jump_smash" )

	thisEntity:SetContextThink( "OgreTankThink", OgreTankThink, 1 )
end

--------------------------------------------------------------------------------

function OgreTankThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	-- Increase acquisition range after the initial aggro
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 850 )
		thisEntity.bAcqRangeModified = true
	end

	local nEnemiesRemoved = 0
	local fSearchRange = 700
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, fSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	-- Iterate backwards since we're removing entries
	for i = #enemies, 1, -1 do
		local enemy = enemies[ i ]
		if enemy ~= nil then
			if enemy:GetUnitName() == "npc_dota_explosive_barrel" or enemy:GetUnitName() == "npc_dota_crate" then
				--printf( "OgreTankThink: removed invalid target named %s", enemy:GetUnitName() )
				table.remove( enemies, i )
			else
				local flDist = ( enemy:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
				if flDist < 210 then
					nEnemiesRemoved = nEnemiesRemoved + 1
					table.remove( enemies, i )
				end
			end
		end
	end

	if JumpAbility ~= nil and JumpAbility:IsFullyCastable() and nEnemiesRemoved > 0 then
		return Jump()
	end

	if #enemies == 0 then
		return 1
	end

	if SmashAbility ~= nil and SmashAbility:IsFullyCastable() then
		local hSmashTarget = enemies[ 1 ]
		return Smash( hSmashTarget )
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
