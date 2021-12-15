--[[ Candy Well AI ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hBucketSoldier = nil
	thisEntity.hBombAbility = thisEntity:FindAbilityByName( "candy_well_bomb" )
	if thisEntity.hBombAbility == nil then
		print( 'MISSING candy_well_bomb on Candy Well AI' )
	else
		thisEntity.hBombAbility:UpgradeAbility( true )
	end
	
	
	local hNoCCAbility = thisEntity:FindAbilityByName( "ability_absolute_no_cc" )
	if hNoCCAbility == nil then
		hNoCCAbility = thisEntity:AddAbility( "ability_absolute_no_cc" )
	end 
	if hNoCCAbility ~= nil then
		hNoCCAbility:UpgradeAbility( false )
	end

	thisEntity:SetContextThink( "CandyWellThink", CandyWellThink, 1.0 )
end

--------------------------------------------------------------------------------

function CandyWellThink()
	--print( "Candy Well Thinking" )
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		--print( "No enemies found" )
		return 1
	end

	thisEntity.hBucketSoldier = nil
	local hAllies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_UNITS_EVERYWHERE, false )
	if #hAllies == 0 then
		--print( "No allies found" )
		--return 1
	else
		for _,ally in pairs( hAllies ) do
			if ally:GetUnitName() == "npc_dota_creature_bucket_soldier" then
				--print( "Bucket Soldier Found" )
				thisEntity.hBucketSoldier = ally
			end
		end
	end

	--print( "Found enemies!  Attempting to cast candy well bomb" )
	if thisEntity.hBombAbility and thisEntity.hBombAbility:IsFullyCastable() then
		--print( "Cast Candy Well Bomb" )
		if thisEntity.hBucketSoldier == nil then
			local enemy = hEnemies[ RandomInt( 1, #hEnemies) ]
			return CastBomb( enemy )
		end
	end

	return 1
end

--------------------------------------------------------------------------------

function CastBomb( unit )
	--print( "Candy Well - CastBomb" )
	local vPos = unit:GetAbsOrigin()
	local vTargetPos = vPos + RandomVector( 100 )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hBombAbility:entindex(),
		Queue = false,
	})

	return 1
end

--------------------------------------------------------------------------------