
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	IgniteAbility = thisEntity:FindAbilityByName( "baby_ogre_magi_area_ignite" )
	BloodlustAbility = thisEntity:FindAbilityByName( "ogre_magi_channelled_bloodlust" )

	thisEntity:SetContextThink( "OgreMagiThink", OgreMagiThink, 1 )
end

--------------------------------------------------------------------------------

function OgreMagiThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if BloodlustAbility ~= nil and BloodlustAbility:IsChanneling() then
		return 0.5
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )

	local bIgniteReady = ( #enemies > 0 and IgniteAbility ~= nil and IgniteAbility:IsFullyCastable() )

	if BloodlustAbility ~= nil and BloodlustAbility:IsFullyCastable() then
		local friendlies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		for _,friendly in pairs ( friendlies ) do
			if friendly ~= nil then
				if ( friendly:GetUnitName() == "npc_dota_creature_baby_ogre_tank" ) then
					local fDist = ( friendly:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
					local fCastRange = BloodlustAbility:GetCastRange( thisEntity:GetOrigin(), nil )
					--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
					if ( fDist <= fCastRange ) and ( ( #enemies > 0 ) or ( friendly:GetAggroTarget() ) ) then
						return Bloodlust( friendly )
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

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation to these magi
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Ogre Magi is approaching unit named " .. hUnit:GetUnitName() )

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

function Bloodlust( hUnit )
	--print( "Casting bloodlust on " .. hUnit:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = BloodlustAbility:entindex(),
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
		AbilityIndex = IgniteAbility:entindex(),
		Position = hEnemy:GetOrigin(),
		Queue = false,
	})

	return 0.55
end

--------------------------------------------------------------------------------

