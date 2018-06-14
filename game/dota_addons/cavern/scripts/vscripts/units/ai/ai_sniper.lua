
require("units/ai/ai_cavern_shared")

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:SetContextThink( "SniperThink", SniperThink, 1 )
end

--------------------------------------------------------------------------------

function SniperThink()
	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn == nil then
		return nil
	elseif flEarlyReturn > 0 then
		return flEarlyReturn
	end

	if thisEntity.hMaskOfMadnessAbility == nil then
		thisEntity.hMaskOfMadnessAbility = FindItemAbility( thisEntity, "item_mask_of_madness" )
	end

	local hClosestPlayer = GetClosestNoteworthyEnemyNearbyOrReturnToSpawn( thisEntity )

	if hClosestPlayer == nil then
		return 1
	end

	if thisEntity:GetHealth() < ( thisEntity:GetMaxHealth() * 0.3 ) then 
		UseMaskOfMadness()
	end

	local flEnemyDistance = (hClosestPlayer:GetAbsOrigin() - thisEntity:GetAbsOrigin() ):Length2D()

	if thisEntity:GetAttackRange() >= flEnemyDistance then
		--printf( "Sniper is attacking %s", hClosestPlayer:GetUnitName() )
		AttackTargetOrder( thisEntity, hClosestPlayer )
	end

	if thisEntity.fLastLaughAttempt == nil or GameRules:GetGameTime() > ( thisEntity.fLastLaughAttempt + VOICE_LINE_COOLDOWN ) then
		local nRandomInt = RandomInt( 0, 10 )
		-- Bit wonky that we're calling these inside a Think
		if nRandomInt == 9 then
			GameRules.Cavern:FireLaugh( thisEntity )
		elseif nRandomInt == 10 then
			GameRules.Cavern:FireTaunt( thisEntity )
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function UseMaskOfMadness()
	if thisEntity.hMaskOfMadnessAbility ~= nil and thisEntity.hMaskOfMadnessAbility:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = thisEntity.hMaskOfMadnessAbility:entindex(),
			Queue = false,
		})
	end
end
