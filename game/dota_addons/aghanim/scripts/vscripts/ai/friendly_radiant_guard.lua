--[[ Phantom Lancer AI ]]

require( "aghanim_utility_functions" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.flSearchRadius = 700
	thisEntity.hSmashAbility = thisEntity:FindAbilityByName( "hellbear_smash" )
	if thisEntity.hSmashAbility == nil then
		print( "Smash Ability not found!" )
	end
	thisEntity:SetContextThink( "FriendlyRadiantGuardThink", FriendlyRadiantGuardThink, 0.5 )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_truesight_aura", { duration = -1, radius = 700 } )
end

--------------------------------------------------------------------------------

function FriendlyRadiantGuardThink()
	--print( "Friendly Guard Thinking" )
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.bStartRescue == true then
		return UnitRescueThinker( thisEntity )
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
				--printf( "FriendlyRadiantGuardThink: removed invalid target named %s", enemy:GetUnitName() )
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

	if #enemies == 0 then
		return Reset()
	end

	if thisEntity.hSmashAbility ~= nil and thisEntity.hSmashAbility:IsFullyCastable() then
		local hSmashTarget = enemies[ 1 ]
		local flDist = ( hSmashTarget:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
		--print( flDist )
		if flDist < 300 then
			return Smash()
		end
	end

	return 0.25
end

--------------------------------------------------------------------------------

function Smash()
	--print( "Casting Hellbear Smash" )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hSmashAbility:entindex(),
		Queue = false,
	})

	return 3
end

--------------------------------------------------------------------------------

function Reset()
	local roomCenter = Entities:FindAllByName( "objective" )
	if #roomCenter > 0 then
		local hRoomCenter = roomCenter[1]
		local vPos = hRoomCenter:GetAbsOrigin() + RandomVector( RandomFloat( 0, 500 ) )
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos
		})
	end		

	return 1.25
end

--------------------------------------------------------------------------------
