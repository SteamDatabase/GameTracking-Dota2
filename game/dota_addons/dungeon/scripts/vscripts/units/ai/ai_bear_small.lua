
--[[ units/ai/ai_bear_small.lua ]]

--------------------------------------------------------------------------------

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.hCleave = thisEntity:FindAbilityByName( "bear_cleave" )
	thisEntity:SetContextThink( "BearSmallThink", BearSmallThink, 0.5 )
end

--------------------------------------------------------------------------------

function BearSmallThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end

	if ( not thisEntity:GetAggroTarget() ) then
		return 1.0
	end

	-- print("small bear - found enemies")

	if thisEntity.hCleave:IsFullyCastable() then
		CastCleave()
	end
	return 1.0
end

function CastCleave( hTarget )
	-- print("small bear - cleaving")
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = thisEntity:GetAggroTarget():entindex(),
		AbilityIndex = thisEntity.hCleave:entindex(),
		Queue = false,
	})
end
