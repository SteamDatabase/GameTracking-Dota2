
require( "ai/ai_core" )

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hDetonatorAbility = thisEntity:FindAbilityByName( "kobold_overboss_detonator" )

	thisEntity:SetContextThink( "KoboldThink", KoboldThink, 0.1 )
end

--------------------------------------------------------------------------------

function KoboldThink()
	if not IsServer() then
		return
	end

	if thisEntity == nil or thisEntity:IsNull() or ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.1
	end

	if thisEntity.hDetonatorAbility and thisEntity.hDetonatorAbility:IsFullyCastable() then
		return CastDetonator()
	end
	return 0.1
end

--------------------------------------------------------------------------------

function CastDetonator()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.hDetonatorAbility:entindex(),
		Queue = false,
	})
	return -1
end

--------------------------------------------------------------------------------
