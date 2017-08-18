
--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	UndeadAbility = thisEntity:FindAbilityByName( "undead_tusk_skeleton" )

	thisEntity:SetContextThink( "UndeadTuskAbility", UndeadTuskAbility, 0.5 )
end

--------------------------------------------------------------------------------

function UndeadTuskAbility()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if thisEntity:IsChanneling() then
		return -1
	end

	if RandomInt( 0 , 2 ) ~= 0 and not thisEntity.bSummoned then
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = UndeadAbility:entindex(),
		Queue = false,
	})
	else
		local hBuff = thisEntity:FindModifierByName( "modifier_undead_skeleton" )
		if hBuff ~= nil then
			hBuff:WakeUp()
		end
		return -1
	end

	

	return 0.5
end

