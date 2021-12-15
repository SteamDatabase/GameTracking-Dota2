require( "utility_functions" )

bBasicSpellDebug = false

--Casting heuristics
CAST_RANGE_BUFFER = 100
MOVE_TO_CAST_NO_TARGETS = false
NO_TARGET_AOE_ENEMIES_BASIC = 1
NO_TARGET_AOE_ENEMIES_ULTIMATE = 2
UNIT_TARGET_AOE_ENEMIES_BASIC = 1
UNIT_TARGET_AOE_ENEMIES_ULTIMATE = 2
POINT_TARGET_AOE_ENEMIES_BASIC = 1
POINT_TARGET_AOE_ENEMIES_ULTIMATE = 2

UNIT_TARGET_METHODS =
{
	"closest",
	"farthest",
	"random",
}
UNIT_TARGET_METHOD = UNIT_TARGET_METHODS[3]

function IsNoTargetSpellCastValid( hSpell )
	if bBasicSpellDebug then
		print( "IsNoTargetSpellCastValid: " .. hSpell:GetAbilityName() )
	end
	-- Assume that this spell is centered on me.
	local nEnemiesRequired = NO_TARGET_AOE_ENEMIES_BASIC
	if hSpell:GetAbilityType() == ABILITY_TYPE_ULTIMATE  then
		nEnemiesRequired = NO_TARGET_AOE_ENEMIES_ULTIMATE
	end

	local nAbilityRadius = hSpell:GetAOERadius()
	if nAbilityRadius == 0 then
		-- Just slam it for now so the spell goes off.  If spells don't have these in basic dota that is generally a bug
		if bBasicSpellDebug then
			print( "--WARNING - ability " .. hSpell:GetAbilityName() .. " has no defined AOE Radius! " )
		end
		nAbilityRadius = 250
	end

	local enemies = FindUnitsInRadius( hSpell:GetCaster():GetTeamNumber(), hSpell:GetCaster():GetOrigin(), hSpell:GetCaster(), nAbilityRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #enemies < nEnemiesRequired then
		return false
	end

	if bBasicSpellDebug then
		print( "--Found " .. #enemies .. " : " .. hSpell:GetAbilityName() )
		print( "" )
	end

	return true
end

function GetBestAOEUnitTarget( hSpell )
	--For now, just use normal unit targeting
	return GetBestUnitTarget( hSpell )
end

function GetBestDirectionalPointTarget( hSpell )
	if bBasicSpellDebug then
		print( "GetBestDirectionalPointTarget: " .. hSpell:GetAbilityName() )
	end

	local nEnemiesRequired = UNIT_TARGET_AOE_ENEMIES_BASIC
	if hSpell:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
		nEnemiesRequired = UNIT_TARGET_AOE_ENEMIES_ULTIMATE
	end

	local nAbilityRadius = hSpell:GetAOERadius()
	if nAbilityRadius == 0 then
		-- Just slam it for now so the spell goes off.  
		-- Linear spells will likely need a specific solution, 
		-- as their radiuses are not universally defined
		nAbilityRadius = 250
		if bBasicSpellDebug then
			print( "--GetBestDirectionalPointTarget: WARNING - ability " .. hSpell:GetAbilityName() .. " has no defined AOE Radius! " )
		end
	end

	local vLocation = GetTargetLinearLocation( 	hSpell:GetCaster():GetTeamNumber(), 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  					
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												hSpell:GetCaster():GetOrigin(),
												GetTryToUseSpellRange( hSpell:GetCaster(), hSpell ),
												nAbilityRadius,
												nEnemiesRequired )

	if vLocation == vec3_invalid then
		if bBasicSpellDebug then
			print( "--GetBestDirectionalPointTarget: cannot find location with " .. nAbilityRadius .. " radius and " .. nEnemiesRequired .. " required enemies" )
		end
		return nil
	end

	if bBasicSpellDebug then
		print( "--Found directional target point: (" .. vLocation.x .. ", " .. vLocation.y .. ", " .. vLocation.z .. " : " .. hSpell:GetAbilityName() )
		print( "" )
	end

	return vLocation
end

function GetBestUnitTarget( hSpell )
	if bBasicSpellDebug and hSpell then 
		print( "GetBestUnitTarget: " .. hSpell:GetAbilityName() )
	end

	local enemies = FindUnitsInRadius( hSpell:GetCaster():GetTeamNumber(), hSpell:GetCaster():GetOrigin(), hSpell:GetCaster(), GetTryToUseSpellRange( hSpell:GetCaster(), hSpell ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	if #enemies == 0 then
		if bBasicSpellDebug then
			print( "--Found 0 enemies")	
		end
		return nil
	end

	if UNIT_TARGET_METHOD == "closest" then
		return enemies[1]
	end
	if UNIT_TARGET_METHOD == "random" then
		return enemies[RandomInt(1, #enemies)]
	end
	if UNIT_TARGET_METHOD == "farthest" then
		return enemies[#enemies]
	end

	return nil
end

function GetBestAOEPointTarget( hSpell )
	if bBasicSpellDebug then
		print( "GetBestAOEPointTarget: " .. hSpell:GetAbilityName() )
	end

	local nEnemiesRequired = UNIT_TARGET_AOE_ENEMIES_BASIC
	if hSpell:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
		nEnemiesRequired = UNIT_TARGET_AOE_ENEMIES_ULTIMATE
	end

	local nAbilityRadius = hSpell:GetAOERadius()
	if nAbilityRadius == 0 then
		-- Just slam it for now so the spell goes off.  If spells don't have these in basic dota that is generally a bug
		nAbilityRadius = 250
		if bBasicSpellDebug then
			print( "--GetBestAOEPointTarget: WARNING - ability " .. hSpell:GetAbilityName() .. " has no defined AOE Radius! " )
		end
	end

	local vLocation = GetTargetAOELocation( hSpell:GetCaster():GetTeamNumber(), 
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,  					
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											hSpell:GetCaster():GetOrigin(),
											GetTryToUseSpellRange( hSpell:GetCaster(), hSpell ),
											nAbilityRadius,
											nEnemiesRequired )
	if vLocation == vec3_invalid then
		if bBasicSpellDebug then
			print( "--GetBestAOEPointTarget: cannot find location with " .. nAbilityRadius .. " radius and " .. nEnemiesRequired .. " required enemies" )
		end
		return nil
	end

	if bBasicSpellDebug then
		print( "--Found aoe target point: (" .. vLocation.x .. ", " .. vLocation.y .. ", " .. vLocation.z .. " : " .. hSpell:GetAbilityName() )
	end

	return vLocation
end

function GetBestPointTarget( hSpell )
	-- for now just use AOE
	return GetBestAOEPointTarget( hSpell )
end

function FindTreeTarget( hSpell )
	local Trees = GridNav:GetAllTreesAroundPoint( hSpell:GetCaster():GetOrigin(), GetTryToUseSpellRange( hSpell:GetCaster(), hSpell ), false )
	if #Trees == 0 then
		return nil
	end

	return Trees[RandomInt( 1, #Trees )]
end

function CastSpellNoTarget( hSpell )
	if bBasicSpellDebug and hSpell then
		print ( "CastSpellNoTarget: " .. hSpell:GetAbilityName() )
	end
	ExecuteOrderFromTable({
		UnitIndex = hSpell:GetCaster():entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hSpell:entindex()
	})

	return GetSpellCastTime( hSpell )
end

function CastSpellUnitTarget( hSpell, hTarget )
	if bBasicSpellDebug and hSpell and hTarget then
		print ( "CastSpellUnitTarget: " .. hSpell:GetAbilityName() .. ", target: ".. hTarget:GetUnitName() )
	end
	ExecuteOrderFromTable({
		UnitIndex = hSpell:GetCaster():entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hTarget:entindex(),
		AbilityIndex = hSpell:entindex()
	})

	return GetSpellCastTime( hSpell )
end

function CastSpellPointTarget( hSpell, vLocation )
	if bBasicSpellDebug and hSpell and vLocation then
		print ( "CastSpellPointTarget: " .. hSpell:GetAbilityName() .. ", location: (" .. vLocation.x .. ", " .. vLocation.y .. ", " .. vLocation.z  )
	end
	ExecuteOrderFromTable({
		UnitIndex = hSpell:GetCaster():entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vLocation,
		AbilityIndex = hSpell:entindex(),
	})

	return GetSpellCastTime( hSpell )
end

function CastSpellTreeTarget( hSpell, hTree )
	if bBasicSpellDebug and hSpell then
		print( "CastSpellTreeTarget: " .. hSpell:GetAbilityName() )
	end

	ExecuteOrderFromTable({
		UnitIndex = hSpell:GetCaster():entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET_TREE,
		TargetIndex = GetTreeIdForEntityIndex( hTree:entindex() ),
		AbilityIndex = hSpell:entindex(),
	})
	return GetSpellCastTime( hSpell )
end

function CastSpell( hSpell )
	if bBasicSpellDebug and hSpell then
		print ( "CastSpell: " .. hSpell:GetAbilityName() )
	end
	if hSpell == nil or hSpell:IsFullyCastable() == false then
		if bBasicSpellDebug then
			print ( "No valid spell or spell not ready!" )
		end
		return 0.1
	end

	local hTarget = nil
	local vTargetLoc = nil

	local nBehavior = hSpell:GetBehavior()
	local nTargetTeam = hSpell:GetAbilityTargetTeam()
	local nTargetType = hSpell:GetAbilityTargetType()

	if bitand( nTargetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY ) ~= 0 and hSpell:GetAbilityName() ~= "pugna_life_drain" and hSpell:GetAbilityName() ~= "frostivus2018_luna_eclipse" then
		--Maybe target a minion?
		if bBasicSpellDebug then
			print( "Try to cast friendly spell on myself" )
		end
		return CastSpellUnitTarget( hSpell, hSpell:GetCaster() )
	else
		if bitand( nTargetType, DOTA_UNIT_TARGET_TREE ) ~= 0 then
			if bBasicSpellDebug then
				print( "try to cast tree targeting spell" )
			end
			local Tree = FindTreeTarget( hSpell )
			if Tree ~= nil then
				return CastSpellTreeTarget( hSpell, Tree )
			end
		end

		if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) ~= 0 or bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_IMMEDIATE ) ~= 0 and IsNoTargetSpellCastValid( hSpell ) then
			if bBasicSpellDebug then
				print( "Try to cast no target or immediate spell" )
			end
			return CastSpellNoTarget( hSpell )
		end

	 	if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_DIRECTIONAL ) ~= 0 then
	 		if bBasicSpellDebug then
	 			print( "spell is directional" )
	 		end
			local vTargetLoc = GetBestDirectionalPointTarget( hSpell )
			if vTargetLoc ~= nil then
				if bBasicSpellDebug then
					print( "Try to cast directional spell" )
				end
				return CastSpellPointTarget( hSpell, vTargetLoc )
			end
		end

		if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_POINT ) ~= 0 then
			if bBasicSpellDebug then
				print( "Stolen spell is point" )
			end
			if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_AOE ) ~= 0 then
				if bBasicSpellDebug then
					print( "Stolen spell is point aoe " )
				end
				local vTargetLoc = GetBestAOEPointTarget( hSpell )
				if vTargetLoc ~= nil then
					if bBasicSpellDebug then
						print( "Try to cast point aoe spell" )
					end
					return CastSpellPointTarget( hSpell, vTargetLoc )
				end
			else
				if bBasicSpellDebug then
					print( "spell is point non-aoe" )
				end
				local vTargetLoc = GetBestPointTarget( hSpell )
				if vTargetLoc ~= nil then
					if bBasicSpellDebug then
						print( "Try to cast point non-aoe spell" )
					end
					return CastSpellPointTarget( hSpell, vTargetLoc )
				end
			end
		end 

		if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) ~= 0 then
			if bBasicSpellDebug then
				print( "spell is unit targeted" )
			end
			if bitand( nBehavior, DOTA_ABILITY_BEHAVIOR_AOE ) ~= 0 then
				if bBasicSpellDebug then
					print( "spell is unit targeted aoe " )
				end
				local hTarget = GetBestAOEUnitTarget( hSpell )
				if hTarget ~= nil then
					if bBasicSpellDebug then
						print( "Try to cast unit aoe spell" )
					end
					return CastSpellUnitTarget( hSpell, hTarget )
				end
			else
				if bBasicSpellDebug then
					print( "spell is unit targeted non aoe" )
				end
				local hTarget = GetBestUnitTarget( hSpell )
				if hTarget ~= nil then
					if bBasicSpellDebug then
						print( "Try to cast unit spell" )
					end
					return CastSpellUnitTarget( hSpell, hTarget )
				end
			end
		end
	end
	if bBasicSpellDebug then
		print ( "No valid spell casting for my spell" )
	end
	return 0.1
end

function GetSpellCastTime( hSpell )
	local flCastPoint = math.max( 0.25, hSpell:GetCastPoint() )
	if bBasicSpellDebug then
		print( "GetSpellCastTime " .. hSpell:GetAbilityName() .. ": " .. flCastPoint + 0.01 )
	end
	return flCastPoint + 0.01
end

function GetTryToUseSpellRange( hCaster, hSpell )
	local flCastRange = hSpell:GetCastRange( vec3_invalid, nil )
	local flAcquisitionRange = hCaster:GetAcquisitionRange()
	local flTryRange = flCastRange

	if flAcquisitionRange > flCastRange then
		flTryRange = flAcquisitionRange
	end

	return flTryRange + CAST_RANGE_BUFFER
end