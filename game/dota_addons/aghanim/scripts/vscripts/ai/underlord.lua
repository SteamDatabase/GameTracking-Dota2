
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hDamageAbility = thisEntity:FindAbilityByName( "aghsfort_underlord_firestorm" )
	thisEntity.hChannelledAbility = thisEntity:FindAbilityByName( "underlord_channelled_buff" )

	thisEntity.fEnemySearchRange = 700

	thisEntity:SetContextThink( "UnderlordThink", UnderlordThink, 1 )
end

--------------------------------------------------------------------------------

function UnderlordThink()
	if thisEntity == nil or thisEntity:IsNull() or thisEntity:IsAlive() == false then
		return -1
	end
	
	if GameRules:IsGamePaused() then
		return 1
	end

	if thisEntity.hChannelledAbility ~= nil and thisEntity.hChannelledAbility:IsChanneling() then
		return 0.5
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.fEnemySearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )

	local bIgniteReady = ( #enemies > 0 and thisEntity.hDamageAbility ~= nil and thisEntity.hDamageAbility:IsFullyCastable() )

	if thisEntity.hChannelledAbility ~= nil and thisEntity.hChannelledAbility:IsFullyCastable() then
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,friendly in pairs ( friendlies ) do
			if friendly ~= nil then
				if ( friendly:GetUnitName() == "npc_dota_creature_dragon_knight" ) then
					local fDist = ( friendly:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
					local fCastRange = thisEntity.hChannelledAbility:GetCastRange( thisEntity:GetOrigin(), nil )
					--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
					if ( fDist <= fCastRange ) and ( ( #enemies > 0 ) or ( friendly:GetAggroTarget() ) ) then
						return CastChannelledBuff( friendly )
					elseif ( fDist > 400 ) and ( fDist < 900 ) then
						if bIgniteReady == false then
							return Approach( friendly )
						end
					end
				end
			end
		end
	end

	if bIgniteReady then
		return IgniteArea( enemies[ RandomInt( 1, #enemies ) ] )
	end

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation

	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--printf( "\"%s\" is approaching unit named \"%s\"", thisEntity:GetUnitName(), hUnit:GetUnitName() )

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

function CastChannelledBuff( hUnit )
	--print( "Casting CastChannelledBuff on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hChannelledAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function IgniteArea( hEnemy )
	--print( "Casting ignite on " .. hEnemy:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hDamageAbility:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})

	return 0.55
end

--------------------------------------------------------------------------------
