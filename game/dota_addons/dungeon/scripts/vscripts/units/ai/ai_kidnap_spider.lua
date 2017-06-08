
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	local szSpawnerName = "darkforest_pass_spiderboss"
	thisEntity.hBossSpawner = Entities:FindByName( nil, szSpawnerName )

	if thisEntity.hBossSpawner == nil then
		print( "[ai_kidnap_spider] - ERROR: Spawner \"" .. szSpawnerName .. "\" Not Found" )
		return
	end

	thisEntity.vOrigSpawnPos = thisEntity:GetOrigin()

	hLassoAbility = thisEntity:FindAbilityByName( "batrider_flaming_lasso" )

	thisEntity:AddNewModifier( thisEntity, nil, "modifier_phased", { duration = -1 } )

	thisEntity:SetContextThink( "KidnapSpiderThink", KidnapSpiderThink, 1 )
end

--------------------------------------------------------------------------------

function KidnapSpiderThink()
	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if hLassoAbility == nil then
		return 1
	end

	if not hLassoAbility:IsFullyCastable() then
		return RunAway( thisEntity.hBossSpawner:GetOrigin() )
	else
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
		if #enemies == 0 then
			--return RunAway( thisEntity.vOrigSpawnPos )
			return 1
		end

		local fDistToBossSpawner = ( thisEntity:GetOrigin() - thisEntity.hBossSpawner:GetOrigin() ):Length2D()
		if fDistToBossSpawner > 2500 then
			for _, enemy in pairs( enemies ) do
				--print( string.format( "enemy \"%s\" has lasso modifier: %s", enemy:GetUnitName(), tostring( ( enemy:HasModifier( "modifier_batrider_flaming_lasso" == nil ) ) ) ) )
				if enemy ~= nil and enemy:IsRealHero() and enemy:IsAlive() and ( not enemy:HasModifier( "modifier_batrider_flaming_lasso" ) ) then
					local fDistToEnemy = ( thisEntity:GetOrigin() - enemy:GetOrigin() ):Length2D()
					if fDistToEnemy < 160 then
						return CastLasso( enemy )
					end
				end
			end
		end
	end

	return 0.4
end

--------------------------------------------------------------------------------

function CastLasso( unit )
	print( "ai_kidnap_spider - CastLasso" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = unit:entindex(),
		AbilityIndex = hLassoAbility:entindex(),
		Queue = false,
	})

	return 1.0
end

--------------------------------------------------------------------------------

function RunAway( vPos )
	thisEntity.bMoving = true

	--print( "ai_kidnap_spider - RunAway" )

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vPos
	})

	return 10
end

--------------------------------------------------------------------------------

