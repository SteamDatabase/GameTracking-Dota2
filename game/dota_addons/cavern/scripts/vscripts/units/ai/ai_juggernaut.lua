
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	hBladeFuryAbility = thisEntity:FindAbilityByName( "creature_juggernaut_blade_fury" )

	thisEntity:SetContextThink( "JuggernautThink", JuggernautThink, 1 )
end

--------------------------------------------------------------------------------

function JuggernautThink()
	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	local flEarlyReturn = InitialRoomMobLogic( thisEntity )
	if flEarlyReturn ~= nil then 
		return flEarlyReturn
	end

	local hClosestPlayer = GetClosestPlayerInRoomOrReturnToSpawn( thisEntity )
	if hClosestPlayer == nil then
		return 0.5
	end

	--[[
	if thisEntity.bRunningAway then
		local vRandomDestination = thisEntity:GetAbsOrigin() + RandomVector( 800 )
		MoveOrder( thisEntity, vRandomDestination )

		return 5.0
	end
	]]

	if thisEntity.stage and thisEntity.stage == 2 then
		if hBladeFuryAbility and hBladeFuryAbility:IsCooldownReady() then
			CastBladeFuryAbility()

			--[[
			local vRandomDestination = thisEntity:GetAbsOrigin() + RandomVector( 800 )
			MoveOrder( thisEntity, vRandomDestination )

			-- @todo: say something funny as I run away

			thisEntity.bRunningAway = true
			]]

			return 5.0
		end
	end

	return 0.5
end

--------------------------------------------------------------------------------

function CastBladeFuryAbility()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = hBladeFuryAbility:entindex()
	})
end

--------------------------------------------------------------------------------
