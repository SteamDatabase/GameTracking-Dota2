
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if IsServer() == false then
		return
	end

	thisEntity.hAttackAbility = thisEntity:FindAbilityByName( "aghsfort_phoenix_flame_revenant_attack" )

	thisEntity:SetContextThink( "FlameRevenantThink", FlameRevenantThink, 0.25 )
end

--------------------------------------------------------------------------------

function Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_flame_thrower_tree_afterburn.vpcf", context )
end

--------------------------------------------------------------------------------

function FlameRevenantThink()
	if IsServer() == false then
		return
	end

	if not thisEntity.bInitialized then
		--printf( "initialize flame revenant" )

		thisEntity.hAttackAbility.fWidth = thisEntity.hAttackAbility:GetSpecialValueFor( "width" )

		local hOwner = thisEntity:GetOwnerEntity()
		local hFireSpiritsAbility = hOwner:FindAbilityByName( "aghsfort_phoenix_fire_spirits" )
		if not hFireSpiritsAbility then
			printf( "WARNING: flame revenant's owner has no ability named aghsfort_phoenix_fire_spirits, returning from think early" )
			return 0.25
		end

		local nFireSpiritsRadius = hFireSpiritsAbility:GetSpecialValueFor( "radius" )
		local radius_pct_as_length = thisEntity.hAttackAbility:GetSpecialValueFor( "radius_pct_as_length" )
		thisEntity.hAttackAbility.fAttackLength = nFireSpiritsRadius * ( radius_pct_as_length / 100.0 )

		thisEntity.bInitialized = true
	end

	if thisEntity:IsChanneling() then
		return 0.25
	end

	local nSearchRange = 500
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, nSearchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 0.25
	end

	if thisEntity.hAttackAbility ~= nil and thisEntity.hAttackAbility:IsFullyCastable() then
		local nMaxAdjacentEnemies = 0
		local bestEnemy = nil

		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
				local flDistToEnemy = #( thisEntity:GetOrigin() - enemy:GetOrigin() )
				if thisEntity.hAttackAbility.fAttackLength > flDistToEnemy then
					local nAdjacentEnemies = 1
					for _,adjacentEnemy in pairs( enemies ) do
						if adjacentEnemy ~= nil and adjacentEnemy ~= enemy and adjacentEnemy:IsAlive() then
							local vSeparation = enemy:GetOrigin() - adjacentEnemy:GetOrigin()
							local flDistBetweenEnemies = #vSeparation
							if flDistBetweenEnemies < thisEntity.hAttackAbility.fWidth then
								nAdjacentEnemies = nAdjacentEnemies + 1
							end
						end
					end
				
					if nMaxAdjacentEnemies < nAdjacentEnemies or ( nMaxAdjacentEnemies == nMaxAdjacentEnemies and RandomInt( 0,1 ) == 1 ) then
						nMaxAdjacentEnemies = nAdjacentEnemies
						bestEnemy = enemy
					end
				end
			end
		end
		
		if bestEnemy ~= nil then
			return CastAttackAbility( bestEnemy )
		end
	else
		local target = enemies[ #enemies ]
		local vPos = target:GetAbsOrigin()
		thisEntity:FaceTowards( vPos )
	end

	return 0.25
end

--------------------------------------------------------------------------------

function CastAttackAbility( hEnemy )
	--printf( "Casting thisEntity.hAttackAbility on %s", hEnemy:GetUnitName() )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = thisEntity.hAttackAbility:entindex(),
		TargetIndex = hEnemy:entindex(),
		Queue = false,
	})

	return 0.25
end

--------------------------------------------------------------------------------
