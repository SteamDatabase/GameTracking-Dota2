require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "PugnaThink", PugnaThink, 1 )

	hNetherBlastAbility = thisEntity:FindAbilityByName( "creature_pugna_nether_blast" )
	hDecrepifyAbility = thisEntity:FindAbilityByName( "creature_pugna_decrepify" )
	hLifeDrainAbility = thisEntity:FindAbilityByName( "creature_pugna_life_drain" )

	thisEntity.NetherBlasts = {}

	thisEntity.LifeDrainTarget = nil

	thisEntity.Mode = "NetherBlast"
	thisEntity.ModeDuration = { ["NetherBlast"]=8, ["LifeDrain"]=8 }
	thisEntity.ModeStart = nil

	thisEntity.LastDecrepTarget = nil

end

--------------------------------------------------------------------------------

function PugnaThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
	if hClosestPlayer == nil then
		return 1
	end

	local GameTime = GameRules:GetGameTime()

	if thisEntity.ModeStart == nil then
		thisEntity.ModeStart = GameTime
	else	
		if (GameTime - thisEntity.ModeStart) > thisEntity.ModeDuration[thisEntity.Mode] then 
			if thisEntity.Mode == "LifeDrain" then 
				thisEntity.Mode = "NetherBlast" 
				thisEntity.NetherBlastQueue = nil	
			elseif thisEntity.Mode == "NetherBlast" then 
				thisEntity.Mode = "LifeDrain" 
			end
			StopOrder( thisEntity )	
			thisEntity.ModeStart = GameTime
			--printf("%f", GameTime - thisEntity.ModeStart)
		end
	end

	--printf("mode = %s", thisEntity.Mode)

	if thisEntity.Mode == "LifeDrain" then
		if thisEntity.LifeDrainTarget ~= hClosestPlayer or not hLifeDrainAbility:IsChanneling() then
			thisEntity.LifeDrainTarget = hClosestPlayer
			CastLifeDrainAbility( thisEntity.LifeDrainTarget )
		end
	else
		if hNetherBlastAbility and hNetherBlastAbility:IsCooldownReady() then
			if thisEntity.NetherBlastQueue == nil or #thisEntity.NetherBlastQueue < 1 then
				thisEntity.NetherBlastQueue = {}
				local flCurrentAngle = RandomFloat(0,2*math.pi)
				local flAngleIncrement = (RandomInt(0,1) == 1) and 2*math.pi/12 or -2*math.pi/12
				for i=1,20 do
					local vSpawnPoint = thisEntity:GetAbsOrigin() + Vector( math.cos(flCurrentAngle), math.sin(flCurrentAngle), 0 )*475
					table.insert( thisEntity.NetherBlastQueue, vSpawnPoint )
					flCurrentAngle = flCurrentAngle + flAngleIncrement
				end
			end
			local vNetherblastTarget = table.remove( thisEntity.NetherBlastQueue )
			CastNetherBlastAbility( vNetherblastTarget )
		end

		if hDecrepifyAbility and hDecrepifyAbility:IsCooldownReady() then
			local hEnemies = GetEnemyHeroesInRoom( thisEntity )
			local hDecrepTarget = GetRandomUnique( hEnemies, { thisEntity.LastDecrepTarget } )
			if hDecrepTarget ~= nil then
				CastDecrepifyAbility( hDecrepTarget )
				thisEntity.LastDecrepTarget = hDecrepTarget
			end
		end
	end
	
	return 0.2
end

--------------------------------------------------------------------------------

function CastNetherBlastAbility( vPos )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = hNetherBlastAbility:entindex(),
		Position = vPos,
		Queue = false,
	})
end

--------------------------------------------------------------------------------

function CastDecrepifyAbility( hUnit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hDecrepifyAbility:entindex(),
		TargetIndex = hUnit:GetEntityIndex()
	})
end

--------------------------------------------------------------------------------

function CastLifeDrainAbility( hUnit )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		AbilityIndex = hLifeDrainAbility:entindex(),
		TargetIndex = hUnit:GetEntityIndex()
	})
end

--------------------------------------------------------------------------------
