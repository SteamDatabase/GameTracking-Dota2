function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	if thisEntity:GetTeam() ~= DOTA_TEAM_NEUTRALS then
		return
	end

	thisEntity.hFlop = thisEntity:FindAbilityByName( "ogreseal_flop" )
	thisEntity.flSearchRadius = 5000

	thisEntity.hFlop:StartCooldown(3)

	thisEntity:SetContextThink( "OgreSealThink", OgreSealThink, 1 )
end

--------------------------------------------------------------------------------

function OgreSealThink()
	if not thisEntity then return end
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity.flSearchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #hEnemies == 0 then
		return 1
	end

	if thisEntity.hFlop ~= nil and thisEntity.hFlop:IsFullyCastable() then
		return CastBellyFlop( hEnemies[#hEnemies] )
	end

	thisEntity:MoveToPosition(hEnemies[#hEnemies]:GetAbsOrigin())

	return 0.5
end

--------------------------------------------------------------------------------

function CastBellyFlop( enemy )
	local position = thisEntity:GetOrigin() + thisEntity:GetForwardVector() * 50
	local positionRandom = position + RandomVector(15)

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = thisEntity.hFlop:entindex(),
		Position = positionRandom,
		Queue = false,
	})

	-- put it on cooldown for a random amount of time so they don't synchronize
	-- the delay is so it can still cast the ability
	Timers:CreateTimer(1,
    function()
		thisEntity.hFlop:StartCooldown(RandomFloat(3.5,5.5))
	end)

	return 2.5
end
