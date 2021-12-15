
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	HealAbility = thisEntity:FindAbilityByName( "forest_troll_high_priest_heal" )

	thisEntity:SetContextThink( "TrollPriestThink", TrollPriestThink, 1 )
end

--------------------------------------------------------------------------------

function TrollPriestThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	thisEntity.bIsBusy = nil

	if HealAbility ~= nil and HealAbility:IsFullyCastable() then
		
		local heroes = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, HealAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _,hero in pairs ( heroes ) do
			if hero ~= nil then
				if hero ~= thisEntity then
					if hero:GetHealth() < ( hero:GetMaxHealth() * 0.75 ) then
						local fDist = ( hero:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
						local fCastRange = HealAbility:GetCastRange( thisEntity:GetOrigin(), nil )
						--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
						if fDist <= fCastRange then
							thisEntity.bIsBusy = true
							return Heal( hero )
						--[[elseif ( fDist > 350 ) and ( fDist < 600 ) then
							thisEntity.bIsBusy = true
							return Approach( hero )--]]
						end
					end
				end
			end
		end

		local creeps = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, HealAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _,creep in pairs ( creeps ) do
			if creep ~= nil then
				if creep ~= thisEntity then
					if creep:GetHealth() < ( creep:GetMaxHealth() * 0.75 ) then
						local fDist = ( creep:GetOrigin() - thisEntity:GetOrigin() ):Length2D()
						local fCastRange = HealAbility:GetCastRange( thisEntity:GetOrigin(), nil )
						--print( string.format( "fDist == %d, fCastRange == %d", fDist, fCastRange ) )
						if fDist <= fCastRange then
							thisEntity.bIsBusy = true
							return Heal( creep )
						--[[elseif ( fDist > 350 ) and ( fDist < 600 ) then
							thisEntity.bIsBusy = true
							return Approach( creep )--]]
						end
					end
				end
			end
		end
	end

	local fFuzz = RandomFloat( -0.1, 0.1 ) -- Adds some timing separation
	return 0.5 + fFuzz
end

--------------------------------------------------------------------------------

function Approach( hUnit )
	--print( "Troll Priest is approaching unit named " .. hUnit:GetUnitName() )

	local vToUnit = hUnit:GetOrigin() - thisEntity:GetOrigin()
	vToUnit = vToUnit:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToUnit * thisEntity:GetIdealSpeed(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------

function Heal( hUnit )
	--print( "Casting heal" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = HealAbility:entindex(),
		TargetIndex = hUnit:entindex(),	
		Queue = false,
	})

	return 1
end


