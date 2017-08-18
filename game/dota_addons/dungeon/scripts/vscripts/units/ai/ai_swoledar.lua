
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hHealAbility = thisEntity:FindAbilityByName( "swoledar_heal" )

	thisEntity:SetContextThink( "SwoledarThink", SwoledarThink, 1 )
end

--------------------------------------------------------------------------------

function SwoledarThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if hHealAbility ~= nil and hHealAbility:IsChanneling() then
		return 0.5
	end

	if hHealAbility ~= nil and hHealAbility:IsFullyCastable() then
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _, friendly in pairs ( friendlies ) do
			if friendly ~= nil and friendly:GetUnitName() == "npc_dota_creature_siltbreaker" then
				return CastHeal( friendly )
			end
		end
	end

	local fFuzz = RandomFloat( -0.1, 0.1 )
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Swoledar is approaching unit named " .. hUnit:GetUnitName() )

	local vToUnit = hUnit:GetOrigin() - thisEntity:GetOrigin()
	vToUnit = vToUnit:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToUnit * thisEntity:GetIdealSpeed()
	})

	return 1
end

--------------------------------------------------------------------------------

function CastHeal( hUnit )
	--print( "Swoledar is casting heal on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hHealAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

