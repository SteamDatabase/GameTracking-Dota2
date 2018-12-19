require( "ai/ai_shared" )

function Spawn( entityKeyValues )
	if thisEntity == nil then
		return
	end

	if IsServer() == false then
		return
	end

	thisEntity.AbilityRollingBoulder = thisEntity:FindAbilityByName( "creature_earth_spirit_rolling_boulder" )
	thisEntity.AbilitySpawnRemnant = thisEntity:FindAbilityByName( "earth_spirit_stone_caller" )
	local fInitialDelay = RandomFloat( 0, 1.5 ) -- separating out the timing of all the ranged creeps' thinks
	thisEntity:SetContextThink( "EarthSpiritlingThink", EarthSpiritlingThink, fInitialDelay )
	thisEntity.bSpawnedRemnant = false
end

function EarthSpiritlingThink()

	if ( not thisEntity:IsAlive() and not thisEntity.bSpawnedRemnant ) then
		--printf("spawning remnant")
		local hAllies = GetAlliesInRange( thisEntity, 300 )
		for index,hAlly in pairs(hAllies) do
			if hAlly.AbilitySpawnRemnant and hAlly.AbilitySpawnRemnant:IsFullyCastable() then
				CastPositionalAbility( hAlly, thisEntity:GetOrigin(), hAlly.AbilitySpawnRemnant )
				break
			end
		end

		thisEntity.bSpawnedRemnant = true
		return -1
	end

	local flNow = GameRules:GetGameTime()

	if thisEntity.AbilityRollingBoulder and thisEntity.AbilityRollingBoulder:IsFullyCastable() then
		
		local hEnemies = GetVisibleEnemyHeroesInRange( thisEntity, 600 )
		local hTarget = GetRandomUnique( hEnemies )

		if hTarget then
			local flLastAllyCastTime = LastAllyCastTime(thisEntity, thisEntity.AbilityRollingBoulder, 1000, hTarget )
			if( flNow - flLastAllyCastTime > 3 ) then
				CastPositionalAbility( thisEntity, hTarget:GetOrigin(), thisEntity.AbilityRollingBoulder )
				UpdateLastCastTime( thisEntity, thisEntity.AbilityRollingBoulder, hTarget )
			end
		end
	end

	return 0.5
end
